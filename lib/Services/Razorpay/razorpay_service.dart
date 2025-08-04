import 'dart:convert';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';
import 'package:http/http.dart' as http;

class RazorpayService {
  Future<RestResponse> getorderid({required double amount}) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getOrderIdApi,
        body: jsonEncode({"totalPrice": amount}),
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
