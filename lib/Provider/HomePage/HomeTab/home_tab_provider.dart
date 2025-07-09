import 'package:flutter/material.dart';
import 'package:gkmarts/Models/HomeTab_Models/banner_model.dart';
import 'package:gkmarts/Models/HomeTab_Models/game_join_model.dart';
import 'package:gkmarts/Models/HomeTab_Models/venue_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Services/HomeTab/home_tab_service.dart';
import 'package:provider/provider.dart';

class HomeTabProvider with ChangeNotifier {
  int unreadNotifications = 6;
  bool isBannerGetting = false;
  bool isBookVenueLoading = false;
  List<VenueModel> venueList = [];
  List<VenueModel> filteredVenueList = [];

  List<GameJoinModel> joinGameList = [];
  bool isJoinGameLoading = false;
  List<BannerModel> bannerList = [];
  int _currentBannerIndex = 0;
  int get currentBannerIndex => _currentBannerIndex;

  //--
  int _selectedServiceIndex = -1;
  int get selectedServiceIndex => _selectedServiceIndex;

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

  void setSelectedService(int index) {
    _selectedServiceIndex = index;
    notifyListeners();
  }

  void setBannerIndex(int index) {
    _currentBannerIndex = index;
    notifyListeners();
  }

  Future<void> getBookVenue(BuildContext context) async {
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;

    if (!isOnline) return;

    isBookVenueLoading = true;
    notifyListeners();

    try {
      // Simulated delay to mimic API call
      await Future.delayed(const Duration(seconds: 1));

      // Dummy static response
      final dummyResponse = {
        "data": [
          {
            "venueName": "Mavericks Cricket Academy",
            "venueAddress":
                "Shankar Kalate Nagar, Opp. Silver Fitness Club, Wakad, Pune 57",
            "imageUrl":
                "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
            "rating": 4.2,
            "totalReviews": 38,
            "price": 12000,
          },
          {
            "venueName": "Royal Banquet",
            "venueAddress": "New Delhi, India",
            "imageUrl":
                "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
            "rating": 3.8,
            "totalReviews": 27,
            "price": 8500,
          },
          {
            "venueName": "Green Lawn Resort",
            "venueAddress": "Pune, India",
            "imageUrl":
                "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
            "rating": 4.5,
            "totalReviews": 49,
            "price": 14500,
          },
          {
            "venueName": "Skyline Terrace",
            "venueAddress": "Bangalore, India",
            "imageUrl":
                "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
            "rating": 4.0,
            "totalReviews": 18,
            "price": 11000,
          },
          {
            "venueName": "Lakeside Palace",
            "venueAddress": "Udaipur, India",
            "imageUrl":
                "https://images.unsplash.com/photo-1663832952954-170d73947ba7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3JpY2tldCUyMGZpZWxkfGVufDB8fDB8fHww",
            "rating": 4.7,
            "totalReviews": 56,
            "price": 18000,
          },
        ],
      };

      final List<Map<String, dynamic>> list =
          (dummyResponse['data'] as List<dynamic>).cast<Map<String, dynamic>>();

      venueList = list.map((e) => VenueModel.fromJson(e)).toList();
      setVenueList(venueList);
    } catch (e) {
      // Optional: log error, but no user alert
      debugPrint("Venue fetch error: $e");
    } finally {
      isBookVenueLoading = false;
      notifyListeners();
    }
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
            "date": "2025-07-10",
            "time": "Sat 16 Mar,",
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
            "date": "2025-07-10",
            "time": "Sat 16 Mar,",
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
      bannerList = [
        BannerModel(
          imageId: '1',
          imageUrl:
              'https://media.istockphoto.com/id/531912354/photo/dramatic-american-football-stadium.webp?a=1&b=1&s=612x612&w=0&k=20&c=t2zCElMELwlIA9lLxIY06mAv1Z9a1i1IEitg4WsDKjA=',
        ),
        BannerModel(
          imageId: '2',
          imageUrl:
              'https://media.istockphoto.com/id/495800596/photo/dramatic-soccer-stadium.webp?a=1&b=1&s=612x612&w=0&k=20&c=aH1ZzO4OGhDLS973joMuiIWy2OLCJXxZGTUFRvl9Dw4=',
        ),
        BannerModel(
          imageId: '3',
          imageUrl:
              'https://media.istockphoto.com/id/495800596/photo/dramatic-soccer-stadium.webp?a=1&b=1&s=612x612&w=0&k=20&c=aH1ZzO4OGhDLS973joMuiIWy2OLCJXxZGTUFRvl9Dw4=',
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
