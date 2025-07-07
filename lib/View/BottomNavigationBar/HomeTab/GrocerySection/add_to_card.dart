import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Models/Grocery_section/cart_item_model.dart';
import 'package:gkmarts/Provider/HomePage/Grocery_section/grocery_product_provider.dart';
import 'package:gkmarts/Provider/Location/location_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/GrocerySection/quantity_stepper.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:provider/provider.dart';

class AddToCard extends StatelessWidget {
  const AddToCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<GroceryProductProvider>();
    final cartItems = cartProvider.cart;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: GlobalAppBar(title: "🛒 Your Cart", centerTitle: true),
        body:
            cartItems.isEmpty
                ? Center(
                  child: Text(
                    "Your cart is empty",
                    style: AppTextStyle.mediumGrey(),
                  ),
                )
                : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 150),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          const CartAddressBox(),
                          const SizedBox(height: 12),
                          ...cartItems.map((item) => CartItemCard(item: item)),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CartSummaryBox(
                        originalPrice: cartProvider.totalOriginalPrice,
                        discount: cartProvider.totalDiscount,
                        total: cartProvider.totalPrice,
                        onPlaceOrder: () => cartProvider.placeOrder(context),
                        isLoading: cartProvider.isOrderPlacing,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class CartAddressBox extends StatelessWidget {
  const CartAddressBox({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Delivery Address",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgColor, // Soft light background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Address info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Deliver to:",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      locationProvider.userAddress.isNotEmpty
                          ? locationProvider.userAddress
                          : "No address selected",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to address screen
                },
                child: const Text(
                  "Change",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  const CartItemCard({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<GroceryProductProvider>();
    final product = item.product;
    final qty = item.quantity;
    final price = product.price * qty;
    final originalTotal = (product.originalPrice ?? product.price) * qty;
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // make image full height
        children: [
          // Left Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                    errorWidget:
                        (context, url, error) => const Icon(Icons.error),
                  ),
                  if (product.discountLabel != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          product.discountLabel!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Right Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // spread vertically
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Quantity
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppTextStyle.blackText(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.quantity,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  // Price
                  Row(
                    children: [
                      Text(
                        '₹$price',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.originalPrice != null)
                        Text(
                          '₹$originalTotal',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),

                  // Stepper + Delete
                  Row(
                    children: [
                      QuantityStepper(
                        quantity: qty,
                        onIncrement:
                            () => cartProvider.updateCartItemQuantity(
                              product,
                              qty + 1,
                            ),
                        onDecrement: () {
                          if (qty > 1) {
                            cartProvider.updateCartItemQuantity(
                              product,
                              qty - 1,
                            );
                          }
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color:
                              AppColors
                                  .secondaryTextColor, // Professional muted tone
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => cartProvider.removeFromCart(product),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartSummaryBox extends StatelessWidget {
  final double originalPrice;
  final double discount;
  final double total;
  final VoidCallback onPlaceOrder;
  final bool isLoading;

  const CartSummaryBox({
    super.key,
    required this.originalPrice,
    required this.discount,
    required this.total,
    required this.onPlaceOrder,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// MRP & Discount Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total (MRP):",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              Text(
                "₹$originalPrice",
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryTextColor,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "You Save:",
                style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
              ),
              Text(
                "₹$discount",
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          /// Total + Button
          Row(
            children: [
              // Total Payable
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Payable:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹$total",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Place Order Button
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 40,
                  child: GlobalButton(
                    text: "Place Order",
                    onPressed: onPlaceOrder,
                    isLoading: isLoading,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
