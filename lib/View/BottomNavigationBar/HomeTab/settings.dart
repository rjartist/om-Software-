import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isToggled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Settings", showBackButton: true),
      body: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          final user = provider.user;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Allow Notification",
                                style: AppTextStyle.blackText(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              Text(
                                "By turning on you can receive updates on offers and events sent from turfs",
                                style: AppTextStyle.blackText(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFAEA9A9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Switch(
                          value: isToggled,
                          onChanged: (value) {
                            setState(() {
                              isToggled = value;
                            });
                          },
                          activeColor: AppColors.gradientRedEnd,
                          inactiveTrackColor: AppColors.bgColor,

                          inactiveThumbColor:
                              Colors.grey, // thumb color when OFF
                          // splashRadius: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Account",
                      style: AppTextStyle.blackText(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),

                        border: Border.all(
                          width: 0.5,
                          color: AppColors.gradientRedStart,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Center(
                                  child: Text(
                                    "DELETE THIS ACCOUNT",
                                    style: AppTextStyle.blackText(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                content: Text(
                                  "Are You Sure You Want To Delete This Account ?",
                                  style: AppTextStyle.blackText(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: AppColors.bgColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            "CANCEL",
                                            style: AppTextStyle.blackText(
                                              color: Color(0xFF353535),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),

                                      Container(
                                        width: 120,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppColors
                                                  .profileSectionButtonColor,
                                              AppColors
                                                  .profileSectionButtonColor2,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<LoginProvider>()
                                                .deleteAccount(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            fixedSize: Size(150, 40),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),

                                          child: Text(
                                            "DELETE",
                                            style: AppTextStyle.whiteText(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "DELETE ACCOUNT",
                          style: AppTextStyle.primaryText(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFFE60909),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Center(
                                  child: Text(
                                    "LOG OUT",
                                    style: AppTextStyle.blackText(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                content: Text(
                                  "Are You Sure You Want To Log Out ?",
                                  style: AppTextStyle.blackText(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: AppColors.bgColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            "CANCEL",
                                            style: AppTextStyle.blackText(
                                              color: Color(0xFF353535),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppColors
                                                  .profileSectionButtonColor,
                                              AppColors
                                                  .profileSectionButtonColor2,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<LoginProvider>()
                                                .logout(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(150, 40),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            "LOG OUT",
                                            style: AppTextStyle.whiteText(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
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
                          "LOG OUT",
                          style: AppTextStyle.whiteText(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIconWithTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
