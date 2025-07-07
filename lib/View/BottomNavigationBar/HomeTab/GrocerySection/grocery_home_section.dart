import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Models/Grocery_section/product_model.dart';
import 'package:gkmarts/Provider/HomePage/Grocery_section/grocery_product_provider.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/GrocerySection/add_to_card.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/GrocerySection/header_grocery_section.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/GrocerySection/quantity_stepper.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/network_status_banner.dart';
import 'package:gkmarts/Widget/shimmer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroceryHomeSection extends StatefulWidget {
  const GroceryHomeSection({super.key});

  @override
  State<GroceryHomeSection> createState() => _GroceryHomeSectionState();
}

class _GroceryHomeSectionState extends State<GroceryHomeSection> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroceryProductProvider>().getGroceryCategories(context);
      context.read<GroceryProductProvider>().getProductData(
        context,
        categoryId: 0,
        forceFetch: true,
      );
      context.read<HomeTabProvider>().getBanner(context);
    });
  }

  void _onRefresh() async {
    await context.read<GroceryProductProvider>().getGroceryCategories(context);
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Consumer<GroceryProductProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  onRefresh: _onRefresh,
                  header: WaterDropMaterialHeader(
                    backgroundColor: Colors.white,
                    color: AppColors.primaryColor,
                    distance: 20.0,
                    offset: 30,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 16,
                        ), // Consistent padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Back Button
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                              color: AppColors.black,
                              padding:
                                  EdgeInsets.zero, // Removes internal padding
                              constraints:
                                  const BoxConstraints(), // Removes minimum button constraints
                            ),

                            // Title
                            const Text(
                              "Grocery",
                              style: TextStyle(
                                color: AppColors.primaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            // Cart Badge
                            Consumer<GroceryProductProvider>(
                              builder: (context, groceryProductProvider, _) {
                                final cartCount =
                                    groceryProductProvider.cart.length;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        child: AddToCard(),
                                      ),
                                    );
                                  },
                                  child: Badge(
                                    alignment: Alignment.topRight,
                                    label: Text(
                                      cartCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: AppColors.primaryColor,
                                    child: const Icon(
                                      Icons.shopping_cart_outlined,
                                      color: AppColors.black,
                                      size: 28,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const NetworkStatusBanner(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const HeaderGrocerySection(),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '— ',
                                style: TextStyle(
                                  color: Colors.grey,
                                ), // style the dashes if needed
                              ),
                              TextSpan(
                                text: ' Explore ',
                                style: AppTextStyle.blackText(),
                              ),
                              TextSpan(
                                text: 'Catagories',
                                style: AppTextStyle.blackText(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const TextSpan(
                                text: '—',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Above ProductListView
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Builder(
                          builder: (context) {
                            final provider =
                                Provider.of<GroceryProductProvider>(context);

                            if (provider.isGroceryCatLoading) {
                              return const ShimmerCategoryList(); // define below
                            }

                            if (provider.groceryCategories.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 32),
                                child: Center(
                                  child: Text("No categories found"),
                                ),
                              );
                            }

                            return const GroceryCategoryListView();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Consumer<GroceryProductProvider>(
                          builder: (context, provider, _) {
                            if (provider.isProductLoading) {
                              return const ShimmerProductListView();
                            }

                            if (provider.filteredProducts.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 32),
                                  child: Text(
                                    "No products found",
                                    style: AppTextStyle.mediumGrey(),
                                  ),
                                ),
                              );
                            }

                            return ProductListView(
                              products: provider.filteredProducts,
                            );
                          },
                        ),
                      ),

                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                      //   child:
                      //       provider.isProductLoading
                      //           ? const ShimmerProductListView()
                      //           : provider.filteredProducts.isEmpty
                      //           ? Center(
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(top: 32),
                      //               child: Text(
                      //                 "No products found",
                      //                 style: AppTextStyle.mediumGrey(),
                      //               ),
                      //             ),
                      //           )
                      //           : ProductListView(
                      //             products: provider.filteredProducts,
                      //           ),
                      // ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Floating cart notification
                if (provider.showCartNotification &&
                    provider.recentlyAddedProduct != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                            child: AddToCard(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.white),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  "${provider.recentlyAddedProduct!.name} added to cart",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const Text(
                              "View Cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class GroceryCategoryListView extends StatelessWidget {
  const GroceryCategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroceryProductProvider>();
    final categories = provider.groceryCategories;
    final selectedId = provider.selectedCategoryId;

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedId;

          return GestureDetector(
            onTap: () => provider.selectCategory(category.id, context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 110, // Slightly wider
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade50 : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isSelected
                          ? AppColors.borderColor.withValues(alpha: 0.3)
                          : Colors.grey.shade300,
                  width: 0,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: category.image,
                      height: 80,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(),
                      errorWidget:
                          (context, url, error) => Image.asset(
                            'assets/images/catagories.png',
                            height: 80,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color:
                          isSelected
                              ? AppColors.primaryTextColor
                              : AppColors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;

  const ProductListView({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: '— ',
                style: TextStyle(
                  color: Colors.grey,
                ), // style the dashes if needed
              ),
              TextSpan(text: ' Explore ', style: AppTextStyle.blackText()),
              TextSpan(
                text: 'products',
                style: AppTextStyle.blackText(fontWeight: FontWeight.bold),
              ),

              const TextSpan(text: '—', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(0),
          child: GridView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 190.h,
              crossAxisSpacing: 15,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductGridCard(product: product);
            },
          ),
        ),
      ],
    );
  }
}

class ProductGridCard extends StatelessWidget {
  final ProductModel product;

  const ProductGridCard({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroceryProductProvider>();
    final selectedQty = provider.getQuantity(product);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: product.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),

              // Discount Badge - Top Left
              if (product.discountLabel != null)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8), // Curved top-left
                        bottomRight: Radius.circular(8), // Curved bottom-right
                      ),
                    ),
                    child: Text(
                      product.discountLabel!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Add Button - Inside image, bottom right
              Positioned(
                bottom: 6,
                right: 6,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: () {
                      provider.addToCart(product, selectedQty);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // White container with bottom radius only
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              Text(
                product.name,
                style: AppTextStyle.blackText(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              Text(
                product.quantity,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${product.price * selectedQty}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      if (product.originalPrice != null)
                        Text(
                          '₹${product.originalPrice! * selectedQty}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),

                  QuantityStepper(
                    quantity: selectedQty,
                    onIncrement:
                        () => provider.setQuantity(product, selectedQty + 1),
                    onDecrement: () {
                      if (selectedQty > 1) {
                        provider.setQuantity(product, selectedQty - 1);
                      }
                    },
                    height: 24,
                    width: 24,
                    fontSize: 12,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    usePrimaryForAdd: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BuildQuantityFilter extends StatelessWidget {
  const BuildQuantityFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroceryProductProvider>();
    final quantities = ["All", ...provider.availableQuantities];
    final selected = provider.selectedQuantity ?? "All";

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderColor.withValues(alpha: 0.3),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selected,
            isDense: true,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.primaryTextColor,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primaryTextColor,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: AppColors.white,
            items:
                quantities.map((q) {
                  return DropdownMenuItem<String>(
                    value: q,
                    child: Row(
                      children: [
                        if (q == "All")
                          const Icon(
                            Icons.filter_list,
                            size: 16,
                            color: AppColors.grey,
                          ),
                        if (q == "All") const SizedBox(width: 6),
                        Text(
                          q,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            onChanged: (selected) {
              if (selected != null) {
                provider.filterByQuantity(selected);
              }
            },
          ),
        ),
      ),
    );
  }
}
