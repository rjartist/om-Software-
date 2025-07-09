import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeTabProvider>();

    if (provider.isBannerGetting) {
      return Container(
        padding: EdgeInsets.all(16),
        height: 137,
        child: _buildShimmer(),
      );
    }

    if (provider.bannerList.isEmpty) {
      return const SizedBox(
        height: 137,
        child: Center(child: Text("No banners available.")),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: provider.bannerList.length,
          // itemBuilder: (context, index, _) {
          //   final banner = provider.bannerList[index];
          //   return ClipRRect(
          //     borderRadius: BorderRadius.circular(12),
          //     child: CachedNetworkImage(
          //       imageUrl: banner.imageUrl,
          //       fit: BoxFit.cover,
          //       width: double.infinity,
          //       placeholder: (context, url) => _buildShimmer(),
          //       errorWidget:
          //           (context, url, error) => Image.asset(
          //             'assets/images/carBooking.png.png',
          //             fit: BoxFit.cover,
          //             width: double.infinity,
          //           ),
          //     ),
          //   );
          // },
          itemBuilder: (context, index, _) {
            final banner = provider.bannerList[index];

            return Stack(
              children: [
                // 📷 Banner image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: banner.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => _buildShimmer(),
                    errorWidget:
                        (context, url, error) => Image.asset(
                          'assets/images/carBooking.png.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                  ),
                ),

                // 👉 Arrow button overlay
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: InkWell(
                    onTap: () {
                      // Navigate to banner detail or target page
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => TargetPage(banner: banner),
                      //   ),
                      // );
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },

          options: CarouselOptions(
            height: 137,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              provider.setBannerIndex(index);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(provider.bannerList.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    provider.currentBannerIndex == index
                        ? Colors.black
                        : Colors.grey.shade400,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
