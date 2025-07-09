import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_banner.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_header.dart';
import 'package:gkmarts/Widget/network_status_banner.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NetworkStatusBanner(),
              HomeHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HomeBanner(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Book a venue ', style: AppTextStyle.titleText()),

                    InkWell(
                      onTap: () {
                        context.read<BottomNavProvider>().changeIndex(3);
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Join A Game', style: AppTextStyle.titleText()),

                    InkWell(
                      onTap: () {
                        context.read<HomeTabProvider>().getBookVenue(context);
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
              _startPlayingSection(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Your onTap logic
          },
          backgroundColor: AppColors.primaryColor,
          shape: const CircleBorder(),
          child: Container(
            width: 23,
            height: 23,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Vector.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _startPlayingSection() {
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
            Text(
              "START PLAYING",
              style: AppTextStyle.blackText(
                // fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                // Handle Create tap
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
                ),
              ],
            ),

            // RIGHT SIDE: Button
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  // Handle tap
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
                    style: AppTextStyle.primaryText(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
          height: 181,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.joinGameList.length,
            itemBuilder: (context, index) {
              final game = provider.joinGameList[index];

              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white, // Required for shadow to appear
                  borderRadius: BorderRadius.circular(12),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.3), // Soft shadow
                  //     blurRadius: 6,
                  //     offset: Offset(0, 2),
                  //   ),
                  // ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Handle join or view details
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
                                flex: 5,
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
                                                final member = game.members[i];
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

                                    // Host Name below the row
                                    Row(
                                      children: [
                                        Text(
                                          game.hostName,
                                          style: AppTextStyle.blackText(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        hSizeBox(5),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 3,
                                            vertical: 3,
                                          ),

                                          decoration: BoxDecoration(
                                            color: AppColors.grey,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "HOST",
                                            style: AppTextStyle.blackText(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // RIGHT SIDE: Details
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      game.address,
                                      style: AppTextStyle.greytext(
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // 🔘 Join Game button
                          Center(
                            child: SizedBox(
                              width: 146,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle join
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  // padding: const EdgeInsets.symmetric(
                                  //   vertical: 8,
                                  // ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.h),
                                  ),
                                ),
                                child: Text(
                                  "Join Game",
                                  style: AppTextStyle.whiteText(),
                                ),
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
      },
    );
  }
}


class JoinGameShimmer extends StatelessWidget {
  const JoinGameShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 181,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                              Container(height: 10, width: 60, color: Colors.grey),
                              const SizedBox(height: 4),
                              Container(height: 8, width: 40, color: Colors.grey),
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
                              Container(height: 12, width: double.infinity, color: Colors.grey),
                              const SizedBox(height: 6),
                              Container(height: 10, width: 100, color: Colors.grey),
                              const SizedBox(height: 6),
                              Container(height: 10, width: 120, color: Colors.grey),
                              const SizedBox(height: 6),
                              Container(height: 10, width: 80, color: Colors.grey),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "No venues available at the moment.",
              style: AppTextStyle.greytext(),
            ),
          );
        }

        return SizedBox(
          height: 194,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.venueList.length,
            itemBuilder: (context, index) {
              final venue = provider.venueList[index];

              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.05),
                  //     blurRadius: 6,
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return VenueDetailsPage(venueId: venue.venueName);
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with top radius only
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: venue.imageUrl,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Center(child: SizedBox()),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/venue.png",
                                    ),
                                  ),
                                ),
                          ),
                        ),

                        // Details
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Venue name + rating
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      venue.venueName,
                                      style: AppTextStyle.primaryText(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
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

                              // Address + price
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      venue.venueAddress,
                                      style: AppTextStyle.greytext(
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "₹${venue.price}",
                                    style: AppTextStyle.blackText(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
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
      height: 194,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3, // number of shimmer cards
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
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
                        Container(
                          height: 12,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 6),
                        Container(height: 12, width: 60, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
