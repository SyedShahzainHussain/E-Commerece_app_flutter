import 'package:e_commerce/model/login_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(LoginModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("token", user.user!.token.toString());
    sp.setString("name", user.user!.organizationName.toString());
    sp.setString("useremail", user.user!.email.toString());
    sp.setString("profilePhoto", user.user!.profilePhoto.toString());

    notifyListeners();
    return true;
  }

  Future<LoginModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String token = sp.getString("token") ?? '';
    final String name = sp.getString("name") ?? '';
    final String email = sp.getString("useremail") ?? '';
    final String password = sp.getString("userpassword") ?? '';
    final String profilePhoto = sp.getString("profilePhoto") ?? '';
    return LoginModel(
      user: User(
        email: email,
        organizationName: name,
        token: token,
        password: password,
        profilePhoto: profilePhoto,
      ),
    );
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove("token");
    await sp.remove("name");
    await sp.remove("useremail");
    await sp.remove("password");
    await sp.remove("profilePhoto");

    return true;
  }
}
