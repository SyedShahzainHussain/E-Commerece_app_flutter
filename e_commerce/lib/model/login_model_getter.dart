import 'package:e_commerce/model/login_model.dart';
import 'package:e_commerce/viewModel/user_view_model.dart';
import 'package:flutter/material.dart';

class LoginModelGetter with ChangeNotifier {
  LoginModel? _loginModel;

  LoginModel get loginModel => _loginModel!;

  //! updateprofile loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
   setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchLoginModel() async {
    // Assume this is an asynchronous operation to fetch the login model.
    // Replace the following line with the actual logic to fetch the login model.
    _loginModel = await UserViewModel().getUser();

    // Notify listeners that the state has changed.
    notifyListeners();
  }
}
