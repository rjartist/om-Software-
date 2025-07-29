import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Profile/edit_profile_provider.dart';
import 'package:gkmarts/Provider/Profile/profile_page_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    // Initialize provider values if needed
    final profile = context.read<ProfileProvider>().user;
    if (profile != null) {
      context.read<EditProfileProvider>().initializeFromProfile(profile);
    }
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
                    Navigator.pop(context);
                    provider.clearImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Edit Profile", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Consumer<EditProfileProvider>(
          builder: (context, provider, _) {
            final imageUrl = provider.user?.user?.profileImage;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        provider.selectedImage != null
                            ? FileImage(provider.selectedImage!)
                            : imageUrl != null
                            ? NetworkImage(imageUrl)
                            : const AssetImage('assets/images/user.jpeg')
                                as ImageProvider,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      _showImagePickerBottomSheet(context);
                    },
                    child: Text(
                      "Change Profile Image",
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
                            padding: const EdgeInsets.only(left: 12, right: 15),
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
                                  onSelected:
                                      (_) => provider.setSelectedGender(index),
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
                              onPressed: () => provider.editProfile(context),
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
    );
  }

  Widget _buildTextField(String iconPath, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        color: AppColors.white,
        child: TextField(
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
