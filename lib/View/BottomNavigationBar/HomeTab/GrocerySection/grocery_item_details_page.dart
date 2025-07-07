// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gkmarts/Models/Grocery_section/grocery_items_details_model.dart';
// import 'package:gkmarts/Provider/HomePage/Grocery_section/grocery_section_provider.dart';
// import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
// import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
// import 'package:gkmarts/Widget/global_appbar.dart';
// import 'package:gkmarts/Widget/global_button.dart';
// import 'package:provider/provider.dart';

// class GroceryItemDetailPage extends StatefulWidget {
//   final int itemId;

//   const GroceryItemDetailPage({super.key, required this.itemId});

//   @override
//   State<GroceryItemDetailPage> createState() => _GroceryItemDetailPageState();
// }

// class _GroceryItemDetailPageState extends State<GroceryItemDetailPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch the item detail using Provider
//     Future.microtask(() {
//       context.read<GrocerySectionProvider>().fetchGroceryItemDetail(
//         widget.itemId.toString(),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: GlobalAppBar(title: "Product Details", showBackButton: true),
//       body: Consumer<GrocerySectionProvider>(
//         builder: (context, provider, _) {
//           if (provider.isGroceryItemDetailLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final item = provider.groceryItemDetail;

//           if (item == null) {
//             return Center(
//               child: Text("No details found.", style: AppTextStyle.mediumGrey()),
//             );
//           }

//           return Column(
//             children: [
//               /// 🖼️ Image
//               _buildImage(item.imageUrl),

//               /// 🧾 Lifted Container with Details
//               Expanded(
//                 child: Transform.translate(
//                   offset: const Offset(0, -20),
//                   child: Container(
//                     padding: EdgeInsets.all(16.w),
//                     decoration: const BoxDecoration(
//                       color: AppColors.backgroundColor,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildTitlePriceSection(item),
//                           SizedBox(height: 12.h),
//                           _buildDescriptionSection(item),
//                           SizedBox(height: 12.h),
//                           _buildInfoRow("Brand", item.brand),
//                           _buildInfoRow("Quantity", item.quantity),
//                           _buildInfoRow("Expiry Date", item.expiryDate),
//                           SizedBox(height: 80.h), // Space for button
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),

//       /// 🛒 Bottom Add to Cart Button
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
//         child: GlobalButton(
//           text: "Add to Cart",
//           onPressed: () {
//             // TODO: Add to cart logic here
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Item added to cart")),
//             );
//           },
//         ),
//       ),
//     );
//   }
//   Widget _buildImage(String imageUrl) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12.r),
//       child: Image.network(
//         imageUrl,
//         width: double.infinity,
//         height: 200.h,
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//   Widget _buildTitlePriceSection(GroceryItemDetailModel item) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           item.title,
//           style: AppTextStyle.blackText(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Row(
//           children: [
//             Text(
//               "₹${item.discountPrice.toStringAsFixed(2)}",
//               style: AppTextStyle.blackText(fontSize: 16),
//             ),
//             SizedBox(width: 10.w),
//             if (item.originalPrice > item.discountPrice)
//               Text(
//                 "₹${item.originalPrice.toStringAsFixed(2)}",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   decoration: TextDecoration.lineThrough,
//                 ),
//               ),
//             if (item.discountPercent > 0)
//               Container(
//                 margin: EdgeInsets.only(left: 8.w),
//                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   color: Colors.redAccent,
//                   borderRadius: BorderRadius.circular(4.r),
//                 ),
//                 child: Text(
//                   "-${item.discountPercent}%",
//                   style: AppTextStyle.smallWhiteTitle,
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildDescriptionSection(GroceryItemDetailModel item) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Description", style: AppTextStyle.title),
//         SizedBox(height: 6.h),
//         Text(item.description, style: AppTextStyle.mediumGrey()),
//       ],
//     );
//   }

//   Widget _buildInfoRow(String label, String? value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         children: [
//           Text("$label: ", style: AppTextStyle.blackText()),
//           Expanded(
//             child: Text(
//               value ?? "-",
//               style: AppTextStyle.mediumGrey(),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
