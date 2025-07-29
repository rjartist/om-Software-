import 'package:flutter/material.dart';
import 'package:gkmarts/Models/BookTabModel/venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
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

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    _buildInfoRow("Booking ID", provider.bookingId.toString()),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Paid:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "₹${provider.finalPayableAmount}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
