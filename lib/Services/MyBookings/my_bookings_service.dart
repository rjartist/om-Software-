import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Profile/profile_page_provider.dart';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';
import 'package:provider/provider.dart';

class MyBookingsService {
  Future<RestResponse> getMyBookings(BuildContext context) async {
    final userId =
        Provider.of<ProfileProvider>(context, listen: false).user?.user?.userId;
    try {
      ApiService apiService = ApiService(
        endpoint:
            "https://devapi.cxplayground.in:7005/api/bookings/user/${userId}",
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
