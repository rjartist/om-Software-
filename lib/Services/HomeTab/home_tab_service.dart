import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';

class HomeTabService {
  Future<RestResponse> getUserCoinsService() async {
    try {
      ApiService apiService = ApiService(
        endpoint: getCoinsApi,
        body: "",
        method: HTTP_METHOD.POST,
        headers: await HttpHeader.getHeader(),
      );
      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

  Future<RestResponse> getAllVenueServices({required String city}) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getAllVenueApi,
        body: jsonEncode({"city": city}),
        method: HTTP_METHOD.POST,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

  Future<RestResponse> getBannerService() async {
    try {
      ApiService apiService = ApiService(
        endpoint: getBannerApi,
        body: "",
        method: HTTP_METHOD.POST,
        headers: HttpHeader.getLoginHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }
}
