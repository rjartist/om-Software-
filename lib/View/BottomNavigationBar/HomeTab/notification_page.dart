import 'package:flutter/material.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';

import 'package:flutter/material.dart';

// Dummy notification data
final List<Map<String, String>> notifications = [
  {
    "title": "8 -10 PM slot available",
    "description": "Can play both cricket/football ",
    "date": "08:20 PM",
  },
  {
    "title": "New Feature",
    "description": "Kumar has requested to join your Football gameon 22nd mar. Let them know if you’re game.",
    "date": "08:20 PM",
  },
  {
    "title": "Account Update",
    "description": "Your profile was updated successfully.",
    "date": "08:20 PM",
  },
];

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(title: "Notifications", showBackButton: true),
      backgroundColor: AppColors.bgColor,
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder:
            (context, index) => const Divider(height: 1, thickness: 1),
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Image Placeholder
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey, // Placeholder color
                  ),
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),

                const SizedBox(width: 10),

                // Title, Description, Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification["title"]!,
                              style: AppTextStyle.blackText()
                            ),
                          ),
                          Text(
                            notification["date"]!,
                           style: AppTextStyle.smallBlack(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notification["description"]!,
                        style: AppTextStyle.smallBlack(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
