import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_bookings.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_coins.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications on page load
    Future.microtask(() async {
      final provider = Provider.of<HomeTabProvider>(context, listen: false);
      await provider.getNotifications(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: "Notifications", showBackButton: true),
      backgroundColor: AppColors.bgColor,
      body: PopScope(
        canPop: true, // ✅ allow back navigation
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            context.read<HomeTabProvider>().markUnreadAsRead(context);
          }
        },
        child: Consumer<HomeTabProvider>(
          builder: (context, provider, child) {
            if (provider.isNotificationsLoading) {
              return const NotificationShimmer();
            }

            if (provider.notificationList.isEmpty) {
              return const Center(child: Text("No notifications yet"));
            }
            return ListView.separated(
              itemCount: provider.notificationList.length,
              separatorBuilder:
                  (_, __) => const Divider(height: 1, thickness: 0.4),
              itemBuilder: (context, index) {
                final notification = provider.notificationList[index];

                return NotificationTile(
                  title: notification.title,
                  description: notification.message,
                  date: notification.date,
                  sentAt: notification.sentAt,
                  type: notification.type,
                  isRead: notification.isRead,
                  onTap: () {
                    switch (notification.type) {
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

                      case 'Review': // past
                      case 'CancelBooking':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MyBookings()),
                        );
                        break;

                      case 'General':
                      default:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationPage(),
                          ),
                        );
                        break;
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String description;
  final String date; // yyyy-MM-dd
  final DateTime sentAt; // full DateTime
  final bool isRead;
  final String type;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.sentAt,
    required this.type,
    required this.isRead,
    this.onTap,
  });

  String get formattedTime {
    return DateFormat(
      'hh:mm a',
    ).format(sentAt.toLocal()); // convert UTC to local
  }

  String get formattedDate {
    return DateFormat(
      'dd MMM yyyy',
    ).format(sentAt.toLocal()); // convert UTC to local
  }

  IconData get typeIcon {
    switch (type.toLowerCase()) {
      case 'coins':
        return Icons.monetization_on; // coin icon
      case 'booking':
        return Icons.event_available; // booking icon
      case 'review':
        return Icons.rate_review; // review icon
      case 'cancelbooking':
        return Icons.cancel; // cancel icon
      case 'general':
      default:
        return Icons.notifications; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isRead ? Colors.white : AppColors.bgColor, // highlight unread
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular icon with unread indicator
            Stack(
              children: [
                // Container(
                //   width: 50,
                //   height: 50,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color:
                //         isRead
                //             ? Colors.grey
                //             : AppColors.primaryColor.withOpacity(0.7),
                //   ),
                //   child: const Icon(Icons.notifications, color: Colors.white),
                // ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isRead
                            ? Colors.grey
                            : AppColors.primaryColor.withOpacity(0.7),
                  ),
                  child: Icon(typeIcon, color: Colors.white), 
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Title, description, date & time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Date & Time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyle.blackText(
                            fontSize: 14,
                            fontWeight:
                                isRead ? FontWeight.w500 : FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    description,
                    style: AppTextStyle.smallBlack().copyWith(
                      color: isRead ? Colors.grey[700] : Colors.black,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$formattedDate, $formattedTime',
                    style: AppTextStyle.base(
                      color: AppColors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6, // number of shimmer items
      separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circle shimmer (icon placeholder)
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Text shimmer placeholders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Date row
                    Row(
                      children: [
                        Expanded(
                          child: ShimmerBox(
                            height: 14,
                            margin: const EdgeInsets.only(right: 8),
                          ),
                        ),
                        ShimmerBox(height: 12, width: 60),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description lines
                    ShimmerBox(height: 12, width: double.infinity),
                    const SizedBox(height: 6),
                    ShimmerBox(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Small helper widget for shimmer boxes
class ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({super.key, required this.height, this.width, this.margin});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        color: Colors.white,
      ),
    );
  }
}
