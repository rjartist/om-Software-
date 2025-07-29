import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/all_players.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class GamesDetail extends StatefulWidget {
  final bool playTab;
  GamesDetail({super.key, required this.playTab});

  @override
  State<GamesDetail> createState() => _GamesDetailState();
}

class _GamesDetailState extends State<GamesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar:
          widget.playTab == true
              ? GlobalAppBar(title: "Games Around You", showBackButton: true)
              : GlobalAppBar(title: "Game Detail", showBackButton: true),
      body: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          final user = provider.user;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  "Badminton",
                  style: AppTextStyle.blackText(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 15),
                child: Text(
                  "07:00 AM - 08:00 AM, 12 Oct, 2025",
                  style: AppTextStyle.primaryText(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 15,
                      bottom: 15,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/location-pin.png",
                          height: 18,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Balewadi Stadium, Pune",
                          style: AppTextStyle.blackText(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      top: 20,
                      bottom: 20,
                      right: 15,
                    ),
                    child: Column(
                      spacing: 15,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Game Details",
                          style: AppTextStyle.blackText(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Venue:",
                                style: AppTextStyle.blackText(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Balewadi Stadium, Pune",
                                style: AppTextStyle.primaryText(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Game Skill:",
                                style: AppTextStyle.blackText(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                "Beginner",
                                style: AppTextStyle.primaryText(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Play and Join:",
                                style: AppTextStyle.blackText(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                "₹100/Player",
                                style: AppTextStyle.primaryText(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Instructions:",
                                style: AppTextStyle.blackText(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bring Your Own Equipment",
                                    style: AppTextStyle.primaryText(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Cost Shared",
                                    style: AppTextStyle.primaryText(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
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
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Players (1)",
                              style: AppTextStyle.blackText(fontSize: 14),
                            ),
                            SizedBox(height: 15),
                            Row(
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
                          ],
                        ),
                        Spacer(),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 300),
                                  child: const AllPlayers(),
                                ),
                              );
                            },
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.bgGreyContainer,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16,
                                  ),
                                  Text(
                                    "All Players",
                                    style: AppTextStyle.blackText(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 15, right: 15),
        child: Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                height: 45,
                // width: 190,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _showSendQueryBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: Text(
                    "SEND QUERY",
                    style: AppTextStyle.blackText(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 45,
                // width: 190,
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
                    _showJoinGameBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: Text(
                    "JOIN GAME",
                    style: AppTextStyle.whiteText(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinGameBottomSheet(BuildContext context) {
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
                "Join Game",
                style: AppTextStyle.primaryText(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 3,
                minLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'Send a message to the host along with your requests',
                  hintStyle: AppTextStyle.blackText(
                    color: AppColors.hintTextColor,
                    fontSize: 10,
                  ),
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 15,
                  right: 15,
                  top: 15,
                ),
                child: Container(
                  height: 43,
                  width: 190,
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    child: Text(
                      "SEND REQUEST",
                      style: AppTextStyle.whiteText(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSendQueryBottomSheet(BuildContext context) {
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
                "Your Query",
                style: AppTextStyle.primaryText(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 3,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: 'Send your query',
                  hintStyle: AppTextStyle.blackText(
                    color: AppColors.hintTextColor,
                    fontSize: 10,
                  ),
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 15,
                  right: 15,
                  top: 15,
                ),
                child: Container(
                  height: 43,
                  width: 190,
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    child: Text(
                      "SEND QUERY",
                      style: AppTextStyle.whiteText(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
