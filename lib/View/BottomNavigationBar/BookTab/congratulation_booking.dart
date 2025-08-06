import 'package:flutter/material.dart';
import 'package:gkmarts/Models/BookTabModel/venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/booking_proceed_pay.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/cancle_booking.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:provider/provider.dart';

class CongratulationBooking extends StatelessWidget {
  final VenueDetailModel model;

  const CongratulationBooking({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: GlobalAppBar(
          title: "Booking Confirmed",
          showBackButton: false,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 60),
                      SizedBox(height: 12),
                      Text(
                        "🎉 Congratulations!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your booking has been successfully confirmed.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                // Booking Details Card
                BookingInfoCard(model: model, provider: provider),

                // Container(
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.05),
                //         blurRadius: 10,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       _buildInfoRow(
                //         "Payment Date",
                //         provider.paymentDate ?? "N/A",
                //       ),
                //       _buildInfoRow(
                //         "Payment Time",
                //         provider.paymentTime ?? "N/A",
                //       ),
                //       _buildInfoRow(
                //         "Payment Method",
                //         provider.paymentMethod ?? "UPI",
                //       ),
                //       _buildInfoRow(
                //         "Booking ID",
                //         provider.bookingId.toString(),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        "Payment Date",
                        provider.paymentDate ?? "N/A",
                      ),
                      _buildInfoRow(
                        "Payment Time",
                        provider.paymentTime ?? "N/A",
                      ),
                      _buildInfoRow(
                        "Payment Method",
                        provider.paymentMethod ?? "UPI",
                      ),
                      _buildInfoRow(
                        "Booking ID",
                        provider.bookingId.toString(),
                      ),
                    ],
                  ),
                ),

                // Container(
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.05),
                //         blurRadius: 10,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 16,
                //     vertical: 16,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const Text(
                //         "Total Paid:",
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       Text(
                //         "₹${provider.finalPayableAmount}",
                //         style: const TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.green,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                PaymentSummaryWidget(provider: provider),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // GlobalPrimaryButton(
                    //   text: "Cancel Booking",
                    //   onTap: () {
                    //     showModalBottomSheet(
                    //       context: context,
                    //       isScrollControlled: true,
                    //       shape: const RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.vertical(
                    //           top: Radius.circular(20),
                    //         ),
                    //       ),
                    //       builder:
                    //           (_) => CancelBookingSheet(
                    //             model: model,
                    //             bookingDateTime:
                    //                 "${provider.paymentDate} at ${provider.paymentTime}",
                    //           ),
                    //     );
                    //   },
                    //   width: 150,
                    // ),
                    GlobalPrimaryButton(
                      text: "Back To Home",
                      onTap: () {
                        context.read<BookTabProvider>().clearBookingData();
                        context.read<BottomNavProvider>().changeIndex(0);
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      width: 150,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, size: 18, color: Colors.grey[700]),
              if (icon != null) const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isTotal ? Colors.black : Colors.grey[800]!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.blackText(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: AppTextStyle.blackText(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (_) => const BookingErrorPage(
//       errorMessage: "Payment could not be processed. Please try again.",
//     ),
//   ),
// );

class BookingErrorPage extends StatelessWidget {
  final String errorMessage;

  const BookingErrorPage({
    super.key,
    this.errorMessage = "Something went wrong!",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Booking Failed", showBackButton: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Center(
              child: Column(
                children: const [
                  Icon(Icons.cancel, color: Colors.redAccent, size: 60),
                  SizedBox(height: 12),
                  Text(
                    "Booking Failed",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),

            Center(
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GlobalSmallButton(
                  text: "Try Again",
                  onTap: () {
                    Navigator.pop(context); // Go back to previous screen
                  },
                  width: 150,
                ),
                GlobalSmallButton(
                  text: "Back To Home",
                  onTap: () {
                    context.read<BottomNavProvider>().changeIndex(0);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  width: 150,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSummaryWidget extends StatefulWidget {
  final BookTabProvider provider;

  const PaymentSummaryWidget({super.key, required this.provider});

  @override
  State<PaymentSummaryWidget> createState() => _PaymentSummaryWidgetState();
}

class _PaymentSummaryWidgetState extends State<PaymentSummaryWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle Title
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payment Summary", style: AppTextStyle.primaryText()),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Expandable Section
          if (isExpanded) ...[
            _buildSummaryRow(
              "Court Fee",
              "₹${provider.courtFee.toStringAsFixed(2)}",
            ),
            _buildSummaryRow(
              "Coupon Discount",
              "- ₹${provider.offerDiscount.toStringAsFixed(2)}",
            ),
            _buildSummaryRow(
              "Coin Redemption",
              "- ₹${provider.coinDiscount.toStringAsFixed(2)}",
            ),
            const Divider(height: 16),
            _buildSummaryRow(
              "Sub Total",
              "₹${provider.subTotal.toStringAsFixed(2)}",
            ),
            _buildSummaryRow(
              "Convenience Fee",
              "₹${provider.convenienceFee.toStringAsFixed(2)}",
            ),
            _buildSummaryRow(
              "Platform Fee (2%)",
              "₹${provider.platformFee.toStringAsFixed(2)}",
            ),
            _buildSummaryRow(
              "GST (18%)",
              "₹${provider.gstOnPlatformFee.toStringAsFixed(2)}",
            ),
            const Divider(height: 16),
          ],

          // Always visible
          _buildSummaryRow(
            "Total Paid",
            "₹${provider.finalPayableAmount.toStringAsFixed(2)}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.primaryText(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? Colors.green[800] ?? Colors.green : Colors.black,
            ),
          ),
          Text(
            value,
            style: AppTextStyle.primaryText(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? Colors.green[800] ?? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
