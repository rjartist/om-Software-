import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';
import 'package:provider/provider.dart';

class LoginService {

    Future<RestResponse> loginStudent(reqBody) async {
    try {
      ApiService apiService = ApiService(
          endpoint: getLoginApi,
          body: jsonEncode(reqBody),
          method: HTTP_METHOD.POST,
          headers: HttpHeader.getLoginHeader());
      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

}
