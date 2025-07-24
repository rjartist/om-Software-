import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkmarts/Models/Profile/profile_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Services/AuthServices/login_auth_service.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/profile_page.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;
  String _emailError = '';
  ProfileModel? _profile;
  int selectedGenderIndex = 0;
  DateTime? selectedDate;

  ProfileModel? get user => _profile;
  String get emailError => _emailError;

  void setSelectedGender(int index) {
    selectedGenderIndex = index;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void clearControllers() {
    emailController.clear();
    nameController.clear();
    phoneController.clear();
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

  /// 🔄 Initialize fields from ProfileModel
  void initializeFromProfile(ProfileModel profile) {
    _profile = profile;

    final user = profile.user;
    nameController.text = user?.name ?? '';
    phoneController.text = user?.phoneNumber ?? '';
    emailController.text = user?.email ?? '';

    // gender (optional)
    if (user?.gender != null) {
      switch (user!.gender!.toLowerCase()) {
        case 'male':
          selectedGenderIndex = 0;
          break;
        case 'female':
          selectedGenderIndex = 1;
          break;
        case 'other':
          selectedGenderIndex = 2;
          break;
      }
    }

    // birthdate (optional)
    if (user?.birthdate != null && user!.birthdate!.isNotEmpty) {
      try {
        selectedDate = DateTime.parse(user.birthdate!);
      } catch (_) {}
    }

    notifyListeners();
  }

  Future<void> requestPermission() async {
    await Permission.photos
        .request(); // or Permission.storage for older devices
  }

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    requestPermission();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Gallery Picker Error: $e");
    }
  }

  Future<void> pickImageFromCamera() async {
    requestPermission();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Camera Picker Error: $e");
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> editProfile(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    String formattedDate =
        selectedDate != null
            ? DateFormat('dd-MM-yyyy').format(selectedDate!)
            : '';

    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final name = nameController.text;
    final phone = phoneController.text;

    validateEmail(email);
    if (_emailError.isNotEmpty) {
      GlobalSnackbar.error(context, _emailError);
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final reqBody = {
        "name": name,
        "phoneNumber": phone,
        "email": email,
        "birthdate": formattedDate,
        "gender": ['Male', 'Female', 'Other'][selectedGenderIndex],
        // "profile_image": _selectedImage != null ? _selectedImage!.path : "",
        "removeProfileImage": _selectedImage == null ? true : false,
      };

      print(reqBody);

      // final response = await LoginAuthService().editProfile(reqBody);
      final response = await LoginAuthService().editProfile(
        reqBody,
        imageFile: _selectedImage, // ✅ pass image file separately
      );

      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        final userModel = ProfileModel.fromJson(data);

        clearControllers();
        GlobalSnackbar.success(context, "Profile updated successfully");

        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 300),
            child: const ProfilePage(homePage: false),
          ),
        );
      } else {
        GlobalSnackbar.error(
          context,
          response.message ?? "Profile update failed",
        );
      }
    } catch (e) {
      GlobalSnackbar.error(context, "Profile update failed: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
