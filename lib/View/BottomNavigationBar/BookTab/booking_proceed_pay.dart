import 'package:flutter/material.dart';
import 'package:gkmarts/Models/BookTabModel/venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/apply_coupen_book.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/congratulation_booking.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingProceedPayPage extends StatelessWidget {
  final VenueDetailModel model;
  final int totalAmount;

  const BookingProceedPayPage({
    super.key,
    required this.model,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Booking", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            BookingInfoCard(model: model, provider: provider),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ApplyCouponPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    0,
                  ), // You can set it to 12 if you want rounded
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Apply Coupon",
                      style: AppTextStyle.primaryText(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow(
                    "Slot Price",
                    "₹${provider.totalPriceBeforeDiscountall}",
                    color: const Color(0xFF4B4B4B),
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    "Offer Discount",
                    "- ₹${provider.offerDiscount}",
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    "Convenience Fee",
                    "₹${provider.convenienceFee}",
                    color: const Color(0xFF4B4B4B),
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    "Total Amount",
                    "₹${provider.finalPayableAmount}",
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: GestureDetector(
          onTap: () {
            provider.proceedToPay(model);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.profileSectionButtonColor,
                  AppColors.profileSectionButtonColor2,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${provider.finalPayableAmount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: const [
                    Text(
                      "PROCEED TO PAY",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
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
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? (isTotal ? Colors.black : Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}

class BookingInfoCard extends StatelessWidget {
  final VenueDetailModel model;
  final BookTabProvider provider;

  const BookingInfoCard({
    super.key,
    required this.model,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        model.modifiedFacility.facilityImages.isNotEmpty
            ? model.modifiedFacility.facilityImages.first.image
            : '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ClipRRect(
          //   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          //   child:
          //       imageUrl.isNotEmpty
          //           ? Image.network(
          //             imageUrl,
          //             width: double.infinity,
          //             height: 180,
          //             fit: BoxFit.cover,
          //             errorBuilder:
          //                 (context, error, stackTrace) => const SizedBox(
          //                   height: 180,
          //                   child: Center(
          //                     child: Icon(Icons.image_not_supported),
          //                   ),
          //                 ),
          //           )
          //           : const SizedBox(
          //             height: 180,
          //             child: Center(child: Icon(Icons.image_not_supported)),
          //           ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildBookingDetails(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.modifiedFacility.facilityName,
          style: AppTextStyle.primaryText(),
        ),
        const SizedBox(height: 4),
        Text(
          model.modifiedFacility.address,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          Icons.flag,
          provider.selectedSport ?? "Selected Sport",
          isBold: true,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.calendar_today, _formatDate(provider.selectedDate)),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.access_time, _getFormattedTimeRange(context)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyle.blackText(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd MMM, yyyy (EEE)").format(date);
  }

  // String _getFormattedTimeRange(BuildContext context) {
  //   final start = provider.selectedStartTime;
  //   final endHour = (start.hour + provider.selectedDurationInHours) % 24;
  //   final end = TimeOfDay(hour: endHour, minute: start.minute);

  //   return "${_formatTime(context, start)} - ${_formatTime(context, end)}";
  // }
  String _getFormattedTimeRange(BuildContext context) {
    final start = provider.selectedStartTime;

    // Add minMinutesSport to start time
    final totalStartMinutes = start.hour * 60 + start.minute;
    final endTotalMinutes =
        totalStartMinutes + (provider.minMinutesSport ?? 60);

    final endHour = (endTotalMinutes ~/ 60) % 24;
    final endMinute = endTotalMinutes % 60;

    final end = TimeOfDay(hour: endHour, minute: endMinute);

    return "${_formatTime(context, start)} - ${_formatTime(context, end)}";
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }
}
