import 'package:flutter/material.dart';
import 'package:gkmarts/Models/HomeTab_Models/banner_model.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
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

          itemBuilder: (context, index, _) {
            final banner = provider.bannerList[index];

            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    // 👇 Replace with your actual target page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TargetPage(banner: banner),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      banner.imageUrl, // 👈 directly use your asset path
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),

                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(12),
                  //   child: CachedNetworkImage(
                  //     imageUrl: banner.imageUrl,
                  //     fit: BoxFit.cover,
                  //     width: double.infinity,
                  //     placeholder: (context, url) => _buildShimmer(),
                  //     errorWidget:
                  //         (context, url, error) => Image.asset(
                  //           'assets/images/banner1.png',
                  //           fit: BoxFit.cover,
                  //           width: double.infinity,
                  //         ),
                  //   ),
                  // ),
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

class TargetPage extends StatelessWidget {
  final BannerModel banner;

  const TargetPage({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner image
          GlobalAppBar(title: banner.title, showBackButton: true),
          Image.asset(
            banner.imageUrl, // e.g. "assets/images/banner12.png"
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),

          // CachedNetworkImage(
          //   imageUrl: banner.imageUrl,
          //   placeholder:
          //       (context, url) => const SizedBox(
          //         height: 200,
          //         child: Center(child: CircularProgressIndicator()),
          //       ),
          //   errorWidget: (context, url, error) => const Icon(Icons.error),
          //   fit: BoxFit.cover,
          //   height: 200,
          //   width: double.infinity,
          // ),
          const SizedBox(height: 16),

          // Banner title or description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              banner.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              banner.description,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
