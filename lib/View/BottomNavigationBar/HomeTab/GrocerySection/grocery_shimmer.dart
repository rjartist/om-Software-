import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';


class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}



class GroceryItemShimmer extends StatelessWidget {
  const GroceryItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6, // show 6 shimmer cards
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 12.w,
        mainAxisExtent: 180.h,
      ),
      itemBuilder: (context, index) => _shimmerCard(),
    );
  }

  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              width: double.infinity,
              height: 110.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
            ),

            // Text placeholders
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10.h,
                    width: 80.w,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 8.h,
                    width: 50.w,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        height: 10.h,
                        width: 30.w,
                        color: Colors.grey[300],
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        height: 10.h,
                        width: 30.w,
                        color: Colors.grey[300],
                      ),
                      const Spacer(),
                      Container(
                        height: 12.h,
                        width: 30.w,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
