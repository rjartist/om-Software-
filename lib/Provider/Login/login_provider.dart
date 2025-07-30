import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkmarts/Models/UserModel/user_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Provider/Location/location_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Services/AuthServices/login_auth_service.dart';
import 'package:gkmarts/View/Auth_view/login.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Utils/SharedPrefHelper/shared_local_storage.dart';
import 'package:gkmarts/View/home_page.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:gkmarts/Widget/mobile_otp_login_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phonNoController = TextEditingController();
  bool isLoading = false;
  bool isForgotPassword = false;
  bool isupdateProfile = false;

  bool _isObscured = true;

  bool get isObscured => _isObscured;

  UserModel? _user;
  UserModel? get user => _user;

  String _passwordStrength = '';
  String get passwordStrength => _passwordStrength;

  String _emailError = '';

  String get emailError => _emailError;
  String _phonNoError = '';
  String get phonNoError => _phonNoError;

  //--------
  final TextEditingController mobileController = TextEditingController();
  // final TextEditingController otpController = TextEditingController();

  bool isOtpSent = false;
  bool isLoggedIn = false;
  VoidCallback? onLoginSuccess;

  bool isOtpSending = false;
  bool isOtpVerifying = false;

  String mobileErrorText = '';

  int resendSeconds = 60;
  Timer? _timer;

  void resetOtpFlag() {
    isOtpSent = false;
    notifyListeners();
  }

  void disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void clearMobileOtp() {
    // Clear error messages
    mobileErrorText = '';
    _phonNoError = '';
    _emailError = '';

    // Reset OTP and login flags
    isOtpSent = false;
    isLoggedIn = false;
    isOtpSending = false;
    isOtpVerifying = false;

    // Reset timer
    resendSeconds = 60;
    _timer?.cancel();
    _timer = null;

    // Reset optional callback
    onLoginSuccess = null;

    notifyListeners();
  }

  void startOtpTimer() {
    _timer?.cancel();
    resendSeconds = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendSeconds == 0) {
        timer.cancel();
      } else {
        resendSeconds--;
        notifyListeners();
      }
    });
  }

  void onMobileChanged(String val) {
    if (val.length == 10) {
      mobileErrorText = '';
    } else {
      mobileErrorText = 'Enter valid 10-digit number';
    }
    notifyListeners();
  }

  Future<void> verifyOtp(
    BuildContext context,
    String mobileNo,
    String otp,
  ) async {
    final trimmedMobile = mobileNo.trim();
    final trimmedOtp = otp.trim();

    if (otp.length != 6) {
      GlobalSnackbar.error(context, "Enter a valid 6-digit OTP");
      return;
    }

    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isOtpVerifying = true;
    notifyListeners();

    try {
      final response = await LoginAuthService().verifyOtpService(
        trimmedMobile,
        trimmedOtp,
      );

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);

        final token = data['accessToken'];
        if (token != null && token is String) {
          await AuthService.saveTokens(token, "");
        }

        if (data['user_id'] != null) {
          await SharedPrefHelper.setUserId(data['user_id']);
        }
        clearMobileOtp();
        GlobalSnackbar.success(
          navigatorKey.currentContext!,
          "Please Continue...",
        );
        navigatorKey.currentContext!.read()<HomeTabProvider>().getCoinsData(
          navigatorKey.currentContext!,
        );
        Navigator.pop(navigatorKey.currentContext!);
        Navigator.pop(navigatorKey.currentContext!);
      } else {
        startOtpTimer();
        GlobalSnackbar.error(navigatorKey.currentContext!, response.message);
      }
    } catch (e) {
      startOtpTimer();
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "OTP verification failed: ${e.toString()}",
      );
    } finally {
      isOtpVerifying = false;
      notifyListeners();
    }
  }

  Future<void> sendOtp(BuildContext context, String mobileNo) async {
    final trimmedMobile = mobileNo.trim();

    if (trimmedMobile.length != 10 ||
        !RegExp(r'^\d{10}$').hasMatch(trimmedMobile)) {
      mobileErrorText = 'Enter valid 10-digit number';
      notifyListeners();
      return;
    }

    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isOtpSending = true;
    notifyListeners();

    try {
      final response = await LoginAuthService().sendOtpService(trimmedMobile);

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);

        isOtpSent = true;
        startOtpTimer();
        notifyListeners();
        GlobalSnackbar.success(
          context,
          data['message'] ?? "OTP sent successfully",
        );
      } else {
        GlobalSnackbar.error(context, response.message ?? "Failed to send OTP");
      }
    } catch (e) {
      GlobalSnackbar.error(context, "Error sending OTP: ${e.toString()}");
    } finally {
      isOtpSending = false;
      notifyListeners();
    }
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn = await AuthService.isLoggedIn();
    notifyListeners();
  }
  //---------

  void validatePhoneNo(String phone) {
    if (phone.isEmpty) {
      _phonNoError = 'Phone number is required';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _phonNoError = 'Enter a valid 10-digit phone number';
    } else {
      _phonNoError = '';
    }
    notifyListeners();
  }

  void validateEmail(String email) {
    if (email.isEmpty) {
      _emailError = 'Email is required';
    } else {
      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
      if (!emailRegex.hasMatch(email)) {
        _emailError = 'Enter a valid email address';
      } else {
        _emailError = '';
      }
    }
    notifyListeners();
  }

  void checkPasswordStrength(String password) {
    if (password.isEmpty) {
      _passwordStrength = '';
    } else if (password.length < 6) {
      _passwordStrength = 'Weak';
    } else if (password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _passwordStrength = 'Strong';
    } else {
      _passwordStrength = 'Medium';
    }
    notifyListeners();
  }

  Future<void> setUser(UserModel? userModel) async {
    _user = userModel;
    if (userModel == null) {
      await SharedPrefHelper.remove('user');
    } else {
      await SharedPrefHelper.setString('user', userModel.toJsonString());
    }
    notifyListeners();
  }

  // Future<void> login(BuildContext context) async {
  //   final isOnline = context.read<ConnectivityProvider>().isOnline;

  //   if (!isOnline) {
  //     GlobalSnackbar.error(context, "No internet connection");
  //     return;
  //   }

  //   FocusScope.of(context).unfocus();
  //   final email = emailController.text.trim();
  //   final password = passwordController.text;

  //   // Validate inputs
  //   validateEmail(email);
  //   if (_emailError.isNotEmpty) {
  //     GlobalSnackbar.error(context, _emailError);
  //     return;
  //   }

  //   if (email.isEmpty || password.isEmpty) {
  //     GlobalSnackbar.error(context, "Please enter email and password");
  //     return;
  //   }

  //   isLoading = true;
  //   notifyListeners();

  //   try {
  //     final reqBody = {"email": email, "password": password};

  //     final response = await LoginAuthService().loginService(reqBody);

  //     if (response.isSuccess) {
  //       final Map<String, dynamic> data = jsonDecode(response.responseData);

  //       final userModel = UserModel.fromJson(data);
  //       await setUser(userModel);

  //       GlobalSnackbar.success(
  //         navigatorKey.currentContext!,
  //         "Login successful",
  //       );

  //       final token = data['accessToken'];
  //       if (token != null && token is String) {
  //         await AuthService().saveTokens(token, "");
  //       }

  //       clearControllers();
  //       final locationProvider = context.read<LocationProvider>();
  //       locationProvider.fetchAndSaveLocation();

  //       Navigator.pushReplacement(
  //         navigatorKey.currentContext!,
  //         PageTransition(
  //           type: PageTransitionType.fade,
  //           duration: const Duration(milliseconds: 300),
  //           child: HomePage(),
  //         ),
  //       );
  //     } else {
  //       GlobalSnackbar.error(
  //         navigatorKey.currentContext!,
  //         response.message ?? "Login failed",
  //       );
  //     }
  //   } catch (e) {
  //     GlobalSnackbar.error(
  //       navigatorKey.currentContext!,
  //       "Login failed: ${e.toString()}",
  //     );
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> login(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    FocusScope.of(context).unfocus();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validate email
    validateEmail(email);
    if (_emailError.isNotEmpty) {
      GlobalSnackbar.error(context, _emailError);
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      GlobalSnackbar.error(context, "Please enter email and password");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final reqBody = {"email": email, "password": password};

      final response = await LoginAuthService().loginService(reqBody);

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        final userModel = UserModel.fromJson(data);
        await setUser(userModel);

        // Save tokens
        final token = data['accessToken'];
        if (token != null && token is String) {
          await AuthService.saveTokens(token, "");
        }

        if (userModel.userId != 0) {
          await SharedPrefHelper.setUserId(userModel.userId);
        }

        clearControllers();

        GlobalSnackbar.success(context, "Login successful");

        // Navigate
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 300),
            child: HomePage(),
          ),
        );
      } else {
        GlobalSnackbar.error(context, response.message ?? "Login failed");
      }
    } catch (e) {
      GlobalSnackbar.error(context, "Login failed: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Load user from SharedPref at app start or when needed
  Future<void> loadUserFromPrefs() async {
    final userString = SharedPrefHelper.getString('user');
    if (userString != null) {
      _user = UserModel.fromJsonString(userString);
      notifyListeners();
    }
  }

  Future<void> updateFullName(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    if (fullNameController.text.trim().isEmpty) {
      GlobalSnackbar.error(context, "please enter your full name");
      return;
    }

    try {
      isupdateProfile = true;
      notifyListeners();

      final newFullName = fullNameController.text.trim();

      // Update Firestore directly
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(_user!.uid)
      //     .update({'fullName': newFullName});

      // final updatedUser = UserModel(
      //   uid: _user!.uid,
      //   email: _user!.email,
      //   fullName: newFullName,
      // );

      // await setUser(updatedUser);

      // GlobalSnackbar.success(
      //   navigatorKey.currentContext!,
      //   "Profile updated successfully",
      // );
      // Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Failed to update profile",
      );
      debugPrint("Error updating full name: $e");
    } finally {
      isupdateProfile = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }
    FocusScope.of(context).unfocus();
    final email = emailController.text.trim();
    if (email.isEmpty) {
      GlobalSnackbar.error(context, "Please enter your email");
      return;
    }

    // try {
    //   isForgotPassword = true;
    //   notifyListeners();
    //   await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    //   GlobalSnackbar.success(
    //     navigatorKey.currentContext!,
    //     "Password reset email sent successfully",
    //   );
    //   clearControllers();
    //   Navigator.pop(navigatorKey.currentContext!);
    // } on FirebaseAuthException catch (e) {
    //   String msg = "Failed to send reset email";
    //   if (e.code == 'user-not-found') {
    //     msg = "No user found with this email";
    //   } else if (e.code == 'invalid-email') {
    //     msg = "Invalid email format";
    //   }
    //   GlobalSnackbar.error(navigatorKey.currentContext!, msg);
    // } catch (e) {
    //   GlobalSnackbar.error(
    //     navigatorKey.currentContext!,
    //     "Unexpected error: $e",
    //   );
    // } finally {
    //   isForgotPassword = false;
    //   notifyListeners();
    // }
  }

  Future<void> createAccount(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    FocusScope.of(context).unfocus();
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phonNo = phonNoController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      GlobalSnackbar.error(context, "Please fill all fields");
      return;
    }

    validateEmail(email);
    validatePhoneNo(phonNo);
    if (_emailError.isNotEmpty) {
      GlobalSnackbar.error(context, _emailError);
      return;
    }

    if (password != confirmPassword) {
      GlobalSnackbar.error(context, "Passwords do not match");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final reqBody = {
        "name": fullName,
        "phone_number": phonNo,
        "email": email,
        "password": password,
      };

      final response = await LoginAuthService().signUpService(reqBody);

      if (response.isSuccess) {
        GlobalSnackbar.success(
          navigatorKey.currentContext!,
          response.message.isNotEmpty
              ? response.message
              : "Account created successfully",
        );

        clearControllers();
        Navigator.pop(navigatorKey.currentContext!);
      } else {
        GlobalSnackbar.error(
          navigatorKey.currentContext!,
          response.message.isNotEmpty ? response.message : "Signup failed",
        );
      }
    } catch (e) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Unexpected error: $e",
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    try {
      // Call the logout API
      final response = await LoginAuthService().logoutService();

      if (response.isSuccess) {
        // Clear user data and tokens
        await AuthService.clearTokens();
        await SharedPrefHelper.clearAll();
        _user = null;
        clearControllers();
        notifyListeners();

        GlobalSnackbar.success(
          navigatorKey.currentContext!,
          "Logged out successfully",
        );

        // Navigate to login screen
        Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      } else {
        GlobalSnackbar.error(
          navigatorKey.currentContext!,
          response.message ?? "Logout failed. Please try again.",
        );
      }
    } catch (e) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Logout failed: ${e.toString()}",
      );
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    try {
      // Call delete API
      final response = await LoginAuthService().deleteAccountService(context);

      if (response.isSuccess) {
        // Clear session and user info
        await AuthService.clearTokens();
        await SharedPrefHelper.clearAppDataExceptCoinPopup();
        _user = null;
        notifyListeners();

        clearControllers(); // Clear any login form controllers if needed

        GlobalSnackbar.success(
          navigatorKey.currentContext!,
          "Account deleted successfully",
        );

        // Navigate to login screen
        Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Login()),
          (route) => false,
        );
      } else {
        GlobalSnackbar.error(
          navigatorKey.currentContext!,
          response.message ?? "Account deletion failed",
        );
      }
    } catch (e) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Account deletion failed: ${e.toString()}",
      );
    }
  }

  // @override
  // void dispose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   fullNameController.dispose();
  //   confirmPasswordController.dispose();
  //   super.dispose();
  // }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    fullNameController.clear();
    phonNoController.clear();

    isLoading = false;
    isForgotPassword = false;
    isupdateProfile = false;
    _isObscured = true;
    _passwordStrength = '';
    _emailError = '';

    notifyListeners();
  }

  void toggleObscureText() {
    _isObscured = !_isObscured;
    notifyListeners();
  }

  void setObscureText(bool value) {
    _isObscured = value;
    notifyListeners();
  }
}
