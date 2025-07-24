import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Models/BookTabModel/venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/booking_date_time_page.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/cancle_booking.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class VenueDetailsPage extends StatefulWidget {
  final int facilityId;
  const VenueDetailsPage({super.key, required this.facilityId});

  @override
  State<VenueDetailsPage> createState() => _VenueDetailsPageState();
}

class _VenueDetailsPageState extends State<VenueDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookTabProvider>(
        context,
        listen: false,
      ).getVenueDetails(widget.facilityId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context);
    final model = provider.venueDetailModel;

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          Provider.of<BookTabProvider>(
            context,
            listen: false,
          ).clearBookingData();
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body:
            provider.isgetVenueDetailsGetting
                ? const Center(child: CupertinoActivityIndicator())
                : model == null
                ? const Center(child: Text("No data available"))
                : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VenueImageSlider(
                        facilityId: model.modifiedFacility.facilityId,
                        imageUrls:
                            model.modifiedFacility.facilityImages
                                .map((e) => e.image)
                                .toList(),
                        currentIndex: provider.currentImageIndex,
                        onPageChanged:
                            (index) => provider.setCurrentImageIndex(index),
                        onBackTap: () {
                          Navigator.pop(context);
                          provider.clearBookingData();
                        },
                      ),
                      _buildVenueInfo(context, model, provider),
                      buildAvailableSports(context, model, provider),
                      _buildAmenities(model),
                      _buildVenueMeta(context, model),
                    ],
                  ),
                ),
        bottomNavigationBar: _buildBottomButtons(context, provider),
      ),
    );
  }

  Widget _buildVenueInfo(
    BuildContext context,
    VenueDetailModel model,
    BookTabProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vSizeBox(5),
          Text(
            model.modifiedFacility.facilityName,
            style: AppTextStyle.titleText(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),

                child: const Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "${formatTime(model.modifiedFacility.facilityStartHour)} - ${formatTime(model.modifiedFacility.facilityEndHour)}",
                style: AppTextStyle.blackText(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.modifiedFacility.address,
                      style: AppTextStyle.blackText(fontSize: 14),
                    ),
                    const SizedBox(height: 4),

                    const SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: () {
                        provider.openMapForVenue(
                          context,
                          model.modifiedFacility.googleMapUrl,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.borderColor),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        foregroundColor: Colors.red,
                      ),
                      icon: Image.asset(
                        'assets/images/google_map_icon.png',
                        height: 16,
                        width: 16,
                      ),
                      label: Text(
                        'Show on Map',
                        style: AppTextStyle.smallBlack(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAvailableSports(
    BuildContext context,
    VenueDetailModel model,
    BookTabProvider provider,
  ) {
    final services = model.modifiedFacility.services;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Available Sports", style: AppTextStyle.titleText()),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final service = services[index];
                final isSelected =
                    provider.selectedSport == service.serviceName;
                final imageUrl =
                    service.serviceImages.isNotEmpty
                        ? service.serviceImages.first.image
                        : '';

                String trimmedName =
                    service.serviceName.length > 12
                        ? service.serviceName.substring(0, 13) + '...'
                        : service.serviceName;

                return GestureDetector(
                  onTap:
                      () => provider.selectSport(
                        service.serviceName,
                        service.serviceId,
                      ),
                  child: Container(
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.redAccent : Colors.transparent,
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(child: buildNetworkOrSvgImage(imageUrl)),

                        const SizedBox(height: 4),
                        Text(
                          trimmedName,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities(VenueDetailModel model) {
    final amenities = model.modifiedFacility.facilityAmenities;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Amenities", style: AppTextStyle.titleText()),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                amenities
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          e.amenityName,
                          style: AppTextStyle.blackText(fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueMeta(BuildContext context, VenueDetailModel model) {
    final feedback = model.modifiedFacility.feedback;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Venue", style: AppTextStyle.titleText()),
          const SizedBox(height: 8),
          Text(
            "2 Multi-Sport Turf",
            style: AppTextStyle.greytext(fontSize: 13),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "${feedback.averageRating} (${feedback.totalCount} ratings)",
                        style: AppTextStyle.blackText(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _outlinedSmallButton("RATE VENUE", () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => RateVenueBottomSheet(model: model),
                    );
                  }),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text("NA+ total Games"),
              //     const SizedBox(height: 6),
              //     _outlinedSmallButton("UPCOMING", () {}),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _outlinedSmallButton(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
        visualDensity: VisualDensity.compact,
      ),
      child: Text(label, style: AppTextStyle.blackText(fontSize: 13)),
    );
  }

  Widget _buildBottomButtons(BuildContext context, BookTabProvider provider) {
    return SafeArea(
      // ✅ Wrap with SafeArea
      minimum: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: 15,
      ), // Padding inside safe area
      child: Row(
        children: [
          Expanded(
            child: GlobalSmallButton(
              textColor: AppColors.black,
              backgroundColor: AppColors.white,
              text: "BULK / CORPORATE",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CorporateBookingSheet(),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GlobalPrimaryButton(
              text: "BOOK NOW!",
              onTap: () {
                if (!provider.isSportSelected()) {
                  GlobalSnackbar.error(
                    context,
                    "Please select an available sport to book this venue",
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BookingDateTimePage(
                          model: provider.venueDetailModel!,
                        ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
//   Widget _buildBottomButtons(BuildContext context, BookTabProvider provider) {
//     return Container(
//       color: AppColors.bgColor,
//       padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25, top: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: GlobalSmallButton(
//               textColor: AppColors.black,
//               backgroundColor: AppColors.white,
//               text: "BULK / CORPORATE",
//               onTap: () {
//                 showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   backgroundColor:
//                       Colors.transparent, // Needed to make curve visible
//                   builder: (context) => const CorporateBookingSheet(),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: GlobalPrimaryButton(
//               // isEnabled: provider.selectedSport != null,
//               text: "BOOK NOW!",
//               onTap: () {
//                 if (!provider.isSportSelected()) {
//                   GlobalSnackbar.error(
//                     context,
//                     "Please select an available sport to book this venue",
//                   );
//                   return;
//                 }
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (_) => BookingDateTimePage(
//                           model: provider.venueDetailModel!,
//                         ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class VenueImageSlider extends StatelessWidget {
  final List<String> imageUrls;
  final int currentIndex;
  final int facilityId;
  final Function(int) onPageChanged;
  final VoidCallback onBackTap;

  const VenueImageSlider({
    super.key,
    required this.imageUrls,
    required this.currentIndex,
    required this.facilityId,
    required this.onPageChanged,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CarouselSlider.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = imageUrls[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => FullScreenImageViewer(
                          images: imageUrls,
                          initialIndex: index,
                        ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.30,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              onPageChanged(index);
            },
          ),
        ),

        // Back Button
        Positioned(
          top: 40,
          left: 16,
          child: GestureDetector(
            onTap: onBackTap,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),

        // Indicator Dots
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imageUrls.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      currentIndex == i
                          ? Colors.redAccent
                          : Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          right: 12,
          bottom: -20,
          child: Row(
            children: [
              Consumer<BookTabProvider>(
                builder: (context, provider, _) {
                  return IgnorePointer(
                    ignoring: provider.isFavoriteLoading,
                    child: AnimatedOpacity(
                      opacity: provider.isFavoriteLoading ? 0.5 : 1,
                      duration: const Duration(milliseconds: 300),
                      child: GestureDetector(
                        behavior:
                            HitTestBehavior.translucent, // Expands tap area
                        onTap: () {
                          provider.toggleFavorite(context, facilityId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ), // Increase tap area
                          child: CircleIconButton(
                            icon:
                                provider.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                            iconColor:
                                provider.isFavorite ? Colors.red : Colors.black,
                            onTap: () {
                              provider.toggleFavorite(context, facilityId);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // Your share function here
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleIconButton(
                    icon: Icons.share,
                    onTap: () {
                      // Your share function here
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RateVenueBottomSheet extends StatelessWidget {
  final VenueDetailModel model;

  const RateVenueBottomSheet({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context);

    return Material(
      color: Colors.white, // Proper background while respecting shape
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              model.modifiedFacility.facilityName,
              style: AppTextStyle.titleText(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final isSelected = index < provider.userRating;
                return IconButton(
                  icon: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 30,
                  ),
                  onPressed: () {
                    provider.updateUserRating(index + 1);
                  },
                );
              }),
            ),
            const SizedBox(height: 12),

            // Comment Input
            TextField(
              onChanged: provider.updateUserComment,
              maxLines: 3,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Write your feedback...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        provider.resetRating();
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GlobalPrimaryButton(
                  text: "Rate",
                  onTap: () {
                    provider.resetRating();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Center(
            child: PhotoView(
              imageProvider: NetworkImage(images[index]),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder:
                  (context, event) =>
                      const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}

class CorporateBookingSheet extends StatelessWidget {
  const CorporateBookingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.6;

    return SizedBox(
      height: height,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
              child: Text(
                "Corporate Bookings",
                textAlign: TextAlign.center,
                style: AppTextStyle.boldBlackText(),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _BookingFeature(
                  label: "Venue\nReservation",
                  assetPath: "assets/images/c1.png",
                ),
                _BookingFeature(
                  label: "Scheduling\nFixtures",
                  assetPath: "assets/images/c2.png",
                ),
                _BookingFeature(
                  label: "Hospitality\nServices",
                  assetPath: "assets/images/c3.png",
                ),
              ],
            ),

            GlobalPrimaryButton(
              text: "I’m Interested",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (_) => CallNow(
                        title: "Corporate Booking Enquiry",
                        description:
                            "Looking to reserve a venue for your corporate event?\nOur team is here to assist you with scheduling\nand more. Reach out now!",
                        phoneNumber: "+91 9999999999",
                        onConfirm: () {}, // Optional action after call
                      ),
                );
              },
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
              child: Text(
                "Long Term / Bulk Booking",
                textAlign: TextAlign.center,
                style: AppTextStyle.boldBlackText(),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _BookingFeature(
                  label: "Repeat\nBookings",
                  assetPath: "assets/images/c4.png",
                ),
                _BookingFeature(
                  label: "Volume\nDiscounts",
                  assetPath: "assets/images/c5.png",
                ),
                _BookingFeature(
                  label: "Easy\nReschedule",
                  assetPath: "assets/images/c6.png",
                ),
              ],
            ),

            GlobalPrimaryButton(
              text: "Enquire Now",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (_) => CallNow(
                        title: "Need Help?",
                        description:
                            "Want to enquire about the venue or your booking?\nFeel free to call our support team.",
                        phoneNumber: "+91 9999999999",
                        onConfirm: () {}, // Optional action after call
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingFeature extends StatelessWidget {
  final String label;
  final String assetPath;

  const _BookingFeature({required this.label, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(assetPath, height: 37, width: 37, fit: BoxFit.cover),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyle.blackText(fontSize: 14),
        ),
      ],
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black, // Default to black
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
