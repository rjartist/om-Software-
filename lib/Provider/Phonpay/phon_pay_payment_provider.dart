import 'package:flutter/foundation.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhonePePaymentProvider extends ChangeNotifier {
  bool isInitialized = false;
  String resultMessage = "";
  String transactionStatus = "";

  final String environment = "SANDBOX";
  final String merchantId = "UATM2283QQKJ8ABA"; // ✅ Your merchant ID
  final String appId = ""; // Usually empty
  final String backendUrl =
      "http://192.168.6.64:5000"; // 👈 your local server IP
  // ✅ Your local Node.js server
  final String flowId = "testuserflow001";

  /// ✅ Step 1: Initialize PhonePe SDK
  Future<void> initPhonePeSDK() async {
    try {
      isInitialized = await PhonePePaymentSdk.init(
        environment,
        merchantId,
        flowId,
        true, // logging enabled for sandbox
      );
      resultMessage = "SDK Initialized: $isInitialized";
    } catch (e) {
      resultMessage = "Init failed: $e";
    }
    notifyListeners();
  }

  /// ✅ Step 2: Start the payment transaction
  Future<void> startPayment({
    required int amount,
    required String userId,
  }) async {
    try {
      final String merchantTransactionId =
          "TXN_${DateTime.now().millisecondsSinceEpoch}";

      final response = await http.post(
        Uri.parse('$backendUrl/generate-token'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": amount,
          "merchantTransactionId": merchantTransactionId,
          "merchantUserId": userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];

        // ✅ Step 2: Prepare request
        final paymentBody = {
          "orderId": merchantTransactionId,
          "merchantId": merchantId,
          "token": token,
          "paymentMode": {"type": "PAY_PAGE"},
        };

        final bodyJson = jsonEncode(paymentBody);

        // ✅ Step 3: Start transaction
        final result = await PhonePePaymentSdk.startTransaction(
          bodyJson,
          "", // iOS only; leave empty for Android
        );

        // ✅ Step 4: Handle result
        if (result != null) {
          final status = result['status']?.toString() ?? "UNKNOWN";
          final error = result['error']?.toString() ?? "No error";
          transactionStatus = "Transaction Status: $status\nError: $error";
        } else {
          transactionStatus = "Transaction cancelled or no response.";
        }
      } else {
        transactionStatus =
            "Failed to get token (status ${response.statusCode})";
      }
    } catch (e) {
      transactionStatus = "Payment error: $e";
    }

    notifyListeners();
  }
}
