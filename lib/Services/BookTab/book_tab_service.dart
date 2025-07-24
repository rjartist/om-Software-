import 'dart:convert';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';

class BookTabService {
Future<RestResponse>getReviewsService(
    int venueId,

  ) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getReviewsApi,
        body: jsonEncode({"venueId": venueId}),
        method: HTTP_METHOD.POST,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }


   Future<RestResponse> checkTurfAvailableService({
    required Map<String, dynamic> reqBody,
  }) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getcheckTurfAvailableServiceApi,
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
  Future<RestResponse> proceedToPayService({
    required Map<String, dynamic> reqBody,
  }) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getProceedToPayApi,
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

  Future<RestResponse> rateVenueService({
    required int venueId,
    required int bookingId,
    required int rating,
    required String feedback,
  }) async {
    try {
      final bodyData = {
        "venueId": venueId,
        "bookingId": bookingId,
        "rating": rating,
        "feedback": feedback,
      };

      ApiService apiService = ApiService(
        endpoint: getRateVenueApi,
        body: jsonEncode(bodyData),
        method: HTTP_METHOD.POST,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

  Future<RestResponse> applyCouponService(
    int totalPrice,
    String couponCode,
  ) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getApplyCouponApi,
        body: jsonEncode({"totalPrice": totalPrice, "couponCode": couponCode}),
        // body: jsonEncode({"totalPrice": 500, "couponCode": couponCode}),
        method: HTTP_METHOD.POST,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

  Future<RestResponse> getCouponService() async {
    try {
      ApiService apiService = ApiService(
        endpoint: getCouponApi,
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

  Future<RestResponse> getSlotPriceService(int venueId, int sportId) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getSlotPriceApi,
        body: jsonEncode({"venueId": venueId, "sportId": sportId}),
        // body: jsonEncode({"venueId": 43, "sportId": 55}),
        method: HTTP_METHOD.POST,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

  Future<RestResponse> addFavoriteService(int venueId) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getfavoriteApi,
        body: jsonEncode({"venueId": venueId}),
        method: HTTP_METHOD.POST,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

  Future<RestResponse> getAllVenueDetailsServices(int facilityId) async {
    try {
      ApiService apiService = ApiService(
        endpoint: "$getVenueDetailsApi/$facilityId",
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
