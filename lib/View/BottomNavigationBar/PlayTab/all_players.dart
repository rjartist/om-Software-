import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:provider/provider.dart';

class AllPlayers extends StatefulWidget {
  const AllPlayers({super.key});

  @override
  State<AllPlayers> createState() => _AllPlayersState();
}

class _AllPlayersState extends State<AllPlayers> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "All Players", showBackButton: true),
      body: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          final user = provider.user;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Search Players',
                      // prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.5),
                        child: Image.asset(
                          "assets/images/search.png",
                          height: 5,
                          width: 5,
                          color: AppColors.grey,
                        ),
                      ),
                      hintStyle: AppTextStyle.greytext(),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 15, top: 0),
              //   child: Text(
              //     "Player - 03",
              //     style: AppTextStyle.blackText(fontSize: 20),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                child: Text(
                  "Badminton",
                  style: AppTextStyle.blackText(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                child: Text(
                  "Balewadi Stadium, Pune",
                  style: AppTextStyle.blackText(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                child: Text(
                  "07:00 AM - 08:00 AM, 12 Oct, 2025",
                  style: AppTextStyle.primaryText(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(color: AppColors.dividerColor),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  bottom: 15,
                  top: 10,
                  right: 15,
                ),
                child: Row(
                  children: [
                    Text(
                      "Players Available",
                      style: AppTextStyle.blackText(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "(05)",
                      style: AppTextStyle.blackText(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5, //provider.filteredVenueList.length,
                itemBuilder: (context, index) {
                  // final venue = provider.filteredVenueList[index];
                  final bool isHost = true;
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            "assets/images/dummyProfile1.jpg",
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Mayur Patil",
                          style: AppTextStyle.blackText(fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        isHost == true && index == 0
                            ? Container(
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
                                  style: AppTextStyle.blackText(fontSize: 8),
                                ),
                              ),
                            )
                            : SizedBox(),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(bottom: 40, left: 15, right: 15),
      //   child: Container(
      //     height: 45,
      //     // width: 190,
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         colors: [
      //           AppColors.profileSectionButtonColor,
      //           AppColors.profileSectionButtonColor2,
      //         ],
      //       ),
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //     child: ElevatedButton(
      //       onPressed: () {},
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: Colors.transparent,
      //         shadowColor: Colors.transparent,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //       ),

      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text(
      //             "INVITE PLAYERS",
      //             style: AppTextStyle.whiteText(
      //               fontWeight: FontWeight.w500,
      //               fontSize: 14,
      //             ),
      //           ),
      //           SizedBox(width: 2),
      //           Icon(Icons.add, color: AppColors.white, size: 14),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildIconWithTextRow(String image, String text) {
    return Row(
      children: [
        Image.asset(
          image.toString(),
          height: 18,
          width: 18,
          color: AppColors.black,
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: AppTextStyle.blackText(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
