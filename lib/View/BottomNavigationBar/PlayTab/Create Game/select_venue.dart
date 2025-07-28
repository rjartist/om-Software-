import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venues.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_sport.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/game_chat_details_screen.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SelectVenue extends StatefulWidget {
  const SelectVenue({super.key});

  @override
  State<SelectVenue> createState() => _SelectVenueState();
}

class _SelectVenueState extends State<SelectVenue> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Select Venue", showBackButton: true),
      body: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
                  hintText: 'Type Sport',
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
          Expanded(child: Venues(gamePage: true,)),
        ],
      ),
    );
  }
}
