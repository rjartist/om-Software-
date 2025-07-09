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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NetworkStatusBanner(),
            const HomeHeader(),
            Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4 ),
              child: Text('Venues Around You', style: AppTextStyle.blackText()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintStyle: const TextStyle(color: Colors.grey),
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

            const Expanded(child: Venues()), 
          ],
        ),
      ),
    );
  }
}
