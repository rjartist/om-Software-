import 'package:flutter/material.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final double height;
  final double width;
  final double fontSize;
  final EdgeInsets padding;
  final bool usePrimaryForAdd;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.height = 28,
    this.width = 28,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.usePrimaryForAdd = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ➖ Minus Button
          InkWell(
            onTap: onDecrement,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(Icons.remove, size: 18),
            ),
          ),

          // 🔢 Quantity
          Padding(
            padding: padding,
            child: Text(
              '$quantity',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // ➕ Plus Button
          InkWell(
            onTap: onIncrement,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: usePrimaryForAdd ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.add,
                size: 18,
                color: usePrimaryForAdd ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}