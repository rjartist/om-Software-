import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/Location/location_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/View/SplashScreen/onbording.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/Auth_view/login.dart';
import 'package:gkmarts/View/home_page.dart';
import 'package:gkmarts/View/home_page_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    navigateto();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigateto() async {
    await Future.delayed(const Duration(seconds: 3));
    final locationProvider = context.read<LocationProvider>();
    locationProvider.fetchAndSaveLocation();
    bool isLoggedIn = await AuthService.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Logo with Circle
                Container(
                  height: 70.h,
                  width: 268.h,
                  decoration: const BoxDecoration(
                    // shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
