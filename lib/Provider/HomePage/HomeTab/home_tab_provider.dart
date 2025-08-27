import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkmarts/Models/GenaralModels/coins_model.dart';
import 'package:gkmarts/Models/HomeTab_Models/banner_model.dart';
import 'package:gkmarts/Models/HomeTab_Models/game_join_model.dart';
import 'package:gkmarts/Models/BookTabModel/venue_model.dart';
import 'package:gkmarts/Models/HomeTab_Models/notification_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Provider/Location/location_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Services/BookTab/book_tab_service.dart';
import 'package:gkmarts/Services/HomeTab/home_tab_service.dart';
import 'package:gkmarts/Utils/SharedPrefHelper/shared_local_storage.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_coins.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:provider/provider.dart';

class HomeTabProvider with ChangeNotifier {
  bool isBannerGetting = false;
  bool isBookVenueLoading = false;
  bool isGamesLoading = false;
  List<VenueModel> venueList = [];
  List<VenueModel> filteredVenueList = [];

  List<GameJoinModel> joinGameList = [];
  bool isJoinGameLoading = false;
  List<BannerModel> bannerList = [];
  int _currentBannerIndex = 0;
  int get currentBannerIndex => _currentBannerIndex;

  int unreadNotifications = 0;
  List<NotificationModel> notificationList = [];
  bool isNotificationsLoading = false;

  //--
  int _selectedServiceIndex = -1;
  int get selectedServiceIndex => _selectedServiceIndex;
  CoinsModel? coinsModel;
  bool isCoinsLoading = false;

  void setVenueList(List<VenueModel> venues) {
    venueList = venues;
    filteredVenueList = venues;
    notifyListeners();
  }

  void searchVenues(String query) {
    if (query.isEmpty) {
      filteredVenueList = venueList;
    } else {
      filteredVenueList =
          venueList
              .where(
                (venue) =>
                    venue.venueName.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    notifyListeners();
  }

  Future<void> toggleFavoriteVenue(BuildContext context, int venueId) async {
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    // Find the venue in the list
    final index = filteredVenueList.indexWhere(
      (venue) => venue.facilityId == venueId,
    );
    if (index == -1) return;

    // Optimistically update UI
    filteredVenueList[index] = filteredVenueList[index].copyWith(
      isFavorite: !filteredVenueList[index].isFavorite,
    );
    notifyListeners();

    try {
      // Call API to update favorite status
      final response = await BookTabService().addFavoriteService(venueId);

      if (response.isSuccess) {
        GlobalSnackbar.success(context, response.message);
      } else {
        // Revert change if API fails
        filteredVenueList[index] = filteredVenueList[index].copyWith(
          isFavorite: !filteredVenueList[index].isFavorite,
        );
        notifyListeners();
        GlobalSnackbar.error(context, response.message);
      }
    } catch (e) {
      // Revert change on error
      filteredVenueList[index] = filteredVenueList[index].copyWith(
        isFavorite: !filteredVenueList[index].isFavorite,
      );
      notifyListeners();
      GlobalSnackbar.error(context, "Something went wrong");
    }
  }

  Future<void> getNotifications(BuildContext context) async {
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;
    if (!isOnline) return;

    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) return;

    isNotificationsLoading = true;
    notifyListeners();

    try {
      final response = await HomeTabService().getNotificationService();

      if (response.isSuccess) {
        notificationList.clear();
        unreadNotifications = 0;
        final data = jsonDecode(response.responseData);

        unreadNotifications = data['unreadCount'] ?? 0;

        // Parse notifications list
        notificationList =
            (data['data'] as List)
                .map((e) => NotificationModel.fromJson(e))
                .toList();
      } else {
        notificationList.clear();
        unreadNotifications = 0;
      }
    } catch (e) {
      notificationList.clear();
      unreadNotifications = 0;
    } finally {
      isNotificationsLoading = false;
      notifyListeners();
    }
  }

  // Mark all unread notifications as read
  Future<void> markUnreadAsRead(BuildContext context) async {
    try {
      // 1. Collect unread notification IDs
      final unreadIds =
          notificationList.where((n) => !n.isRead).map((n) => n.id).toList();

      if (unreadIds.isEmpty) return; // nothing to mark as read

      debugPrint("📩 Marking notifications as read: $unreadIds");

      // 2. Call API to mark them as read
      final response = await HomeTabService().markNotificationsAsRead(
        unreadIds,
      );

      if (response.isSuccess) {
        // 3. Update local state
        for (var n in notificationList) {
          if (unreadIds.contains(n.id)) {
            n.isRead = true;
          }
        }

        unreadNotifications = 0;
        notifyListeners();
      } else {
        debugPrint("Failed to mark notifications as read: ${response.message}");
      }
    } catch (e) {
      debugPrint("Error marking notifications as read: $e");
    }
  }

  Future<void> showCoinPopupOnce(BuildContext context) async {
    // final coins = coinsModel?.remainingBonusCoins ?? 0;
    // showCoinPopup(context, coins);

    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      return;
    }
    // final coins = coinsModel?.remainingBonusCoins ?? 0;
    // showCoinPopup(context, coins);
    if (!SharedPrefHelper.hasShownCoinPopup()) {
      final coins = coinsModel?.remainingBonusCoins ?? 0;
      if (coins > 0) {
        await SharedPrefHelper.markCoinPopupShown();
        showCoinPopup(context, coins);
      }
    }
  }

  void showCoinPopup(BuildContext context, int coins) {
    final expiryDate = coinsModel?.bonusExpiry;
    final formattedExpiry =
        expiryDate != null ? formatFullDate(expiryDate) : 'soon';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie.asset(
                //   'assets/animations/coins.json', // ✅ Add your Lottie animation file
                //   height: 150,
                //   repeat: false,
                // ),
                const SizedBox(height: 12),
                Text(
                  "Bonus Coins 🎉",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "You’ve received $coins bonus coins!\nUse them on your bookings within the next 90 days .\nHurry! Coins expire on $formattedExpiry.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),

                GlobalSmallButton(
                  width: 150,
                  height: 40,
                  text: "View My Coins",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyCoins()),
                    );
                  },
                  backgroundColor: AppColors.white,
                  textColor: AppColors.primaryColor,
                  borderColor: AppColors.borderColor,
                ),
                const SizedBox(height: 20),
                GlobalButton(
                  width: 150,
                  height: 40,
                  text: "Got it!",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getCoinsData(BuildContext context) async {
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;
    if (!isOnline) return;

    final isLoggedIn = await AuthService.isLoggedIn();

    if (!isLoggedIn) {
      return;
    }

    isCoinsLoading = true;
    notifyListeners();

    try {
      final response = await HomeTabService().getUserCoinsService();

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        if (data['success'] == true) {
          coinsModel = CoinsModel.fromJson(data);
        } else {
          debugPrint("Coins API returned success=false");
        }
      } else {
        debugPrint("Coins API error: ${response.message}");
      }
    } catch (e) {
      debugPrint("Coins fetch error: $e");
    } finally {
      isCoinsLoading = false;
      notifyListeners();
    }
  }

  void setSelectedService(int index) {
    _selectedServiceIndex = index;
    notifyListeners();
  }

  void setBannerIndex(int index) {
    _currentBannerIndex = index;
    notifyListeners();
  }

  Future<bool> getBookVenue(BuildContext context) async {
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;
    if (!isOnline) return false;

    isBookVenueLoading = true;
    notifyListeners();

    try {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      final city =
          locationProvider.selectedCity.isNotEmpty
              ? locationProvider.selectedCity
              : "Pune";

      final response = await HomeTabService().getAllVenueServices(city: city);

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        final List<dynamic> facilitiesList = data['facilities'] ?? [];

        venueList = facilitiesList.map((e) => VenueModel.fromJson(e)).toList();
        setVenueList(venueList);

        return venueList.isNotEmpty; // ✅ true if venues found
      } else {
        debugPrint("API Error: ${response.message}");
      }
    } catch (e) {
      debugPrint("Venue fetch error: $e");
    } finally {
      isBookVenueLoading = false;
      notifyListeners();
    }

    return false; // ✅ default: no venues
  }

  Future<void> getJoinGame(BuildContext context) async {
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;

    if (!isOnline) return;

    isJoinGameLoading = true;
    notifyListeners();

    try {
      // Simulated API delay
      await Future.delayed(const Duration(seconds: 1));

      final dummyResponse = {
        "data": [
          {
            "gameName": "Cricket Friendly Match",
            "date": "Sat 16 Mar",
            "time": " 8:00 AM - 9:00 AM",
            "address": "Wankhede Stadium, Mumbai",
            "hostName": "Rahul Verma",
            "hostPhoto":
                "https://media.istockphoto.com/id/1216426542/photo/portrait-of-happy-man-at-white-background-stock-photo.webp?a=1&b=1&s=612x612&w=0&k=20&c=EgxUJNnRMUmyCuVLrnMWcQMPq9EGqdjHNZEBGgAa3hg=",
            "members": [
              {
                "name": "Amit Singh",
                "photo":
                    "https://media.istockphoto.com/id/1325154957/photo/young-man-smiling-with-arms-crossed-on-gray-background-stock-photo.jpg?s=612x612&w=0&k=20&c=RCAoQfqWvgDOM9MwKmyRRXwZcXYS0wL3CcCKQ37eNOU=",
              },
              {
                "name": "Sneha Patel",
                "photo":
                    "https://media.istockphoto.com/id/1325154957/photo/young-man-smiling-with-arms-crossed-on-gray-background-stock-photo.jpg?s=612x612&w=0&k=20&c=RCAoQfqWvgDOM9MwKmyRRXwZcXYS0wL3CcCKQ37eNOU=",
              },
              {
                "name": "John Abraham",
                "photo":
                    "https://media.istockphoto.com/id/1325154957/photo/young-man-smiling-with-arms-crossed-on-gray-background-stock-photo.jpg?s=612x612&w=0&k=20&c=RCAoQfqWvgDOM9MwKmyRRXwZcXYS0wL3CcCKQ37eNOU=",
              },
            ],
          },
          {
            "gameName": "Cricket Friendly Match",
            "date": "Sat 16 Mar",
            "time": " 8:00 AM - 9:00 AM",
            "address": "Wankhede Stadium, Mumbai",
            "hostName": "Rahul Verma",
            "hostPhoto":
                "https://media.istockphoto.com/id/1216426542/photo/portrait-of-happy-man-at-white-background-stock-photo.webp?a=1&b=1&s=612x612&w=0&k=20&c=EgxUJNnRMUmyCuVLrnMWcQMPq9EGqdjHNZEBGgAa3hg=",
            "members": [
              {
                "name": "Amit Singh",
                "photo":
                    "https://media.istockphoto.com/id/1325154957/photo/young-man-smiling-with-arms-crossed-on-gray-background-stock-photo.jpg?s=612x612&w=0&k=20&c=RCAoQfqWvgDOM9MwKmyRRXwZcXYS0wL3CcCKQ37eNOU=",
              },
              {
                "name": "Sneha Patel",
                "photo":
                    "https://media.istockphoto.com/id/1325154957/photo/young-man-smiling-with-arms-crossed-on-gray-background-stock-photo.jpg?s=612x612&w=0&k=20&c=RCAoQfqWvgDOM9MwKmyRRXwZcXYS0wL3CcCKQ37eNOU=",
              },
              {
                "name": "John Abraham",
                "photo":
                    "https://media.istockphoto.com/id/1325154957/photo/young-man-smiling-with-arms-crossed-on-gray-background-stock-photo.jpg?s=612x612&w=0&k=20&c=RCAoQfqWvgDOM9MwKmyRRXwZcXYS0wL3CcCKQ37eNOU=",
              },
            ],
          },
        ],
      };

      final List<Map<String, dynamic>> list =
          (dummyResponse['data'] as List<dynamic>).cast<Map<String, dynamic>>();

      joinGameList = list.map((e) => GameJoinModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Join game fetch error: $e");
    } finally {
      isJoinGameLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBanner(BuildContext context) async {
    isBannerGetting = true;
    notifyListeners();
    try {
      // bannerList = [
      //   BannerModel(
      //     imageId: '1',
      //     imageUrl:
      //         'https://media.istockphoto.com/id/531912354/photo/dramatic-american-football-stadium.webp?a=1&b=1&s=612x612&w=0&k=20&c=t2zCElMELwlIA9lLxIY06mAv1Z9a1i1IEitg4WsDKjA=',
      //   ),
      //   BannerModel(
      //     imageId: '2',
      //     imageUrl:
      //         'https://media.istockphoto.com/id/495800596/photo/dramatic-soccer-stadium.webp?a=1&b=1&s=612x612&w=0&k=20&c=aH1ZzO4OGhDLS973joMuiIWy2OLCJXxZGTUFRvl9Dw4=',
      //   ),
      //   BannerModel(
      //     imageId: '3',
      //     imageUrl:
      //         'https://media.istockphoto.com/id/495800596/photo/dramatic-soccer-stadium.webp?a=1&b=1&s=612x612&w=0&k=20&c=aH1ZzO4OGhDLS973joMuiIWy2OLCJXxZGTUFRvl9Dw4=',
      //   ),
      // ];

      bannerList = [
        BannerModel(
          imageId: '1',
          imageUrl: 'assets/images/banner1.png',
          title: 'Welcome Bonus',
          description:
              '5,000 bonus coins are waiting for you. Use these coins before they expire to get exclusive discounts worth ₹500 on your bookings right from the start.',
        ),
        BannerModel(
          imageId: '2',
          imageUrl: 'assets/images/banner2.png',
          title: 'Refer & Earn',
          description:
              'Share the app with your friends and earn coins when they install and make their first booking on CXPlay. The more friends you refer, the more coins you collect and the more savings you make!',
        ),
        BannerModel(
          imageId: '3',
          imageUrl: 'assets/images/banner3.png',
          title: 'Coupon Offer',
          description:
              'Enjoy instant savings with our special promo code. Apply DISCOUNT10 at checkout to get 10% off your total booking amount.',
        ),
      ];

      //   RestResponse responce = await HomeTabService().getBannerService();

      //   if (responce.isSuccess) {
      //     bannerList = response.data ?? [];
      //   } else {
      //     print("Failed to get banners");
      //   }
    } catch (e) {
      print("Error in getBanner: $e");
    } finally {
      isBannerGetting = false;
      notifyListeners();
    }
  }
}
