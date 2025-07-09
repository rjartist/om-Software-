import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Profile", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Consumer<LoginProvider>(
          builder: (context, provider, _) {
            final user = provider.user;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/images/user.jpeg'),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   (user?.fullName ?? 'Guest User').toUpperCase(),
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.bold,
                            //     color: AppColors.primaryTextColor,
                            //   ),
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            const SizedBox(height: 4),
                            Text(
                              user?.userEmail ?? 'example@email.com',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Hello Developer", // Dummy role
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.hintTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 30),

                  // // SECTION: Account Settings
                  // _sectionTitle("Account Settings"),
                  // _profileTile(Icons.person_outline, "Edit Profile", () {
                  //   // TODO: Navigate to Edit Profile
                  // }),

                  // _profileTile(Icons.receipt_long, "My Orders", () {
                  //   Navigator.push(
                  //     context,
            
                  //     PageTransition(
                  //       type: PageTransitionType.rightToLeft,
                  //       duration: const Duration(milliseconds: 300),
                  //       child: const MyOrdersPage(),
                  //     ),
                  //   );
                  // }),
                  // _profileTile(Icons.lock_outline, "Change Password", () {
                  //   // TODO: Navigate to Change Password
                  // }),

                  // const SizedBox(height: 24),

                  // // SECTION: Help & Support
                  // _sectionTitle("Help & Support"),
                  // _profileTile(Icons.help_outline, "Help Center", () {
                  //   // TODO: Help Center
                  // }),
                  // _profileTile(Icons.feedback_outlined, "Send Feedback", () {
                  //   // TODO: Send Feedback
                  // }),
                  // _profileTile(
                  //   Icons.privacy_tip_outlined,
                  //   "Privacy Policy",
                  //   () {
                  //     // TODO: Privacy Policy
                  //   },
                  // ),

                  // const SizedBox(height: 24),

                  // // SECTION: App Info
                  // _sectionTitle("App Info"),
                  // _profileTile(
                  //   Icons.info_outline,
                  //   "Version 1.0.0",
                  //   null,
                  //   showArrow: false,
                  // ),

                  const SizedBox(height: 150),

                  // SECTION: Logout
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context.read<LoginProvider>().logout(context);
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
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

  // Section Header
  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }

  // Tile Widget
  Widget _profileTile(
    IconData icon,
    String title,
    VoidCallback? onTap, {
    bool showArrow = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, color: AppColors.primaryTextColor),
      ),
      trailing:
          showArrow
              ? const Icon(Icons.arrow_forward_ios_rounded, size: 16)
              : null,
      onTap: onTap,
    );
  }
}
