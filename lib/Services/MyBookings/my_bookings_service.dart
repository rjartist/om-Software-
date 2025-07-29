import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/SharedPrefHelper/shared_local_storage.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';

class MyBookingsService {
  Future<RestResponse> getMyBookings(BuildContext context) async {
    final userId =  SharedPrefHelper.getUserId();
    final endpoint = "$getbookingsApi/$userId";
    debugPrint("GET MyBookings Endpoint: $endpoint");
    try {
      ApiService apiService = ApiService(
        endpoint: "$getbookingsApi/$userId",
        body: "",
        method: HTTP_METHOD.GET,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }
}
