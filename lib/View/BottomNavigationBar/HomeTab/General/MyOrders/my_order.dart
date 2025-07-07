import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/Genaral/general_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/General/MyOrders/my_order_details.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GeneralProvider>().getOrders(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GeneralProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "My Orders", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            provider.isOrderLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.orders.isEmpty
                ? Center(
                  child: Text(
                    "No orders found",
                    style: AppTextStyle.greytext(),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.orders.length,
                  itemBuilder: (context, index) {
                    final order = provider.orders[index];
                    return GestureDetector(
                      onTap: () async {
                        await provider.getOrderDetails(context, order.id);
                        if (context.mounted) {
                          Navigator.push( 
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 300),
                              child: OrderDetailPage(orderId: order.id),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Order ID & Amount
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Order #${order.id}",
                                        style: AppTextStyle.boldBlackText(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "₹${order.totalAmount.toStringAsFixed(2)}",
                                        style: AppTextStyle.primaryText(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Date
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        DateFormat.yMMMd().format(order.date),
                                        style: AppTextStyle.mediumGrey(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  // Status
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Status: ${order.status}",
                                        style: AppTextStyle.greytext(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Chevron Icon Positioned on Right Center
                          Positioned(
                            top: 0,
                            bottom: 0,
                            right: 16,
                            child: Center(
                              child: Icon(
                                Icons.chevron_right,
                                size: 24,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
