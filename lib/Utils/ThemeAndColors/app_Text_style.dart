import 'package:flutter/material.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';

class AppTextStyle {
  static const String _fontFamily = 'Roboto';

  static TextStyle base({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    FontStyle fontStyle = FontStyle.normal,
    double height = 1.3,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      height: height,
    );
  }

  // Regular medium black text
  static TextStyle blackText({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    Color color = Colors.black87,
  }) => base(fontSize: fontSize, fontWeight: fontWeight, color: color);

  static TextStyle primaryText({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.primaryColor,
  }) => base(fontSize: fontSize, fontWeight: fontWeight, color: color);

  // Bold black text
  static TextStyle boldBlackText({
    double fontSize = 16,
    Color color = Colors.black,
  }) => base(fontSize: fontSize, fontWeight: FontWeight.bold, color: color);

  // Small grey text, for hints or captions
  static TextStyle smallGrey({
    double fontSize = 12,
    Color color = Colors.grey,
    FontWeight fontWeight = FontWeight.w400,
  }) => base(fontSize: fontSize, fontWeight: fontWeight, color: color);

  // Small black text (normal weight)
  static TextStyle smallBlack({
    double fontSize = 12,
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w400,
  }) => base(fontSize: fontSize, fontWeight: fontWeight, color: color);

  // Medium grey text, for secondary info
  static TextStyle mediumGrey({
    double fontSize = 14,
    Color color = Colors.grey,
    FontWeight fontWeight = FontWeight.w400,
  }) => base(fontSize: fontSize, fontWeight: fontWeight, color: color);

  static TextStyle greytext({
    double fontSize = 16,
    Color color = Colors.grey,
    FontWeight fontWeight = FontWeight.w400,
  }) => base(fontSize: fontSize, fontWeight: fontWeight, color: color);

  // White text normal weight
  static TextStyle whiteText({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) => base(fontSize: fontSize, fontWeight: fontWeight, color: Colors.white);

  // White bold text
  static TextStyle whiteBoldText({double fontSize = 14}) => base(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Italic text style
  static TextStyle italic({
    double fontSize = 14,
    Color color = Colors.black54,
  }) => base(fontSize: fontSize, color: color, fontStyle: FontStyle.italic);

  static TextStyle titleText() =>
      base(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600);
}

SizedBox hSizeBox(double width) => SizedBox(width: width);

/// Vertical SizedBox
SizedBox vSizeBox(double height) => SizedBox(height: height);
