import 'package:flutter/material.dart';
import 'package:gkmarts/Models/Grocery_section/cart_item_model.dart';
import 'package:gkmarts/Models/Grocery_section/grocery_category_model.dart';
import 'package:gkmarts/Models/Grocery_section/product_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/View/Auth_view/login.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class GroceryProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  List<GroceryCategoryModel> groceryCategories = [];
  // Cart items
  final List<CartItemModel> _cart = [];
  List<CartItemModel> get cart => _cart;

  List<ProductModel> filteredProducts = [];

  bool isProductLoading = false;
  bool isGroceryCatLoading = false;
  String? selectedQuantity = "All";
  Map<int, int> selectedQuantities = {};
  bool isOrderPlacing = false;
  int unreadNotifications = 6;

  //---------------
  bool showCartNotification = false;
  ProductModel? recentlyAddedProduct;

  int? selectedCategoryId;

  void selectCategory(int categoryId, BuildContext context) {
    selectedCategoryId = categoryId;
    getProductData(context, categoryId: categoryId, forceFetch: true);
    notifyListeners();
  }









  

  void showAddToCartNotification(ProductModel product) {
    recentlyAddedProduct = product;
    showCartNotification = true;
    notifyListeners();

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      showCartNotification = false;
      notifyListeners();
    });
  }

  // Set quantity per product
  void setQuantity(ProductModel product, int qty) {
    if (qty < 1) return;
    // Find product in _products list and update its userSelectedQuantity
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index].userSelectedQuantity = qty;
      notifyListeners();
    }
  }

  int getQuantity(ProductModel product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      return _products[index].userSelectedQuantity;
    }
    return 1; // default fallback
  }

  void addToCart(ProductModel product, int unserSelctedQuantity) {
    final existingIndex = _cart.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += unserSelctedQuantity;
    } else {
      _cart.add(
        CartItemModel(product: product, quantity: unserSelctedQuantity),
      );
    }
    showAddToCartNotification(product);
    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(ProductModel product) {
    _cart.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  // Update quantity in cart for given product
  void updateCartItemQuantity(ProductModel product, int newQty) {
    if (newQty < 1) return;

    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cart[index].quantity = newQty;
      notifyListeners();
    }
  }

  double get totalOriginalPrice {
    return _cart.fold(0, (total, item) {
      final original = item.product.originalPrice ?? item.product.price;
      return total + original * item.quantity;
    });
  }

  double get totalDiscount => totalOriginalPrice - totalPrice;

  // Get total price
  double get totalPrice =>
      _cart.fold(0, (total, item) => total + item.totalPrice);

  //---

  void filterByQuantity(String quantity) {
    selectedQuantity = quantity;
    if (quantity == "All") {
      filteredProducts = List.from(_products);
    } else {
      filteredProducts =
          _products.where((product) => product.quantity == quantity).toList();
    }
    notifyListeners();
  }

  List<String> get availableQuantities {
    return _products.map((product) => product.quantity).toSet().toList();
  }

  Future<void> getGroceryCategories(BuildContext context) async {
    isGroceryCatLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate API call

      final List<Map<String, dynamic>> dummyData = [
        {
          'id': 1,
          'title': 'Fruits',
          'image':
              'https://cdn.pixabay.com/photo/2017/08/30/07/52/fruit-2694075_1280.jpg',
        },
        {
          'id': 2,
          'title': 'Vegetables',
          'image':
              'https://cdn.pixabay.com/photo/2017/02/01/15/02/carrots-2025140_1280.jpg',
        },
        {
          'id': 3,
          'title': 'Beverages',
          'image':
              'https://cdn.pixabay.com/photo/2016/11/21/15/52/cola-1845270_1280.jpg',
        },
        {
          'id': 4,
          'title': 'Snacks',
          'image':
              'https://cdn.pixabay.com/photo/2014/12/21/23/54/popcorn-576602_1280.jpg',
        },
        {
          'id': 5,
          'title': 'Dairy',
          'image':
              'https://cdn.pixabay.com/photo/2016/11/23/15/35/milk-1851232_1280.jpg',
        },
        {
          'id': 6,
          'title': 'Bakery',
          'image':
              'https://cdn.pixabay.com/photo/2016/06/03/13/36/bread-1432178_1280.jpg',
        },
      ];

      groceryCategories =
          dummyData.map((json) => GroceryCategoryModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading grocery categories: $e');
      // Optional: Show UI feedback
    } finally {
      isGroceryCatLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts = List.from(products); // reset to all products
    } else {
      filteredProducts =
          products
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()) ||
                    product.quantity.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    }
    notifyListeners();
  }

  Future<void> getProductData(
    BuildContext context, {
    bool forceFetch = false,
    int? categoryId,
  }) async {
    if (_products.isNotEmpty && !forceFetch) return;

    // You can skip internet check if it's dummy only
    // But keeping it here if you want the same logic
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isProductLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      // 👇 Dummy data (Map<String, dynamic>)
      final Map<String, dynamic> dummyData = {
        "1": {
          "id": 1,
          "name": "Fresh Apples",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 120.50,
          "originalPrice": 150.00,
          "discountLabel": "20% OFF",
          "quantity": "1kg",
        },
        "2": {
          "id": 2,
          "name": "Organic Bananas",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 60.00,
          "originalPrice": null,
          "discountLabel": null,
          "quantity": "1 dozen",
        },
        "3": {
          "id": 3,
          "name": "Premium Basmati Rice",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 900.00,
          "originalPrice": 1000.00,
          "discountLabel": "10% OFF",
          "quantity": "5kg",
        },
        "4": {
          "id": 4,
          "name": "Amul Full Cream Milk",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 60.00,
          "originalPrice": 65.00,
          "discountLabel": "8% OFF",
          "quantity": "1 litre",
        },
        "5": {
          "id": 5,
          "name": "Brown Eggs (Farm Fresh)",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 90.00,
          "originalPrice": null,
          "discountLabel": null,
          "quantity": "12 pcs",
        },
        "6": {
          "id": 6,
          "name": "Tata Salt (Iodized)",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 25.00,
          "originalPrice": 30.00,
          "discountLabel": "Save ₹5",
          "quantity": "1kg",
        },
        "7": {
          "id": 7,
          "name": "Sunflower Oil (Fortified)",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 145.00,
          "originalPrice": 160.00,
          "discountLabel": "₹15 OFF",
          "quantity": "1 litre",
        },
        "8": {
          "id": 8,
          "name": "Toned Curd (Pouch)",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 25.00,
          "originalPrice": null,
          "discountLabel": null,
          "quantity": "500g",
        },
        "9": {
          "id": 9,
          "name": "Potatoes (Desi)",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 30.00,
          "originalPrice": 40.00,
          "discountLabel": "25% OFF",
          "quantity": "1kg",
        },
        "10": {
          "id": 10,
          "name": "Broccoli (Fresh)",
          "image":
              "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
          "price": 75.00,
          "originalPrice": 90.00,
          "discountLabel": "Save ₹15",
          "quantity": "500g",
        },
      };

      // Convert dummy data to ProductModel list
      _products =
          dummyData.entries
              .map((entry) => ProductModel.fromMap(entry.key, entry.value))
              .toList();

      filteredProducts = List.from(_products);
    } catch (e) {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Failed to fetch products",
      );
      _products = [];
    } finally {
      isProductLoading = false;
      notifyListeners();
    }
  }

  Future<void> placeOrder(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }
    if (_cart.isEmpty) {
      GlobalSnackbar.error(context, "Cart is empty!");
      return;
    }

    final isLoggedIn = await AuthService().isLoggedIn();
    if (!isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Login()));
      return;
    }
    isOrderPlacing = true;
    notifyListeners();

    // try {
    //   // 1. Prepare order data
    //   final orderId =
    //       DateTime.now().millisecondsSinceEpoch.toString(); // unique order id
    //   final orderTimestamp = DateTime.now().toIso8601String();
    //   final orderStatus = "Pending";

    //   // 2. Format cart items for Firebase
    //   final orderItems =
    //       _cart
    //           .map(
    //             (cartItem) => {
    //               "productId": cartItem.product.id,
    //               "name": cartItem.product.name,
    //               "quantity": cartItem.quantity,
    //               "price": cartItem.product.price,
    //               "total": cartItem.product.price * cartItem.quantity,
    //               "image": cartItem.product.image,
    //             },
    //           )
    //           .toList();

    //   // 4. Order data map
    //   final orderData = {
    //     "orderId": orderId,
    //     "timestamp": orderTimestamp,
    //     "status": orderStatus,
    //     "items": orderItems,
    //     "totalPrice": totalPrice,
    //   };

    //   await OrderService().placeOrderToFirebase(orderId, orderData);

    //   // 6. Clear cart after order placed
    //   _cart.clear();

    //   // 7. Notify listeners
    //   notifyListeners();

    //   // // 8. Show confirmation snackbar or notification
    //   // GlobalSnackbar.success(
    //   //   navigatorKey.currentContext!,
    //   //   "Order placed successfully!",
    //   // );

    //   await NotificationHelper().showNotification(
    //     id: 0,
    //     title: 'Order Confirmed 🎉',
    //     body:
    //         'Your order #$orderId has been placed successfully! '
    //         'We will notify you when it is out for delivery.',
    //   );
    //   Navigator.push(
    //     context,
    //     PageTransition(
    //       type: PageTransitionType.rightToLeft, // or try fade, scale, etc.
    //       duration: const Duration(milliseconds: 300),
    //       child: OrderConfirmationScreen(orderData: orderData),
    //     ),
    //   );
    // } catch (e) {
    //   GlobalSnackbar.error(
    //     navigatorKey.currentContext!,
    //     "Failed to place order: $e",
    //   );
    // } finally {
    //   isOrderPlacing = false;
    //   notifyListeners();
    // }
  }
}
