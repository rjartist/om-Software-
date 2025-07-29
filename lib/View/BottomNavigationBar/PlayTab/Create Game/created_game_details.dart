import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/all_players.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/chat_screen.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CreatedGameDetails extends StatefulWidget {
  final String? sport;
  final String? time;
  final String? date;
  final String? venue;
  final String? skill;
  final String? players;
  final String? cost;
  final List<String>? instructions;
  const CreatedGameDetails({
    super.key,
    this.sport,
    this.time,
    this.date,
    this.venue,
    this.skill,
    this.players,
    this.cost,
    this.instructions,
  });

  @override
  State<CreatedGameDetails> createState() => _CreatedGameDetailsState();
}

class _CreatedGameDetailsState extends State<CreatedGameDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "", showBackButton: true),
      body: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          final user = provider.user;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  widget.sport!,
                  style: AppTextStyle.blackText(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 15, top: 5),
                child: Text(
                  "${widget.time!}, ${widget.date!}",
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
                          widget.venue!,
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
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Game Details",
                          style: AppTextStyle.blackText(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Venue:",
                                style: AppTextStyle.blackText(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.venue!,
                                style: AppTextStyle.primaryText(
                                  fontSize: 12,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.skill!,
                                style: AppTextStyle.primaryText(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        widget.players!.isNotEmpty || widget.cost!.isNotEmpty
                            ? Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Play and Join:",
                                    style: AppTextStyle.blackText(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "₹${widget.cost!}/Player",
                                    style: AppTextStyle.primaryText(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : SizedBox(),
                        widget.instructions!.isNotEmpty
                            ? Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Instruction:",
                                    style: AppTextStyle.blackText(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        widget.instructions!.map((item) {
                                          return Text(
                                            "• $item",
                                            style: AppTextStyle.primaryText(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            )
                            : SizedBox(),
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
                    child: Column(
                      children: [
                        Row(
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
                                      style: AppTextStyle.blackText(
                                        fontSize: 12,
                                      ),
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
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
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
                        SizedBox(height: 20),
                        Container(
                          height: 40,
                          width: MediaQuery.sizeOf(context).width,
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
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 300),
                                  child: const AllPlayers(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                            child: Text(
                              "INVITE PLAYERS +",
                              style: AppTextStyle.whiteText(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
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
        padding: const EdgeInsets.only(bottom: 40, left: 15, right: 15),
        child: Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        child: const ChatScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: Text(
                    "GAME CHAT",
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
}
