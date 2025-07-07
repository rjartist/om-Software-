import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
class GlobalSnackbar {
  static void _showFlushbar(
    BuildContext context,
    String title,
    String message,
    Color backgroundColor,
    Icon icon, {
    Duration duration = const Duration(seconds: 3),
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        title: title,
        message: message,
        backgroundColor: backgroundColor,
        icon: icon,
        duration: duration,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // less vertical margin
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // reduce padding for less height
        animationDuration: const Duration(milliseconds: 400),
        titleColor: Colors.white,
        messageColor: Colors.white,
      ).show(context);
    });
  }

  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String title = "Success",
  }) {
    _showFlushbar(
      context,
      title,
      message,
      Colors.green.shade400, // softer green
      const Icon(Icons.check_circle, color: Colors.white),
      duration: duration,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String title = "Error",
  }) {
    _showFlushbar(
      context,
      title,
      message,
      Colors.red.shade400, // softer red
      const Icon(Icons.error_outline, color: Colors.white),
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String title = "Info",
  }) {
    _showFlushbar(
      context,
      title,
      message,
      Colors.blue.shade400, // softer blue
      const Icon(Icons.info_outline, color: Colors.white),
      duration: duration,
    );
  }
}
