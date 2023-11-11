import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class InternetProvider with ChangeNotifier {
  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  InternetProvider() {
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      _hasInternet = true;
    }
    notifyListeners();
  }
}
