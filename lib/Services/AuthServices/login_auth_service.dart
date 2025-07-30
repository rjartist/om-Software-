import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Profile/profile_page_provider.dart';
import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class LoginAuthService {

  Future<RestResponse> verifyOtpService(String mobileNo, String otp) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getVerifyOtpApi,
        body: jsonEncode({"phoneNumber": mobileNo, "otp": otp}),
        method: HTTP_METHOD.POST,
        headers: HttpHeader.getLoginHeader(),
      );
      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }

   Future<RestResponse> sendOtpService(String mobileNo) async {
    try {
      ApiService apiService = ApiService(
        endpoint: getSendOtpApi,
        body: jsonEncode({"phoneNumber": mobileNo}),
        method: HTTP_METHOD.POST,
        headers: HttpHeader.getLoginHeader(),
      );
      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }



  Future<RestResponse> editProfile(
    Map<String, dynamic> reqBody, {
    File? imageFile,
  }) async {
    try {
      final uri = Uri.parse(editProfileApi); // your actual API endpoint
      final request = http.MultipartRequest('POST', uri);

      // Add form fields
      reqBody.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add the image file if available
      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path)?.split('/');
        if (mimeType != null && mimeType.length == 2) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'profileImage', // backend key
              imageFile.path,
              contentType: MediaType(mimeType[0], mimeType[1]),
            ),
          );
        }
      }

      // Add auth headers
      final headers = await HttpHeader.getHeader();
      request.headers.addAll(headers);

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return RestResponse(
        isSuccess: response.statusCode >= 200 && response.statusCode < 300,
        message: json.decode(response.body)['message'],
        responseData: response.body,
      );
    } catch (e) {
      return RestResponse(isSuccess: false, message: e.toString());
    }
  }
  // Future editProfile(reqBody) async {
  //   try {
  //     ApiService apiService = ApiService(
  //       endpoint: editProfileApi,
  //       body: jsonEncode(reqBody),
  //       method: HTTP_METHOD.POST,
  //       headers: await HttpHeader.getHeader(),
  //     );

  //     RestResponse response = await apiService.exec();
  //     return response;
  //   } catch (e) {
  //     return RestResponse(isSuccess: false);
  //   }
  // }

  Future getProfile() async {
    try {
      ApiService apiService = ApiService(
        endpoint: getProfileApi,
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

  Future logoutService() async {
    try {
      ApiService apiService = ApiService(
        endpoint: getLogoutApi,
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

  Future deleteAccountService(BuildContext context) async {
    final userId =
        Provider.of<ProfileProvider>(context, listen: false).user?.user?.userId;
    try {
      ApiService apiService = ApiService(
        endpoint:
            "https://devapi.cxplayground.in:7005/api/user/${userId}/delete",
        body: "",
        method: HTTP_METHOD.DELETE,
        headers: await HttpHeader.getHeader(),
      );

      RestResponse response = await apiService.exec();
      return response;
    } catch (e) {
      return RestResponse(isSuccess: false);
    }
  }
}
