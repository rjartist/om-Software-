import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Widget/global.dart';


import 'package:provider/provider.dart';

class HttpHeader {
  static Future<Map<String, String>> getHeader() async {
    final authToken = await AuthService.getAccessToken();
    print("authToken   $authToken");
    if (authToken == null || authToken.isEmpty) {
      // Optionally return header without token or handle error
      return getLoginHeader();
    }

    return {
      "Authorization": "Bearer $authToken",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept": "*/*",
    };
  }

  static Map<String, String> getLoginHeader() {
    return {
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept": "*/*",
    };
  }
}
