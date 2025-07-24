import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:provider/provider.dart';

class Venues extends StatelessWidget {
  const Venues({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabProvider>(
      builder: (context, provider, _) {
        if (provider.isBookVenueLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (provider.filteredVenueList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "No venues found.",
              style: TextStyle(color: Colors.grey),
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

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Increased opacity
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
                        // Image with padding and rounded corner
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 140,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: venue.imageUrl,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(child: SizedBox()),
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      color: Colors.grey.shade100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.broken_image_outlined,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
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
