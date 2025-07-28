import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_sport.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_venue.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/game_chat_details_screen.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:intl/intl.dart' as intl;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime>
    with SingleTickerProviderStateMixin {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Formatter for time display
  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return intl.DateFormat.jm().format(dt); // e.g., 12:00 PM
  }

  // Show picker for start or end time
  Future<void> _pickTime(bool isStart) async {
    final ThemeData customTheme = Theme.of(context).copyWith(
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.white,
        dialHandColor: AppColors.primaryColor,
        dialBackgroundColor: const Color(0xFF21212114),
        dialTextColor: MaterialStateColor.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? Colors
                      .white // background of selected hour/minute
                  : Colors.black,
        ),
        hourMinuteTextColor: Colors.white,
        hourMinuteColor: MaterialStateColor.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors
                      .primaryColor // background of selected hour/minute
                  : Colors.grey.shade400,
        ),
        hourMinuteTextStyle: AppTextStyle.primaryText(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        dialTextStyle: AppTextStyle.whiteText(fontSize: 14),
        dayPeriodColor: MaterialStateColor.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors
                      .gradientRedStart // background of selected hour/minute
                  : Colors.white,
        ),
        dayPeriodTextColor: MaterialStateColor.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? Colors
                      .white // background of selected hour/minute
                  : Colors.black,
        ), // <-- AM/PM text color (selected/unselected)
        dayPeriodTextStyle: AppTextStyle.whiteText(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          // AM/PM text color
        ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        onSurface: AppColors.primaryColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
      ),
    );
    final picked = await showTimePicker(
      context: context,
      initialTime:
          isStart
              ? (_startTime ?? TimeOfDay.now())
              : (_endTime ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(data: customTheme, child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Select Time", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Start Time', style: AppTextStyle.blackText()),
              subtitle: Text(
                _formatTime(_startTime),
                style: AppTextStyle.blackText(fontWeight: FontWeight.w400),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () => _pickTime(true),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text('End Time', style: AppTextStyle.blackText()),
              subtitle: Text(
                _formatTime(_endTime),
                style: AppTextStyle.blackText(fontWeight: FontWeight.w400),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () => _pickTime(false),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.profileSectionButtonColor,
                AppColors.profileSectionButtonColor2,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            onPressed: () {
              if (_startTime != null && _endTime != null) {
                // Use selected time here
                Navigator.pop(
                  context,
                  "${_formatTime(_startTime)} - ${_formatTime(_endTime)}",
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select a sport")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "SELECT",
              style: AppTextStyle.whiteText(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimeRangePainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final bool isAM;

  TimeRangePainter({
    required this.startAngle,
    required this.endAngle,
    required this.isAM,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 20;

    final basePaint =
        Paint()
          ..color = Colors.grey[300]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20;

    // final arcPaint =
    //     Paint()
    //       ..shader = const LinearGradient(
    //         colors: [Colors.blue, Colors.purple],
    //       ).createShader(Rect.fromCircle(center: center, radius: radius))
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 20
    //       ..strokeCap = StrokeCap.round;

    final handlePaint = Paint()..color = AppColors.primaryColor;

    // Draw base circle
    canvas.drawCircle(center, radius, basePaint);

    // // Draw range arc
    // double sweep = (endAngle - startAngle + 2 * pi) % (2 * pi);
    // canvas.drawArc(
    //   Rect.fromCircle(center: center, radius: radius),
    //   startAngle,
    //   sweep,
    //   false,
    //   arcPaint,
    // );

    // Draw handles
    final startHandle = center + Offset.fromDirection(startAngle, radius);
    final endHandle = center + Offset.fromDirection(endAngle, radius);
    canvas.drawLine(
      center,
      startHandle,
      Paint()
        ..color = AppColors.primaryColor
        ..strokeWidth = 3,
    );
    canvas.drawLine(
      center,
      endHandle,
      Paint()
        ..color = AppColors.primaryColor
        ..strokeWidth = 3,
    );
    canvas.drawCircle(startHandle, 12, handlePaint);
    canvas.drawCircle(endHandle, 12, handlePaint);

    // Draw hour labels
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    // Draw hour numbers
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      final labelOffset = Offset.fromDirection(angle, radius + 20) + center;
      int hour = i == 0 ? 12 : i;
      String text = hour.toString();

      textPainter.text = TextSpan(
        text: text,
        style: AppTextStyle.blackText(fontSize: 12),
      );
      textPainter.layout();
      canvas.save();
      canvas.translate(
        labelOffset.dx - textPainter.width / 2,
        labelOffset.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(TimeRangePainter oldDelegate) =>
      oldDelegate.startAngle != startAngle ||
      oldDelegate.endAngle != endAngle ||
      oldDelegate.isAM != isAM;
}
