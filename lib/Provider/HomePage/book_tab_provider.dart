import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkmarts/Models/HomeTab_Models/Venue_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BookTabProvider extends ChangeNotifier {
  bool isgetVenueDetailsGetting = false;
  VenueDetailModel? venueDetailModel;
  final PageController imagePageController = PageController();
  int currentImageIndex = 0;
  String? selectedSport;
  DateTime selectedDate = DateTime.now();
  bool isCalendarExpanded = false;
  String? selectedSlot;
  int offerDiscount = 100;
  int convenienceFee = 50;

  TimeOfDay selectedStartTime = TimeOfDay(hour: 0, minute: 0);

  int selectedDurationInHours = 1;

  int userRating = 0;
  String userComment = '';

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

  List<int> selectedTurfIndexes = [];

  int get finalPayableAmount =>
      totalPriceBeforeDiscountall - offerDiscount + convenienceFee;

  bool applyCoupon(String code) {
    final enteredCode = code.trim().toUpperCase();

    if (enteredCode == 'DISCOUNT100') {
      offerDiscount = 100;
      notifyListeners();
      return true;
    }

    return false;
  }

  int get totalPriceBeforeDiscountall {
    int turfCount = selectedTurfIndexes.length;
    if (turfCount == 0) return 0;
    return turfCount * selectedDurationInHours * (venueDetailModel?.price ?? 0);
  }

  void toggleTurfSelection(int index) {
    if (selectedTurfIndexes.contains(index)) {
      selectedTurfIndexes.remove(index);
    } else {
      selectedTurfIndexes.add(index);
    }
    notifyListeners();
  }

  void incrementDuration() {
    if (selectedDurationInHours < 6) {
      selectedDurationInHours++;
      notifyListeners();
    }
  }

  void decrementDuration() {
    if (selectedDurationInHours > 1) {
      selectedDurationInHours--;
      notifyListeners();
    }
  }

  void setStartTime(TimeOfDay time) {
    selectedStartTime = time;
    notifyListeners();
  }

  String get timeRangeString {
    final now = TimeOfDay.now();
    final start = selectedStartTime;
    final endHour = (start.hour + selectedDurationInHours) % 24;
    final endTime = TimeOfDay(hour: endHour, minute: start.minute);
    String format(TimeOfDay time) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return "$hour:$minute $period"; // Example: 4:00 PM
    }

    return "${format(start)} - ${format(endTime)}";
  }

  void selectSlot(String slot) {
    selectedSlot = slot;
    notifyListeners();
  }

  void toggleCalendar() {
    isCalendarExpanded = !isCalendarExpanded;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    isCalendarExpanded = false;
    notifyListeners();
  }

  //   if (!provider.isSportSelected()) {
  //   GlobalSnackbar.showWarning(context, "Please select a sport to proceed.");
  //   return;
  // }

  void selectSport(String sportName) {
    selectedSport = sportName;
    notifyListeners();
  }

  bool isSportSelected() {
    return selectedSport != null;
  }

  void setCurrentImageIndex(int index) {
    currentImageIndex = index;
    notifyListeners();
  }

  Future<void> openMapForVenue(BuildContext context) async {
    final model = venueDetailModel;

    if (model == null || model.venueName.isEmpty || model.venueAddress.isEmpty)
      return;

    final fullQuery = '${model.venueName}, ${model.venueAddress}';
    final encodedQuery = Uri.encodeComponent(fullQuery);
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedQuery',
    );

    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showMapErrorDialog(context, fullQuery);
      }
    } catch (e) {
      debugPrint('❌ Could not launch map: $e');
      _showMapErrorDialog(context, fullQuery);
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

  Future<void> getVenueDetails(String venueId) async {
    isgetVenueDetailsGetting = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final dummyResponse = {
        "venueId": venueId,
        "venueName": "Mavericks Cricket Academy",
        "venueAddress":
            "Shankar Kalate Nagar, Opp. Silver Fitness Club, Wakad, Pune 57",
        "images": [
          "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
          "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
          "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
        ],
        "rating": 4.2,
        "totalReviews": 38,
        "price": 600,
        "availableSports": [
          {
            "sportName": "Cricket",
            "image":
                "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
          },
          {
            "sportName": "Football",
            "image":
                "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
          },
        ],
        "amenities": ["Washroom", "Changing Room", "Shower", "Drinking Water"],
        "totalGamesPlayed": 158,
        "turfCount": 3,
      };

      venueDetailModel = VenueDetailModel.fromJson(dummyResponse);
    } catch (e) {
      debugPrint("Error fetching venue details: $e");
    } finally {
      isgetVenueDetailsGetting = false;
      notifyListeners();
    }
  }

  void clearBookingData() {
    isgetVenueDetailsGetting = false;
    venueDetailModel = null;
    currentImageIndex = 0;
    selectedSport = null;
    selectedDate = DateTime.now();
    isCalendarExpanded = false;
    selectedSlot = null;
    offerDiscount = 100;
    convenienceFee = 50;
    selectedStartTime = TimeOfDay(hour: 16, minute: 0);
    selectedDurationInHours = 1;
    selectedTurfIndexes.clear();
    notifyListeners();
  }
}
