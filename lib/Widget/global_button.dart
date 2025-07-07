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
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: isLoading
                  ? null
                  : const LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              color: isLoading ? AppColors.disabledButtonColor : null,
          
            ),
          ),
          Positioned.fill(
            child: ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.black,
                        ),
                      ),
                    )
                  : Text(
                      text.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
