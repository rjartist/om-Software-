import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gkmarts/Provider/Bookings/booking_list_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_bookings_detail.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "My Bookings", showBackButton: true),
      body: Consumer<MyBookingsProvider>(
        builder: (context, provider, _) {
          print("provider data: ${provider.pastBookings.length}");
          return Column(
            children: [
              Container(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  labelStyle: AppTextStyle.blackText(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primaryColor,
                  tabs: const [
                    Tab(text: "Upcoming"),
                    Tab(text: "Past"),
                    Tab(text: "Cancelled"),
                  ],
                ),
              ),
              Expanded(
                child:
                    provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildBookingList(
                              provider.futureBookings,
                              "Upcoming",
                            ),
                            _buildBookingList(provider.pastBookings, "Past"),
                            _buildBookingList(
                              provider.cancelledBookings,
                              "Cancelled",
                            ),
                          ],
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingList(List bookings, String type) {
    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final slot =
            booking.facilityBookingSlots?[0]; // show first slot if available
        return InkWell(
          onTap: () {
            String bookingType = "";
            if (type == "Upcoming") {
              bookingType = "Upcoming";
            } else if (type == "Past") {
              bookingType = "Past";
            } else {
              bookingType = "Cancelled";
            }
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300),
                child: MyBookingsDetail(booking: booking, type: bookingType),
              ),
            );
          },
          child: Card(
            color: AppColors.white,
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        slot?.facility?.facilityName ?? 'N/A',
                        style: AppTextStyle.blackText(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        type == "Upcoming"
                            ? "assets/images/check_calendar.png"
                            : type == "Past"
                            ? "assets/images/check-mark.png"
                            : "assets/images/circle.png",
                        height: type == "Upcoming" ? 25 : 22,
                        width: type == "Upcoming" ? 25 : 22,
                        color:
                            type == "Upcoming"
                                ? AppColors.accentColor
                                : type == "Past"
                                ? AppColors.successColor
                                : AppColors.primaryColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 15,
                        color: AppColors.accentColor,
                      ),
                      Text(
                        "${slot?.facility?.feedback?.averageRating ?? 0.0} "
                        "(${slot?.facility?.feedback?.totalCount ?? 0} ratings)",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Sports: ",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                      Text(
                        slot?.service?.serviceName ?? "-",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        "Time: ",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                      Text(
                        formatTimeRangeFromStrings(
                          slot?.startTime,
                          slot?.endTime,
                        ),
                        // "${slot?.startTime ?? ''} - ${slot?.endTime ?? ''}",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Date: ",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                      Text(
                        formattedDate(slot?.bookingDate ?? "-"),
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        "Duration: ",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                      Text(
                        calculateDuration(slot?.startTime, slot?.endTime),
                        // "1Hr",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ), // hardcoded
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "₹ ${booking.payment?.collectPayment ?? '0'}",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                      const Spacer(),
                      booking.cancellationStatus == "PENDING" ||
                              booking.cancellationStatus == "SUCCESS" ||
                              booking.cancellationStatus == "REJECT"
                          ? Row(
                            children: [
                              Text(
                                "Cancellation Status: ",
                                style: AppTextStyle.blackText(fontSize: 10),
                              ),
                              Text(
                                "${booking.cancellationStatus ?? '0'}",
                                style: AppTextStyle.blackText(fontSize: 12),
                              ),
                            ],
                          )
                          : Text(
                            "",
                            style: AppTextStyle.blackText(fontSize: 10),
                          ),
                    ],
                  ),
                  if (type == "Past")
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 35,
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
                                _showReviewBottomSheet(
                                  context,
                                  slot?.facility?.facilityName,
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
                                "Rate & Review",
                                style: AppTextStyle.whiteText(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

    return "${outputFormat.format(startTime)} - ${outputFormat.format(endTime)}";
  }

  String calculateDuration(String startTime, String endTime) {
    // Parse times assuming they are in HH:mm:ss format
    final format = DateFormat("HH:mm:ss");

    DateTime start = format.parse(startTime);
    DateTime end = format.parse(endTime);

    // Handle overnight case (e.g., 11 PM to 2 AM)
    if (end.isBefore(start)) {
      end = end.add(Duration(days: 1));
    }

    Duration diff = end.difference(start);

    int hours = diff.inHours;
    int minutes = diff.inMinutes.remainder(60);

    return '$hours hr';
  }

  void _showReviewBottomSheet(BuildContext context, String venueName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Rate & Review",
                style: AppTextStyle.blackText(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                venueName,
                style: AppTextStyle.primaryText(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: 0.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) =>
                        Icon(Icons.star_rounded, color: Colors.amber),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  hintText: 'Write a review',
                  labelStyle: AppTextStyle.blackText(),
                  hintStyle: AppTextStyle.greytext(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    // borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: Size(160, 43),
                        backgroundColor: AppColors.bgContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "CANCEL",
                        style: AppTextStyle.blackText(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.profileSectionButtonColor,
                            AppColors.profileSectionButtonColor2,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(160, 43),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "RATE",
                          style: AppTextStyle.whiteText(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
