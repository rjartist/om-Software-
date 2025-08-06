import 'package:flutter/material.dart';
import 'package:gkmarts/Models/BookTabModel/slot_price_model.dart';
import 'package:gkmarts/Models/BookTabModel/venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/booking_proceed_pay.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:gkmarts/Widget/mobile_otp_login_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingDateTimePage extends StatefulWidget {
  final VenueDetailModel model;

  const BookingDateTimePage({super.key, required this.model});

  @override
  State<BookingDateTimePage> createState() => _BookingDateTimePageState();
}

class _BookingDateTimePageState extends State<BookingDateTimePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookTabProvider>(context, listen: false).getSlotPrices(
        widget.model.modifiedFacility.facilityId,
        widget.model.modifiedFacility.services.first.serviceId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context);

    return Stack(
      children: [
        PopScope(
          canPop: true,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              Provider.of<BookTabProvider>(
                context,
                listen: false,
              ).clearDateTimeRange();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.bgColor,
            appBar: GlobalAppBar(
              title: "Booking",
              showBackButton: true,
              onBackTap: () {
                Provider.of<BookTabProvider>(
                  context,
                  listen: false,
                ).clearDateTimeRange();
                Navigator.pop(context);
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 25,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSelectedSport(context, widget.model, provider),
                    buildDateSelector(context, provider),
                    SlotDropdown(),
                    TimeAndDurationWidget(),
                    buildAvailableTurfSelector(context, provider),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ₹${provider.totalPriceBeforeDiscountall}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GlobalPrimaryButton(
                      height: 43,
                      text: "Next",
                      onTap: () async {
                        final bookProvider = Provider.of<BookTabProvider>(
                          context,
                          listen: false,
                        );
              
                        final isLoggedIn = await AuthService.isLoggedIn();
              
                        if (!isLoggedIn) {
                          // If not logged in, navigate to login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MobileInputPage(),
                            ),
                          );
                          return; // Prevent further execution
                        }
              
                        // If logged in, proceed to booking page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BookingProceedPayPage(
                                  model: widget.model,
                                  totalAmount:
                                      bookProvider.totalPriceBeforeDiscountall,
                                ),
                          ),
                        );
                      },
              
                      isEnabled: provider.isBookingReady,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Loader overlay when checking turf availability
        if (provider.isTurfAvailable)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          ),
      ],
    );
  }

  Widget buildAvailableTurfSelector(
    BuildContext context,
    BookTabProvider provider,
  ) {
    final availableTurfs = provider.getAvailableTurfsForSelectedSlotAndDate();
    final availableTurfIds = provider.availableTurfIdsForSelectedTimeDate;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isSlotAndTimeSelected =
        provider.selectedSlot != null &&
        (provider.selectedStartTime.hour != 0 ||
            provider.selectedStartTime.minute != 0);

    if (availableTurfs.isEmpty && isSlotAndTimeSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        alignment: Alignment.center,
        child: Text(
          "No turfs are available for the selected date and time. Please reselect and try again.",
          style: AppTextStyle.greytext(),
          textAlign: TextAlign.center,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    if (availableTurfs.isEmpty && !isSlotAndTimeSelected) {
      return const SizedBox(height: 60);
    }

    // ✅ Deselect previously selected unavailable turfs
    provider.selectedTurfIndexes.removeWhere((index) {
      if (index >= availableTurfs.length) return true; // prevent out-of-bounds
      final turf = availableTurfs[index];
      final unitId = turf['unitId'] ?? 0;
      return !availableTurfIds.contains(unitId);
    });

    // ✅ Auto-select first available turf
    if (!provider.isTurfAutoSelected &&
        provider.selectedTurfIds.isEmpty &&
        availableTurfs.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final firstAvailableIndex = availableTurfs.indexWhere(
          (turf) => availableTurfIds.contains(turf['unitId']),
        );
        if (firstAvailableIndex != -1) {
          final turf = availableTurfs[firstAvailableIndex];
          provider.toggleTurfSelection(firstAvailableIndex, turf['unitId']);
          provider.isTurfAutoSelected = true;
        }
      });
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.3),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Turf(s)", style: AppTextStyle.titleSmallText()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(availableTurfs.length, (index) {
                final turf = availableTurfs[index];
                final int unitId = turf['unitId'] ?? 0;
                final String unitName = turf['unitName'] ?? "Turf ${index + 1}";

                final bool isAvailable = availableTurfIds.contains(unitId);
                final bool isSelected = provider.selectedTurfIndexes.contains(
                  index,
                );

                return GestureDetector(
                  onTap: () {
                    if (isAvailable) {
                      provider.toggleTurfSelection(index, unitId);
                    } else {
                      GlobalSnackbar.bottomError(
                        context,
                        "This turf is already booked for the selected date and time.",
                      );
                    }
                  },
                  child: Container(
                    width: 170,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? null
                              : isAvailable
                              ? Colors.transparent
                              : Colors.grey.shade300,
                      gradient:
                          isSelected
                              ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.profileSectionButtonColor,
                                  AppColors.profileSectionButtonColor2,
                                ],
                              )
                              : null,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            unitName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  isAvailable
                                      ? (isSelected
                                          ? Colors.white
                                          : Colors.black)
                                      : Colors.black54,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (!isAvailable)
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.lock,
                              size: 16,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void showPriceChartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return const PriceChartBottomSheetTable();
      },
    );
  }

  Widget buildDateSelector(BuildContext context, BookTabProvider provider) {
    final now = DateTime.now();
    final days = List.generate(
      30,
      (index) => now.add(Duration(days: index)),
    ); // 30 future days

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Select Date", style: AppTextStyle.titleSmallText()),

            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.calendar_month,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      isScrollControlled: true,
                      builder: (_) {
                        return FractionallySizedBox(
                          heightFactor: 0.55,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Text(
                                  "Select a Date",
                                  style: AppTextStyle.titleSmallText(),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: TableCalendar(
                                    firstDay: now,
                                    // lastDay: now.add(const Duration(days: 365)),
                                    lastDay: now.add(const Duration(days: 30)),

                                    focusedDay: provider.selectedDate,
                                    selectedDayPredicate:
                                        (day) => isSameDay(
                                          provider.selectedDate,
                                          day,
                                        ),
                                    onDaySelected: (selectedDay, _) {
                                      provider.clearDateTimeRange();
                                      provider.selectDate(selectedDay);

                                      final isToday = isSameDay(
                                        DateTime.now(),
                                        selectedDay,
                                      );
                                      final currentTime =
                                          isToday ? DateTime.now() : null;

                                      provider.getSlotOptionsByDate(
                                        selectedDate: selectedDay,
                                        currentTime: currentTime ?? selectedDay,
                                      );

                                      Navigator.pop(context);
                                    },

                                    calendarStyle: const CalendarStyle(
                                      selectedDecoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      todayDecoration: BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    headerStyle: const HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    showPriceChartBottomSheet(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgColor,

                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.currency_rupee_rounded,
                          size: 16,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Price Chart",
                          style: AppTextStyle.blackText(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (_, index) {
              final date = days[index];
              final isSelected = isSameDay(provider.selectedDate, date);

              return GestureDetector(
                onTap: () {
                  provider.clearDateTimeRange();
                  provider.selectDate(date);

                  final isToday = isSameDay(DateTime.now(), date);
                  final currentTime = isToday ? DateTime.now() : null;
                  final slotOptions = provider.getSlotOptionsByDate(
                    selectedDate: date,
                    currentTime:
                        currentTime ?? date, // Passing date as a fallback
                  );

                  debugPrint("Slot options: $slotOptions");
                },

                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient:
                        isSelected
                            ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.profileSectionButtonColor,
                                AppColors.profileSectionButtonColor2,
                              ],
                            )
                            : null,
                    color: isSelected ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderColor),
                  ),

                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildSelectedSport(
    BuildContext context,
    VenueDetailModel model,
    BookTabProvider provider,
  ) {
    final services = model.modifiedFacility.services;

    if (provider.selectedSport == null || provider.selectedSport!.isEmpty) {
      return const SizedBox();
    }

    final selectedService = services.firstWhere(
      (service) => service.serviceName == provider.selectedSport,
      orElse:
          () => Service(
            serviceId: 0,
            serviceName: '',
            minHour: 0,
            serviceImages: [],
            units: [],
          ),
    );

    if (selectedService.serviceName.isEmpty) return const SizedBox();

    final imageUrl =
        selectedService.serviceImages.isNotEmpty
            ? selectedService.serviceImages.first.image
            : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.profileSectionButtonColor,
                AppColors.profileSectionButtonColor2,
              ],
            ),
            border: Border.all(color: AppColors.borderColor, width: 1.5),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(child: buildNetworkOrSvgImage(imageUrl)),

              const SizedBox(height: 4),
              Text(
                selectedService.serviceName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeAndDurationWidget extends StatelessWidget {
  const TimeAndDurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookTabProvider>();
    final bool isSlotSelected = provider.selectedSlot != null;
    final slotPrice = provider.getSelectedSlotPrice();

    final boxHeight = 69.0;
    final boxSpacing = 12.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          // TIME Box
          Expanded(
            child: GestureDetector(
              // onTap: () async {
              //   if (!isSlotSelected) {
              //     GlobalSnackbar.bottomError(
              //       navigatorKey.currentContext!,
              //       "Please select a slot first.",
              //     );
              //     return;
              //   }

              //   final slotStart = slotPrice?.startTime ?? "00:00:00";
              //   final slotEnd = slotPrice?.endTime ?? "00:00:00";

              //   final slotStartParts =
              //       slotStart.split(":").map(int.parse).toList();
              //   final slotEndParts = slotEnd.split(":").map(int.parse).toList();

              //   final picked = await showTimePicker(
              //     context: context,
              //     initialTime: provider.selectedStartTime,
              //   );

              //   if (picked != null) {
              //     final pickedMinutes = picked.hour * 60 + picked.minute;
              //     final slotStartMinutes =
              //         slotStartParts[0] * 60 + slotStartParts[1];
              //     final slotEndMinutes = slotEndParts[0] * 60 + slotEndParts[1];

              //     if (pickedMinutes >= slotStartMinutes &&
              //         pickedMinutes < slotEndMinutes) {
              //       provider.setStartTime(picked);
              //     } else {
              //       GlobalSnackbar.bottomError(
              //         navigatorKey.currentContext!,
              //         "Please select a time within the slot range.",
              //       );
              //     }
              //   }
              // },
              onTap: () async {
                if (!isSlotSelected) {
                  GlobalSnackbar.bottomError(
                    navigatorKey.currentContext!,
                    "Please select a slot first.",
                  );
                  return;
                }

                final slotStart = slotPrice?.startTime ?? "00:00:00";
                final slotEnd = slotPrice?.endTime ?? "00:00:00";

                final slotStartParts =
                    slotStart.split(":").map(int.parse).toList();
                final slotEndParts = slotEnd.split(":").map(int.parse).toList();

                final slotStartTime = TimeOfDay(
                  hour: slotStartParts[0],
                  minute: slotStartParts[1],
                );
                final slotEndTime = TimeOfDay(
                  hour: slotEndParts[0],
                  minute: slotEndParts[1],
                );

                final selected = await showModalBottomSheet<TimeOfDay>(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder:
                      (_) => SlotTimePickerSheet(
                        start: slotStartTime,
                        end: slotEndTime,
                        intervalMinutes:
                            provider.slotPriceModel?.minimumMinutesSport ?? 30,
                      ),
                );

                if (selected != null) {
                  provider.setStartTime(selected);
                }
              },

              child: Container(
                height: boxHeight,
                margin: EdgeInsets.only(right: boxSpacing / 2),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "TIME",
                        style: AppTextStyle.primaryText(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              isSlotSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSlotSelected ? provider.timeRangeString : "-- : --",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSlotSelected ? Colors.black : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // DURATION Box
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isSlotSelected) {
                  GlobalSnackbar.bottomError(
                    navigatorKey.currentContext!,
                    "Please select a slot first.",
                  );
                  return;
                }
              },
              child: Container(
                height: boxHeight,
                margin: EdgeInsets.only(left: boxSpacing / 2),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "DURATION",
                      style: AppTextStyle.primaryText(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            isSlotSelected
                                ? AppColors.primaryColor
                                : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap:
                              isSlotSelected
                                  ? provider.decrementDuration
                                  : () {
                                    GlobalSnackbar.bottomError(
                                      navigatorKey.currentContext!,
                                      "Please select a slot first.",
                                    );
                                  },
                          child: Icon(
                            Icons.remove_circle_outline,
                            size: 20,
                            color: isSlotSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            isSlotSelected
                                ? _formatDuration(
                                  provider.minMinutesSport ?? 60,
                                )
                                : "--",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color:
                                  isSlotSelected ? Colors.black : Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap:
                              isSlotSelected
                                  ? provider.incrementDuration
                                  : () {
                                    GlobalSnackbar.bottomError(
                                      navigatorKey.currentContext!,
                                      "Please select a slot first.",
                                    );
                                  },
                          child: Icon(
                            Icons.add_circle_outline,
                            size: 20,
                            color: isSlotSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return "$hours hr $minutes min";
    } else if (hours > 0) {
      return "$hours hr";
    } else {
      return "$minutes min";
    }
  }
}

class SlotTimePickerSheet extends StatelessWidget {
  final TimeOfDay start;
  final TimeOfDay end;
  final int intervalMinutes;

  const SlotTimePickerSheet({
    super.key,
    required this.start,
    required this.end,
    required this.intervalMinutes,
  });

  List<Map<String, TimeOfDay>> _generateTimeSlots() {
    final slots = <Map<String, TimeOfDay>>[];
    var current = start;

    while (_isBefore(current, end)) {
      final next = _addMinutes(current, intervalMinutes);
      if (_isBefore(next, end) || _isSame(next, end)) {
        slots.add({"start": current, "end": next});
      }
      current = next;
    }

    return slots;
  }

  bool _isBefore(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }

  bool _isSame(TimeOfDay a, TimeOfDay b) {
    return a.hour == b.hour && a.minute == b.minute;
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutesToAdd) {
    final totalMinutes = time.hour * 60 + time.minute + minutesToAdd;
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    final slots = _generateTimeSlots();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Select Time Slot",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: slots.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final slot = slots[index];
                final start = slot["start"]!;
                final end = slot["end"]!;
                final slotText =
                    "${start.format(context)} – ${end.format(context)}";

                return ListTile(
                  title: Text(slotText, style: const TextStyle(fontSize: 15)),
                  onTap: () {
                    // Send only the start time back
                    Navigator.pop(context, start);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SlotDropdown extends StatelessWidget {
  const SlotDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookTabProvider>();
    final isToday = isSameDay(provider.selectedDate, DateTime.now());

    final slotOptions = provider.getSlotOptionsByDate(
      selectedDate: provider.selectedDate,
      currentTime:
          isToday
              ? DateTime.now()
              : DateTime(
                provider.selectedDate.year,
                provider.selectedDate.month,
                provider.selectedDate.day,
              ),
    );
    final hasActiveSlots = slotOptions.any((slot) => slot["isActive"]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Slot", style: AppTextStyle.titleSmallText()),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (!hasActiveSlots) {
              GlobalSnackbar.bottomError(
                navigatorKey.currentContext!,
                "No slots available for the selected date.",
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.selectedSlot,
                hint: Text(
                  "Choose a slot",
                  style: AppTextStyle.blackText(fontSize: 14),
                ),
                items:
                    slotOptions.map((slot) {
                      return DropdownMenuItem<String>(
                        value: slot["isActive"] ? slot["value"] : null,
                        enabled: slot["isActive"],
                        child: Text(
                          slot["label"],
                          style: AppTextStyle.blackText(
                            fontSize: 14,
                            color:
                                slot["isActive"] ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    provider.selectSlot(value);
                  }
                },
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PriceChartBottomSheetTable extends StatelessWidget {
  const PriceChartBottomSheetTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookTabProvider>();
    final organizedChart = provider.getOrganizedSlotChart();

    final List<SlotPrice> allSlots = [];

    organizedChart.forEach((slotType, slotNameMap) {
      slotNameMap.forEach((slotName, slots) {
        allSlots.addAll(slots);
      });
    });

    allSlots.sort((a, b) => a.startTime.compareTo(b.startTime));

    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.6, // Set height to 60% of screen height
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text("Price Chart", style: AppTextStyle.boldBlackText()),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                children: const [
                  Expanded(flex: 1, child: Center(child: Text("Slot"))),
                  Expanded(child: Center(child: Text("Type"))),
                  Expanded(child: Center(child: Text("Time"))),
                  Expanded(child: Center(child: Text("Rate"))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              // Ensures ListView takes remaining space only
              child:
                  allSlots.isEmpty
                      ? Center(
                        child: Text(
                          "No slots available",
                          style: AppTextStyle.smallGrey(),
                        ),
                      )
                      : ListView.builder(
                        itemCount: allSlots.length,
                        itemBuilder: (_, index) {
                          final slot = allSlots[index];
                          final isWeekend =
                              slot.slotType.toLowerCase() == "weekend";
                          final bgColor =
                              isWeekend
                                  ? Colors.red.withOpacity(0.04)
                                  : (Colors.grey[50] ?? Colors.grey);

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            color: bgColor,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      slot.slotName,
                                      style: AppTextStyle.blackText(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      slot.slotType,
                                      style: AppTextStyle.smallGrey(
                                        color:
                                            isWeekend
                                                ? Colors.red
                                                : (Colors.grey[700] ??
                                                    Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "${formatTimeOnly12(slot.startTime)} - ${formatTimeOnly12(slot.endTime)}",
                                      style: AppTextStyle.smallGrey(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "₹${slot.rate}",
                                      style: AppTextStyle.blackText(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
