import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
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
      appBar: GlobalAppBar(title: "", showBackButton: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Text("Cricket", style: AppTextStyle.blackText(fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
            child: Text(
              "Player - 03",
              style: AppTextStyle.blackText(fontSize: 14),
            ),
          ),

          Divider(color: AppColors.dividerColor),
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
              height: 50,
              width: 50,
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
                child: Icon(Icons.add, color: AppColors.white, size: 25),
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
                    vertical: 14,
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
              height: 50,
              width: 50,
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
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
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
