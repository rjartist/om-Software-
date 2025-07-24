import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void printLog(dynamic data) {
  if (!kReleaseMode) printLog(data.toString());
}

Widget buildNetworkOrSvgImage(
  String imageUrl, {
  double width = 32,
  double height = 32,
}) {
  if (imageUrl.isEmpty) {
    return SizedBox(width: width, height: height);
  } else if (imageUrl.toLowerCase().endsWith('.svg')) {
    return SvgPicture.network(
      imageUrl,
      width: width,
      height: height,
      placeholderBuilder: (_) => SizedBox(width: width, height: height),
    );
  } else {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => SizedBox(width: width, height: height),
    );
  }
}

String formatTime24(String time) {
  final parts = time.split(":");
  final dateTime = DateTime(0, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
  return DateFormat('HH:mm').format(dateTime); // 24-hour format
}
String formatTimeOnly12(String time24) {
  final parts = time24.split(":").map(int.parse).toList();
  final dateTime = DateTime(0, 1, 1, parts[0], parts[1]);
  return DateFormat('hh:mm a').format(dateTime); // 12-hour format
}


String formatTimeApi(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  return DateFormat('HH:mm').format(dateTime);
}

String formatTime(String time) {
  try {
    final parsedTime = DateFormat("HH:mm:ss").parse(time);
    return DateFormat("hh:mm a").format(parsedTime);
  } catch (e) {
    return time; // fallback if parsing fails
  }
}

/// Format any DateTime to "d MMMM yyyy" (e.g., 12 December 2025)
String formatFullDate(DateTime date) {
  return DateFormat('d MMMM yyyy').format(date);
}

class CoomingSoonDialogHelper {
  static void showComingSoon(BuildContext context) {
    showDialog(context: context, builder: (_) => const ComingSoonDialog());
  }
}

class ComingSoonDialog extends StatelessWidget {
  final String title;
  final String message;

  const ComingSoonDialog({
    super.key,
    this.title = "Coming Soon",
    this.message = "This feature is under development.\nPlease stay tuned!",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time_filled,
                size: 48,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyle.titleText()),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.greytext(fontSize: 14),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: GlobalPrimaryButton(
                height: 44,
                text: "OK",
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
