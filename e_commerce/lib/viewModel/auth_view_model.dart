import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/firebase/notifications-services/firebase_notification.dart';
import 'package:e_commerce/model/login_model.dart';
import 'package:e_commerce/repository/authRepository.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/utils/utils..dart';
import 'package:e_commerce/viewModel/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();
  final provider = UserViewModel();
  FirebaseNotificationServices firebaseNotificationServices =
      FirebaseNotificationServices();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool _isLoading2 = false;
  bool get isLoading2 => _isLoading2;
  void setLoading2(bool isLoading) {
    _isLoading2 = isLoading;
    notifyListeners();
  }

  bool _isLoading3 = false;
  bool get isLoading3 => _isLoading3;
  void setLoading3(bool isLoading) {
    _isLoading3 = isLoading;
    notifyListeners();
  }

  void getSignUp(dynamic body, BuildContext context) {
    setLoading(true);
    _myRepo.getSignUp(body).then((value) {
      firebaseNotificationServices.getDevicesToken().then((value) async {
        await FirebaseFirestore.instance.collection('user').doc().set({
          "token": value.toString(),
        });
      });
      Utils.showToast(AppColors.deepPurple, Colors.white, "Account created successfully");
      Navigator.pushNamed(context, RouteName.loginScreen);

      setLoading(false);
    }).onError((error, stackTrace) async {
      setLoading(false);
      final data = error.toString();
      Utils.showToast(AppColors.deepPurple, Colors.white, data);
    });
  }

  void login(dynamic data, BuildContext? context) {
    if (context == null) {
      // Handle the case where the context is null
      return;
    }
    setLoading2(true);
    _myRepo.getLogin(data).then((value) async {
      final token = value['user']['token'];
      final name = value['user']['organizationName'];
      final email = value['user']['email'];
      final profile = value['user']['profilePhoto'];
      final loginmodel = LoginModel(
          user: User(
        email: email,
        token: token,
        organizationName: name,
        profilePhoto: profile,
      ));
      provider.saveUser(loginmodel);
      Utils.showToast(AppColors.deepPurple, Colors.white, "Login successfully");
      setLoading2(false);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.mainScreen, (route) => false);

      if (kDebugMode) {
        print(value);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.showToast(AppColors.deepPurple, Colors.white, error.toString());
      setLoading2(false);
    });
  }

  Future<void> loginProfile(dynamic data) async {
    _myRepo.getLogin(data).then((value) async {
      final token = value['user']['token'];
      final name = value['user']['organizationName'];
      final email = value['user']['email'];
      final profile = value['user']['profilePhoto'];
      final loginmodel = LoginModel(
          user: User(
        email: email,
        token: token,
        organizationName: name,
        profilePhoto: profile,
      ));
      provider.saveUser(loginmodel);
      Utils.showToast(AppColors.deepPurple, Colors.white, "Login successfully");
      setLoading2(false);

      if (kDebugMode) {
        print(value);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.showToast(AppColors.deepPurple, Colors.white, error.toString());
      setLoading2(false);
    });
  }
}
