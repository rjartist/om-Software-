import 'package:gkmarts/Services/AuthServices/auth_services.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Utils/global/global.dart';

import 'package:provider/provider.dart';

class HttpHeader {
  static Future<Map<String, String>> getHeader() async {
    String? authToken = await AuthService().getAccessToken();

    printLog("authToken From Header: $authToken");

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
