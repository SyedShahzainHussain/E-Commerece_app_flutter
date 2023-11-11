import 'dart:convert';
import 'dart:io';
import 'package:e_commerce/data/network/app_exception.dart';
import 'package:e_commerce/data/network/base_api_services.dart';
import 'package:http/http.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await get(Uri.parse(url));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }





  @override
  Future getPostApiResponse(String url, dynamic body) async {
    dynamic responseJson;
    try {
      final response = await post(Uri.parse(url), body: body)
          ;
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

    

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
      case 500:
      case 404:
        try {
          final errorMessage = jsonDecode(response.body)['message'] ?? '';
          throw BadRequestException(
            errorMessage,
          );
        } catch (e) {
          throw FetchDataException(e.toString());
        }
      default:
        throw FetchDataException(
            'Error occured while communicate with serverwith status code${response.statusCode}');
    }
  }
}
