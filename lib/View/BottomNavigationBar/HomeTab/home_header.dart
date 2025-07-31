// widgets/home_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Provider/Location/location_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/notification_page.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_banner.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/profile_page.dart';
import 'package:gkmarts/Widget/mobile_otp_login_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeTabProvider>();
    final location = context.watch<LocationProvider>().userAddress;
    final user = context.watch<LoginProvider>().user;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 10.h,
                bottom: 5.h,
              ),
              // decoration: BoxDecoration(color: AppColors.white),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 6,
                    child: _locationBlock(location: location, context: context),
                  ),

                  const Spacer(),
                  _notificationIcon(
                    badge: homeProvider.unreadNotifications,
                    context: context,
                  ),
                  const SizedBox(width: 8),
                  _profileAvatar(),
                ],
              ),
            ),
            // vSizeBox(15),

            // const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const LocationBottomSheet();
      },
    );
  }

  Widget _locationBlock({
    required String location,
    required BuildContext context,
  }) => GestureDetector(
    onTap: () => _showLocationBottomSheet(context),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            location.isNotEmpty ? location : 'Select Location',
            style: AppTextStyle.blackText(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_arrow_down, color: AppColors.black, size: 18),
      ],
    ),
  );

  Widget _badge({required int count}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.9),
          width: 1.2,
        ),
      ),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      child: Text(
        "$count",
        style: const TextStyle(
          color: AppColors.textOnAccent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _notificationIcon({
    required int badge,
    required BuildContext context,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationPage()),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.notifications_none,
            color: AppColors.black,
            size: 30,
          ),
          if (badge > 0)
            Positioned(right: 0, top: -8, child: _badge(count: badge)),
        ],
      ),
    );
  }

  Widget _profileAvatar() => GestureDetector(
    onTap: () async {
      final isLoggedIn = await AuthService.isLoggedIn();

      if (!isLoggedIn) {
        // If not logged in, navigate to login page
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const MobileInputPage()),
        );
        return; // Prevent further execution
      }
      Navigator.push(
        navigatorKey.currentContext!,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          duration: const Duration(milliseconds: 300),
          child: const ProfilePage(homePage: false),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/images/user.jpeg'),
      ),
    ),
  );
}

class LocationBottomSheet extends StatefulWidget {
  const LocationBottomSheet({super.key});

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedAddress;
  final List<String> popularCities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Ahmedabad',
    'Pune',
    'Jaipur',
  ];
  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return DraggableScrollableSheet(
      initialChildSize: 0.50,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Select Your Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: AppColors.primaryColor),
                      tooltip: 'Refresh location',
                      onPressed: () {
                        context.read<LocationProvider>().refreshAddress();
                      },
                    ),
                  ],
                ),

                // TextField(
                //   controller: _searchController,
                //   decoration: InputDecoration(
                //     hintText: 'Type Location',
                //     filled: true,
                //     fillColor: AppColors.bgColor,
                //     suffixIcon: const Icon(Icons.search), // Icon at the end
                //     contentPadding: const EdgeInsets.symmetric(
                //       horizontal: 16,
                //       vertical: 14,
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //       borderSide: BorderSide.none, // No visible border
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //       borderSide: BorderSide.none,
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //       borderSide: BorderSide.none,
                //     ),
                //   ),
                //   onSubmitted: (value) {
                //     setState(() {
                //       selectedAddress = value.trim();
                //     });
                //   },
                // ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          locationProvider.userAddress.isNotEmpty
                              ? locationProvider.userAddress
                              : 'Fetching current location...',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await context
                              .read<LocationProvider>()
                              .refreshAddress();
                        },
                        child: const Text('Use'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Popular Cities',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      popularCities.map((city) {
                        return GestureDetector(
                          onTap: () {
                            context.read<LocationProvider>().setCustomAddress(
                              city,
                            );
                            context.read<HomeTabProvider>().getBookVenue(
                              context,
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              city,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                if (selectedAddress != null && selectedAddress!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade100),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue.shade50,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_pin, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedAddress!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<LocationProvider>().setCustomAddress(
                              selectedAddress!,
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Set'),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
