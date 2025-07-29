import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkmarts/Models/Favorites/my_favorites_model.dart';
import 'package:gkmarts/Models/Profile/profile_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Services/AuthServices/login_auth_service.dart';
import 'package:gkmarts/Services/Favorites/my_favorites_service.dart';
import 'package:gkmarts/Services/MyBookings/my_bookings_service.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyFavoritesProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  MyFavoritesModel? _favoritesModel;
  List<ListOfFacilities> get favoritesList =>
      _favoritesModel?.listOfFacilities ?? [];

  Future<void> getMyFavorites(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await MyFavoritesService().getMyFavorites();

      print("Response for Favorites: $response");

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        _favoritesModel = MyFavoritesModel.fromJson(data);
        // GlobalSnackbar.success(context, "Favorites loading successful");
      } else {
        // GlobalSnackbar.error(
        //   context,
        //   response.message ?? "Favorites loading failed",
        // );
        print("Favorites API Error: ${response.message}");
      }
    } catch (e) {
      // GlobalSnackbar.error(
      //   context,
      //   "Favorites loading failed: ${e.toString()}",
      // );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
