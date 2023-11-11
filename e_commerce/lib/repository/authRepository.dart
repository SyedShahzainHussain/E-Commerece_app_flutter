import 'package:e_commerce/constants/appUrl.dart';
import 'package:e_commerce/data/network/base_api_services.dart';
import 'package:e_commerce/data/network/network_api_services.dart';

class AuthRepository {

  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> getSignUp(dynamic body) async {
    try {
      dynamic response =
          await baseApiServices.getPostApiResponse(AppUrl.signUpUrl, body);
      return response;
    } catch (_) {
      rethrow;
    }
  }

  Future<dynamic> getLogin(dynamic body) async {
    try {
      dynamic response =
          await baseApiServices.getPostApiResponse(AppUrl.loginUrl, body);
      return response;
    } catch (_) {
      rethrow;
    }
  }
}
