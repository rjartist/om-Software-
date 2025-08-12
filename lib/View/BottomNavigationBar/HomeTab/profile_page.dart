import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gkmarts/Models/GenaralModels/coins_model.dart';
import 'package:gkmarts/Models/MyBookings/bookings_count_model.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      final bookingsProvider = context.read<BookingsCountProvider>();

      profileProvider.getProfile(context);
      bookingsProvider.fetchBookingsCounts(context);
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
                final coinsModel = context.watch<HomeTabProvider>().coinsModel;

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
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl ?? "",
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.grey[200],
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                          const CircleAvatar(
                                            radius: 35,
                                            backgroundImage: AssetImage(
                                              'assets/images/user.jpeg',
                                            ),
                                            backgroundColor: Colors.white,
                                          ),
                                ),
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
                          _profileOptions(context, coinsModel!),
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

  // void _handleLoggedInAction(BuildContext context, VoidCallback action) async {
  //   final isLoggedIn = await AuthService.isLoggedIn();
  //   if (!isLoggedIn) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => const MobileInputPage()),
  //     );
  //     return;
  //   }
  //   action();
  // }

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

  Widget _profileOptions(BuildContext context, CoinsModel coinModel) {
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                      child: const MyCoins(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Coins",
                          style: AppTextStyle.blackText(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        Text(
                          "${coinModel.remainingBonusCoins} Points",
                          style: AppTextStyle.primaryText(
                            // fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: const MyCoins(),
                  ),
                );
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
                  () {
                    _showHelpBottomSheet(context);
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
                "assets/images/cancel.png",
                "Cancellation/Reschedule",
                () {
                  _showCancelBottomSheet(context);
                },
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
