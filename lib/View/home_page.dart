import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_tab.dart';
import 'package:gkmarts/View/BottomNavigationBar/LearnTab/Learn_tab.dart';
import 'package:gkmarts/View/BottomNavigationBar/MoreTab/more_tab.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/paly_tab.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/book_tab.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Delay until after the first frame to get context safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  void _initData() {
    final homeTabProvider = Provider.of<HomeTabProvider>(
      context,
      listen: false,
    );
    homeTabProvider.getBanner(context);
    homeTabProvider.getBookVenue(context);
    homeTabProvider.getJoinGame(context);
  }

  final List<Widget> _pages = const [
    HomeTab(),
    PlayTab(),
    LearnTab(),
    BookTab(),
    MoreTab(),
  ];
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<BottomNavProvider>();
    final currentIndex = navProvider.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: navProvider.changeIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.gradientGreyEnd,
        selectedLabelStyle: AppTextStyle.smallBlack(
          fontWeight: FontWeight.w600, // bold label for active
          color: AppColors.primaryColor,
        ),
        unselectedLabelStyle: AppTextStyle.smallBlack(
          fontWeight: FontWeight.w400,
          color: AppColors.gradientGreyEnd,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1 ? Icons.people : Icons.people_outline,
            ),
            label: "Play",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ?  Icons.menu_book : Icons.menu_book_outlined,
            ),
            label: "Learn",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3
                  ? Icons.calendar_month
                  : Icons.calendar_month_outlined,
            ),
            label: "Book",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 4 ?Icons.menu : Icons.menu, 
            ),
            label: "More",
          ),
        ],
      ),
    );
  }
}

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: GlobalAppBar(title: "HomePage"),
//       body: Column(
//         children: [
//           const NetworkStatusBanner(), 
//           const Expanded(
//             child: Center(child: Text("Main Content Here")),
//           ),
//         ],
//       ),
//     );
//   }
// }

  //  final isOnline = context.watch<ConnectivityProvider>().isOnline;