import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Models/HomeTab_Models/Venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/booking_date_time_page.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:provider/provider.dart';

class VenueDetailsPage extends StatefulWidget {
  final String venueId;
  const VenueDetailsPage({super.key, required this.venueId});

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
      ).getVenueDetails(widget.venueId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context);
    final model = provider.venueDetailModel;

    return Scaffold(
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
                    _buildImageSlider(context, provider, model),
                    _buildVenueInfo(context, model,provider),
                    buildAvailableSports(context, model, provider),
                    _buildAmenities(model),
                    _buildVenueMeta(model),
                  ],
                ),
              ),
      bottomNavigationBar: _buildBottomButtons(context, provider),
    );
  }

  
  Widget _buildVenueInfo(BuildContext context, VenueDetailModel model, BookTabProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vSizeBox(5),
          Text(model.venueName, style: AppTextStyle.titleText()),
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
                      model.venueAddress,
                      style: AppTextStyle.blackText(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: () {
                          provider.openMapForVenue(context);
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
                      icon: const Icon(Icons.map, size: 16),
                      label: Text(
                        'Show on Map',
                        style: AppTextStyle.smallBlack(),
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

  Widget _buildImageSlider(
    BuildContext context,
    BookTabProvider provider,
    VenueDetailModel model,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          child: PageView.builder(
            controller: provider.imagePageController,
            itemCount: model.images.length,
            onPageChanged: provider.setCurrentImageIndex,
            itemBuilder:
                (_, i) => Image.network(model.images[i], fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              model.images.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      provider.currentImageIndex == i
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
            children: const [
              _CircleIcon(icon: Icons.favorite_border),
              SizedBox(width: 12),
              _CircleIcon(icon: Icons.share),
            ],
          ),
        ),
      ],
    );
  }


  Widget buildAvailableSports(
    BuildContext context,
    VenueDetailModel model,
    BookTabProvider provider,
  ) {
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
              itemCount: model.availableSports.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final sport = model.availableSports[index];
                final isSelected = provider.selectedSport == sport.sportName;
                return GestureDetector(
                  onTap: () => provider.selectSport(sport.sportName),
                  child: Container(
                    width: 80,
                    height: 80,
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
                        ClipOval(
                          child: Image.network(
                            sport.image,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sport.sportName,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
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
                model.amenities
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
                          e,
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

  Widget _buildVenueMeta(VenueDetailModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Venue", style: AppTextStyle.titleText()),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text("${model.rating} (${model.totalReviews} reviews)"),
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
                      builder: (_) => const RateVenueBottomSheet(),
                    );
                  }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${model.totalGamesPlayed}+ Games"),
                  const SizedBox(height: 6),
                  _outlinedSmallButton("UPCOMING", () {}),
                ],
              ),
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
    return Container(
      color: AppColors.bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  backgroundColor:
                      Colors.transparent, // Needed to make curve visible
                  builder: (context) => const CorporateBookingSheet(),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GlobalSmallButton(
              text: "BOOK NOW!",
              onTap: () {
                if (!provider.isSportSelected()) {
                  GlobalSnackbar.error(context, "Please select a sport");
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

class RateVenueBottomSheet extends StatelessWidget {
  const RateVenueBottomSheet({super.key});

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
              "Rate Mavericks Cricket Academy",
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
                GlobalSmallButton(
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

            GlobalSmallButton(text: "I’m Interested", onTap: () {}),

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

            GlobalSmallButton(text: "Enquire Now", onTap: () {}),
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

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  const _CircleIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Icon(icon, color: Colors.black, size: 20),
    );
  }
}
