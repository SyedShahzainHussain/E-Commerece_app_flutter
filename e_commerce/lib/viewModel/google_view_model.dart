import 'package:e_commerce/repository/google/google_authentication.dart';
import 'package:e_commerce/repository/intenet/internet_provider.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/utils/utils..dart';
import 'package:e_commerce/viewModel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleViewModel {
  static Future handleGoogleSinIn(BuildContext context) async {
    final google = context.read<GoogleSignInprovider>();
    final intenet = context.read<InternetProvider>();
    await intenet.checkConnectivity();
    final data = context.read<AuthViewModel>();

    if (intenet.hasInternet == false) {
      Utils.showToast(
          AppColors.deepPurple, Colors.white, "No Internet Connection ");
      data.setLoading3(false);
    } else {
      data.setLoading3(true);
      await google.signInWithGoogle().then((value) async {
        if (google.hasError == true) {
          Utils.showToast(AppColors.deepPurple, Colors.white,
              google.hasErrorMessage.toString());
          data.setLoading3(false);
        } else {
          await google.saveDataToSharedPreferences().then((value) {
            google.setSignIn().then((value) {
              data.setLoading3(false);
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.mainScreen, (route) => false);
            });
          });
        }
      });
    }
  }
}
