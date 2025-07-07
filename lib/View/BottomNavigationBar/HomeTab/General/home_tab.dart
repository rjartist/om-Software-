import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/General/home_header.dart';
import 'package:gkmarts/Widget/network_status_banner.dart';
import 'package:provider/provider.dart';

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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Book a venue ', style: AppTextStyle.titleText()),

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
            ],
          ),
        ),
      ),
    );
  }
}

class JoinGameSection extends StatelessWidget {
  const JoinGameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabProvider>(
      builder: (context, provider, _) {
        if (provider.isJoinGameLoading) {
          return const SizedBox(
            height: 194,
            child: Center(child: CircularProgressIndicator()),
          );
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
          height: 194,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.joinGameList.length,
            itemBuilder: (context, index) {
              final game = provider.joinGameList[index];

              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.white,
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

                                    const SizedBox(height: 4),

                                    // Host Name below the row
                                    Text(
                                      game.hostName,
                                      style: AppTextStyle.greytext(
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // LEFT SIDE: Host + Members
                              // Expanded(
                              //   flex: 4,
                              //   child: Column(
                              //     children: [

                              //       Row(
                              //         children: [
                              //           // 👤 Host Avatar
                              //           CircleAvatar(
                              //             radius: 24,
                              //             backgroundImage: NetworkImage(
                              //               game.hostPhoto,
                              //             ),
                              //           ),

                              //           SizedBox(
                              //             width:
                              //                 60, // adjust width depending on max number of overlaps
                              //             height: 24,
                              //             child: Stack(
                              //               clipBehavior: Clip.none,
                              //               children: List.generate(
                              //                 game.members.take(3).length,
                              //                 (i) {
                              //                   final member = game.members[i];
                              //                   return Positioned(
                              //                     left:
                              //                         i *
                              //                         18.0, // overlap control
                              //                     child: CircleAvatar(
                              //                       radius: 12,
                              //                       backgroundColor:
                              //                           Colors.white,
                              //                       child: CircleAvatar(
                              //                         radius: 11,
                              //                         backgroundImage:
                              //                             NetworkImage(
                              //                               member.photo,
                              //                             ),
                              //                       ),
                              //                     ),
                              //                   );
                              //                 },
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),

                              //       const SizedBox(height: 4),
                              //       Text(
                              //         game.hostName,
                              //         style: AppTextStyle.greytext(
                              //           fontSize: 11,
                              //         ),
                              //         overflow: TextOverflow.ellipsis,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              const SizedBox(width: 12),

                              // RIGHT SIDE: Details
                              Expanded(
                                flex: 6,
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
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${game.members.length + 1} joined",
                                          style: AppTextStyle.greytext(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${game.date} | ${game.time}",
                                      style: AppTextStyle.greytext(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      game.address,
                                      style: AppTextStyle.greytext(
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
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
                              height: 30,
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
                                    borderRadius: BorderRadius.circular(8),
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

class BookaVenueSection extends StatelessWidget {
  const BookaVenueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabProvider>(
      builder: (context, provider, _) {
        if (provider.isBookVenueLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
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
                      // Handle tap
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
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
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
                                        style: AppTextStyle.primaryText(
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
                                      maxLines: 1,
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
