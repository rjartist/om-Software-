import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/Bookings/booking_list_provider.dart';
import 'package:gkmarts/Provider/Bookings/bookings_count_provider.dart';
import 'package:gkmarts/Provider/Bookings/cancel_booking_provider.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Provider/Favorites/my_favorites_provider.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Provider/HomePage/learn_provider.dart';
import 'package:gkmarts/Provider/Location/location_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Provider/Phonpay/phon_pay_payment_provider.dart';
import 'package:gkmarts/Provider/Profile/edit_profile_provider.dart';
import 'package:gkmarts/Provider/Profile/profile_page_provider.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Utils/SharedPrefHelper/shared_local_storage.dart';
import 'package:gkmarts/View/SplashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => HomeTabProvider()),
        ChangeNotifierProvider(create: (_) => BookTabProvider()),
        ChangeNotifierProvider(create: (_) => LearnProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => MyBookingsProvider()),
        ChangeNotifierProvider(create: (_) => MyFavoritesProvider()),
        ChangeNotifierProvider(create: (_) => PhonePePaymentProvider ()),
        ChangeNotifierProvider(create: (_) => BookingsCountProvider()),
        ChangeNotifierProvider(create: (_) => CancelBookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: SplashScreen(),
        title: 'CX PlayGround',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
