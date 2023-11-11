import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage with ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  bool? isLanguage;

  ChangeLanguage() {
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? storedLanguage = sp.getString("AppLanguage");

    if (storedLanguage != null) {
      _appLocale = Locale(storedLanguage);
      isLanguage = storedLanguage == "ur";
      notifyListeners();
    }
  }

  Future<String> getLanguages() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String languageCode = sp.getString("AppLanguage") ?? '';
    return languageCode;
  }

  setEnglish(bool value) async {
    isLanguage = value;
    notifyListeners();
  }

  void chnageLanguages(bool languages) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (languages == true) {
      sp.setString("AppLanguage", "ur");
      _appLocale = const Locale("ur");
      setEnglish(true);
      notifyListeners();
    } else {
      sp.setString("AppLanguage", "en");
      _appLocale = const Locale("en");
      setEnglish(false);
      notifyListeners();
    }
  }
}
