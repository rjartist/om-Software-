
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';


class PhonePePaymentProvider extends ChangeNotifier {


  bool isInitialized = false;
  String resultMessage = "";

  final String environment = "SANDBOX"; // or "PRODUCTION"
  final String merchantId = "TEST-M2283QQKJ8ABA_25072"; // use your test merchantId
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

  Future<void> startTransaction() async {
    const dummyRequest =
        '{ "merchantId": "TEST-M2283QQKJ8ABA_25072", "transactionId": "TID123456", "amount": 10000, "mobileNumber": "9999999999", "paymentInstrument": { "type": "PAY_PAGE" }, "callbackUrl": "https://webhook.site/..." }';

    try {
      Map<dynamic, dynamic>? response = await PhonePePaymentSdk.startTransaction(
        dummyRequest,
        "", // Not needed for Android
      );

      if (response != null) {
        final status = response['status'];
        final error = response['error'];
        resultMessage = (status == 'SUCCESS')
            ? "Payment Success"
            : "Payment Failed: $status\nError: $error";
      } else {
        resultMessage = "Transaction Interrupted or Canceled";
      }
    } catch (e) {
      resultMessage = "Transaction Error: $e";
    }
    notifyListeners();
  }


//-----------
  // // final String merchantId = "M2306160483220675579140";
  // // final String merchantId = "UATM2283QQKJ8ABA";
  // final String merchantId = "TEST-M2283QQKJ8ABA_25072";
  // final String environment = "SANDBOX";
  // final String clallBackUrl =
  //     "https://webhook.site/49295539-ea26-4890-a57e-821adbf47d57";

  // // Use only for SANDBOX testing, don't expose in PROD
  // // final String saltKey = "4495e7ce-0728-44bd-83da-d28553ee1d8d";
  // final String saltKey = "ZDZlNWNiYzYtYjg2NC00ZGMxLTgzZjktMjk0MWY3YWQ5N2Ez";
  // final String saltIndex = "1";

  // final String mobileNumber = "9999999999";
  // String checksum = "";
  // late String flowId;

  // String requestPayload = "";
  // String result = "";

  // Future<void> initializeSDK(String userId) async {
  //   try {
  //     flowId = "FLOW$userId${DateTime.now().millisecondsSinceEpoch}";

  //     bool isInitialized = await PhonePePaymentSdk.init(
  //       environment,
  //       merchantId,
  //       flowId,
  //       true, // enableLogging
  //     );

  //     result = 'PhonePe SDK Initialized - $isInitialized';
  //   } catch (error) {
  //     result = 'PhonePe SDK Initialization Failed: $error';
  //   }

  //   debugPrint(result);
  //   notifyListeners();
  // }

  // Future<void> startPhonePeTransaction() async {
  //   try {
  //     // Step 1: Prepare JSON payload
  //     final payload = {
  //       "merchantId": merchantId,
  //       "transactionId": "e474af20-a2a6-46c1-9a5d-73910ae86d0b",
  //       "merchantUserId": "e474af20-a2a6-46c1-9a5d-73910ae86d0b",
  //       "amount": 200, // in paise = ₹2.00
  //       "merchantOrderId": "OD139924923",
  //       "mobileNumber": mobileNumber,
  //       "message": "Order Payment",
  //       "shortName": "Test User",
  //       "paymentScope": "PHONEPE",
  //       "deviceContext": {"phonePeVersionCode": 303391},
  //     };

  //     // Step 2: Encode payload as JSON
  //     String jsonPayload = jsonEncode(payload);

  //     // Step 3: Generate checksum
  //     const String apiPath = "/v4/debit";
  //     String base64Body = base64Encode(utf8.encode(jsonPayload));
  //     String toHash = "$base64Body$apiPath$saltKey";

  //     var hmacSha256 = Hmac(sha256, utf8.encode(saltKey));
  //     Digest digest = hmacSha256.convert(utf8.encode(toHash));
  //     checksum = "${base64Encode(digest.bytes)}###$saltIndex";

  //     debugPrint("Checksum: $checksum");

  //     // Step 4: Prepare final request payload
  //     requestPayload =
  //         Platform.isIOS
  //             ? base64Body // base64 for iOS
  //             : jsonPayload; // raw JSON for Android

  //     // Step 5: Start Transaction
  //     Map<dynamic, dynamic>? response =
  //         await PhonePePaymentSdk.startTransaction(
  //           requestPayload,
  //           "", // leave appSchema empty for Android
  //         );

  //     // Step 6: Handle SDK response
  //     if (response != null) {
  //       String status = response['status'].toString();
  //       String error = response['error']?.toString() ?? "None";

  //       switch (status) {
  //         case 'SUCCESS':
  //           result = "✅ Payment Successful";
  //           break;
  //         case 'FAILURE':
  //           result = "❌ Payment Failed: $error";
  //           break;
  //         case 'INTERRUPTED':
  //           result = "⚠️ Payment Interrupted: $error";
  //           break;
  //         default:
  //           result = "⚠️ Unknown Status: $status | Error: $error";
  //       }
  //     } else {
  //       result = "❌ Payment Flow Incomplete (No response)";
  //     }
  //   } catch (e) {
  //     result = "🚫 Transaction Exception: $e";
  //   }

  //   debugPrint(result);
  //   notifyListeners();
  // }

  // String calculateChecksumForV4API({
  //   required String payloadJson,
  //   required String saltKey,
  //   required String saltIndex,
  // }) {
  //   const String apiPath = "/v4/debit"; // <-- matches your POST endpoint
  //   String base64Body = base64Encode(utf8.encode(payloadJson));
  //   String toHash = "$base64Body$apiPath$saltKey";

  //   var hmacSha256 = Hmac(sha256, utf8.encode(saltKey));
  //   Digest digest = hmacSha256.convert(utf8.encode(toHash));
  //   return "${base64Encode(digest.bytes)}###$saltIndex";
  // }
}




// class PhonePePaymentScreen extends StatefulWidget {
//   @override
//   _PhonePePaymentScreenState createState() => _PhonePePaymentScreenState();
// }

// class _PhonePePaymentScreenState extends State<PhonePePaymentScreen> {
//   String result = "Idle";

//   final String environment = "SANDBOX"; // or "PRODUCTION"
//   final String merchantId = "UATM2283QQKJ8ABA"; // your PhonePe merchant ID
//   final String flowId = "testuserflow001"; // any unique alphanumeric ID (no special chars)
//   final bool enableLogs = true; // false in PRODUCTION

//   @override
//   void initState() {
//     super.initState();
//     initPhonePeSDK();
//   }

//   Future<void> initPhonePeSDK() async {
//     try {
//       bool isInitialized = await PhonePePaymentSdk.init(
//           environment, merchantId, flowId, enableLogs);

//       setState(() {
//         result = 'PhonePe SDK Initialized: $isInitialized';
//       });
//     } catch (e) {
//       setState(() {
//         result = "Init failed: $e";
//       });
//     }
//   }

//   Future<void> startPhonePeTransaction() async {
//     try {
//       // Replace this with your actual request payload (JSON string)
//       final String requestPayload = "{...}"; // Step 3 from server-side docs

//       // Only needed on iOS, but must pass empty or dummy string on Android
//       final String appSchema = ""; // or "yourappscheme://" on iOS

//       final response =
//           await PhonePePaymentSdk.startTransaction(requestPayload, appSchema);

//       if (response != null) {
//         String status = response['status'].toString();
//         String error = response['error'].toString();

//         setState(() {
//           result = status == 'SUCCESS'
//               ? "Flow Completed - Status: SUCCESS"
//               : "Flow Completed - Status: $status, Error: $error";
//         });
//       } else {
//         setState(() {
//           result = "Flow Incomplete";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         result = "Transaction failed: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("PhonePe Payment")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: startPhonePeTransaction,
//               child: Text("Pay with PhonePe"),
//             ),
//             SizedBox(height: 20),
//             Text(result),
//           ],
//         ),
//       ),
//     );
//   }
// }
