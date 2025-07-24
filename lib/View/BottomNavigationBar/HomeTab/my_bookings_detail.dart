import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Models/MyBookings/my_bookings_detail_model.dart';
import 'package:gkmarts/Provider/Bookings/booking_list_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_bookings.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyBookingsDetail extends StatefulWidget {
  final dynamic booking;
  MyBookingsDetail({super.key, required this.booking});

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
      appBar: GlobalAppBar(title: "My Bookings", showBackButton: true),
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
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(12),
                        //   child: CachedNetworkImage(
                        //     imageUrl:
                        //         booking
                        //             .facilityBookingSlots
                        //             ?.first
                        //             .facility
                        //             ?.facilityImages
                        //             ?.first
                        //             .image,
                        //     fit: BoxFit.cover,
                        //     width: double.infinity,
                        //     placeholder: (context, url) => _buildShimmer(),
                        //     errorWidget:
                        //         (context, url, error) => Image.asset(
                        //           'assets/images/banner1.png',
                        //           fit: BoxFit.cover,
                        //           width: double.infinity,
                        //         ),
                        //   ),
                        // ),
                        // Image.asset(
                        //   'assets/images/venueImage.jpg',
                        //   width: double.infinity,
                        //   height: 120,
                        //   fit: BoxFit.cover,
                        // ),
                        // SizedBox(height: 10),
                        Text(
                          booking
                                  .facilityBookingSlots
                                  ?.first
                                  .facility
                                  ?.facilityName ??
                              '',
                          style: AppTextStyle.blackText(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${booking.facilityBookingSlots?.first.facility?.address!}, ${booking.facilityBookingSlots?.first.facility?.city}, ${booking.facilityBookingSlots?.first.facility?.state}, ${booking.facilityBookingSlots?.first.facility?.zipcode}",
                          style: AppTextStyle.blackText(
                            fontSize: 12,
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
                          children: [
                            Text(
                              "Payment Date: ",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Payment Time: ",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Payment Method: ",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: Colors.black87,
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
                              ),
                            ),
                          ],
                        ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Paid: ",
                          style: AppTextStyle.blackText(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.currency_rupee_sharp, size: 14),
                        Text(
                          booking.payment.collectPayment.toString(),
                          style: AppTextStyle.blackText(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
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
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Cancellation",
                                  style: AppTextStyle.blackText(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "To cancel a booking, go to the 'My Bookings' section, find your upcoming booking, and submit a cancellation request.",
                                style: AppTextStyle.blackText(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 15,
                                  left: 15,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppColors.profileSectionButtonColor,
                                            AppColors
                                                .profileSectionButtonColor2,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type:
                                                  PageTransitionType
                                                      .rightToLeft,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: const MyBookings(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "GO TO MY BOOKINGS",
                                          style: AppTextStyle.whiteText(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
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
              ),
            ],
          );
        },
      ),
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
    return DateFormat("d MMM, E").format(date); // Format as "15 Mar, Fri"
  }

  String formatTimeRangeFromStrings(String start, String end) {
    final timeFormat = DateFormat('HH:mm');
    final outputFormat = DateFormat('hh:mm a');

    DateTime startTime = timeFormat.parse(start); // "06:00"
    DateTime endTime = timeFormat.parse(end); // "07:00"

    return "${outputFormat.format(startTime)} to ${outputFormat.format(endTime)}";
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
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
