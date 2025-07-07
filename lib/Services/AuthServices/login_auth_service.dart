import 'dart:convert';

import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Services/Login/login_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';

class LoginAuthService {
  Future loginService(reqBody) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getLoginApi,
        body: jsonEncode(reqBody),
        method: HTTP_METHOD.POST,
        headers: HttpHeader.getLoginHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

  Future<RestResponse> signUpService(Map<String, dynamic> reqBody) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getSignupApi,
        body: jsonEncode(reqBody), // ✅ Pass the request body
        method: HTTP_METHOD.POST,
        headers: HttpHeader.getLoginHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false, errMsg: e.toString());
    }
  }
}
