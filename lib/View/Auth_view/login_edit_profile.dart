import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Profile/edit_profile_provider.dart';
import 'package:gkmarts/Provider/Profile/profile_page_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/home_page.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoginEditProfile extends StatefulWidget {
  const LoginEditProfile({super.key});

  @override
  State<LoginEditProfile> createState() => _LoginEditProfileState();
}

class _LoginEditProfileState extends State<LoginEditProfile> {
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = context.read<ProfileProvider>();

      // wait for profile API to complete
      await profileProvider.getProfile(context);

      final profile = profileProvider.user;
      if (profile != null) {
        context.read<EditProfileProvider>().initializeFromProfile(profile);
      }
    });
  }

  Future<void> _pickDate() async {
    final provider = Provider.of<EditProfileProvider>(context, listen: false);
    final initialDate = provider.selectedDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.gradientRedStart,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      provider.setSelectedDate(picked);
    }
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    final provider = Provider.of<EditProfileProvider>(context, listen: false);
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: AppColors.white,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
            left: 15,
            right: 15,
            top: 20,
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: AppColors.primaryColor,
                ),
                title: Text('Camera', style: AppTextStyle.primaryText()),
                onTap: () {
                  Navigator.pop(context);
                  provider.pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primaryColor,
                ),
                title: Text('Gallery', style: AppTextStyle.primaryText()),
                onTap: () {
                  Navigator.pop(context);
                  provider.pickImageFromGallery();
                },
              ),
              if (provider.selectedImage != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    'Remove Image',
                    style: AppTextStyle.primaryText(),
                  ),
                  onTap: () {
                    setState(() {
                      provider.clearImage();
                      Navigator.pop(context);
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  bool _isValidEmail(String email) {
    // Basic email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvoked: (didPop) {
        if (!didPop) {
          if (_isSaving) {
            // ignore back while saving
            return;
          }
          // device/system back button → go to HomePage
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: GlobalAppBar(
          title: "Edit Profile",
          showBackButton: false,
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Consumer<EditProfileProvider>(
              builder: (context, provider, _) {
                final imageUrl = provider.user?.user?.profileImage;

                final ImageProvider imageProvider =
                    provider.selectedImage != null
                        ? FileImage(provider.selectedImage!)
                        : (imageUrl != null && imageUrl.isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : AssetImage(
                              provider.user?.user?.gender == "Male"
                                  ? 'assets/images/male.png'
                                  : provider.user?.user?.gender == "Female"
                                  ? 'assets/images/female.png'
                                  : 'assets/images/user.png',
                            )
                            as ImageProvider;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => Dialog(
                                  backgroundColor: Colors.black,
                                  insetPadding: EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: InteractiveViewer(
                                      panEnabled: true,
                                      minScale: 0.8,
                                      maxScale: 2.5,
                                      child: Image(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                        height: 350,
                                        width: 300,
                                      ),
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              provider.selectedImage != null
                                  ? FileImage(provider.selectedImage!)
                                  : (imageUrl != null && imageUrl.isNotEmpty)
                                  ? NetworkImage(imageUrl)
                                  : AssetImage(
                                        provider.user?.user?.gender == "Male"
                                            ? 'assets/images/male.png'
                                            : provider.user?.user?.gender ==
                                                "Female"
                                            ? 'assets/images/female.png'
                                            : 'assets/images/user.png',
                                      )
                                      as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _showImagePickerBottomSheet(context);
                        },
                        child: Text(
                          "Update Profile Image",
                          style: AppTextStyle.primaryText(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Input Fields
                      _buildTextField(
                        "assets/images/userIcon.png",
                        provider.nameController,
                      ),
                      _buildTextField(
                        "assets/images/phoneIcon.png",
                        provider.phoneController,
                        readOnly: true,
                      ),
                      _buildTextFieldEmail(
                        "assets/images/mailIcon.png",
                        provider.emailController,
                      ),

                      // Birthday Picker
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            color: AppColors.white,
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/calendarIcon.png",
                                  height: 20,
                                  width: 20,
                                  color: AppColors.black,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  provider.selectedDate != null
                                      ? DateFormat(
                                        'dd-MM-yyyy',
                                      ).format(provider.selectedDate!)
                                      : "Enter Your Birthday",
                                  style: AppTextStyle.blackText(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Gender Choice Chips
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          color: AppColors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 15,
                                ),
                                child: Image.asset(
                                  "assets/images/genderIcon.png",
                                  height: 20,
                                  width: 20,
                                  color: AppColors.black,
                                ),
                              ),
                              Wrap(
                                spacing: 20.0,
                                children: List.generate(
                                  ['Male', 'Female', 'Other'].length,
                                  (index) {
                                    final label =
                                        ['Male', 'Female', 'Other'][index];
                                    final selected =
                                        provider.selectedGenderIndex == index;

                                    return ChoiceChip(
                                      label: Text(
                                        label,
                                        style: AppTextStyle.blackText(
                                          color:
                                              selected
                                                  ? AppColors.white
                                                  : AppColors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      selected: selected,
                                      onSelected: (value) {
                                        setState(() {
                                          provider.setSelectedGender(index);
                                          if (provider.selectedGenderIndex ==
                                              0) {
                                            provider.user?.user?.gender =
                                                "Male";
                                          } else if (provider
                                                  .selectedGenderIndex ==
                                              1) {
                                            provider.user?.user?.gender =
                                                "Female";
                                          } else {
                                            provider.user?.user?.gender =
                                                "Other";
                                          }
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                      selectedColor:
                                          AppColors.profileSectionButtonColor,
                                      backgroundColor: AppColors.white,
                                      showCheckmark: false,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                          right: 15,
                          left: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: AppTextStyle.blackText(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.profileSectionButtonColor,
                                      AppColors.profileSectionButtonColor2,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final name =
                                        provider.nameController.text.trim();
                                    final email =
                                        provider.emailController.text.trim();

                                    if (name.isEmpty) {
                                      GlobalSnackbar.error(
                                        context,
                                        "Name cannot be empty",
                                      );
                                      return;
                                    }
                                    if (email.isEmpty) {
                                      GlobalSnackbar.error(
                                        context,
                                        "Email cannot be empty",
                                      );
                                      return;
                                    }
                                    if (!_isValidEmail(email)) {
                                      GlobalSnackbar.error(
                                        context,
                                        "Enter a valid email address",
                                      );
                                      return;
                                    }

                                    setState(() => _isSaving = true);

                                    await provider.editProfile(
                                      context,
                                      isFromLogin: true,
                                    );

                                    setState(() => _isSaving = false);
                                  },
                                  // onPressed: () {
                                  //   final name =
                                  //       provider.nameController.text.trim();
                                  //   final email =
                                  //       provider.emailController.text.trim();

                                  //   if (name.isEmpty) {
                                  //     GlobalSnackbar.error(
                                  //       context,
                                  //       "Name cannot be empty",
                                  //     );
                                  //     return;
                                  //   }

                                  //   if (email.isEmpty) {
                                  //     GlobalSnackbar.error(
                                  //       context,
                                  //       "Email cannot be empty",
                                  //     );
                                  //     return;
                                  //   }

                                  //   if (!_isValidEmail(email)) {
                                  //     GlobalSnackbar.error(
                                  //       context,
                                  //       "Enter a valid email address",
                                  //     );
                                  //     return;
                                  //   }

                                  //   // ✅ All validations passed → Call API
                                  //   provider.editProfile(
                                  //     context,
                                  //     isFromLogin: true,
                                  //   );

                                  // },
                                  // onPressed: () => provider.editProfile(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Save",
                                    style: AppTextStyle.whiteText(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String iconPath,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        color: AppColors.white,
        child: TextField(
          readOnly: readOnly,
          controller: controller,
          style: AppTextStyle.blackText(),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter",
            hintStyle: AppTextStyle.blackText(),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                iconPath,
                height: 5,
                width: 5,
                color: AppColors.black,
              ),
            ),
          ),
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }

  Widget _buildTextFieldEmail(
    String iconPath,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        color: AppColors.white,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          style: AppTextStyle.blackText(),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email",
            hintStyle: AppTextStyle.greytext(),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                iconPath,
                height: 5,
                width: 5,
                color: AppColors.black,
              ),
            ),
          ),
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }
}
