import 'package:flutter/material.dart';
import 'package:gkmarts/Services/Razorpay/razorpay_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayProvider with ChangeNotifier {
  late Razorpay _razorpay;
  static const String _razorKey = "rzp_test_uXD0ztJrdB9WVt";

  Function(PaymentSuccessResponse response)? _onSuccess;
  Function(int code, String message)? _onFailure;

  RazorpayProvider() {
    _razorpay = Razorpay();
    _initializeListeners();
  }

  void _initializeListeners() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startPayment({
    required int amount,
    required String? phone,
    // required String name,
    // required String email,
    required Function(PaymentSuccessResponse response) onSuccess,
    required Function(int code, String message) onFailure,
  }) async {
    _onSuccess = onSuccess;
    _onFailure = onFailure;

    String? orderId;
    try {
      orderId = await RazorpayService.createOrder(amount: amount);
    } catch (e) {
      debugPrint('❌ Error creating Razorpay order: $e');
      _onFailure?.call(-1, "Order creation failed");
      return;
    }

    if (orderId == null) {
      _onFailure?.call(-1, "Failed to create order");
      return;
    }

    var options = {
      'key': _razorKey,
      'amount': amount,
      // 'name': name,
      'order_id': orderId,
      'description': 'Turf Booking',
      'prefill': {
        'contact': phone,
        // 'email': email
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('❌ Razorpay open error: $e');
      _onFailure?.call(-1, e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("✅ Razorpay Payment Successful:");
    debugPrint("Payment ID: ${response.paymentId}");
    debugPrint("Order ID: ${response.orderId}");
    debugPrint("Signature: ${response.signature}");

    _onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Message: ${response.message}");

    _onFailure?.call(response.code ?? -1, response.message ?? 'Unknown error');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("💼 External Wallet selected: ${response.walletName}");
  }

  void disposeRazorpay() {
    _razorpay.clear();
    _onSuccess = null;
    _onFailure = null;
  }
}
