import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Favorites/my_favorites_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/venue_details_page.dart';
import 'package:gkmarts/Widget/global_appbar.dart' show GlobalAppBar;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

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
          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 15,
              right: 15,
            ),
            itemCount: provider.favoritesList.length,
            itemBuilder: (context, index) {
              final item = provider.favoritesList;

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        child: VenueDetailsPage(
                          facilityId: item[index].facilityId!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: AppColors.white,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              ClipRRect(
                               borderRadius: BorderRadius.circular(10),                        
                                child: CachedNetworkImage(
                                  imageUrl:
                                      item[index].facilityImages!.first.image
                                          .toString(),
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (_, __) => Container(
                                        height: 140,
                                        color: Colors.grey[300],
                                      ),
                                  errorWidget:
                                      (_, __, ___) => Container(
                                        height: 140,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  right: 5,
                                ),
                                child: Image.asset(
                                  "assets/images/heart.png",
                                  height: 22,
                                  width: 22,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
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
                                size: 14,
                                color: AppColors.accentColor,
                              ),
                              SizedBox(width: 3),
                              Text(
                                // item[index].feedback!.averageRating.toString(),
                                "${item[index].feedback!.averageRating ?? 0.0} "
                                "(${item[index].feedback!.totalCount ?? 0})",
                                style: AppTextStyle.blackText(fontSize: 10),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item[index].address!,
                                  // "${item[index].address!}, ${item[index].city}, ${item[index].state}, ${item[index].zipcode}",
                                  style: AppTextStyle.greytext(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                                // const SizedBox(width: 80),
                                Text(
                                  "₹ ${item[index].services!.first.minRate} Onwards",
                                  style: AppTextStyle.greytext(fontSize: 10),
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
      ),
    );
  }
}
