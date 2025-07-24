import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/calendar_past_details.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/calendar_upcoming_details.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CalendarScreenMain extends StatefulWidget {
  const CalendarScreenMain({super.key});

  @override
  State<CalendarScreenMain> createState() => _CalendarScreenMainState();
}

class _CalendarScreenMainState extends State<CalendarScreenMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: GlobalAppBar(title: "Calendar", showBackButton: true),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.profileSectionButtonColor,
                            AppColors.profileSectionButtonColor2,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => setState(() => selectedTab = 0),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor:
                              selectedTab == 0
                                  ? Colors.transparent
                                  : Colors.grey[300],
                          foregroundColor:
                              selectedTab == 0 ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Upcoming",
                          style: AppTextStyle.blackText(
                            color:
                                selectedTab == 0
                                    ? AppColors.white
                                    : AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.profileSectionButtonColor,
                            AppColors.profileSectionButtonColor2,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => setState(() => selectedTab = 1),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor:
                              selectedTab == 1
                                  ? Colors.transparent
                                  : Colors.grey[300],
                          foregroundColor:
                              selectedTab == 1 ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Past",
                          style: AppTextStyle.blackText(
                            color:
                                selectedTab == 1
                                    ? AppColors.white
                                    : AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TabBarView
            Expanded(
              child:
                  selectedTab == 0
                      ? Center(
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 15,
                                right: 15,
                                left: 15,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: CalendarUpcomingDetails(),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 15,
                                                bottom: 10,
                                              ),
                                              child: Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Badminton",
                                                    style:
                                                        AppTextStyle.blackText(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    "07:00 AM - 08:00 AM, Oct 12",
                                                    style:
                                                        AppTextStyle.primaryText(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Mavericks Cricket Academy",
                                                    style:
                                                        AppTextStyle.blackText(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Pune, Maharashtra, India",
                                                    style:
                                                        AppTextStyle.blackText(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Beginner",
                                                    style:
                                                        AppTextStyle.primaryText(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Stack(
                                              children: [
                                                Positioned.fill(
                                                  top: 20,
                                                  left: 5,
                                                  child: Transform.rotate(
                                                    angle: 60, // 45,
                                                    child: Transform.scale(
                                                      scale: 1.6,
                                                      child: Container(
                                                        height: 190,
                                                        color:
                                                            AppColors
                                                                .bgContainer,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 15,
                                                        right: 15,
                                                        bottom: 15,
                                                      ),
                                                  child: Column(
                                                    spacing: 10,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin:
                                                                Alignment
                                                                    .topCenter,
                                                            end:
                                                                Alignment
                                                                    .bottomCenter,
                                                            colors: [
                                                              AppColors
                                                                  .profileSectionButtonColor,
                                                              AppColors
                                                                  .profileSectionButtonColor2,
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                "Request",
                                                                style: AppTextStyle.whiteText(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .circle_notifications,
                                                                size: 15,
                                                                color:
                                                                    AppColors
                                                                        .white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin:
                                                                Alignment
                                                                    .topCenter,
                                                            end:
                                                                Alignment
                                                                    .bottomCenter,
                                                            colors: [
                                                              AppColors
                                                                  .profileSectionButtonColor,
                                                              AppColors
                                                                  .profileSectionButtonColor2,
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                "Queries",
                                                                style: AppTextStyle.whiteText(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .circle_notifications,
                                                                size: 15,
                                                                color:
                                                                    AppColors
                                                                        .white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 20,
                                                            ),
                                                        child: Container(
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            gradient: LinearGradient(
                                                              begin:
                                                                  Alignment
                                                                      .topCenter,
                                                              end:
                                                                  Alignment
                                                                      .bottomCenter,
                                                              colors: [
                                                                AppColors
                                                                    .profileSectionButtonColor,
                                                                AppColors
                                                                    .profileSectionButtonColor2,
                                                              ],
                                                            ),
                                                          ),
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              shadowColor:
                                                                  Colors
                                                                      .transparent,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                            child: Image.asset(
                                                              'assets/images/Vector.png', // use same logo as login
                                                              fit:
                                                                  BoxFit
                                                                      .scaleDown,
                                                              height: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      : Center(
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 15,
                                right: 15,
                                left: 15,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: CalendarUpcomingDetails(),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 15,
                                                bottom: 10,
                                              ),
                                              child: Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Badminton",
                                                    style:
                                                        AppTextStyle.blackText(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    "07:00 AM - 08:00 AM, Oct 12",
                                                    style:
                                                        AppTextStyle.primaryText(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Mavericks Cricket Academy",
                                                    style:
                                                        AppTextStyle.blackText(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Pune, Maharashtra, India",
                                                    style:
                                                        AppTextStyle.blackText(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    "Beginner",
                                                    style:
                                                        AppTextStyle.primaryText(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Stack(
                                              children: [
                                                Positioned.fill(
                                                  top: 20,
                                                  left: 5,
                                                  child: Transform.rotate(
                                                    angle: 60, // 45,
                                                    child: Transform.scale(
                                                      scale: 1.6,
                                                      child: Container(
                                                        height: 190,
                                                        color:
                                                            AppColors
                                                                .bgContainer,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 15,
                                                        right: 15,
                                                        bottom: 15,
                                                      ),
                                                  child: Column(
                                                    spacing: 10,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin:
                                                                Alignment
                                                                    .topCenter,
                                                            end:
                                                                Alignment
                                                                    .bottomCenter,
                                                            colors: [
                                                              AppColors
                                                                  .profileSectionButtonColor,
                                                              AppColors
                                                                  .profileSectionButtonColor2,
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                "Request",
                                                                style: AppTextStyle.whiteText(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .circle_notifications,
                                                                size: 15,
                                                                color:
                                                                    AppColors
                                                                        .white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin:
                                                                Alignment
                                                                    .topCenter,
                                                            end:
                                                                Alignment
                                                                    .bottomCenter,
                                                            colors: [
                                                              AppColors
                                                                  .profileSectionButtonColor,
                                                              AppColors
                                                                  .profileSectionButtonColor2,
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                "Queries",
                                                                style: AppTextStyle.whiteText(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .circle_notifications,
                                                                size: 15,
                                                                color:
                                                                    AppColors
                                                                        .white,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 20,
                                                            ),
                                                        child: Container(
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            gradient: LinearGradient(
                                                              begin:
                                                                  Alignment
                                                                      .topCenter,
                                                              end:
                                                                  Alignment
                                                                      .bottomCenter,
                                                              colors: [
                                                                AppColors
                                                                    .profileSectionButtonColor,
                                                                AppColors
                                                                    .profileSectionButtonColor2,
                                                              ],
                                                            ),
                                                          ),
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              shadowColor:
                                                                  Colors
                                                                      .transparent,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                            child: Image.asset(
                                                              'assets/images/Vector.png', // use same logo as login
                                                              fit:
                                                                  BoxFit
                                                                      .scaleDown,
                                                              height: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for angled background
class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.2, 0); // Start 20% from top-left
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
