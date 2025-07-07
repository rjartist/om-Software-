import 'package:flutter/material.dart';
import 'package:gkmarts/Models/General/MyOredrs/my_order_details.dart';
import 'package:gkmarts/Models/General/MyOredrs/my_order_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:provider/provider.dart';

class GeneralProvider extends ChangeNotifier {
  // My Orders list
  List<MyOrderModel> _orders = [];
  List<MyOrderModel> get orders => _orders;

  bool isOrderLoading = false;

  // Order detail
  MyOrderDetailModel? _orderDetail;
  MyOrderDetailModel? get orderDetail => _orderDetail;

  bool isOrderDetailLoading = false;

  // -------------------- GET ORDERS (LIST) --------------------
  Future<void> getOrders(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isOrderLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simulated delay

    try {
      final List<Map<String, dynamic>> dummyOrders = [
        {
          "id": 101,
          "status": "Delivered",
          "date": "2025-06-28T10:00:00Z",
          "totalAmount": 345.50,
        },
        {
          "id": 102,
          "status": "Processing",
          "date": "2025-06-30T14:30:00Z",
          "totalAmount": 250.00,
        },
      ];

      _orders = dummyOrders.map((json) => MyOrderModel.fromJson(json)).toList();
    } catch (e) {
      GlobalSnackbar.error(context, "Failed to fetch orders");
      _orders = [];
    } finally {
      isOrderLoading = false;
      notifyListeners();
    }
  }

  // -------------------- GET ORDER DETAIL --------------------
  Future<void> getOrderDetails(BuildContext context, int orderId) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;

    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isOrderDetailLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simulate delay

    try {
      final Map<String, dynamic> dummyDetail = {
        "id": orderId,
        "status": "Delivered",
        "date": "2025-06-28T10:00:00Z",
        "totalAmount": 345.50,
        "paymentMethod": "UPI",
        "deliveryAddress": "Flat 202, Garden View, Pune",
        "deliveryCharge": 30.0,
        "items": [
          {
            "productId": 1,
            "name": "Fresh Apples",
            "image":
                "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
            "quantity": 2,
            "price": 120.50,
            "originalPrice": 150.00,
            "discountLabel": "20% OFF",
            "unit": "1kg",
          },
          {
            "productId": 4,
            "name": "Amul Full Cream Milk",
            "image":
                "https://cdn.pixabay.com/photo/2020/05/22/03/10/vegetables-5203555_640.jpg",
            "quantity": 1,
            "price": 60.00,
            "unit": "1 litre",
          },
        ],
      };

      _orderDetail = MyOrderDetailModel.fromJson(dummyDetail);
    } catch (e) {
      GlobalSnackbar.error(context, "Failed to load order details");
      _orderDetail = null;
    } finally {
      isOrderDetailLoading = false;
      notifyListeners();
    }
  }

  // Optional: clear order detail (when exiting detail screen)
  void clearOrderDetail() {
    _orderDetail = null;
    notifyListeners();
  }
}
