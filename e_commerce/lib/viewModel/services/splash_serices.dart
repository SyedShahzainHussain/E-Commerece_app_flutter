import 'package:e_commerce/model/login_model.dart';
import 'package:e_commerce/repository/google/google_authentication.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/viewModel/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashServices {
  Future<LoginModel> getUserData() => UserViewModel().getUser();

  void checkAuthentication(BuildContext context) async {
    await context.read<GoogleSignInprovider>().checkSignInUser();
    final isSign = context.read<GoogleSignInprovider>().isSignedIn;
    if (isSign == true) {
      Future.delayed(
        Duration.zero,
      ).then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.mainScreen, (route) => false);
      });
    } else {
      getUserData().then((value) {
        if (value.user!.token == "null" || value.user!.token == "") {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.loginScreen, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.mainScreen, (route) => false);
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print(error);
        }
      });
    }
  }
}
