import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gkmarts/Provider/Bookings/bookings_count_provider.dart';
import 'package:gkmarts/Provider/Profile/profile_page_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/edit_profile_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_bookings.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_coins.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_favorites.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/settings.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final bool homePage;
  const ProfilePage({super.key, required this.homePage});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    // Call getProfile after widget is built
    final provider = context.read<ProfileProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.getProfile(context);
    });
    final secondProvider = context.read<BookingsCountProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await secondProvider.fetchBookingsCounts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar:
          widget.homePage == true
              ? GlobalAppBar(
                title: "Profile",
                showBackButton: false,
                isHomeScreen: true,
              )
              : GlobalAppBar(title: "Profile", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            final user = provider.user;
            final imageUrl = provider.user?.user?.profileImage;

            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (user == null) {
              return const Center(child: Text("No profile data found."));
            }

            return Consumer<BookingsCountProvider>(
              builder: (context, secondProvider, _) {
                final count = secondProvider.bookingCount;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Header
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                provider.user?.user?.profileImage != null
                                    ? NetworkImage(imageUrl!)
                                    : const AssetImage(
                                          'assets/images/user.jpeg',
                                        )
                                        as ImageProvider,
                            backgroundColor: Colors.white,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 300),
                                  child: const EditProfilePage(),
                                ),
                              );
                            },
                            child: Image.asset(
                              "assets/images/edit.png",
                              height: 18,
                              width: 18,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.user?.name ?? "--",
                        style: AppTextStyle.blackText(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.user?.phoneNumber ?? "--",
                        style: AppTextStyle.smallGrey(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  (count?.upcomingBookingCount ?? 0).toString(),
                                  style: AppTextStyle.blackText(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Upcoming Bookings",
                                  style: AppTextStyle.blackText(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  (count?.totalBookingCount ?? 0).toString(),
                                  style: AppTextStyle.blackText(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Total Bookings",
                                  style: AppTextStyle.blackText(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            // _stat(
                            //   providerBookingsCount
                            //       .bookingCount!
                            //       .upcomingBookingCount!,
                            //   "Upcoming Bookings",
                            // ),
                            // _stat(
                            //   providerBookingsCount
                            //       .bookingCount!
                            //       .totalBookingCount!,
                            //   "Total Bookings",
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            _profileTile(
                              "assets/images/check_calendar.png",
                              "My Bookings",
                              () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 300),
                                    child: const MyBookings(),
                                  ),
                                );
                              },
                            ),
                            _profileTile(
                              "assets/images/heart.png",
                              "My Favorites",
                              () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 300),
                                    child: const MyFavorites(),
                                  ),
                                );
                              },
                            ),

                            _profileTile(
                              "assets/images/coins.svg",
                              "My Coins",
                              () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 300),
                                    child: const MyCoins(),
                                  ),
                                );
                              },
                              isSvg: true,
                            ),
                            _profileTile(
                              "assets/images/support.png",
                              "Help & Support",
                              () {
                                _showHelpBottomSheet(context);
                              },
                            ),
                            _profileTile(
                              "assets/images/cancel.png",
                              "Cancellation/Reschedule",
                              () {
                                _showCancelBottomSheet(context);
                              },
                            ),
                            _profileTile(
                              "assets/images/setings.png",
                              "Settings",
                              () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Settings(),
                                  ),
                                );
                              },
                            ),
                            _profileTile(
                              "assets/images/share.png",
                              "Invite a Friend",
                              () {
                                // Share logic
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _stat(int? value, String label) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: AppTextStyle.blackText(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          label,
          style: AppTextStyle.blackText(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _profileTile(
    String icon,
    String title,
    VoidCallback onTap, {
    bool isSvg = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading:
          isSvg
              ? SvgPicture.asset(
                icon,
                height: 22,
                width: 22,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.primaryColor,
                //   BlendMode.srcIn,
                // ),
              )
              : Image.asset(
                icon,
                height: 22,
                width: 22,
                color: AppColors.primaryColor,
              ),
      title: Text(title, style: AppTextStyle.blackText(fontSize: 15)),
      onTap: onTap,
    );
  }

  void _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Need Help!",
                style: AppTextStyle.primaryText(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "To get any help or support, contact our support team",
                style: AppTextStyle.blackText(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _supportButton("CHAT", "assets/images/whatsapp.png"),
                  _supportButton("CALL", null, icon: Icons.call),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Cancellation / Reschedule",
                style: AppTextStyle.primaryText(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "To cancel a booking, go to 'My Bookings' and submit a cancellation request.",
                style: AppTextStyle.blackText(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                      child: const MyBookings(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "GO TO MY BOOKINGS",
                  style: AppTextStyle.whiteText(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _supportButton(String label, String? iconAsset, {IconData? icon}) {
    return Container(
      width: 150,
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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconAsset != null)
              Image.asset(
                iconAsset,
                height: 18,
                width: 18,
                color: AppColors.white,
              ),
            if (icon != null) Icon(icon, color: AppColors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyle.whiteText(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
