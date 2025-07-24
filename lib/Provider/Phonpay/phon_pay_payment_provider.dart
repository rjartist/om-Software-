import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:http/http.dart' as http;

class PhonePePaymentProvider extends ChangeNotifier {
  // final String merchantId = "M2306160483220675579140";
  // final String merchantId = "UATM2283QQKJ8ABA";
  final String merchantId = "TEST-M2283QQKJ8ABA_25072";
  final String environment = "SANDBOX";
  final String clallBackUrl =
      "https://webhook.site/49295539-ea26-4890-a57e-821adbf47d57";

  // Use only for SANDBOX testing, don't expose in PROD
  // final String saltKey = "4495e7ce-0728-44bd-83da-d28553ee1d8d";
  final String saltKey = "ZDZlNWNiYzYtYjg2NC00ZGMxLTgzZjktMjk0MWY3YWQ5N2Ez";
  final String saltIndex = "1";

  final String mobileNumber = "9999999999";
  String checksum = "";
  late String flowId;

  String requestPayload = "";
  String result = "";

  Future<void> initializeSDK(String userId) async {
    try {
      flowId = "FLOW$userId${DateTime.now().millisecondsSinceEpoch}";

      bool isInitialized = await PhonePePaymentSdk.init(
        environment,
        merchantId,
        flowId,
        true, // enableLogging
      );

      result = 'PhonePe SDK Initialized - $isInitialized';
    } catch (error) {
      result = 'PhonePe SDK Initialization Failed: $error';
    }

    debugPrint(result);
    notifyListeners();
  }

  Future<void> startPhonePeTransaction() async {
    try {
      // Step 1: Prepare JSON payload
      final payload = {
        "merchantId": merchantId,
        "transactionId": "e474af20-a2a6-46c1-9a5d-73910ae86d0b",
        "merchantUserId": "e474af20-a2a6-46c1-9a5d-73910ae86d0b",
        "amount": 200, // in paise = ₹2.00
        "merchantOrderId": "OD139924923",
        "mobileNumber": mobileNumber,
        "message": "Order Payment",
        "shortName": "Test User",
        "paymentScope": "PHONEPE",
        "deviceContext": {"phonePeVersionCode": 303391},
      };

      // Step 2: Encode payload as JSON
      String jsonPayload = jsonEncode(payload);

      // Step 3: Generate checksum
      const String apiPath = "/v4/debit";
      String base64Body = base64Encode(utf8.encode(jsonPayload));
      String toHash = "$base64Body$apiPath$saltKey";

      var hmacSha256 = Hmac(sha256, utf8.encode(saltKey));
      Digest digest = hmacSha256.convert(utf8.encode(toHash));
      checksum = "${base64Encode(digest.bytes)}###$saltIndex";

      debugPrint("Checksum: $checksum");

      // Step 4: Prepare final request payload
      requestPayload =
          Platform.isIOS
              ? base64Body // base64 for iOS
              : jsonPayload; // raw JSON for Android

      // Step 5: Start Transaction
      Map<dynamic, dynamic>? response =
          await PhonePePaymentSdk.startTransaction(
            requestPayload,
            "", // leave appSchema empty for Android
          );

      // Step 6: Handle SDK response
      if (response != null) {
        String status = response['status'].toString();
        String error = response['error']?.toString() ?? "None";

        switch (status) {
          case 'SUCCESS':
            result = "✅ Payment Successful";
            break;
          case 'FAILURE':
            result = "❌ Payment Failed: $error";
            break;
          case 'INTERRUPTED':
            result = "⚠️ Payment Interrupted: $error";
            break;
          default:
            result = "⚠️ Unknown Status: $status | Error: $error";
        }
      } else {
        result = "❌ Payment Flow Incomplete (No response)";
      }
    } catch (e) {
      result = "🚫 Transaction Exception: $e";
    }

    debugPrint(result);
    notifyListeners();
  }

  String calculateChecksumForV4API({
    required String payloadJson,
    required String saltKey,
    required String saltIndex,
  }) {
    const String apiPath = "/v4/debit"; // <-- matches your POST endpoint
    String base64Body = base64Encode(utf8.encode(payloadJson));
    String toHash = "$base64Body$apiPath$saltKey";

    var hmacSha256 = Hmac(sha256, utf8.encode(saltKey));
    Digest digest = hmacSha256.convert(utf8.encode(toHash));
    return "${base64Encode(digest.bytes)}###$saltIndex";
  }
}



