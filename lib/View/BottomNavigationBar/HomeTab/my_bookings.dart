import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gkmarts/Models/MyBookings/MyBookingsModel.dart';
import 'package:gkmarts/Provider/Bookings/booking_list_provider.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_bookings_detail.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
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
                            // _buildBookingList(
                            //   provider.futureBookings,
                            //   "Upcoming",
                            // ),
                            // _buildBookingList(provider.pastBookings, "Past"),
                            // _buildBookingList(
                            //   provider.cancelledBookings,
                            //   "Cancelled",
                            // ),
                            UpcomingBookingList(
                              futureBookings: provider.futureBookings,
                            ),
                            PastBookingList(
                              pastBookings: provider.pastBookings,
                            ),
                            CancelledBookingList(
                              cancelledBookings: provider.cancelledBookings,
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

  // Widget _buildBookingList(List bookings, String type) {
  //   if (bookings.isEmpty) {
  //     return const Center(child: Text("No bookings found"));
  //   }

  //   return ListView.builder(
  //     padding: const EdgeInsets.all(12),
  //     itemCount: bookings.length,
  //     itemBuilder: (context, index) {
  //       final booking = bookings[index];
  //       final slot =
  //           booking.facilityBookingSlots?[0]; // show first slot if available
  //       return InkWell(
  //         onTap: () {
  //           String bookingType = "";
  //           if (type == "Upcoming") {
  //             bookingType = "Upcoming";
  //           } else if (type == "Past") {
  //             bookingType = "Past";
  //           } else {
  //             bookingType = "Cancelled";
  //           }
  //           Navigator.push(
  //             context,
  //             PageTransition(
  //               type: PageTransitionType.rightToLeft,
  //               duration: const Duration(milliseconds: 300),
  //               child: MyBookingsDetail(booking: booking, type: bookingType),
  //             ),
  //           );
  //         },
  //         child: Card(
  //           color: AppColors.white,
  //           elevation: 3,
  //           margin: const EdgeInsets.symmetric(vertical: 8),
  //           child: Padding(
  //             padding: const EdgeInsets.all(15),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       slot?.facility?.facilityName ?? 'N/A',
  //                       style: AppTextStyle.blackText(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     Image.asset(
  //                       type == "Upcoming"
  //                           ? "assets/images/check_calendar.png"
  //                           : type == "Past"
  //                           ? "assets/images/check-mark.png"
  //                           : "assets/images/circle.png",
  //                       height: type == "Upcoming" ? 25 : 22,
  //                       width: type == "Upcoming" ? 25 : 22,
  //                       color:
  //                           type == "Upcoming"
  //                               ? AppColors.accentColor
  //                               : type == "Past"
  //                               ? AppColors.successColor
  //                               : AppColors.primaryColor,
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     const Icon(
  //                       Icons.star,
  //                       size: 15,
  //                       color: AppColors.accentColor,
  //                     ),
  //                     Text(
  //                       "${slot?.facility?.feedback?.averageRating ?? 0.0} "
  //                       "(${slot?.facility?.feedback?.totalCount ?? 0} ratings)",
  //                       style: AppTextStyle.blackText(fontSize: 10),
  //                     ),
  //                   ],
  //                 ),
  //                 const Divider(),
  //                 const SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "Sports: ",
  //                       style: AppTextStyle.blackText(fontSize: 10),
  //                     ),
  //                     Text(
  //                       slot?.service?.serviceName ?? "-",
  //                       style: AppTextStyle.blackText(fontSize: 12),
  //                     ),
  //                     const Spacer(),
  //                     Text(
  //                       "Time: ",
  //                       style: AppTextStyle.blackText(fontSize: 10),
  //                     ),
  //                     Text(
  //                       formatTimeRangeFromStrings(
  //                         slot?.startTime,
  //                         slot?.endTime,
  //                       ),
  //                       // "${slot?.startTime ?? ''} - ${slot?.endTime ?? ''}",
  //                       style: AppTextStyle.blackText(fontSize: 12),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "Date: ",
  //                       style: AppTextStyle.blackText(fontSize: 10),
  //                     ),
  //                     Text(
  //                       formattedDate(slot?.bookingDate ?? "-"),
  //                       style: AppTextStyle.blackText(fontSize: 12),
  //                     ),
  //                     const Spacer(),
  //                     Text(
  //                       "Duration: ",
  //                       style: AppTextStyle.blackText(fontSize: 10),
  //                     ),
  //                     Text(
  //                       calculateDuration(slot?.startTime, slot?.endTime),
  //                       // "1Hr",
  //                       style: AppTextStyle.blackText(fontSize: 12),
  //                     ), // hardcoded
  //                   ],
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Text(
  //                       "₹ ${booking.payment?.collectPayment ?? '0'}",
  //                       style: AppTextStyle.blackText(fontSize: 12),
  //                     ),
  //                     const Spacer(),
  //                     booking.cancellationStatus == "PENDING" ||
  //                             booking.cancellationStatus == "SUCCESS" ||
  //                             booking.cancellationStatus == "REJECT"
  //                         ? Row(
  //                           children: [
  //                             Text(
  //                               "Cancellation Status: ",
  //                               style: AppTextStyle.blackText(fontSize: 10),
  //                             ),
  //                             Text(
  //                               "${booking.cancellationStatus ?? '0'}",
  //                               style: AppTextStyle.blackText(fontSize: 12),
  //                             ),
  //                           ],
  //                         )
  //                         : Text(
  //                           "",
  //                           style: AppTextStyle.blackText(fontSize: 10),
  //                         ),
  //                   ],
  //                 ),
  //                 if (type == "Past")
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 10),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         Container(
  //                           height: 35,
  //                           decoration: BoxDecoration(
  //                             gradient: LinearGradient(
  //                               begin: Alignment.topCenter,
  //                               end: Alignment.bottomCenter,
  //                               colors: [
  //                                 AppColors.profileSectionButtonColor,
  //                                 AppColors.profileSectionButtonColor2,
  //                               ],
  //                             ),
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: ElevatedButton(
  //                             onPressed: () {
  //                               _showReviewBottomSheet(
  //                                 context,
  //                                 slot?.facility?.facilityName,
  //                               );
  //                             },
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: Colors.transparent,
  //                               shadowColor: Colors.transparent,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                             ),
  //                             child: Text(
  //                               "Rate & Review",
  //                               style: AppTextStyle.whiteText(),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showReviewBottomSheet(BuildContext context, String venueName) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     backgroundColor: Colors.white,
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           left: 16,
  //           right: 16,
  //           top: 16,
  //           // 👇 This ensures padding at the bottom equal to keyboard height
  //           bottom: MediaQuery.of(context).viewInsets.bottom + 16,
  //         ),
  //         child: SingleChildScrollView(
  //           // 👇 Ensures scrollable content when keyboard is open
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Center(
  //                 child: Text(
  //                   "Rate & Review",
  //                   style: AppTextStyle.blackText(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Center(
  //                 child: Text(
  //                   venueName,
  //                   style: AppTextStyle.primaryText(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Center(
  //                 child: RatingBar.builder(
  //                   initialRating: 0.0,
  //                   minRating: 1,
  //                   direction: Axis.horizontal,
  //                   allowHalfRating: false,
  //                   itemCount: 5,
  //                   itemSize: 40,
  //                   itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                   itemBuilder:
  //                       (context, _) =>
  //                           const Icon(Icons.star_rounded, color: Colors.amber),
  //                   onRatingUpdate: (rating) {
  //                     print(rating);
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               TextField(
  //                 maxLines: 3,
  //                 decoration: InputDecoration(
  //                   filled: true,
  //                   fillColor: AppColors.white,
  //                   hintText: 'Write a review',
  //                   labelStyle: AppTextStyle.blackText(),
  //                   hintStyle: AppTextStyle.greytext(),
  //                   contentPadding: const EdgeInsets.symmetric(
  //                     horizontal: 16,
  //                     vertical: 14,
  //                   ),
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       elevation: 0,
  //                       fixedSize: const Size(160, 43),
  //                       backgroundColor: AppColors.bgContainer,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                     ),
  //                     child: Text(
  //                       "CANCEL",
  //                       style: AppTextStyle.blackText(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                   const Spacer(),
  //                   Container(
  //                     height: 43,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       gradient: LinearGradient(
  //                         begin: Alignment.topCenter,
  //                         end: Alignment.bottomCenter,
  //                         colors: [
  //                           AppColors.profileSectionButtonColor,
  //                           AppColors.profileSectionButtonColor2,
  //                         ],
  //                       ),
  //                     ),
  //                     child: ElevatedButton(
  //                       onPressed: () {},
  //                       style: ElevatedButton.styleFrom(
  //                         fixedSize: const Size(160, 43),
  //                         backgroundColor: Colors.transparent,
  //                         shadowColor: Colors.transparent,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       child: Text(
  //                         "RATE",
  //                         style: AppTextStyle.whiteText(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

String formattedDate(String dateString) {
  DateTime date = DateTime.parse(dateString); // Parse the String to DateTime
  return DateFormat("d MMM, yyyy").format(date); // Format as "15 Mar, Fri"
}

String formatTimeRangeFromStrings(String? start, String? end) {
  if (start == null || end == null) return "-";

  try {
    final timeFormat = DateFormat('HH:mm');
    final outputFormat = DateFormat('hh:mm a');

    DateTime startTime = timeFormat.parse(start);
    DateTime endTime = timeFormat.parse(end);

    return "${outputFormat.format(startTime)} - ${outputFormat.format(endTime)}";
  } catch (e) {
    return "-";
  }
}

String calculateDuration(String? startTime, String? endTime) {
  if (startTime == null || endTime == null) return "-";

  try {
    final format = DateFormat("HH:mm:ss");

    DateTime start = format.parse(startTime);
    DateTime end = format.parse(endTime);

    // Handle overnight time slot (e.g. 10 PM - 1 AM)
    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    Duration diff = end.difference(start);

    int hours = diff.inHours;
    int minutes = diff.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return "$hours hr $minutes min";
    } else if (hours > 0) {
      return "$hours hr";
    } else {
      return "$minutes min";
    }
  } catch (e) {
    return "-";
  }
}

class UpcomingBookingList extends StatelessWidget {
  final List<FutureBookings> futureBookings;

  const UpcomingBookingList({super.key, required this.futureBookings});

  @override
  Widget build(BuildContext context) {
    if (futureBookings.isEmpty) {
      return const NoDataWidget(
        assetName: 'assets/images/No data.svg',
        // width: 180,
        height: 250,
        message: "No upcoming Bookings",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: futureBookings.length,
      itemBuilder: (context, index) {
        final booking = futureBookings[index];
        final slot =
            booking.facilityBookingSlots?.isNotEmpty == true
                ? booking.facilityBookingSlots!.first
                : null;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300),
                child: MyBookingsDetail(booking: booking, type: "Upcoming"),
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
                        "assets/images/check_calendar.png",
                        height: 25,
                        width: 25,
                        color: AppColors.accentColor,
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
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
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
                      if (booking.cancellationStatus == "PENDING" ||
                          booking.cancellationStatus == "SUCCESS" ||
                          booking.cancellationStatus == "REJECT")
                        Row(
                          children: [
                            Text(
                              "Cancellation Status: ",
                              style: AppTextStyle.blackText(fontSize: 10),
                            ),
                            Text(
                              "${booking.cancellationStatus}",
                              style: AppTextStyle.blackText(fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PastBookingList extends StatelessWidget {
  final List<PastBookings> pastBookings;

  const PastBookingList({super.key, required this.pastBookings});

  @override
  Widget build(BuildContext context) {
    if (pastBookings.isEmpty) {
      return const NoDataWidget(
        assetName: 'assets/images/No data.svg',
        // width: 180,
        height: 250,
        message: "No Past Bookings",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: pastBookings.length,
      itemBuilder: (context, index) {
        final booking = pastBookings[index];
        final slot =
            booking.facilityBookingSlots?.isNotEmpty == true
                ? booking.facilityBookingSlots!.first
                : null;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300),
                child: MyBookingsDetail(booking: booking, type: "Past"),
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
                  // Header row
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
                        "assets/images/check-mark.png",
                        height: 22,
                        width: 22,
                        color: AppColors.successColor,
                      ),
                    ],
                  ),

                  // Rating row
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 15,
                        color: AppColors.accentColor,
                      ),
                      Text(
                        "${slot?.facility?.feedback?.averageRating ?? 0.0} (${slot?.facility?.feedback?.totalCount ?? 0} ratings)",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                    ],
                  ),

                  const Divider(),
                  const SizedBox(height: 10),

                  // Sports & Time row
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
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Date & Duration row
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
                        calculateDuration(
                          slot?.startTime ?? '',
                          slot?.endTime ?? '',
                        ),
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Amount & Cancellation Status
                  Row(
                    children: [
                      Text(
                        "₹ ${booking.payment?.collectPayment ?? '0'}",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                      const Spacer(),
                      if (booking.cancellationStatus == "PENDING" ||
                          booking.cancellationStatus == "SUCCESS" ||
                          booking.cancellationStatus == "REJECT") ...[
                        Text(
                          "Cancellation Status: ",
                          style: AppTextStyle.blackText(fontSize: 10),
                        ),
                        Text(
                          "${booking.cancellationStatus}",
                          style: AppTextStyle.blackText(fontSize: 12),
                        ),
                      ],
                    ],
                  ),

                  // Rate & Review Button
                  if (booking.userSubmittedFeedback == false)
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
                                  venueName: slot?.facility?.facilityName,
                                  bookingId: booking.bookingId ?? 0,
                                  venueId: slot?.facility?.facilityId ?? 0,
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
                    )
                  else
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
                              onPressed: () async {
                                await context
                                    .read<BookTabProvider>()
                                    .getReviews(
                                      venueId:
                                          booking
                                              .facilityBookingSlots
                                              ?.first
                                              .facility
                                              ?.facilityId ??
                                          0,
                                    );
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (_) => ViewVenueReviewsBottomSheet(),
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
                                "View All Review",
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

  void _showReviewBottomSheet(
    BuildContext context, {
    String? venueName,
    required int bookingId,
    required int venueId, //facilityId
  }) {
    double selectedRating = 0.0;
    TextEditingController reviewController = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            // 👇 This ensures padding at the bottom equal to keyboard height
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            // 👇 Ensures scrollable content when keyboard is open
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Rate & Review",
                    style: AppTextStyle.blackText(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    venueName ?? "",
                    style: AppTextStyle.primaryText(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: RatingBar.builder(
                    initialRating: 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star_rounded, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      selectedRating = rating;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 3,
                  controller: reviewController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.borderColor.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    hintText: 'Write a review',
                    labelStyle: AppTextStyle.blackText(),
                    hintStyle: AppTextStyle.greytext(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: const Size(160, 43),
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
                    const Spacer(),
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
                        onPressed: () async {
                          if (selectedRating == 0.0 ||
                              reviewController.text.isEmpty) {
                            GlobalSnackbar.error(
                              context,
                              "Please provide rating and review",
                            );

                            return;
                          }

                          final bookTabProvider = Provider.of<BookTabProvider>(
                            context,
                            listen: false,
                          );

                          await bookTabProvider.rateVenueProvider(
                            venueId: venueId,
                            bookingId: bookingId,
                            rating: selectedRating.toInt(),
                            feedback: reviewController.text.trim(),
                          );
               
                          Navigator.pop(context);
                        },

                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(160, 43),
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
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CancelledBookingList extends StatelessWidget {
  final List<CancelledBookings> cancelledBookings;

  const CancelledBookingList({super.key, required this.cancelledBookings});

  @override
  Widget build(BuildContext context) {
    if (cancelledBookings.isEmpty) {
      return const NoDataWidget(
        assetName: 'assets/images/No data.svg',
        // width: 180,
        height: 250,
        message: "No Cancelled Bookings",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: cancelledBookings.length,
      itemBuilder: (context, index) {
        final booking = cancelledBookings[index];
        final slot =
            booking.facilityBookingSlots?.isNotEmpty == true
                ? booking.facilityBookingSlots?.first
                : null;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300),
                child: MyBookingsDetail(booking: booking, type: "Cancelled"),
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
                  // Title Row
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
                        "assets/images/circle.png",
                        height: 22,
                        width: 22,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),

                  // Rating Row
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

                  // Sport & Time
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
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Date & Duration
                  Row(
                    children: [
                      Text(
                        "Date: ",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                      Text(
                        formattedDate(
                          slot?.bookingDate ??
                              booking.startDate ??
                              DateTime.now().toIso8601String(),
                        ),
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),

                      const Spacer(),
                      Text(
                        "Duration: ",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                      Text(
                        calculateDuration(slot?.startTime, slot?.endTime),
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Amount & Cancellation status
                  Row(
                    children: [
                      Text(
                        "₹ ${booking.payment?.collectPayment ?? '0'}",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                      const Spacer(),
                      if (booking.cancellationStatus != null)
                        Row(
                          children: [
                            Text(
                              "Cancellation Status: ",
                              style: AppTextStyle.blackText(fontSize: 10),
                            ),
                            Text(
                              "${booking.cancellationStatus}",
                              style: AppTextStyle.blackText(fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
