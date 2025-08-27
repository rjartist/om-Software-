import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Favorites/my_favorites_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/book_tab.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:gkmarts/Widget/global_appbar.dart' show GlobalAppBar;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  @override
  void initState() {
    super.initState();

    Provider.of<MyFavoritesProvider>(
      context,
      listen: false,
    ).getMyFavorites(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "My Favorites", showBackButton: true),
      body: Consumer<MyFavoritesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          // ✅ Empty state check
          if (provider.favoritesList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/empty_favorites.png", // 👈 Add your placeholder asset
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No favorites yet",
                    style: AppTextStyle.primaryText(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Start adding venues to your favorites!",
                    style: AppTextStyle.greytext(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.profileSectionButtonColor,
                          AppColors.profileSectionButtonColor2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BookTab()),
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
                        "View Venues",
                        style: AppTextStyle.whiteText(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: provider.favoritesList.length,
            itemBuilder: (context, index) {
              final favorite = provider.favoritesList[index];

              // PageController for image slider
              final PageController _controller = PageController();

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                            child: VenueDetailsPage(
                              facilityId: favorite.facilityId!,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------- IMAGES ----------
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 140,
                                    width: double.infinity,
                                    child:
                                        (favorite.facilityImages != null &&
                                                favorite
                                                    .facilityImages!
                                                    .isNotEmpty)
                                            ? Stack(
                                              children: [
                                                PageView.builder(
                                                  controller: _controller,
                                                  itemCount:
                                                      favorite
                                                          .facilityImages!
                                                          .length,
                                                  itemBuilder: (
                                                    context,
                                                    imgIndex,
                                                  ) {
                                                    return Image.network(
                                                      favorite
                                                          .facilityImages![imgIndex]
                                                          .image!,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      loadingBuilder: (
                                                        context,
                                                        child,
                                                        loadingProgress,
                                                      ) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Container(
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade200,
                                                        );
                                                      },
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => Container(
                                                            color:
                                                                Colors
                                                                    .grey
                                                                    .shade100,
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons
                                                                    .broken_image_outlined,
                                                                size: 40,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                    );
                                                  },
                                                ),
                                                Positioned(
                                                  bottom: 8,
                                                  left: 0,
                                                  right: 0,
                                                  child: Center(
                                                    child: SmoothPageIndicator(
                                                      controller: _controller,
                                                      count:
                                                          favorite
                                                              .facilityImages!
                                                              .length,
                                                      effect: ExpandingDotsEffect(
                                                        dotHeight: 6,
                                                        dotWidth: 6,
                                                        activeDotColor:
                                                            AppColors
                                                                .primaryColor,
                                                        dotColor:
                                                            Colors.white54,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                            : Container(
                                              color: Colors.grey.shade200,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                  ),

                                  // ---------- FAVORITE ICON ----------
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.white.withOpacity(
                                        0.8,
                                      ),
                                      child: Icon(
                                        Icons.favorite,
                                        color: AppColors.primaryColor,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ---------- DETAILS ----------
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Facility Name + Rating
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        favorite.facilityName ??
                                            "Unknown Facility",
                                        style: AppTextStyle.primaryText(
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
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
                                        const SizedBox(width: 4),
                                        Text(
                                          "${favorite.feedback?.averageRating ?? 0.0}",
                                          style: AppTextStyle.greytext(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          " (${favorite.feedback?.totalCount ?? 0})",
                                          style: AppTextStyle.greytext(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Address + Price
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        favorite.address ?? "",
                                        style: AppTextStyle.greytext(
                                          fontSize: 12,
                                          color: AppColors.borderColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            (favorite.services != null &&
                                                    favorite
                                                        .services!
                                                        .isNotEmpty)
                                                ? "₹${favorite.services!.first.minRate} "
                                                : "₹ ",
                                        style: AppTextStyle.blackText(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Onwards",
                                            style: AppTextStyle.greytext(
                                              fontSize: 12,
                                              color: AppColors.borderColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: Text(
                                //         favorite.address ?? "Address not available",
                                //         style: AppTextStyle.greytext(fontSize: 13),
                                //         maxLines: 2,
                                //         overflow: TextOverflow.ellipsis,
                                //       ),
                                //     ),
                                //     Text(
                                //       (favorite.services != null &&
                                //               favorite.services!.isNotEmpty)
                                //           ? "₹${favorite.services!.first.minRate} Onwards"
                                //           : "Rate not available",
                                //       style: AppTextStyle.blackText(
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
