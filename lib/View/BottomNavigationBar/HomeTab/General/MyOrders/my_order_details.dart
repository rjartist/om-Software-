import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/Genaral/general_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId; // Accept orderId
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GeneralProvider>().getOrderDetails(context, widget.orderId);
    });
  }
@override
Widget build(BuildContext context) {
  final provider = context.watch<GeneralProvider>();
  final order = provider.orderDetail;

  return Scaffold(
    backgroundColor: AppColors.bgColor,
    appBar: GlobalAppBar(title: "Order Details", showBackButton: true),
    body: provider.isOrderDetailLoading
        ? const Center(child: CircularProgressIndicator())
        : order == null
            ? Center(
                child: Text(
                  "Order not found",
                  style: AppTextStyle.greytext(),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID & Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order #${order.id}",
                          style: AppTextStyle.boldBlackText(fontSize: 18),
                        ),
                        Text(
                          "₹${order.totalAmount.toStringAsFixed(2)}",
                          style: AppTextStyle.primaryText(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat.yMMMd().format(order.date),
                          style: AppTextStyle.mediumGrey(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text("Status: ${order.status}", style: AppTextStyle.greytext()),
                      ],
                    ),

                    const Divider(height: 30),

                    Text(
                      "Items",
                      style: AppTextStyle.boldBlackText(fontSize: 16),
                    ),
                    const SizedBox(height: 12),

                    ...order.items.map((item) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.image,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: AppTextStyle.blackText(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("${item.quantity} x ₹${item.price.toStringAsFixed(2)}",
                                      style: AppTextStyle.smallBlack()),
                                  Text("Unit: ${item.unit}", style: AppTextStyle.smallGrey()),
                                  if (item.discountLabel != null)
                                    Text(
                                      item.discountLabel!,
                                      style: AppTextStyle.smallGrey(color: Colors.green),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                              style: AppTextStyle.blackText(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    const Divider(height: 30),

                    Text(
                      "Payment & Delivery",
                      style: AppTextStyle.boldBlackText(fontSize: 16),
                    ),
                    const SizedBox(height: 10),

                    Text("Payment Method: ${order.paymentMethod}", style: AppTextStyle.blackText()),
                    Text("Delivery Charge: ₹${order.deliveryCharge.toStringAsFixed(2)}",
                        style: AppTextStyle.blackText()),
                    const SizedBox(height: 10),
                    Text("Address:", style: AppTextStyle.blackText(fontWeight: FontWeight.w600)),
                    Text(order.deliveryAddress, style: AppTextStyle.smallBlack()),

                    const Divider(height: 30),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Total: ₹${order.totalAmount.toStringAsFixed(2)}",
                        style: AppTextStyle.boldBlackText(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
  );
}
}