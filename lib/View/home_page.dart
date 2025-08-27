import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Provider/Location/location_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Utils/OneSignal/OneSignalService.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_tab.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_bookings.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_coins.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/notification_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/profile_page.dart'
    show ProfilePage;
import 'package:gkmarts/View/BottomNavigationBar/LearnTab/learn_tab.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/book_tab.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/all_conversation.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/play_tab.dart';
import 'package:gkmarts/View/Auth_view/mobile_otp_login_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:gkmarts/Provider/Profile/profile_page_provider.dart';
import 'dart:async';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();

    // Set Android navigation bar to white and icons to dark
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, 
        systemNavigationBarIconBrightness: Brightness.dark, 
        statusBarColor: Colors.transparent, 
        statusBarIconBrightness: Brightness.dark, 
      ),
    );

    // Delay until after the first frame to get context safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
      _handlePendingNotification();
    });

   _initDeepLinks();
  }

  void _initDeepLinks() async{
    _appLinks = AppLinks();

    // Handle app links when app is already running
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) _handleAppLink(uri);
    });

    // Handle initial link when app is opened from cold start
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleAppLink(initialUri);
    }
  }

  void _handleAppLink(Uri uri) {
    if (uri.pathSegments.isEmpty) return;

    final type = uri.pathSegments.first; // "venue" or "refer"
    final value = uri.pathSegments.last;

    if (type == "venue") {
      final venueId = int.tryParse(value);
      if (venueId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VenueDetailsPage(facilityId: venueId),
          ),
        );
      }
    } else if (type == "refer") {
      // final referralCode = value;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => ReferPage(referralCode: referralCode),
      //   ),
      // );
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }
  void _handlePendingNotification() async {
    final isLoggedIn = await AuthService.isLoggedIn();

    if (!isLoggedIn) {
      // Redirect to login
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) => const MobileInputPage()),
      // );
      return;
    }
    final data = OneSignalService.pendingNotificationData;
    if (data == null) return;

    final type = data['type'];

    switch (type) {
      case 'Coins':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyCoins()),
        );
        break;

      case 'Booking':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyBookings()),
        );
        break;

      case 'Review':
      //past
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyBookings()),
        );
        break;

      case 'CancelBooking':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyBookings()),
        );
        break;

      case 'General':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationPage()),
        );
        break;

      default:
        debugPrint("Unknown notification type: $type");
    }

    // Clear pending data
    OneSignalService.pendingNotificationData = null;
  }

  void _initData() {
    final homeTabProvider = Provider.of<HomeTabProvider>(
      context,
      listen: false,
    );
    final locationProvider = context.read<LocationProvider>();
    locationProvider.fetchAndSaveLocation();
    homeTabProvider.getBanner(context);
    homeTabProvider.getBookVenue(context);
    homeTabProvider.getJoinGame(context);
    homeTabProvider.getCoinsData(context);
    context.read<ProfileProvider>().getProfile(context);
  }

  final List<Widget> _pages = const [
    HomeTab(),
    PlayTab(),
    LearnTab(),
    BookTab(),
    ProfilePage(homePage: true),
    // ReferAndEarn(),
  ];
  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<BottomNavProvider>();
    final currentIndex = navProvider.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: _pages[currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
           elevation: 0,
          onTap: (index) async {
            if (index == 4) {
              final isLoggedIn = await AuthService.isLoggedIn();
              if (!isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const MobileInputPage(
                          isHome: true,
                          referralCode: "",
                        ),
                  ),
                );
                return; // Stop navigation to ProfilePage
              }
            }
            navProvider.changeIndex(index); // Proceed normally
          },
          // onTap: navProvider.changeIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.gradientGreyEnd,
          selectedLabelStyle: AppTextStyle.smallBlack(
            fontWeight: FontWeight.w600,
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
                currentIndex == 2 ? Icons.menu_book : Icons.menu_book_outlined,
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
              icon: Icon(currentIndex == 4 ? Icons.menu : Icons.menu),
              label: "More",
            ),
          ],
        ),
      ),
      floatingActionButton:
          currentIndex == 0 || currentIndex == 1
              ? FloatingActionButton(
                onPressed: () {
                  // Add your action here
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                      child: AllConversation(),
                    ),
                  );
                },
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                child: const Icon(Icons.message, color: Colors.white, size: 28),
              )
              : null,
    );
  }
}


// final referralLink = "https://cxplay-bb5b4.web.app/refer/$referralCode";

// SharePlus.instance.share(
//   ShareParams(
//     text: "Join CX Play with my referral!\n$referralLink",
//     subject: "CX Play Referral",
//   ),
// );

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