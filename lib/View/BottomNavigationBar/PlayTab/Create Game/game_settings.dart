import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_sport.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_venue.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/game_chat_details_screen.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class GameSettings extends StatefulWidget {
  const GameSettings({super.key});

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();

  String selectedOption = "Beginner";

  bool isEnabled = false; // Toggle state

  final List<String> options = [
    "Beginner",
    "Amateur",
    "Intermediate",
    "Expert",
  ];

  final List<String> items = [
    'Bring Your Own Equipment',
    'Cost Shared',
    'Vaccinated Players Preferred',
  ];
  List<bool> isChecked = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Game Settings", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Game Skill",
                style: AppTextStyle.blackText(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        options.map((skill) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ), // 👈 Add horizontal spacing
                            child: Column(
                              children: [
                                Text(
                                  skill,
                                  style: AppTextStyle.blackText(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ), // 👈 Vertical spacing between text and radio
                                Radio<String>(
                                  value: skill,
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                  },
                                  activeColor: Colors.red,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SwitchListTile(
              activeColor: AppColors.gradientRedStart,
              inactiveThumbColor: AppColors.darkGrey,
              inactiveTrackColor: AppColors.bgContainer,
              title: Text(
                "Pay and Join",
                style: AppTextStyle.blackText(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: isEnabled,
              onChanged: (val) {
                setState(() {
                  isEnabled = val;
                });
              },
            ),
            // Text(
            //   "Pay and Join",
            //   style: AppTextStyle.blackText(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            isEnabled ? SizedBox(height: 10) : SizedBox(),
            isEnabled
                ? Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: Text(
                    "Players will have to pay below amount to join your game. You will not be able to remove a person once they have paid",
                    style: AppTextStyle.blackText(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
                : SizedBox(),
            isEnabled
                ? Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
                  child: Container(
                    color: AppColors.white,
                    child: TextField(
                      controller: firstController,
                      style: AppTextStyle.blackText(),
                      decoration: InputDecoration(
                        hintText: "Cost Per Player",
                        hintStyle: AppTextStyle.blackText(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFA7A7A7),
                        ),
                        // 👇 Add border styles
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                )
                : SizedBox(),
            isEnabled
                ? Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
                  child: Container(
                    color: AppColors.white,
                    child: TextField(
                      controller: secondController,
                      style: AppTextStyle.blackText(),
                      decoration: InputDecoration(
                        hintText: "Total Players(including you)",
                        hintStyle: AppTextStyle.blackText(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFA7A7A7),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),

                        // 👇 Add border styles
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                )
                : SizedBox(),
            isEnabled ? SizedBox(height: 10) : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
              child: Text(
                "Add Instruction",
                style: AppTextStyle.blackText(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                      items[index],
                      style: AppTextStyle.blackText(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: isChecked[index],
                    onChanged: (value) {
                      setState(() {
                        isChecked[index] = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryColor,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
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
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: Text(
                    "CANCEL",
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
                    final selectedInstructions = <String>[];
                    for (int i = 0; i < items.length; i++) {
                      if (isChecked[i]) {
                        selectedInstructions.add(items[i]);
                      }
                    }

                    Navigator.pop(context, {
                      'selectedSkill': selectedOption,
                      'costPerPlayer': firstController.text,
                      'totalPlayers': secondController.text,
                      'instructions': selectedInstructions,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: Text(
                    "OK",
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

class GameSettingsData {
  final String selectedSkill;
  final String costPerPlayer;
  final String totalPlayers;
  final List<String> instructions;

  GameSettingsData({
    required this.selectedSkill,
    required this.costPerPlayer,
    required this.totalPlayers,
    required this.instructions,
  });
}
