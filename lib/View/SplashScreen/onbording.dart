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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        spacing: 20,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 468,
                        width: double.infinity,
                        child: Image.asset(page['image']!, fit: BoxFit.cover),
                      ),
                      vSizeBox(10),
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
                              color:
                                  _currentIndex == dotIndex
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      vSizeBox(40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Text(
                              page['title']!,
                              style: AppTextStyle.boldBlackText(fontSize: 18),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page['subtitle']!,
                              style: AppTextStyle.greytext(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),

                            vSizeBox(30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_currentIndex < _pages.length - 1) {
                                      _controller.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
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
          Text(
            "Let’s get playing!",
            style: AppTextStyle.base(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GlobalButton(
              // text: _currentIndex == _pages.length - 1 ? "Let's Start" : "Next",
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
          vSizeBox(10),
        ],
      ),
    );
  }
}
