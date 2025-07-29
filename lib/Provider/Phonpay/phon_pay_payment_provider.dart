import 'package:flutter/foundation.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhonePePaymentProvider extends ChangeNotifier {
  bool isInitialized = false;
  String resultMessage = "";
  String transactionStatus = "";

  final String environment = "SANDBOX";
  // final String merchantId = "TEST-M2283QQKJ8ABA_25072"; // Your merchant ID
  final String merchantId = "UATM2283QQKJ8ABA"; // Your merchant ID
  final String appId = ""; // Usually empty
  // final String backendUrl = "http://10.0.2.2:5000"; // use localhost or IP
  final String backendUrl =
      "http://192.168.169.64:5000"; // ✅ Use your local IP here

  final String merchantTransactionId =
      "TXN_${DateTime.now().millisecondsSinceEpoch}";

  final String flowId = "testuserflow001";

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

  Future<void> startPayment({
    required int amount,
    required String userId,
  }) async {
    try {
      // STEP 1: Call backend to get token & orderId
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

        // STEP 2.2: Prepare request body
        // final paymentBody = {
        //   "orderId": merchantTransactionId,
        //   "merchantId": merchantId,
        //   "token": token,
        //   "paymentInstrument": {"type": "PAY_PAGE"},
        // };
        final paymentBody = {
          "orderId": merchantTransactionId,
          "merchantId": merchantId,
          "token": token, // comes from backend Create Order API
          "paymentMode": {"type": "PAY_PAGE"},
        };

        final bodyJson = jsonEncode(paymentBody);

        // STEP 2.3: Start transaction — only pass request body and appSchema
        final result = await PhonePePaymentSdk.startTransaction(
          bodyJson,
          "", // replace this with your app schema for iOS; for Android can be empty
        );

        // STEP 2.4: Handle response
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
