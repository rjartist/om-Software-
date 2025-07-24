import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/games_detail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Games extends StatelessWidget {
  Games({super.key});

  final List<String> imageUrls = [
    'assets/images/dummyProfile1.jpg',
    'assets/images/dummyProfile2.jpg',
    'assets/images/dummyProfile3.jpg',
    'assets/images/dummyProfile4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabProvider>(
      builder: (context, provider, _) {
        // if (provider.isGamesLoading) {
        //   return const Center(child: CupertinoActivityIndicator());
        // }

        // if (provider.filteredVenueList.isEmpty) {
        //   return const Padding(
        //     padding: EdgeInsets.all(16),
        //     child: Text(
        //       "No games found.",
        //       style: TextStyle(color: Colors.grey),
        //     ),
        //   );
        // }

        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3, //provider.filteredVenueList.length,
          itemBuilder: (context, index) {
            // final venue = provider.filteredVenueList[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: const GamesDetail(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 15,
                                ),
                                child: Text(
                                  "Regular",
                                  style: AppTextStyle.primaryText(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  top: 15,
                                ),
                                child: SizedBox(
                                  height: 70,
                                  width: MediaQuery.sizeOf(context).width / 2.2,
                                  child: Stack(
                                    children: List.generate(imageUrls.length, (
                                      index,
                                    ) {
                                      return Positioned(
                                        // right: 180,
                                        left:
                                            index * 40.0, // horizontal overlap
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                              imageUrls[index],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  bottom: 15,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Mayur Patil",
                                      style: AppTextStyle.blackText(
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.bgContainer,
                                        borderRadius: BorderRadius.circular(5),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 5,
                                          left: 5,
                                          top: 2.5,
                                          bottom: 2.5,
                                        ),
                                        child: Text(
                                          "HOST",
                                          style: AppTextStyle.blackText(
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/badmintonIcon.png",
                                    height: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Badminton Activity",
                                    style: AppTextStyle.primaryText(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/group.png",
                                    height: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "4 Players Joined",
                                    style: AppTextStyle.blackText(fontSize: 10),
                                  ),
                                ],
                              ),
                              Text(
                                "Sat 16 Mar, 8:00 AM - 9:00 AM",
                                style: AppTextStyle.blackText(fontSize: 10),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/location-pin.png",
                                    height: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Balewadi Stadium, Pune",
                                    style: AppTextStyle.blackText(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 150,
                        height: 35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.profileSectionButtonColor,
                              AppColors.profileSectionButtonColor2,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // context
                            //     .read<LoginProvider>()
                            //     .logout(context);
                          },
                          style: ElevatedButton.styleFrom(
                            // fixedSize: Size(150, 35),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Join Game",
                            style: AppTextStyle.whiteText(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
