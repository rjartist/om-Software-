import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Bookings/booking_list_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/my_bookings_detail.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
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
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 300),
                child: MyBookingsDetail(booking: booking),
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
                        "${slot?.startTime ?? ''} - ${slot?.endTime ?? ''}",
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
                        slot?.bookingDate ?? "-",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        "Duration: ",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                      Text(
                        "1Hr",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ), // hardcoded
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "INR: ",
                        style: AppTextStyle.blackText(fontSize: 10),
                      ),
                      Text(
                        "${booking.payment?.collectPayment ?? '0'}",
                        style: AppTextStyle.blackText(fontSize: 12),
                      ),
                    ],
                  ),
                  if (type == "Past")
                    Row(
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
                            onPressed: () {},
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
