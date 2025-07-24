import 'package:gkmarts/Services/Api_service/api_service.dart';
import 'package:gkmarts/Utils/endpoint.dart';
import 'package:gkmarts/Utils/headers.dart';

class MyFavoritesService {
  Future getMyFavorites() async {
    try {
      ApiService apiService = ApiService(
        endpoint: getfavoritesApi,
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
