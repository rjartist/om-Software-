import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Models/MyBookings/MyBookingsModel.dart';
import 'package:gkmarts/Models/MyBookings/my_bookings_detail_model.dart';
import 'package:gkmarts/Provider/Bookings/booking_list_provider.dart';
import 'package:gkmarts/Provider/Bookings/cancel_booking_provider.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle, vSizeBox;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_bookings.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBookingsDetail extends StatefulWidget {
  final dynamic booking;
  final String type;
  MyBookingsDetail({super.key, required this.booking, required this.type});

  @override
  State<MyBookingsDetail> createState() => _MyBookingsDetailState();
}

class _MyBookingsDetailState extends State<MyBookingsDetail> {
  @override
  void initState() {
    super.initState();

    // Fetch API data on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyBookingsProvider>(
        context,
        listen: false,
      ).fetchBookings(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(
        title:
            widget.type == "Upcoming"
                ? "Confirmed Bookings"
                : widget.type == "Past"
                ? "Past Bookings"
                : "Cancelled Bookings",
        showBackButton: true,
      ),
      body: Consumer<MyBookingsProvider>(
        builder: (context, provider, _) {
          final booking = widget.booking;
          final slot = booking.facilityBookingSlots?.first;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                  bottom: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking
                                  .facilityBookingSlots
                                  ?.first
                                  .facility
                                  ?.facilityName ??
                              '',
                          style: AppTextStyle.primaryText(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${booking.facilityBookingSlots?.first.facility?.address!}, ${booking.facilityBookingSlots?.first.facility?.city}, ${booking.facilityBookingSlots?.first.facility?.state}, ${booking.facilityBookingSlots?.first.facility?.zipcode}",
                          style: AppTextStyle.greytext(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5),
                        _buildIconWithTextRow(
                          "assets/images/badmintonIcon.png",
                          booking
                              .facilityBookingSlots
                              ?.first
                              .service
                              ?.serviceName,
                        ),
                        SizedBox(height: 5),

                        _buildIconWithTextRow(
                          "assets/images/calendarLinesIcon.png",
                          formatDate(
                            booking.facilityBookingSlots?.first.bookingDate,
                          ),
                        ),
                        SizedBox(height: 5),
                        _buildIconWithTextRow(
                          "assets/images/eventIcon.png",
                          formatTimeRangeFromStrings(
                            booking.facilityBookingSlots?.first.startTime,
                            booking.facilityBookingSlots?.first.endTime,
                          ),
                        ),
                        SizedBox(height: 5),
                        // _buildIconWithTextRow(
                        //   "assets/images/rupeesIcon.png",
                        //   booking.payment.collectPayment.toString(),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),

                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Date: ",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              formattedDate(
                                booking.payment.paymentDate.toString(),
                              ),
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Time: ",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              formatTimeStrings(
                                booking.payment.paymentTime.toString(),
                              ),
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Method: ",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              booking.payment.paymentMethod.toString(),
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Booking ID: ",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              booking.facilityBookingSlots?.first.bookingId
                                      .toString() ??
                                  "0",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.type != "Cancelled" && booking.payment != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: PaymentSummaryFromBooking(
                    payment: booking.payment!,
                    courtFee: booking.totalAmount ?? '0.00',
                    convenienceFee: booking.convenienceFees ?? '0.00',
                  ),
                ),
              if (widget.type == "Cancelled")
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 20,
                  ),

                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Paid: ",
                            style: AppTextStyle.blackText(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "₹ ${booking.payment.collectPayment.toString()}",
                            style: AppTextStyle.blackText(
                              fontSize: 14,
                              color: AppColors.successColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (widget.type == "Upcoming") vSizeBox(20),
              widget.type == "Upcoming"
                  ? Container(
                    height: 45,
                    width: 190,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.profileSectionButtonColor,
                          AppColors.profileSectionButtonColor2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _showCancellationBottomSheet(context, booking);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      child: Text(
                        "Cancellation",
                        style: AppTextStyle.whiteText(
                          fontWeight: FontWeight.w500,        
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                  : SizedBox(),
            ],
          );
        },
      ),
    );
  }

  void _showCancellationBottomSheet(
    BuildContext context,
    dynamic cancellationItem,
  ) {
    String? selectedReason;

    final List<String> reasons = [
      "Change of plans",
      "Found a better option",
      "Incorrect booking details",
      "Other",
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text("Cancellation Request", style: AppTextStyle.titleText()),
                const SizedBox(height: 16),

                // Venue Info
                _infoRow(
                  Icons.location_on_outlined,
                  cancellationItem
                      .facilityBookingSlots
                      ?.first
                      .facility
                      ?.facilityName!,
                ),
                const SizedBox(height: 8),
                _infoRow(
                  Icons.calendar_today_outlined,
                  formatDate(
                    widget.booking.facilityBookingSlots?.first.bookingDate,
                  ),
                ),
                const SizedBox(height: 20),

                // Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reason for Cancellation",
                    style: AppTextStyle.blackText(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),

                // Dropdown
                DropdownButtonFormField<String>(
                  value: selectedReason,
                  hint: Text("Select reason", style: AppTextStyle.greytext()),
                  items:
                      reasons.map((reason) {
                        return DropdownMenuItem<String>(
                          value: reason,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.fiber_manual_record,
                                size: 6,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                reason,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.blackText(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                      context
                          .read<CancelBookingProvider>()
                          .setBookingIdAndReason(
                            cancellationItem?.bookingId,
                            selectedReason!,
                          );
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: GlobalCancelButton(
                        borderColor: AppColors.borderColor,
                        textColor: AppColors.black,
                        backgroundColor: Colors.grey.shade100,
                        text: "Cancel",
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlobalPrimaryButton(
                        text: "Submit Request",
                        onTap: () {
                          if (selectedReason == null) {
                            GlobalSnackbar.error(
                              context,
                              "Please select a reason.",
                            );
                          } else {
                            final reason = selectedReason;
                            Navigator.pop(context);

                            context.read<CancelBookingProvider>().cancelBooking(
                              context,
                              cancellationItem?.bookingId,
                              selectedReason!,
                            );
                            showDialog(
                              context: navigatorKey.currentContext!,
                              barrierDismissible: false,
                              builder:
                                  (_) => CancellationSuccessDialog(
                                    bookingId: cancellationItem?.bookingId,
                                    venueName:
                                        cancellationItem
                                            .facilityBookingSlots
                                            ?.first
                                            .facility
                                            ?.facilityName!,
                                    reason: reason!,
                                  ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Bottom note
                Text(
                  "Cancellations are subject to facility policies.\nCharges may apply.",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.greytext(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString); // Parse the String to DateTime
    return DateFormat("d MMM yyyy, E").format(date); // Format as "15 Mar, Fri"
  }

  String formattedDate(String dateString) {
    DateTime date = DateTime.parse(dateString); // Parse the String to DateTime
    return DateFormat("d MMM, yyyy").format(date); // Format as "15 Mar, Fri"
  }

  String formatTimeRangeFromStrings(String start, String end) {
    final timeFormat = DateFormat('HH:mm');
    final outputFormat = DateFormat('hh:mm a');

    DateTime startTime = timeFormat.parse(start); // "06:00"
    DateTime endTime = timeFormat.parse(end); // "07:00"

    return "${outputFormat.format(startTime)} to ${outputFormat.format(endTime)}";
  }

  String formatTimeStrings(String time) {
    final timeFormat = DateFormat('HH:mm');
    final outputFormat = DateFormat('hh:mm a');

    DateTime startTime = timeFormat.parse(time); // "07:00"

    return outputFormat.format(startTime);
  }

  Widget _buildIconWithTextRow(String image, String text) {
    return Row(
      children: [
        Image.asset(
          image.toString(),
          height: 18,
          width: 18,
          color: AppColors.black,
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: AppTextStyle.blackText(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

Widget _infoRow(IconData icon, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: Colors.grey[600]),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: AppTextStyle.blackText(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

class CancellationSuccessDialog extends StatelessWidget {
  final int bookingId;
  final String venueName;
  final String reason;

  const CancellationSuccessDialog({
    super.key,
    required this.bookingId,
    required this.venueName,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 60, color: Colors.green),
          const SizedBox(height: 12),
          Text(
            "Cancellation Request Sent",
            style: AppTextStyle.blackText(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Booking ID: $bookingId",
            style: AppTextStyle.blackText(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "Venue: $venueName",
            style: AppTextStyle.blackText(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "Reason: $reason",
            style: AppTextStyle.blackText(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Your request has been sent.\nWe’ll notify you shortly.\nFor help, call CX support.",
            textAlign: TextAlign.center,
            style: AppTextStyle.gradientText(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GlobalPrimaryButton(
                  text: "Back to Home",
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    context.read<BookTabProvider>().clearBookingData();
                    context.read<BottomNavProvider>().changeIndex(0);
                  },
                  height: 42,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlobalCancelButton(
                  borderColor: AppColors.borderColor,
                  textColor: AppColors.black,
                  backgroundColor: Colors.grey.shade100,
                  text: "Call Now",
                  onTap: () async {
                    final Uri phoneUri = Uri(
                      scheme: 'tel',
                      path: '18001234567',
                    );
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      GlobalSnackbar.error(context, "Could not launch dialer.");
                    }
                  },
                  height: 42,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentSummaryFromBooking extends StatefulWidget {
  final Payment payment;
  final String courtFee; // From booking.totalAmount
  final String convenienceFee; // From booking.convenienceFees

  const PaymentSummaryFromBooking({
    super.key,
    required this.payment,
    required this.courtFee,
    required this.convenienceFee,
  });

  @override
  State<PaymentSummaryFromBooking> createState() =>
      _PaymentSummaryFromBookingState();
}

class _PaymentSummaryFromBookingState extends State<PaymentSummaryFromBooking> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.payment;

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
          // Title + Toggle
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

          if (isExpanded) ...[
            _buildRow("Court Fee", "₹${widget.courtFee}"),
            _buildRow("Coupon Discount", "- ₹${p.couponDiscount ?? '0.00'}"),
            _buildRow("Coin Redemption", "- ₹${p.coinDiscount ?? '0.00'}"),
            const Divider(height: 16),
            _buildRow("Sub Total", "₹${_calculateSubTotal()}"),
            _buildRow("Convenience Fee", "₹${widget.convenienceFee}"),
            _buildRow("Platform Fee (2%)", "₹${p.platformFees ?? '0.00'}"),
            _buildRow("GST (18%)", "₹${p.gst ?? '0.00'}"),
            const Divider(height: 16),
          ],

          _buildRow(
            "Total Paid",
            "₹${p.collectPayment ?? '0.00'}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  String _calculateSubTotal() {
    final fee = double.tryParse(widget.courtFee) ?? 0.0;
    final coupon = double.tryParse(widget.payment.couponDiscount ?? "0") ?? 0.0;
    final coin = double.tryParse(widget.payment.coinDiscount ?? "0") ?? 0.0;
    final subTotal = fee - coupon - coin;
    return subTotal.toStringAsFixed(2);
  }

  Widget _buildRow(String title, String value, {bool isTotal = false}) {
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
