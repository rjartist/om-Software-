import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_header.dart';
import 'package:gkmarts/Widget/mobile_otp_login_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Venues extends StatefulWidget {
  final bool gamePage;
  Venues({super.key, required this.gamePage});

  @override
  State<Venues> createState() => _VenuesState();
}

class _VenuesState extends State<Venues> {
  final Map<int, PageController> _controllers = {};

  @override
  void dispose() {
    // Dispose all controllers when Venues is destroyed
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabProvider>(
      builder: (context, provider, _) {
        if (provider.isBookVenueLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (provider.filteredVenueList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: EmptyVenuesWidget(
              showImage: true,
              onRetry: () {
                // close any existing sheet first
                Navigator.popUntil(context, (route) => route.isFirst);

                // reopen Location BottomSheet
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.bgColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (_) => const LocationBottomSheet(),
                );
              },
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.filteredVenueList.length,
          itemBuilder: (context, index) {
            final venue = provider.filteredVenueList[index];
            _controllers[index] = _controllers[index] ?? PageController();
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius:
                        8, // Increased blur to match search field shadow
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
                      if (widget.gamePage == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => VenueDetailsPage(
                                  facilityId: venue.facilityId,
                                ),
                          ),
                        );
                      } else {
                        Navigator.pop(context, venue.venueName);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                      venue.facilityImages.isNotEmpty
                                          ? Stack(
                                            children: [
                                              PageView.builder(
                                                controller: _controllers[index],
                                                itemCount:
                                                    venue.facilityImages.length,
                                                itemBuilder: (
                                                  context,
                                                  imgIndex,
                                                ) {
                                                  return Image.network(
                                                    venue
                                                        .facilityImages[imgIndex],
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    loadingBuilder: (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null)
                                                        return child;
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
                                                    controller:
                                                        _controllers[index]!,
                                                    count:
                                                        venue
                                                            .facilityImages
                                                            .length,
                                                    effect: ExpandingDotsEffect(
                                                      dotHeight: 6,
                                                      dotWidth: 6,
                                                      activeDotColor:
                                                          AppColors
                                                              .primaryColor,
                                                      dotColor: Colors.white54,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                          : Image.network(
                                            venue.imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                color: Colors.grey.shade200,
                                              );
                                            },
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Container(
                                                  color: Colors.grey.shade100,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                ),

                                // Favorite Button (top right corner)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Consumer<BookTabProvider>(
                                    builder: (context, provider, _) {
                                      return IgnorePointer(
                                        ignoring: provider
                                            .isFavoriteListLoading(
                                              venue.facilityId,
                                            ),
                                        child: AnimatedOpacity(
                                          opacity:
                                              provider.isFavoriteListLoading(
                                                    venue.facilityId,
                                                  )
                                                  ? 0.5
                                                  : 1,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              final isLoggedIn =
                                                  await AuthService.isLoggedIn();
                                              if (!isLoggedIn) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) =>
                                                            const MobileInputPage(
                                                              referralCode: "",
                                                            ),
                                                  ),
                                                );
                                                return;
                                              }
                                              provider.toggleFavoriteList(
                                                context,
                                                venue.facilityId,
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 14,
                                              backgroundColor: Colors.white
                                                  .withOpacity(0.8),
                                              child: Icon(
                                                provider.isFavoriteList(
                                                      venue.facilityId,
                                                    )
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color:
                                                    provider.isFavoriteList(
                                                          venue.facilityId,
                                                        )
                                                        ? Colors.red
                                                        : Colors.black,
                                                size: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name + rating
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      venue.venueName,
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
                                        "${venue.rating}",
                                        style: AppTextStyle.greytext(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        " (${venue.totalReviews})",
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
              ),
            );
          },
        );
      },
    );
  }
}
