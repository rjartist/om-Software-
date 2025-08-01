// import 'dart:convert';
// import 'dart:io';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:http/http.dart' as http;


// class PhonePePaymentProvider extends ChangeNotifier {
//   String? accessToken;
// int? tokenExpiry;

//   String merchantId = "UATM2283QQKJ8ABA";
//   String saltKey = "4495e7ce-0728-44bd-83da-d28553ee1d8d";
//   String saltIndex = "1";
//   String environment = "SANDBOX";
//   String appPackageName = "com.omsoftware.cxplayground";

//   Object? result;
//   String requestPayload = "";


//   Future<void> fetchAuthToken() async {
//   final url = Uri.parse('https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token');

//   final headers = {
//     'Content-Type': 'application/x-www-form-urlencoded',
//   };

//   final body = {
//     'client_id': 'YOUR_CLIENT_ID',          // ✅ Replace with real client ID
//     'client_version': '1',
//     'client_secret': 'YOUR_CLIENT_SECRET',  // ✅ Replace with real secret
//     'grant_type': 'client_credentials',
//   };

//   try {
//     final response = await http.post(url, headers: headers, body: body);

//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);
//       accessToken = json['access_token'];
//       tokenExpiry = json['expires_at'];
//       result = "Token fetched successfully!";
//     } else {
//       result = "Failed to fetch token: ${response.statusCode} ${response.body}";
//     }
//   } catch (e) {
//     result = "Token fetch error: $e";
//   }

//   notifyListeners();
// }


//   Future<void> initPhonePeSdk() async {
//     try {
//       bool isInitialized = await PhonePePaymentSdk.init(
//         environment,
//         merchantId,
//         appPackageName,
//         true, // Enable Logs
//       );
//       result = "SDK Initialized: $isInitialized";
//     } catch (error) {
//       result = error.toString();
//     }
//     notifyListeners();
//   }

//   Future<void> startTransaction() async {
//     final txnId = "TXN${DateTime.now().millisecondsSinceEpoch}";
//     final amount = 1000; // Amount in paisa (₹10)

//     Map<String, dynamic> paymentData = {
//       "merchantId": merchantId,
//       "transactionId": txnId,
//       "orderId": txnId,
//       "amount": amount,
//       "merchantUserId": "User123",
//       "mobileNumber": "9999999999",
//       "paymentInstrument": {
//         "type": "UPI_INTENT",
//         "targetApp": "com.phonepe.app",
//       },
//       "callbackUrl": "https://webhook.site/abcd1234",
//     };

//     requestPayload = jsonEncode(paymentData);

//     String checksum = generateChecksum(requestPayload);

//     try {
//       final response = await PhonePePaymentSdk.startTransaction(
//         requestPayload,
//         checksum,
//       );

//       if (response != null) {
//            print("SDK Result => Status: ${response['status']}, Error: ${response['error']}");
//         result =
//             "Transaction Status: ${response['status']}\n${response.toString()}";
//       } else {
//         result = "No response from SDK.";
//       }
//     } catch (error) {
//       result = error.toString();
//     }
//     notifyListeners();
//   }

//   String generateChecksum(String payload) {
//     final base64Payload = base64Encode(utf8.encode(payload));
//     const txnPath = "/api/v3/transaction/initiate";
//     final stringToHash = "$base64Payload$txnPath$saltKey";
//     final bytes = utf8.encode(stringToHash);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   Future<void> getInstalledUpiApps() async {
//     try {
//       final apps = await PhonePePaymentSdk.getUpiAppsForAndroid();
//       result =
//           apps != null ? "Installed UPI Apps: $apps" : "No UPI apps found.";
//     } catch (error) {
//       result = error.toString();
//     }
//     notifyListeners();
//   }
// }

