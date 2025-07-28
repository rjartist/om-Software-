import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venues.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_header.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/create_game.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/games.dart';
import 'package:gkmarts/Widget/network_status_banner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlayTab extends StatelessWidget {
  const PlayTab({super.key});

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
          vSizeBox(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text('Games Around You', style: AppTextStyle.blackText()),
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        child: CreateGame(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(98, 20), // Exact size
                    padding: EdgeInsets.zero, // Remove extra space
                    side: const BorderSide(color: Colors.red),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:
                        VisualDensity.compact, // ✅ Makes button tighter
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Create",
                      style: AppTextStyle.primaryText(
                        fontSize:
                            14, // 👈 Shrink font to fit 20 height perfectly
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                    color: Colors.black.withOpacity(0.2),
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
                  hintText: 'Type Game',
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
          vSizeBox(8),
          Expanded(child: Games()),
        ],
      ),
    );
  }
}
