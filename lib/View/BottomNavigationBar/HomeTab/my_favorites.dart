import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Favorites/my_favorites_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart' show GlobalAppBar;
import 'package:provider/provider.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  // Sample data for favorites
  final List<Map<String, dynamic>> favorites = List.generate(
    3,
    (index) => {
      "title": "Mavericks Cricket Academy",
      "rating": "3.9 (18)",
      "address":
          "Shankar Kalate Nagar, Opp. Silver Fitness Club, Wakad, Pune 57",
      "image": 'assets/images/venue.png',
    },
  );

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
          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 10,
              right: 10,
            ),
            itemCount: provider.favoritesList.length,
            itemBuilder: (context, index) {
              final item = provider.favoritesList;

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Card(
                  color: AppColors.white,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CachedNetworkImage(
                        //   imageUrl: venue.imageUrl,
                        //   height: 100,
                        //   width: double.infinity,
                        //   fit: BoxFit.cover,
                        //   placeholder:
                        //       (_, __) => Container(
                        //         height: 100,
                        //         color: Colors.grey[300],
                        //       ),
                        //   errorWidget:
                        //       (_, __, ___) => Container(
                        //         height: 100,
                        //         color: Colors.grey[300],
                        //         child: Center(
                        //           child: Icon(
                        //             Icons.broken_image_outlined,
                        //             size: 40,
                        //             color: Colors.grey,
                        //           ),
                        //         ),
                        //       ),
                        // ),
                        Image.asset(
                          "assets/images/venueImage.jpg",
                          height: 110,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item[index].facilityName!,
                                style: AppTextStyle.primaryText(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // const Spacer(),
                            Icon(
                              Icons.star,
                              size: 15,
                              color: AppColors.accentColor,
                            ),
                            Text(
                              // item[index].feedback!.averageRating.toString(),
                              "${item[index].feedback!.averageRating ?? 0.0} "
                              "(${item[index].feedback!.totalCount ?? 0} ratings)",
                              style: AppTextStyle.blackText(fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${item[index].address!}, ${item[index].city}, ${item[index].state}, ${item[index].zipcode}",
                                style: AppTextStyle.greytext(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ),
                            const SizedBox(width: 80),
                            Image.asset(
                              "assets/images/coin.png",
                              height: 17,
                              width: 17,
                              color: AppColors.successColor,
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              "assets/images/heart.png",
                              height: 17,
                              width: 17,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
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
