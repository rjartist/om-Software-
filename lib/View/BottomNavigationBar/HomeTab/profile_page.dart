import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gkmarts/Models/MyBookings/bookings_count_model.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Widget/mobile_otp_login_widget.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

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
    final provider = context.read<ProfileProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.getProfile(context);
      await context.read<BookingsCountProvider>().fetchBookingsCounts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.bgColor,
      appBar:
          widget.homePage
              ? GlobalAppBar(
                title: "Profile",
                showBackButton: false,
                isHomeScreen: true,
                backgroundColor: Colors.transparent,
              )
              : GlobalAppBar(
                title: "Profile",
                showBackButton: true,
                backgroundColor: Colors.transparent,
              ),
      body: Stack(
        children: [
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              height: 250,
              width: double.infinity,
              color: Colors.blue[50],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 60),
            child: Consumer<ProfileProvider>(
              builder: (context, provider, _) {
                final user = provider.user;
                final imageUrl = user?.user?.profileImage;

                return Consumer<BookingsCountProvider>(
                  builder: (context, secondProvider, _) {
                    final count = secondProvider.bookingCount;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 16),
                              CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    imageUrl != null
                                        ? NetworkImage(imageUrl)
                                        : const AssetImage(
                                              'assets/images/user.jpeg',
                                            )
                                            as ImageProvider,
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.user?.name ?? "--",
                                    style: AppTextStyle.blackText(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "+91 ${user?.user?.phoneNumber ?? "--"}",
                                    style: AppTextStyle.smallGrey(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: InkWell(
                                  onTap: () async {
                                    final isLoggedIn =
                                        await AuthService.isLoggedIn();

                                    if (!isLoggedIn) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const MobileInputPage(),
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        child: const EditProfilePage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "EDIT",
                                    style: AppTextStyle.blackText(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 16),
                          // _bookingStats(count),
                          const SizedBox(height: 15),
                          _profileOptions(context),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleLoggedInAction(BuildContext context, VoidCallback action) async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MobileInputPage()),
      );
      return;
    }
    action();
  }

  Widget _bookingStats(BookingCount? count) {
    return Container(
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
        ],
      ),
    );
  }

  Widget _profileOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: AppColors.buttonDisabled),
              borderRadius: BorderRadius.circular(20),
              color: AppColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: 15,
                right: 15,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Coins",
                        style: AppTextStyle.blackText(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "₹0",
                        style: AppTextStyle.blackText(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset("assets/images/coin.png", height: 40, width: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: AppColors.buttonDisabled),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _profileTile(
                  "assets/images/check_calendar.png",
                  "My Bookings",
                  () {
                    _handleLoggedInAction(context, () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                          child: const MyBookings(),
                        ),
                      );
                    });

                    // Navigator.push(
                    //   context,
                    //   PageTransition(
                    //     type: PageTransitionType.rightToLeft,
                    //     duration: const Duration(milliseconds: 300),
                    //     child: const MyBookings(),
                    //   ),
                    // );
                  },
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: AppColors.buttonDisabled),

              color: AppColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _profileTile(
                "assets/images/heart.png",
                "My Favorites",
                () {
                  _handleLoggedInAction(context, () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        child: const MyFavorites(),
                      ),
                    );
                  });
                  // Navigator.push(
                  //   context,
                  //   PageTransition(
                  //     type: PageTransitionType.rightToLeft,
                  //     duration: const Duration(milliseconds: 300),
                  //     child: const MyFavorites(),
                  //   ),
                  // );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: AppColors.buttonDisabled),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: AppColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _iconTile(Icons.monetization_on, "My Coins", () {
                _handleLoggedInAction(context, () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                      child: const MyCoins(),
                    ),
                  );
                });
                // Navigator.push(
                //   context,
                //   PageTransition(
                //     type: PageTransitionType.rightToLeft,
                //     duration: const Duration(milliseconds: 300),
                //     child: const MyCoins(),
                //   ),
                // );
              }),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: AppColors.buttonDisabled),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _profileTile(
                  "assets/images/support.png",
                  "Help & Support",
                  () {},
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: AppColors.buttonDisabled),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: AppColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _profileTile(
                "assets/images/cancel.png",
                "Cancellation/Reschedule",
                () {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: AppColors.buttonDisabled),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _profileTile(
                  "assets/images/setings.png",
                  "Settings",
                  () {
                    _handleLoggedInAction(context, () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                          child: const Settings(),
                        ),
                      );
                    });
                    // Navigator.push(
                    //   context,
                    //   PageTransition(
                    //     type: PageTransitionType.rightToLeft,
                    //     duration: const Duration(milliseconds: 300),
                    //     child: const Settings(),
                    //   ),
                    // );
                  },
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: AppColors.buttonDisabled),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: AppColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _profileTile(
                "assets/images/share.png",
                "Invite a Friend",
                () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconTile(IconData iconData, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(iconData, color: AppColors.primaryColor, size: 24),
      title: Text(title, style: AppTextStyle.blackText(fontSize: 15)),
      onTap: onTap,
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
              ? SvgPicture.asset(icon, height: 22, width: 22)
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
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width * 0.25, 80, size.width * 0.5, 40);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, 30);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
