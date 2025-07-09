import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/Auth_view/login.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:page_transition/page_transition.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/onboard2.png',
      'title': 'Welcome to CX PlayGround',
      'subtitle':
          'Simplify your sports experience with CX PlayGround’s easy booking and real-time availability.',
    },
    {
      'image': 'assets/images/onboard2.png',
      'title': 'Book Your Favourite Turf Grounds',
      'subtitle': 'Enjoy your favourite sports like never before',
    },
    // {
    //   'image': 'assets/images/onboarding3.png',
    //   'title': 'Book Instantly',
    //   'subtitle': 'Fast and hassle-free booking for your favorite sports venues.',
    // },
  ];
@override
Widget build(BuildContext context) {
  final Size screenSize = MediaQuery.of(context).size;

  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Image.asset(
                        page['image']!,
                        width: double.infinity,
                        height: screenSize.height * 0.45,
                        fit: BoxFit.cover,
                      ),

                      SizedBox(height: screenSize.height * 0.02),

                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (dotIndex) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _currentIndex == dotIndex
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenSize.height * 0.04),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              page['title']!,
                              style: AppTextStyle.boldBlackText(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page['subtitle']!,
                              style: AppTextStyle.greytext(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: screenSize.height * 0.1),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_currentIndex < _pages.length - 1) {
                                      _controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                    ],
                  ),
                );
              },
            ),
          ),

          Divider(
            height: 1,
            color: Colors.grey.shade300,
            indent: 24,
            endIndent: 24,
          ),

          SizedBox(height: screenSize.height * 0.015),

          Text(
            "Let’s get playing!",
            style: AppTextStyle.base(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: GlobalButton(
              text: "Let's Start",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const Login(),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: screenSize.height * 0.01),
        ],
      ),
    ),
  );
}
}