import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkmarts/Models/BookTabModel/coupon_model.dart';
import 'package:gkmarts/Models/BookTabModel/reviews_model.dart';
import 'package:gkmarts/Models/BookTabModel/slot_price_model.dart';
import 'package:gkmarts/Models/BookTabModel/venue_detail_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Services/BookTab/book_tab_service.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/congratulation_booking.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class BookTabProvider extends ChangeNotifier {
  bool isgetVenueDetailsGetting = false;
  bool isFavorite = false;
  bool isFavoriteLoading = false;
  VenueReviewsResponseModel? venueReviews;

  bool isReviewsLoading = false;
  bool isCouponLoading = false;
  bool isCouponApplying = false;
  bool isSlotPriceLoading = false;
  bool isProceedToPlay = false;
  bool isRatevenue = false;
  bool isTurfAvailable = false;
  List<CouponModel> couponList = [];
  final TextEditingController couponController = TextEditingController();
  String couponAppliedMessage = '';
  String? selectedCouponCode;
  int offerDiscount = 0; //coupon
  bool isCouponApplied = false;
  SlotPriceModel? slotPriceModel;
  VenueDetailModel? venueDetailModel;
  final PageController imagePageController = PageController();
  int currentImageIndex = 0;
  String? selectedSport;
  int? selectedSportId;
  DateTime selectedDate = DateTime.now();
  bool isCalendarExpanded = false;
  String? selectedSlot;
  AvailableSlotDate? filteredAvailableSlotsForSelectedDate; //---------
  List<int> availableTurfIdsForSelectedTimeDate = []; //--

  bool isTurfAutoSelected = false;

  String? paymentDate;
  String? paymentTime;
  String? paymentMethod = "UPI";
  int? bookingId;
  int? paymentId;
  List<int> selectedTurfIndexes = [];
  List<int> selectedTurfIds = [];

  DateTime startDateForList = DateTime.now();
  int? selectedUnitId;
  TimeOfDay selectedStartTime = TimeOfDay(hour: 0, minute: 0);

  // int selectedDurationInHours = 1;
  int? minMinutesSport; // not 60

  int userRating = 0;
  String userComment = '';
  //----------------------
  bool showConvenienceBreakdown = false;
  void toggleConvenienceBreakdown() {
    showConvenienceBreakdown = !showConvenienceBreakdown;
    notifyListeners();
  }

  bool useCoins = false;
  int appliedCoins = 0;
  int coinToRupeeValue = 1;
  int? coinWalletId;

  void setCoinWalletId(int? id) {
    coinWalletId = id;
  }

  void toggleUseCoins(bool value, int available) {
    if (value && available < 500) {
      // Don't allow toggling if not enough coins
      useCoins = false;
      appliedCoins = 0;
    } else {
      useCoins = value;
      appliedCoins = value ? 500 : 0;
    }
    notifyListeners();
  }

  void setCoins(int value, int available) {
    appliedCoins = available >= 500 ? value.clamp(0, 500) : 0;
    notifyListeners();
  }

  //----------
  double get courtFee => totalPriceBeforeDiscountall.toDouble();
  double get platformFee => courtFee * 0.02;
  double get gstOnPlatformFee => platformFee * 0.18;
  double get convenienceFee => platformFee + gstOnPlatformFee;
  double get subTotal => courtFee - offerDiscount - coinDiscount;
  int get coinDiscount => appliedCoins * coinToRupeeValue;
  double get finalPayableAmount => subTotal + convenienceFee;

  int get totalPriceBeforeDiscountall {
    final slot = getSelectedSlotPrice();
    if (slot == null) return 0;

    final int ratePerHour = slot.rate;
    final int turfCount = selectedTurfIndexes.length;
    final int durationInMinutes = minMinutesSport ?? 0;

    if (turfCount == 0 || durationInMinutes == 0) return 0;

    final double ratePerMinute = ratePerHour / 60.0;
    final double total = turfCount * durationInMinutes * ratePerMinute;

    return total.round(); // or .ceil() if you want to always round up
  }

  void selectCoupon(String code) {
    selectedCouponCode = code;
    couponController.text = code;
    notifyListeners();
  }

  void toggleTurfSelection(int index, int unitId) {
    if (unitId == 0) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Turf ID is missing. Please try again.",
      );
    }

    if (selectedTurfIndexes.contains(index)) {
      selectedTurfIndexes.remove(index);
      selectedTurfIds.remove(unitId);
    } else {
      selectedTurfIndexes.add(index);
      selectedTurfIds.add(unitId);
    }

    notifyListeners();
  }

  TimeOfDay _calculateEndTime() {
    final endDateTime = DateTime(
      0,
      1,
      1,
      selectedStartTime.hour,
      selectedStartTime.minute,
    ).add(Duration(minutes: minMinutesSport ?? 60));

    return TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute);
  }

  void applyCouponCode(String code) {
    selectedCouponCode = code;
    couponController.text = code;
    notifyListeners();
  }

  void selectUnitId(int unitId) {
    selectedUnitId = unitId;
    notifyListeners();
  }

  List<Map<String, dynamic>> getAvailableTurfsForSelectedSlotAndDate() {
    if (slotPriceModel == null || selectedSlot == null) return [];

    final SlotPrice? selectedSlotPrice = getSelectedSlotPrice();
    if (selectedSlotPrice == null) return [];

    final String selectedDayName = DateFormat('EEEE').format(selectedDate);

    final availableTurfs = <Map<String, dynamic>>[];

    slotPriceModel!.calendarSlots.forEach((unitId, calendarList) {
      final matchingCalendarSlots =
          calendarList.where((calendarSlot) {
            return calendarSlot.day == selectedDayName &&
                timeRangeOverlaps(
                  slotStart: selectedSlotPrice.startTime,
                  slotEnd: selectedSlotPrice.endTime,
                  calendarStart: calendarSlot.startTimeSlot,
                  calendarEnd: calendarSlot.endTimeSlot,
                );
          }).toList();

      if (matchingCalendarSlots.isNotEmpty) {
        availableTurfs.add({
          "unitId": int.tryParse(unitId) ?? 0,
          "unitName": matchingCalendarSlots.first.unitName,
        });
      }
    });

    return availableTurfs;
  }

  // getAvailableTurfsForSelectedSlotAndDate
  bool timeRangeOverlaps({
    required String slotStart,
    required String slotEnd,
    required String calendarStart,
    required String calendarEnd,
  }) {
    final slotStartTime = _parseTime(slotStart);
    final slotEndTime = _parseTime(slotEnd);
    final calendarStartTime = _parseTime(calendarStart);
    final calendarEndTime = _parseTime(calendarEnd);

    return slotStartTime.isAfter(calendarStartTime) ||
            slotStartTime.isAtSameMomentAs(calendarStartTime)
        ? slotEndTime.isBefore(calendarEndTime) ||
            slotEndTime.isAtSameMomentAs(calendarEndTime)
        : false;
  }

  DateTime _parseTime(String time) {
    final parts = time.split(":").map(int.parse).toList();
    return DateTime(0, 1, 1, parts[0], parts[1]);
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    isCalendarExpanded = false;
    _filterSlotsOfselctedDate();
    autoSelectFirstAvailableSlot();
    notifyListeners();
  }

  void _filterSlotsOfselctedDate() {
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    filteredAvailableSlotsForSelectedDate = slotPriceModel?.availableSlots
        .firstWhere(
          (slotDate) => slotDate.date == selectedDateStr,
          orElse: () => AvailableSlotDate(date: '', slots: []),
        );
    // Optionally: clear if empty
    if (filteredAvailableSlotsForSelectedDate?.date.isEmpty ?? true) {
      filteredAvailableSlotsForSelectedDate = null;
    }
  }

  int getMaxDurationForSelectedSlot() {
    final slot = getSelectedSlotPrice();
    if (slot == null) return 1;

    final slotStartParts = slot.startTime.split(":").map(int.parse).toList();
    final slotEndParts = slot.endTime.split(":").map(int.parse).toList();

    final startDateTime = DateTime(
      0,
      0,
      0,
      slotStartParts[0],
      slotStartParts[1],
    );
    final endDateTime = DateTime(0, 0, 0, slotEndParts[0], slotEndParts[1]);

    final difference = endDateTime.difference(startDateTime).inHours;
    return difference > 0 ? difference : 1;
  }

  void incrementDuration() {
    final slot = getSelectedSlotPrice();
    isTurfAutoSelected = false;
    if (slot == null) return;

    final slotEndParts = slot.endTime.split(":").map(int.parse).toList();
    final slotEndDateTime = DateTime(0, 1, 1, slotEndParts[0], slotEndParts[1]);

    final startDateTime = DateTime(
      0,
      1,
      1,
      selectedStartTime.hour,
      selectedStartTime.minute,
    );

    // final newEndDateTime = startDateTime.add(
    //   Duration(minutes: minMinutesSport ?? 60 + 60),
    // );
    final newEndDateTime = startDateTime.add(
      Duration(
        minutes: minMinutesSport! + (slotPriceModel?.minimumMinutesSport ?? 60),
      ),
    );

    if (newEndDateTime.isAfter(slotEndDateTime)) {
      GlobalSnackbar.bottomError(
        navigatorKey.currentContext!,
        "Increasing duration exceeds slot end time.",
      );
      return;
    }

    minMinutesSport =
        minMinutesSport! + (slotPriceModel?.minimumMinutesSport ?? 60);
    updateAvailableTurfIdsForSelectedTimeRange();
    notifyListeners();
  }

  void decrementDuration() {
    final baseMinutes = slotPriceModel?.minimumMinutesSport ?? 60;
    if (minMinutesSport != null && minMinutesSport! > baseMinutes) {
      isTurfAutoSelected = false;
      minMinutesSport = minMinutesSport! - baseMinutes;
      updateAvailableTurfIdsForSelectedTimeRange();
      notifyListeners();
    }
  }

  void updateTimeRangeBasedOnSlot(SlotPrice slot) {
    final now = DateTime.now();

    final slotStartParts = slot.startTime.split(":").map(int.parse).toList();
    final slotEndParts = slot.endTime.split(":").map(int.parse).toList();

    final slotStartDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      slotStartParts[0],
      slotStartParts[1],
    );

    final slotEndDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      slotEndParts[0],
      slotEndParts[1],
    );

    if (isSameDay(selectedDate, now)) {
      if (now.isAfter(slotStartDateTime) && now.isBefore(slotEndDateTime)) {
        final roundedNow =
            now.minute > 0
                ? DateTime(now.year, now.month, now.day, now.hour + 1)
                : DateTime(now.year, now.month, now.day, now.hour);
        selectedStartTime = TimeOfDay(hour: roundedNow.hour, minute: 0);
      } else {
        selectedStartTime = TimeOfDay(
          hour: slotStartParts[0],
          minute: slotStartParts[1],
        );
      }
    } else {
      selectedStartTime = TimeOfDay(
        hour: slotStartParts[0],
        minute: slotStartParts[1],
      );
    }

    final maxDurationMinutes =
        slotEndDateTime
            .difference(
              DateTime(
                now.year,
                now.month,
                now.day,
                selectedStartTime.hour,
                selectedStartTime.minute,
              ),
            )
            .inMinutes;

    minMinutesSport =
        maxDurationMinutes > 0 ? slotPriceModel?.minimumMinutesSport ?? 60 : 0;

    updateAvailableTurfIdsForSelectedTimeRange();
    notifyListeners();
  }

  String _formatTimeOfDayWithSeconds(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }

  void updateAvailableTurfIdsForSelectedTimeRange() {
    final endTime = _calculateEndTime(); // still needed!

    // Always clear previous selection
    availableTurfIdsForSelectedTimeDate.clear();

    final startDateTime = DateTime(
      0,
      1,
      1,
      selectedStartTime.hour,
      selectedStartTime.minute,
    );
    final endDateTime = DateTime(0, 1, 1, endTime.hour, endTime.minute);

    final slots = filteredAvailableSlotsForSelectedDate?.slots ?? [];

    // Filter only slots fully inside the selected time range
    final matchingSlots =
        slots.where((slot) {
          final parts = slot.timeRange.split(" - ");
          if (parts.length != 2) return false;

          final slotStart = _parseTime(parts[0]);
          final slotEnd = _parseTime(parts[1]);

          return !slotStart.isBefore(startDateTime) &&
              !slotEnd.isAfter(endDateTime);
        }).toList();

    if (matchingSlots.isEmpty) return;

    final unitIdSets =
        matchingSlots
            .map(
              (slot) => slot.availableUnits.map((unit) => unit.unitId).toSet(),
            )
            .toList();

    final commonUnitIds = unitIdSets.reduce((a, b) => a.intersection(b));

    availableTurfIdsForSelectedTimeDate = commonUnitIds.toList();
  }

  void setStartTime(TimeOfDay time) {
    final slot = getSelectedSlotPrice();
    if (slot == null) return;

    final now = DateTime.now();
    final isToday = isSameDay(selectedDate, now);

    if (isToday) {
      final nowMinutes = now.hour * 60 + now.minute;
      final pickedMinutes = time.hour * 60 + time.minute;

      if (pickedMinutes < nowMinutes) {
        GlobalSnackbar.bottomError(
          navigatorKey.currentContext!,
          "You cannot select a past time for today.",
        );
        return;
      }
    }

    final slotEndParts = slot.endTime.split(":").map(int.parse).toList();
    final slotEndDateTime = DateTime(0, 1, 1, slotEndParts[0], slotEndParts[1]);

    final startDateTime = DateTime(0, 1, 1, time.hour, time.minute);
    final safeDuration = Duration(
      minutes: minMinutesSport ?? 60,
    ); // fallback to 60
    final newEndDateTime = startDateTime.add(safeDuration);

    if (newEndDateTime.isAfter(slotEndDateTime)) {
      GlobalSnackbar.bottomError(
        navigatorKey.currentContext!,
        "Selected time + duration exceeds slot end time.",
        duration: Duration(seconds: 3),
      );
      return;
    }

    selectedStartTime = time;
    updateAvailableTurfIdsForSelectedTimeRange();
    notifyListeners();
  }

  // String get timeRangeString {
  //   final start = selectedStartTime;

  //   final startDateTime = DateTime(0, 1, 1, start.hour, start.minute);
  //   final endDateTime = startDateTime.add(
  //     Duration(minutes: minMinutesSport ?? 60),
  //   );

  //   return "${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}";
  // }

  String get timeRangeString {
    final start = selectedStartTime;

    final startDateTime = DateTime(0, 1, 1, start.hour, start.minute);
    final endDateTime = startDateTime.add(
      Duration(minutes: minMinutesSport ?? 60),
    );

    return "${DateFormat('hh:mm a').format(startDateTime)} - ${DateFormat('hh:mm a').format(endDateTime)}";
  }

  get context => null;

  void selectSlot(String slot) {
    selectedSlot = slot;
    selectedTurfIndexes.clear();
    selectedTurfIds.clear();
    isTurfAutoSelected = false;
    final slotPrice = getSelectedSlotPrice();
    if (slotPrice != null) {
      updateTimeRangeBasedOnSlot(slotPrice);
    }

    notifyListeners();
  }

  void toggleCalendar() {
    isCalendarExpanded = !isCalendarExpanded;
    notifyListeners();
  }

  SlotPrice? getSelectedSlotPrice() {
    if (slotPriceModel == null || selectedSlot == null) return null;

    final slots =
        slotPriceModel!.slotsPrice.entries.expand((e) => e.value).toList();
    return slots.firstWhereOrNull((s) => s.slotId.toString() == selectedSlot);
  }

  List<Map<String, dynamic>> getSlotOptionsByDate({
    required DateTime selectedDate,
    required DateTime currentTime,
  }) {
    final isToday = isSameDay(selectedDate, DateTime.now());
    final currentDay = selectedDate.weekday;
    final isWeekend =
        currentDay == DateTime.saturday || currentDay == DateTime.sunday;
    final slotType = isWeekend ? 'Weekend' : 'Weekday';
    final slots = slotPriceModel?.slotsPrice[slotType] ?? [];

    return slots.map((slot) {
      final endParts = slot.endTime.split(":").map(int.parse).toList();
      final slotEndDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        endParts[0],
        endParts[1],
      );

      // Filter only if it’s today. Otherwise all slots are active.
      final isActive = isToday ? currentTime.isBefore(slotEndDateTime) : true;

      return {
        "label":
            "${formatTimeOnly12(slot.startTime)} - ${formatTimeOnly12(slot.endTime)} (${slot.slotName})",
        "value": slot.slotId.toString(),
        "isActive": isActive,
      };
    }).toList();
  }

  bool get isBookingReady {
    return selectedSlot != null &&
        selectedTurfIndexes.isNotEmpty &&
        (minMinutesSport ?? 0) > 0;
  }

  Map<String, Map<String, List<SlotPrice>>> getOrganizedSlotChart() {
    final Map<String, Map<String, List<SlotPrice>>> organizedChart = {};

    int totalSlotsCount = 0;

    slotPriceModel?.slotsPrice.forEach((slotType, slots) {
      if (!organizedChart.containsKey(slotType)) {
        organizedChart[slotType] = {};
      }

      for (var slot in slots) {
        if (!organizedChart[slotType]!.containsKey(slot.slotName)) {
          organizedChart[slotType]![slot.slotName] = [];
        }
        organizedChart[slotType]![slot.slotName]!.add(slot);
        totalSlotsCount++;
      }
    });

    debugPrint("Total slots organized: $totalSlotsCount");

    return organizedChart;
  }

  void selectSport(String sportName, int sportId) {
    selectedSport = sportName;
    selectedSportId = sportId;
    notifyListeners();
  }

  bool isSportSelected() {
    return selectedSport != null;
  }

  void setCurrentImageIndex(int index) {
    currentImageIndex = index;
    notifyListeners();
  }

  void autoSelectFirstAvailableSlot() {
    final now = DateTime.now();
    final isToday = isSameDay(selectedDate, now);

    final slotOptions = getSlotOptionsByDate(
      selectedDate: selectedDate,
      currentTime:
          isToday
              ? now
              : DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
              ),
    );

    final firstActiveSlot = slotOptions.firstWhere(
      (slot) => slot["isActive"] == true,
      orElse: () => <String, Object>{},
    );

    if (firstActiveSlot.isNotEmpty && selectedSlot == null) {
      final value = firstActiveSlot["value"];
      if (value is String) {
        selectSlot(value);
      }
    }

    // ✅ Do nothing if no active slots
    // Elsewhere you already show "No slots available"
  }

  //----------
  Future<void> getSlotPrices(int venueId, int sportId) async {
    isSlotPriceLoading = true;
    notifyListeners();

    final isOnline =
        navigatorKey.currentContext!.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      isgetVenueDetailsGetting = false;
      notifyListeners();
      return;
    }

    try {
      final response = await BookTabService().getSlotPriceService(
        venueId,
        sportId,
      );

      if (response.isSuccess) {
        final Map<String, dynamic> data = jsonDecode(response.responseData);
        slotPriceModel = SlotPriceModel.fromJson(data['response']);
        minMinutesSport = slotPriceModel?.minimumMinutesSport ?? 60;
        _filterSlotsOfselctedDate();
        autoSelectFirstAvailableSlot();
        notifyListeners();
      } else {
        GlobalSnackbar.error(navigatorKey.currentContext!, response.message);
      }
    } catch (e) {
      debugPrint("Error fetching slot prices: $e");
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Something went wrong",
      );
    } finally {
      isSlotPriceLoading = false;
      notifyListeners();
    }
  }

  Future<bool> applyCoupon() async {
    if (selectedCouponCode == null || selectedCouponCode!.isEmpty) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Please select or enter a coupon code.",
      );
      return false;
    }

    isCouponApplying = true;
    notifyListeners();

    final int totalPrice = totalPriceBeforeDiscountall;
    final String couponCode = selectedCouponCode!;

    try {
      final response = await BookTabService().applyCouponService(
        totalPrice,
        couponCode,
      );

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        final responseData = data['response'];

        offerDiscount = responseData['discount_amount'] ?? 0;

        couponAppliedMessage = "Coupon applied successfully!";
        isCouponApplied = true;
        notifyListeners();
        return true;
      } else {
        couponAppliedMessage = "Failed to apply coupon. Please try again.";
        isCouponApplied = false;
        return false;
      }
    } catch (e) {
      couponAppliedMessage = "Error applying coupon.";
      isCouponApplied = false;
      return false;
    } finally {
      isCouponApplying = false;
      notifyListeners();
    }
  }

  Future<void> getCoupons() async {
    isCouponLoading = true;
    notifyListeners();

    final isOnline =
        navigatorKey.currentContext!.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      isgetVenueDetailsGetting = false;
      notifyListeners();
      return;
    }

    try {
      final response = await BookTabService().getCouponService();

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        final List<dynamic> couponData = data['existingCoupons'] ?? [];
        couponList =
            couponData.map((item) => CouponModel.fromJson(item)).toList();
        notifyListeners();
      } else {
        GlobalSnackbar.error(navigatorKey.currentContext!, response.message);
      }
    } catch (e) {
      debugPrint("Error fetching slot prices: $e");
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Something went wrong",
      );
    } finally {
      isCouponLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(BuildContext context, int venueId) async {
    final isOnline =
        navigatorKey.currentContext!.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    final previousFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    isFavoriteLoading = true;
    notifyListeners();

    try {
      final response = await BookTabService().addFavoriteService(venueId);

      if (response.isSuccess) {
        final Map<String, dynamic> data = jsonDecode(response.responseData);
        isFavorite = data['isFavorite'] == true;
        GlobalSnackbar.success(context, response.message);
      } else {
        isFavorite = previousFavoriteStatus;
        GlobalSnackbar.error(context, response.message);
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
      isFavorite = previousFavoriteStatus;
      GlobalSnackbar.error(context, "Something went wrong");
    } finally {
      isFavoriteLoading = false;
      notifyListeners();
    }
  }

  Future<void> getVenueDetails(int facilityId) async {
    final isOnline =
        navigatorKey.currentContext!.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }
    isgetVenueDetailsGetting = true;
    notifyListeners();

    try {
      final response = await BookTabService().getAllVenueDetailsServices(
        facilityId,
      );

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        final responseJson = data['response'];
        venueDetailModel = VenueDetailModel.fromJson(responseJson);
        isFavorite = venueDetailModel?.isFavorite ?? false;
      } else {
        debugPrint("API Error: ${response.message}");
      }
    } catch (e) {
      debugPrint("Error fetching venue details: $e");
    } finally {
      isgetVenueDetailsGetting = false;
      notifyListeners();
    }
  }

  void updateStartDateIfNeeded(DateTime newDate) {
    // If selectedDate not visible in current 5-day window
    final listDates = List.generate(
      5,
      (i) => startDateForList.add(Duration(days: i)),
    );
    final isInList = listDates.any((d) => isSameDay(d, newDate));

    if (!isInList) {
      startDateForList = newDate;
    }

    selectedDate = newDate;
    notifyListeners();
  }

  void updateUserRating(int rating) {
    userRating = rating;
    notifyListeners();
  }

  void updateUserComment(String comment) {
    userComment = comment;
    notifyListeners();
  }

  void resetRating() {
    userRating = 0;
    userComment = '';
    notifyListeners();
  }

  Future<void> openMapForVenue(
    BuildContext context,
    String googleMapUrl,
  ) async {
    if (googleMapUrl.isEmpty) {
      _showMapErrorDialog(context, "Google Map URL not available");
      return;
    }

    final url = Uri.parse(googleMapUrl);

    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showMapErrorDialog(context, "Could not open Google Maps");
      }
    } catch (e) {
      debugPrint("❌ Could not launch map: $e");
      _showMapErrorDialog(context, "Could not open Google Maps");
    }
  }

  void _showMapErrorDialog(BuildContext context, String address) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: const [
                Icon(Icons.location_off, color: Colors.redAccent),
                SizedBox(width: 8),
                Text("Unable to Open Map"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "We couldn't open the map directly.",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                const Text("You can manually search for:"),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: address));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Address copied to clipboard"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text("Copy Address"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  void clearBookingData() {
    isFavorite = false;
    isFavoriteLoading = false;
    isgetVenueDetailsGetting = false;
    venueDetailModel = null;
    currentImageIndex = 0;
    selectedSport = null;
    selectedDate = DateTime.now();
    isCalendarExpanded = false;
    selectedSlot = null;
    offerDiscount = 0;
    // convenienceFee = 0;
    selectedStartTime = TimeOfDay(hour: 16, minute: 0);
    minMinutesSport = 60;
    selectedTurfIndexes.clear();
    selectedTurfIds.clear();
    selectedSportId = null;
    // Reset coupon-related variables
    couponList.clear();
    couponController.clear();
    selectedCouponCode = null;
    couponAppliedMessage = '';
    isCouponApplied = false;
    isCouponApplying = false;
    isCouponLoading = false;
    useCoins = false;
    appliedCoins = 0;
    showConvenienceBreakdown = false;
    notifyListeners();
  }

  void clearDateTimeRange() {
    selectedSlot = null;
    selectedTurfIndexes.clear();
    selectedStartTime = TimeOfDay(hour: 0, minute: 0);
    availableTurfIdsForSelectedTimeDate.clear();
    minMinutesSport = 60;
    selectedTurfIds.clear();
    selectedDate = DateTime.now();
    filteredAvailableSlotsForSelectedDate = null;
    notifyListeners();
  }

  Future<void> getReviews({required int venueId}) async {
    isReviewsLoading = true;
    notifyListeners();

    final isOnline =
        navigatorKey.currentContext!.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "No internet connection",
      );
      isReviewsLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await BookTabService().getReviewsService(venueId);

      if (response.isSuccess) {
        final responseData = jsonDecode(response.responseData);

        // ✅ Store entire model
        venueReviews = VenueReviewsResponseModel.fromJson(responseData);
      } else {
        venueReviews = null;
        // GlobalSnackbar.error(navigatorKey.currentContext!, response.message);
      }
    } catch (e) {
      debugPrint("Error rating venue: $e");
      // GlobalSnackbar.error(
      //   navigatorKey.currentContext!,
      //   "Something went wrong",
      // );
    } finally {
      isReviewsLoading = false;
      notifyListeners();
    }
  }

  Future<void> rateVenueProvider({
    required int venueId,
    required int bookingId,
    required int rating,
    required String feedback,
  }) async {
    isRatevenue = true;
    notifyListeners();

    final isOnline =
        navigatorKey.currentContext!.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "No internet connection",
      );
      isRatevenue = false;
      notifyListeners();
      return;
    }

    try {
      final response = await BookTabService().rateVenueService(
        venueId: venueId,
        bookingId: bookingId,
        rating: rating,
        feedback: feedback,
      );

      if (response.isSuccess) {
        GlobalSnackbar.success(navigatorKey.currentContext!, "Rating added");
      } else {
        GlobalSnackbar.error(navigatorKey.currentContext!, response.message);
      }
    } catch (e) {
      debugPrint("Error rating venue: $e");
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Something went wrong",
      );
    } finally {
      isRatevenue = false;
      notifyListeners();
    }
  }

  Future<void> proceedToPay(VenueDetailModel model) async {
    isProceedToPlay = true;
    notifyListeners();

    final isOnline =
        navigatorKey.currentContext!.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "No internet connection",
      );
      isProceedToPlay = false;
      notifyListeners();
      return;
    }

    try {
      // Build only the required request body
      final reqBody = {
        "sportId": selectedSportId,
        "date": DateFormat("ddList (0 items)-MM-yyyy").format(selectedDate),
        "startTime": formatTimeApi(selectedStartTime),
        "endTime": formatTimeApi(_calculateEndTime()),
        "turfIds": selectedTurfIds,

        "basePrice": totalPriceBeforeDiscountall,
        "couponDiscountAmount": offerDiscount,
        "coinDiscountUsed": coinDiscount,
        "coinWalletId": coinWalletId,
        "usedCoins": appliedCoins,
        "platformFees": platformFee.toStringAsFixed(2),
        "gst": gstOnPlatformFee.toStringAsFixed(2),
        "convenienceFees": convenienceFee.toStringAsFixed(2),
        "totalPrice": finalPayableAmount.toStringAsFixed(2),
      };

      debugPrint("Proceed to Pay Req Body: $reqBody");
      final response = await BookTabService().proceedToPayService(
        reqBody: reqBody,
      );

      if (response.isSuccess) {
        final responseData = jsonDecode(response.responseData);
        final now = DateTime.now();
        bookingId = responseData['response']['booking_id'];
        paymentId = responseData['response']['paymentId'];
        paymentDate = DateFormat("dd MMMM yyyy").format(now);
        paymentTime = DateFormat("hh:mm a").format(now);
        // 🔁 Refresh coin data after booking success
        navigatorKey.currentContext!.read<HomeTabProvider>().getCoinsData(
          navigatorKey.currentContext!,
        );

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => CongratulationBooking(model: model),
            ),
          );
        });
      } else {
        GlobalSnackbar.error(navigatorKey.currentContext!, response.message);
      }
    } catch (e) {
      debugPrint("Error in proceedToPay: $e");
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Something went wrong",
      );
    } finally {
      isProceedToPlay = false;
      notifyListeners();
    }
  }

  Future<bool> checkTurfAvailability({required int venueId}) async {
    isTurfAvailable = true;
    notifyListeners();
    try {
      final reqBody = {
        "venueId": venueId,
        "sportId": selectedSportId,
        "date": DateFormat("dd-MM-yyyy").format(selectedDate),
        "startTime": formatTimeApi(selectedStartTime),
        "endTime": formatTimeApi(_calculateEndTime()),
        "turfIds": selectedTurfIds,
      };

      debugPrint("Check Turf Availability Req Body: $reqBody");

      final response = await BookTabService().checkTurfAvailableService(
        reqBody: reqBody,
      );

      if (response.isSuccess) {
        final responseData = jsonDecode(response.responseData);
        final List availableTurfs =
            responseData['response']['list_of_available_turfs'];

        final List<int> availableTurfIds =
            availableTurfs.map<int>((item) => item['unit_id'] as int).toList();

        final allSelectedAreAvailable = selectedTurfIds.every(
          (id) => availableTurfIds.contains(id),
        );

        if (allSelectedAreAvailable) {
          debugPrint("All selected turfs are available.");
          return true;
        } else {
          GlobalSnackbar.error(
            navigatorKey.currentContext!,
            "Some selected turfs are not available.",
          );
          return false;
        }
      } else {
        GlobalSnackbar.bottomError(
          navigatorKey.currentContext!,
          response.message,
        );

        return false;
      }
    } catch (e) {
      debugPrint("Error in checkTurfAvailability: $e");
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Something went wrong",
      );
      return false;
    } finally {
      isTurfAvailable = false;
      notifyListeners();
    }
  }
}
