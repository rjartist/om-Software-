import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:provider/provider.dart';

class ApplyCouponPage extends StatefulWidget {
  const ApplyCouponPage({super.key});

  @override
  State<ApplyCouponPage> createState() => _ApplyCouponPageState();
}

class _ApplyCouponPageState extends State<ApplyCouponPage> {
  final TextEditingController _couponController = TextEditingController();
  String appliedMessage = '';
  bool isApplied = false;

  void _applyCoupon(BookTabProvider provider) {
    final enteredCode = _couponController.text.trim().toUpperCase();

    if (enteredCode == 'DISCOUNT100') {
      provider.offerDiscount = 100;

      setState(() {
        appliedMessage = "Coupon Applied: ₹100 OFF";
        isApplied = true;
      });
      Navigator.pop(context); // or show a Snackbar
    } else {
      setState(() {
        appliedMessage = "Invalid Coupon Code";
        isApplied = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Apply Coupon", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your coupon code",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: "Enter code here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GlobalButton(
              text: "Apply Coupon",
              onPressed: () => _applyCoupon(provider),
            ),
            const SizedBox(height: 12),
            if (appliedMessage.isNotEmpty)
              Text(
                appliedMessage,
                style: TextStyle(
                  color: isApplied ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
