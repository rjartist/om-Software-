import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/HomePage/Grocery_section/grocery_product_provider.dart';
import 'package:gkmarts/Provider/Location/location_provider.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/General/home_banner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HeaderGrocerySection extends StatelessWidget {
  const HeaderGrocerySection({super.key});

  Widget _locationBlock({required String location}) => GestureDetector(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: AppColors.black, size: 20),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            location.isNotEmpty ? location : 'Select delivery location...',
            style: AppTextStyle.blackText(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_arrow_down, color: AppColors.black, size: 18),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<GroceryProductProvider>();
    final location = context.watch<LocationProvider>().userAddress;
    final user = context.watch<LoginProvider>().user;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(30.r),
          //   bottomRight: Radius.circular(30.r),
          // ),
          color: AppColors.white.withValues(alpha: 0.7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 6, child: _locationBlock(location: location)),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'Discover Glocery Product',
              style: AppTextStyle.blackText(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.bgColor,
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: AppTextStyle.primaryText(),
                      cursorColor: AppColors.primaryColor,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        hintText: 'Search product',
                        hintStyle: AppTextStyle.mediumGrey(),
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.bgColor,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppColors.borderColor.withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppColors.borderColor.withOpacity(0.8),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: homeProvider.searchProducts,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // const BuildQuantityFilter(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
