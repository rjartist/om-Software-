import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:provider/provider.dart';

class ApplyCouponPage extends StatefulWidget {
  const ApplyCouponPage({super.key});

  @override
  State<ApplyCouponPage> createState() => _ApplyCouponPageState();
}

class _ApplyCouponPageState extends State<ApplyCouponPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookTabProvider>().getCoupons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Coupons", showBackButton: true),
      body: Consumer<BookTabProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCouponInput(provider),
                const SizedBox(height: 12),
                if (provider.couponAppliedMessage.isNotEmpty)
                  Text(
                    provider.couponAppliedMessage,
                    style: TextStyle(
                      color:
                          provider.isCouponApplied ? Colors.green : Colors.red,
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(child: _buildCouponList(provider)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCouponList(BookTabProvider provider) {
    if (provider.isCouponLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (provider.couponList.isEmpty) {
      return Center(
        child: Text("No available coupons.", style: AppTextStyle.greytext()),
      );
    }

    return ListView.separated(
      itemCount: provider.couponList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final coupon = provider.couponList[index];

        return InkWell(
          onTap: () {
            provider.selectCoupon(coupon.couponCode);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(coupon.couponCode, style: AppTextStyle.blackText()),
                      const SizedBox(height: 4),
                      Text(
                        coupon.discountAmount != null
                            ? "₹${coupon.discountAmount} OFF"
                            : "${coupon.discountPercentage}% OFF",
                        style: AppTextStyle.primaryText(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Expires: ${formatFullDateString(coupon.expiryDate)}",
                        style: AppTextStyle.greytext(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  activeColor: AppColors.primaryColor,
                  value: coupon.couponCode,
                  groupValue: provider.selectedCouponCode,
                  onChanged: (value) {
                    provider.selectCoupon(value!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCouponInput(BookTabProvider provider) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: provider.couponController,
              decoration: const InputDecoration(
                hintText: "Apply Coupon",
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed:
              provider.isCouponApplying
                  ? null
                  : () async {
                    final success = await provider.applyCoupon();
                    if (success && mounted) {
                      Navigator.pop(context);
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              provider.isCouponApplying
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Text("Apply", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
