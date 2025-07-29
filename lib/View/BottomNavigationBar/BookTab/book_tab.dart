import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venues.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_header.dart';
import 'package:gkmarts/Widget/network_status_banner.dart';
import 'package:provider/provider.dart';

class BookTab extends StatelessWidget {
  const BookTab({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NetworkStatusBanner(),
          HomeHeader(),
          vSizeBox(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text('Venues Around You', style: AppTextStyle.blackText()),
          ),
          vSizeBox(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.2,
                    ), // Match the stronger shadow
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  context.read<HomeTabProvider>().searchVenues(value);
                },
                decoration: InputDecoration(
                  hintText: 'Type venues...',
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.5),
                    child: Image.asset(
                      "assets/images/search.png",
                      height: 5,
                      width: 5,
                      color: AppColors.grey,
                    ),
                  ),
                  hintStyle:
                      AppTextStyle.greytext(), // Match with your defined style
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

          vSizeBox(8),
           Expanded(child: Venues(gamePage: false)),
        ],
      ),
    );
  }
}
