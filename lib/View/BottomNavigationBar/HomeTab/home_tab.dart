import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Provider/Phonpay/phon_pay_payment_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_banner.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_header.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/create_game.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/calendar_screen_main.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/play_tab.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/network_status_banner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeTabProvider>().showCoinPopupOnce(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NetworkStatusBanner(),
            HomeHeader(),
            vSizeBox(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HomeBanner(),
            ),
            // phonePePaymentSection(context),

            vSizeBox(8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Book A Venue', style: AppTextStyle.titleText()),

                  InkWell(
                    onTap: () {
                      context.read<BottomNavProvider>().changeIndex(3);
                      // final homeTabProvider = Provider.of<HomeTabProvider>(
                      //   context,
                      //   listen: false,
                      // );

                      // homeTabProvider.getBookVenue(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          'SEE ALL',
                          style: AppTextStyle.primaryText(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BookaVenueSection(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Join A Game', style: AppTextStyle.titleText()),

                  InkWell(
                    onTap: () {
                      CoomingSoonDialogHelper.showComingSoon(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          'SEE ALL',
                          style: AppTextStyle.primaryText(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            JoinGameSection(),
            _startPlayingSection(context),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Your onTap logic
      //   },
      //   backgroundColor: AppColors.primaryColor,
      //   shape: const CircleBorder(),
      //   child: Container(
      //     width: 23,
      //     height: 23,
      //     decoration: const BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage('assets/images/Vector.png'),
      //         fit: BoxFit.contain,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget phonePePaymentSection(BuildContext context) {
    final provider = Provider.of<PhonePePaymentProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: Column(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await provider.initPhonePeSDK();
                    },
                    icon: const Icon(Icons.power),
                    label: const Text("Initialize PhonePe SDK"),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        provider.isInitialized
                            ? () async {
                              await provider.startPayment(
                                amount: 10000,
                                userId: "user123",
                              );
                            }
                            : null,
                    icon: const Icon(Icons.payment),
                    label: const Text("Start Payment ₹100"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            provider.resultMessage,
            style: const TextStyle(fontSize: 16, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(
            provider.transactionStatus,
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

Widget _startPlayingSection(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        // 🔝 Top Row: START PLAYING + CREATE button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("START PLAYING", style: AppTextStyle.titleText()),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    child: CreateGame(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                fixedSize: const Size(98, 20), // Exact size
                padding: EdgeInsets.zero, // Remove extra space
                side: const BorderSide(color: Colors.red),
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact, // ✅ Makes button tighter
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Create",
                  style: AppTextStyle.primaryText(
                    fontSize: 14, // 👈 Shrink font to fit 20 height perfectly
                  ),
                ),
              ),
            ),
          ],
        ),

        const Divider(height: 24),

        // 📦 Flex Row: Left 6 - Right 4
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE: Create Game + No games
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Game",
                  style: AppTextStyle.blackText(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "No games in your calendar",
                  style: AppTextStyle.greytext(fontSize: 13),
                  maxLines: 2,
                ),
              ],
            ),

            // RIGHT SIDE: Button
            Flexible(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        child: CalendarScreenMain(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "View My Calendar",
                      overflow: TextOverflow.ellipsis, // 👈 Optional
                      style: AppTextStyle.primaryText(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class JoinGameSection extends StatelessWidget {
  const JoinGameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabProvider>(
      builder: (context, provider, _) {
        if (provider.isJoinGameLoading) {
          return JoinGameShimmer();
        }

        if (provider.joinGameList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "No games available to join.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.joinGameList.length,
            itemBuilder: (context, index) {
              final game = provider.joinGameList[index];

              return Align(
                alignment: Alignment.center,
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white, // Required for shadow to appear
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        spreadRadius: 0.2,
                        offset: Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Color(0x11000000), // light top
                        blurRadius: 6,
                        spreadRadius: 0.1,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        CoomingSoonDialogHelper.showComingSoon(context);
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔝 Top: Two-part section
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      // 👤 Host + 👥 Members in same Row
                                      Row(
                                        children: [
                                          // Host Avatar
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundImage: NetworkImage(
                                              game.hostPhoto,
                                            ),
                                          ),

                                          // Overlapping Member Avatars (right next to host)
                                          SizedBox(
                                            width:
                                                60, // Adjust based on expected overlap
                                            height: 24,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: List.generate(
                                                game.members.take(3).length,
                                                (i) {
                                                  final member =
                                                      game.members[i];
                                                  return Positioned(
                                                    left:
                                                        i *
                                                        18.0, // Controls overlap
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: CircleAvatar(
                                                        radius: 11,
                                                        backgroundImage:
                                                            NetworkImage(
                                                              member.photo,
                                                            ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 5),
                                      Text(
                                        game.hostName,
                                        style: AppTextStyle.blackText(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),

                                      // Host Name below the row
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.bgContainer,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),

                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 5,
                                            left: 5,
                                            top: 2.5,
                                            bottom: 2.5,
                                          ),
                                          child: Text(
                                            "HOST",
                                            style: AppTextStyle.blackText(
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // RIGHT SIDE: Details
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        game.gameName,
                                        style: AppTextStyle.primaryText(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.group,
                                            size: 14,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${game.members.length + 1} joined",
                                            style: AppTextStyle.blackText(
                                              fontSize: 12.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${game.date} | ${game.time}",
                                        style: AppTextStyle.blackText(
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFF002463),
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color:
                                                  Colors
                                                      .white, // White icon inside blue circle
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              game.address,
                                              style: AppTextStyle.greytext(
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: PlayTab(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 146,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // color: Colors.grey.shade300,
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
                                  child: Text(
                                    "Join Game",
                                    style: AppTextStyle.whiteText(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class JoinGameShimmer extends StatelessWidget {
  const JoinGameShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210, // ✅ Same height wrapper as real card section
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              height: 180, // ✅ Exact height of real card
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000), // ✅ 25% opacity black
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Top row (avatars + details)
                      Row(
                        children: [
                          // Host & members
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 60,
                                      height: 24,
                                      child: Stack(
                                        children: List.generate(
                                          3,
                                          (i) => Positioned(
                                            left: i * 18.0,
                                            child: const CircleAvatar(
                                              radius: 12,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 11,
                                                backgroundColor: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 10,
                                  width: 60,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 8,
                                  width: 40,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Game details
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 12,
                                  width: double.infinity,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 10,
                                  width: 100,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 10,
                                  width: 120,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 10,
                                  width: 80,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(), // ✅ Keeps Join button at bottom
                      // Join Button
                      Center(
                        child: Container(
                          width: 146,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookaVenueSection extends StatelessWidget {
  const BookaVenueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabProvider>(
      builder: (context, provider, _) {
        if (provider.isBookVenueLoading) {
          return const BookVenueShimmer();
        }

        if (provider.venueList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "No venues available at the moment.",
              style: AppTextStyle.greytext(),
            ),
          );
        }

        return SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.venueList.length,
            itemBuilder: (context, index) {
              final venue = provider.venueList[index];

              return Align(
                alignment: Alignment.center,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(
                          0x22000000,
                        ), // softer black with lower opacity
                        blurRadius: 8, // smaller blur = softer edges
                        spreadRadius: 0.2, // minimal spread
                        offset: Offset(0, 3), // gentle vertical offset
                      ),
                      BoxShadow(
                        color: Color(0x11000000), // very light top shadow
                        blurRadius: 6,
                        spreadRadius: 0.1,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => VenueDetailsPage(
                                    facilityId: venue.facilityId,
                                  ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: venue.imageUrl,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (_, __) => Container(
                                            height: 100,
                                            color: Colors.grey[300],
                                          ),
                                      errorWidget:
                                          (_, __, ___) => Container(
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                  vSizeBox(10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          venue.venueName,
                                          style: AppTextStyle.primaryText(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            "${venue.rating}",
                                            style: AppTextStyle.greytext(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "(${venue.totalReviews})",
                                            style: AppTextStyle.greytext(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          venue.venueAddress,
                                          style: AppTextStyle.greytext(
                                            fontSize: 12,
                                            color: AppColors.borderColor,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        "₹${venue.price}",
                                        style: AppTextStyle.blackText(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class BookVenueShimmer extends StatelessWidget {
  const BookVenueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230, // ✅ Matches BookaVenueSection outer height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              height: 200, // ✅ Matches real card height
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000), // ✅ 25% opacity black
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📷 Image placeholder
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 12,
                                width: 50,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 14,
                                width: 40,
                                color: Colors.grey,
                              ),
                            ],
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
      ),
    );
  }
}
