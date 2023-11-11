import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInprovider with ChangeNotifier {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _hasErrorMessage;
  String? get hasErrorMessage => _hasErrorMessage;

  String? _provider;
  String? get provider => _provider;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  String? _userId;
  String? get userId => _userId;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

// ! signinwithGoogle
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredentials =
            await firebaseAuth.signInWithCredential(credential);

        if (kDebugMode) {
          print(userCredentials.user);
        }
        final User? user = userCredentials.user;
        if (user != null) {
          _hasError = false;
          _hasErrorMessage = '';
          _name = user.displayName;
          _email = user.email;
          _imageUrl = user.photoURL;
          _userId = user.uid;
          _provider = "google";
          notifyListeners();
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _hasErrorMessage =
                "You already have an account with us.Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _hasErrorMessage = "Some unexpected error";
            _hasError = true;
            notifyListeners();
            break;

          default:
            _hasErrorMessage = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    }
  }

//! save to sharedPreferences
  Future saveDataToSharedPreferences() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('name', _name!);
    sp.setString('email', _email!);
    sp.setString('provider', _provider!);
    sp.setString('imageUrl', _imageUrl!);
    sp.setString('userId', _userId!);
    notifyListeners();
  }

//! get data sharedPreference
Future getDataToSharedPreference()async{
     final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.getString('name');
    sp.getString('email');
    sp.getString('provider');
    sp.getString('imageUrl');
    sp.getString('userId');
    notifyListeners();
}

//! user sign out
  Future userSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("name");
    sp.remove("email");
    sp.remove("provider");
    sp.remove("imageUrl");
    sp.remove("userId");
    sp.remove("sign_in");
    notifyListeners();
  }

//! set the bool to true when user sign in
  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = await sp.setBool("sign_in", true);
    notifyListeners();
  }

//! check user is sign in
  Future checkSignInUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool("sign_in") ?? false;
    notifyListeners();
  }
}
