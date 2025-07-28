import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/create_game_chat_details.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBarWithSuffixIcon(
        title: "Game Chat",
        showBackButton: true,
        suffixIcon: Icons.info_outline_rounded,
        onSuffixTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 300),
              child: CreateGameChatDetails(),
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.white),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cricket",
                    style: AppTextStyle.blackText(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "11:00 AM - 12:00 PM, 22 Mar, Mon",
                    style: AppTextStyle.primaryText(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(
                    "assets/images/dummyProfile1.jpg",
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vaibhav Mahajan",
                      style: AppTextStyle.blackText(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Hi, can i join this game?",
                      style: AppTextStyle.blackText(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(
                    "assets/images/dummyProfile1.jpg",
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mayur Patil",
                      style: AppTextStyle.blackText(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Yes sure you can join.",
                      style: AppTextStyle.blackText(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          left: 15,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                shape: BoxShape.circle,
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero, // Important for centering
                ),
                child: Icon(Icons.add, color: AppColors.white, size: 20),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200, // Light grey background
                  hintText: 'Write a message',
                  labelStyle: AppTextStyle.blackText(),
                  hintStyle: AppTextStyle.greytext(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.profileSectionButtonColor,
                    AppColors.profileSectionButtonColor2,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero, // Important for centering
                ),
                child: Icon(Icons.send, color: AppColors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
