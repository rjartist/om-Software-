import 'package:flutter/material.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/created_game_details.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/game_settings.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_date.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_sport.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_time.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_venue.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:page_transition/page_transition.dart';

class CreateGame extends StatefulWidget {
  const CreateGame({super.key});

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  String? selectedItemSports;
  String? selectedItemVenue;
  String? selectedItemDate;
  String? selectedItemTime;
  String? selectedItemSkill;
  String? selectedItemCost;
  String? selectedItemPlayer;
  List<String>? selectedIteminstruction;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Create Game", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildGameCard(
              "Select Sport",
              selectedItemSports == null ? "" : selectedItemSports!,
              () async {
                String? selectedSport = await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: const SelectSport(),
                  ),
                );
                if (selectedSport != null) {
                  setState(() {
                    selectedItemSports = selectedSport;
                  });
                }
              },
            ),
            buildGameCard(
              "Select Venue",
              selectedItemVenue == null ? "" : selectedItemVenue!,
              () async {
                String? selectedVenue = await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: const SelectVenue(),
                  ),
                );
                if (selectedVenue != null) {
                  setState(() {
                    selectedItemVenue = selectedVenue;
                  });
                }
              },
            ),
            buildGameCard(
              "Date",
              selectedItemDate == null ? "" : selectedItemDate!,
              () async {
                String? selectedDate = await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: const SelectDate(),
                  ),
                );
                if (selectedDate != null) {
                  setState(() {
                    selectedItemDate = selectedDate;
                  });
                }
              },
            ),
            buildGameCard(
              "Time",
              selectedItemTime == null ? "" : selectedItemTime!,
              () async {
                String? selectedTime = await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: const SelectTime(),
                  ),
                );
                if (selectedTime != null) {
                  setState(() {
                    selectedItemTime = selectedTime;
                  });
                }
              },
            ),

            buildGameSettingsCard(
              "Game Settings",
              selectedItemSkill == null ? "" : selectedItemSkill!,
              selectedItemCost == null ? "" : selectedItemCost!,
              selectedItemPlayer == null ? "" : selectedItemPlayer!,
              selectedIteminstruction != null ? selectedIteminstruction! : [],
              () async {
                final result = await Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: const GameSettings(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedItemSkill = result['selectedSkill'];
                    selectedItemCost = result['costPerPlayer'];
                    selectedItemPlayer = result['totalPlayers'];
                    selectedIteminstruction = List<String>.from(
                      result['instructions'] ?? [],
                    );
                  });

                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.profileSectionButtonColor,
                AppColors.profileSectionButtonColor2,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            onPressed: () {
              if (selectedItemSports == "" ||
                  selectedItemTime == "" ||
                  selectedItemDate == "" ||
                  selectedItemVenue == "" ||
                  selectedItemSkill == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select details")),
                );
              } else {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: CreatedGameDetails(
                      sport: selectedItemSports,
                      time: selectedItemTime,
                      date: selectedItemDate,
                      venue: selectedItemVenue,
                      skill: selectedItemSkill,
                      cost: selectedItemCost,
                      players: selectedItemPlayer,
                      instructions: [selectedIteminstruction].first,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero, // Important for centering
            ),
            child: Text("CREATE GAME", style: AppTextStyle.whiteText()),
          ),
        ),
      ),
    );
  }

  Widget buildGameCard(String text, String value, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                // spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: AppTextStyle.blackText(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value != ""
                      ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          value,
                          style: AppTextStyle.primaryText(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                      : SizedBox(),
                ],
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, size: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGameSettingsCard(
    String text,
    String skill,
    String costPerPlayer,
    String totalPlayer,
    List<String> instruction,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                // spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: AppTextStyle.blackText(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  skill != ""
                      ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Game Skill: ",
                              style: AppTextStyle.blackText(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              skill,
                              style: AppTextStyle.primaryText(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                      : SizedBox(),
                  totalPlayer != ""
                      ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Text(
                              "Play & Join: ",
                              style: AppTextStyle.blackText(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "$totalPlayer Players",
                              style: AppTextStyle.primaryText(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            SizedBox(width: 5),
                            costPerPlayer != ""
                                ? Text(
                                  "₹$costPerPlayer/Player",
                                  style: AppTextStyle.primaryText(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                                : SizedBox(),
                          ],
                        ),
                      )
                      : SizedBox(),
                  instruction.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Text(
                              "Instruction: ",
                              style: AppTextStyle.blackText(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  instruction.map((item) {
                                    return Text(
                                      "• $item",
                                      style: AppTextStyle.primaryText(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      )
                      : SizedBox(),
                ],
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}
