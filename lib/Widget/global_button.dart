import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';

class GlobalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const GlobalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 45,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            // gradient:
            //     isLoading
            //         ? null
            //         : const LinearGradient(
            //           colors: [AppColors.primaryColor, AppColors.primaryColor],
            //         ),
            gradient:
                isLoading
                    ? null
                    : const LinearGradient(
                      colors: [Color(0xFFE60909), Color(0xFFF35A5A)],
                    ),

            color: isLoading ? AppColors.disabledButtonColor : null,
          ),
          child: Container(
            alignment: Alignment.center,
            height: height,
            child:
                isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      text.toUpperCase(),
                      style: AppTextStyle.whiteText(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ).copyWith(letterSpacing: 1.2),
                    ),
          ),
        ),
      ),
    );
  }
}

class GlobalPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool isEnabled; // Add this flag

  const GlobalPrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 191,
    this.height = 43,
    this.isEnabled = true, // Default true
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isEnabled
                    ? [
                      AppColors.profileSectionButtonColor,
                      AppColors.profileSectionButtonColor2,
                    ]
                    : [Colors.grey, Colors.grey],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: AppTextStyle.whiteText(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class GlobalPrimarySmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool isEnabled; // Add this flag

  const GlobalPrimarySmallButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 100,
    this.height = 30,
    this.isEnabled = true, // Default true
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isEnabled
                    ? [
                      AppColors.profileSectionButtonColor,
                      AppColors.profileSectionButtonColor2,
                    ]
                    : [Colors.grey, Colors.grey],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: AppTextStyle.whiteText(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class GlobalGreySmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool isEnabled; // Add this flag

  const GlobalGreySmallButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 100,
    this.height = 30,
    this.isEnabled = true, // Default true
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgContainer, AppColors.bgContainer],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: AppTextStyle.blackText(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class GlobalSmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final Color? borderColor;

  const GlobalSmallButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 191,
    this.height = 43,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side:
                borderColor != null
                    ? BorderSide(color: borderColor!)
                    : BorderSide.none,
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}

class GlobalCancelButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final Color? borderColor;

  const GlobalCancelButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 191,
    this.height = 43,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side:
                borderColor != null
                    ? BorderSide(color: borderColor!)
                    : BorderSide.none,
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: AppTextStyle.blackText(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
