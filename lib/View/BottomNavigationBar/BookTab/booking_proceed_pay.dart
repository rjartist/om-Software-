import 'package:flutter/material.dart';
import 'package:gkmarts/Models/HomeTab_Models/Venue_detail_model.dart';
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
                        fontWeight: FontWeight.w500,
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
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    "Offer Discount",
                    "- ₹${provider.offerDiscount}",
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    "Convenience Fee",
                    "₹${provider.convenienceFee}",
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CongratulationBooking(model: model),
              ),
            );
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
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

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
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
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // Widget buildBookingInfoCard(BuildContext context, BookTabProvider provider) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(0),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     padding: const EdgeInsets.all(16),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildVenueImage(),
  //         const SizedBox(width: 16),
  //         _buildBookingDetails(provider),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildVenueImage() {
  //   return Expanded(
  //     flex: 3,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(10),
  //       child: Image.network(
  //         model.images.first,
  //         height: 120,
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildBookingDetails(BookTabProvider provider) {
  //   return Expanded(
  //     flex: 7,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           model.venueName,
  //           style: AppTextStyle.primaryText(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           model.venueAddress,
  //           style: const TextStyle(fontSize: 14, color: Colors.grey),
  //         ),
  //         const SizedBox(height: 12),
  //         _buildInfoRow(
  //           Icons.sports,
  //           provider.selectedSport ?? "Selected Sport",
  //         ),
  //         const SizedBox(height: 8),
  //         _buildInfoRow(
  //           Icons.calendar_today,
  //           _formatDate(provider.selectedDate),
  //         ),
  //         const SizedBox(height: 8),
  //         _buildInfoRow(Icons.access_time, _getFormattedTimeRange(provider)),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildInfoRow(IconData icon, String text) {
  //   return Row(
  //     children: [
  //       Icon(icon, size: 16, color: Colors.black54),
  //       const SizedBox(width: 6),
  //       Text(text, style: const TextStyle(fontSize: 14)),
  //     ],
  //   );
  // }

  // String _formatDate(DateTime date) {
  //   final formatter = DateFormat("dd MMM, yyyy (EEE)");
  //   return formatter.format(date);
  // }

  // String _getFormattedTimeRange(BookTabProvider provider) {
  //   final start = provider.selectedStartTime;
  //   final endHour = (start.hour + provider.selectedDurationInHours) % 24;
  //   final end = TimeOfDay(hour: endHour, minute: start.minute);

  //   return "${_formatTime(start)} - ${_formatTime(end)}";
  // }

  // String _formatTime(TimeOfDay time) {
  //   final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  //   final suffix = time.period == DayPeriod.am ? "AM" : "PM";
  //   final minutes = time.minute.toString().padLeft(2, '0');
  //   return "$hour:$minutes $suffix";
  // }
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
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVenueImage(),
          const SizedBox(width: 16),
          _buildBookingDetails(context),
        ],
      ),
    );
  }

  Widget _buildVenueImage() {
    return Expanded(
      flex: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          model.images?.first ?? '',
          height: 120,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
        ),
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            model.venueName ?? "Venue Name",
            style: AppTextStyle.primaryText(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            model.venueAddress ?? "Venue Address",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.sports,
            provider.selectedSport ?? "Selected Sport",
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.calendar_today,
            _formatDate(provider.selectedDate),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.access_time, _getFormattedTimeRange(context)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd MMM, yyyy (EEE)").format(date);
  }

  String _getFormattedTimeRange(BuildContext context) {
    final start = provider.selectedStartTime;
    final endHour = (start.hour + provider.selectedDurationInHours) % 24;
    final end = TimeOfDay(hour: endHour, minute: start.minute);

    return "${_formatTime(context, start)} - ${_formatTime(context, end)}";
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    return time.format(
      context,
    ); // Automatically formats to 12hr/24hr based on locale
  }
}
