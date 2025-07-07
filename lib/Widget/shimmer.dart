import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductListView extends StatelessWidget {
  const ShimmerProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 16,
            width: 140, // Approx width of the text
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),

        const SizedBox(height: 20),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 190.h,
            crossAxisSpacing: 15,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top image placeholder
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                  ),

                  // Bottom content
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),

                        // Name shimmer
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                        ),

                        const SizedBox(height: 4),

                        // Quantity shimmer
                        Container(
                          height: 12,
                          width: 40,
                          color: Colors.grey.shade300,
                        ),

                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price shimmer
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 14,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 60,
                                  height: 12,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),

                            // Stepper shimmer (mimics QuantityStepper)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 18,
                                    height: 14,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
class ShimmerCategoryList extends StatelessWidget {
  const ShimmerCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 110,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 12,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}