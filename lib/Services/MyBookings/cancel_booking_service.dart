import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Profile/profile_page_provider.dart';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';
import 'package:provider/provider.dart';

class CancelBookingService {
  Future<RestResponse> cancelBooking(reqBody) async {
    try {
      ApiService apiService = ApiService(
        endpoint: cancelBookingApi,
        body: jsonEncode(reqBody),
        method: HTTP_METHOD.POST,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }
}
