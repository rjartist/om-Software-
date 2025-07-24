// // 📦 Final & Clean Dart File for REST API Handling (with working enum, error-safe client)

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

// ✅ 1. Define HTTP methods enum
enum HTTP_METHOD { GET, POST, PUT, PATCH, DELETE }

// ✅ 2. Response wrapper class
class RestResponse {
  bool isSuccess;
  int? statusCode;
  String responseData;
  String errMsg;
  String message;
  Map<String, dynamic> json;

  RestResponse({
    required this.isSuccess,
    this.statusCode,
    this.responseData = '',
    this.errMsg = '',
    this.message = '',
    this.json = const {},
  });
}

// ✅ 3. ApiService class
class ApiService {
  final String endpoint;
  final String body;
  final Map<String, String> headers;
  final HTTP_METHOD method;

  late http.Response response;

  ApiService({
    required this.endpoint,
    required this.body,
    required this.method,
    required this.headers,
  });

  Future<RestResponse> exec() async {
    final res = RestResponse(isSuccess: false);

    try {
      response = await _makeApiRequest().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException("Request timed out"),
      );

      res.statusCode = response.statusCode;
      res.responseData = response.body;

      // Log (you can replace this with debugPrint or print)
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        res.json = decoded;
        res.message = decoded['message'] ?? '';
        res.isSuccess = decoded['success'] == true;

        if (!res.isSuccess) {
          res.errMsg = decoded['message'] ?? "Operation failed";
        }
      } else {
        res.errMsg = "Invalid response format from server.";
      }
    } catch (e) {
      res.errMsg = _parseException(e);
    }

    return res;
  }

  String _parseException(dynamic exc) {
    final msg = exc.toString();
    if (msg.contains("timed out")) return "The request timed out.";
    if (msg.contains("host lookup")) return "Check your internet connection.";
    if (msg.contains("refused")) return "Server refused the connection.";
    return "Error occurred: \$msg";
  }

  Future<http.Response> _makeApiRequest() {
    final client = accopsHttpClient();
    final uri = Uri.parse(endpoint);

    switch (method) {
      case HTTP_METHOD.GET:
        return client.get(uri, headers: headers);
      case HTTP_METHOD.POST:
        return client.post(uri, headers: headers, body: body);
      case HTTP_METHOD.PUT:
        return client.put(uri, headers: headers, body: body);
      case HTTP_METHOD.PATCH:
        return client.patch(uri, headers: headers, body: body);
      case HTTP_METHOD.DELETE:
        return client.delete(uri, headers: headers, body: body);
    }
  }
}

// ✅ 4. Secure HttpClient with invalid cert allowance (if needed)
http.Client accopsHttpClient({bool allowInvalidCerts = false}) {
  final ioClient = HttpClient();
  ioClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) => allowInvalidCerts;

  return IOClient(ioClient);
}


// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:gkmarts/Utils/global/global.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';

// // HTTP Method Enum
// enum HTTP_METHOD { POST, GET, PUT, PATCH, DELETE }

// // Response Class
// class RestResponse {
//   bool isSuccess;
//   int? statusCode;
//   String responseData;
//   String errMsg;
//   String message;
//   Map<String, dynamic> json;

//   RestResponse({
//     required this.isSuccess,
//     this.statusCode,
//     this.responseData = "",
//     this.errMsg = "",
//     this.message = "",
//     this.json = const {},
//   });
// }

// // ApiService Class
// class ApiService {
//   final String endpoint;
//   final String body;
//   final Map<String, String> headers;
//   final HTTP_METHOD method;

//   late http.Response response;

//   ApiService({
//     required this.endpoint,
//     required this.body,
//     required this.method,
//     required this.headers,
//   });

//   Future<RestResponse> exec() async {
//     RestResponse res = RestResponse(isSuccess: false);

//     try {
//       response = await _makeApiRequest().timeout(
//         const Duration(seconds: 60),
//         onTimeout: () => throw TimeoutException("Request timed out"),
//       );

//       res.statusCode = response.statusCode;
//       res.responseData = response.body;

//       print("Response Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (decoded is Map<String, dynamic>) {
//           res.json = decoded;
//           res.message = decoded['message'] ?? '';
//           res.isSuccess = decoded['success'] == true;

//           if (!res.isSuccess) {
//             res.errMsg = decoded['message'] ?? "Operation failed";
//           }
//         } else {
//           res.errMsg = "Invalid response format from server.";
//         }
//       } else {
//         res.errMsg = response.reasonPhrase ?? "Unknown error";
//       }
//     } catch (e) {
//       res.errMsg = _parseException(e);
//     }

//     return res;
//   }

//   Future<http.Response> _makeApiRequest() {
//     final client = accopsHttpClient(allowInvalidCerts: true);
//     final uri = Uri.parse(endpoint);

//     switch (method) {
//       case HTTP_METHOD.GET:
//         return client.get(uri, headers: headers);
//       case HTTP_METHOD.POST:
//         return client.post(uri, headers: headers, body: body);
//       case HTTP_METHOD.PUT:
//         return client.put(uri, headers: headers, body: body);
//       case HTTP_METHOD.PATCH:
//         return client.patch(uri, headers: headers, body: body);
//       case HTTP_METHOD.DELETE:
//         return client.delete(uri, headers: headers, body: body);
//     }
//   }

//   String _parseException(dynamic exc) {
//     final msg = exc.toString();
//     if (msg.contains("timed out")) return "The request timed out. Please try again later.";
//     if (msg.contains("host lookup")) return "Failed to connect. Check your internet connection.";
//     if (msg.contains("refused")) return "Connection refused. Please try again later.";
//     return "Error occurred: $msg";
//   }
// }

// // HTTP Client Allowing Invalid Certificates
// http.Client accopsHttpClient({bool allowInvalidCerts = false}) {
//   var ioClient = HttpClient()
//     ..badCertificateCallback = (X509Certificate cert, String host, int port) => allowInvalidCerts;
//   ioClient.connectionTimeout = const Duration(seconds: 30);
//   ioClient.idleTimeout = const Duration(seconds: 30);
//   return IOClient(ioClient);
// }