import 'dart:convert';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:http/http.dart' as http;

class RazorpayService {
static const String _baseUrl = "http://192.168.25.64:5000";

  static Future<String?> createOrder({required int amount}) async {
    try {
      final url = Uri.parse("$_baseUrl/create-razorpay-order");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"amount": amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id']; 
      } else {
    
        return null;
      }
    } catch (e) {

      return null;
    }
  }

  // Future<RestResponse> getorderid() async {
  //   try {
  //     ApiService apiService = ApiService(
  //       endpoint: getBookingCountApi,
  //       body: "",
  //       method: HTTP_METHOD.POST,
  //       headers: await HttpHeader.getHeader(),
  //     );

  //     RestResponse response = await apiService.exec();
  //     return response;
  //   } catch (e) {
  //     return RestResponse(isSuccess: false);
  //   }
  // }
}
