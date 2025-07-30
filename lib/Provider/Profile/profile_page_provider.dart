import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkmarts/Models/Profile/profile_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Services/AuthServices/login_auth_service.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  ProfileModel? _profile;
  ProfileModel? get user => _profile;

  String? get profileImage {
    final img = _profile?.user?.profileImage;
    if (img != null && img.isNotEmpty) {
      return _profile?.user?.profileImage;
    }
    return null;
  }

  void clearProfileProviderAllData() {
    isLoading = false;
    _profile = null;
    notifyListeners();
  }

  Future<void> getProfile(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await LoginAuthService().getProfile();

      print("Response for profile: $response");

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        _profile = ProfileModel.fromJson(data);
        // GlobalSnackbar.success(context, "Profile loaded successfully");
      } else {
        // GlobalSnackbar.error(
        //   context,
        //   response.message ?? "Profile Loading failed",
        // );
      }
    } catch (e) {
      // GlobalSnackbar.error(context, "Profile Loading failed: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
