import 'package:e_commerce/extension/language/language.dart';
import 'package:e_commerce/extension/mediaQuery/media_query.dart';
import 'package:e_commerce/extension/sizedBox_height/sizedbox.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/utils/utils..dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenAdmin extends StatefulWidget {
  const LoginScreenAdmin({super.key});

  @override
  State<LoginScreenAdmin> createState() => _LoginScreenAdminState();
}

class _LoginScreenAdminState extends State<LoginScreenAdmin> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final _loginMode = FocusNode();
  final _passwordMode = FocusNode();
  final _form = GlobalKey<FormState>();

  ValueNotifier<bool> isObsecure = ValueNotifier<bool>(false);
  String? email;
  String? password;
  bool? isLogin;
  bool _isLoading = false;

  Future<void> getEmailPasswordFromSharedPreference() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    email = sp.getString("email") ?? '';
    password = sp.getString("password") ?? '';
    isLogin = sp.getBool('isLogin') ?? false;
  }

  addEmailToSharedPreferences() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("email", "Admin@gmail.com");
    sp.setString("password", "admin12345");
  }

  @override
  void initState() {
    addEmailToSharedPreferences();
    getEmailPasswordFromSharedPreference()
        .then((value) => chechUserIsLoginOrNot(isLogin!));

    super.initState();
  }

  void chechUserIsLoginOrNot(bool isLogin) {
    if (isLogin == false) {
      return;
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.productOverviewScreen, (route) => false);
    }
  }

  @override
  void dispose() {
    _loginMode.dispose();
    _passwordMode.dispose();
    super.dispose();
  }

  saveData() async {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (emailcontroller.text == email && passwordcontroller.text == password) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setBool("isLogin", true);
      await Future.delayed(
        const Duration(seconds: 5),
        () {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.productOverviewScreen,
            (route) => false,
          );
        },
      );
    } else {
      await Future.delayed(
        const Duration(seconds: 2),
        () {
          setState(() {
            _isLoading = false;
          });
          Utils.showToast(AppColors.deepPurple, Colors.white,
              context.localizations!.wrongCredentials);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.localizations!.admin)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                'assets/3728455.png',
                width: double.infinity,
                height: context.screenHeight * .3,
              ),
              TextFormField(
                controller: emailcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return context.localizations!.pleaseenteraemail;
                  }
                  return null;
                },
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordMode),
                focusNode: _loginMode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.localizations!.email,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                ),
              ),
              10.height,
              ValueListenableBuilder(
                valueListenable: isObsecure,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: passwordcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return context.localizations!.pleaseenterapassword;
                      }
                      return null;
                    },
                    focusNode: _passwordMode,
                    obscuringCharacter: "*",
                    obscureText: isObsecure.value,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            isObsecure.value = !isObsecure.value;
                          },
                          icon: Icon(isObsecure.value
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      labelText: context.localizations!.password,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
              10.height,
              Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () {
                        saveData();
                      },
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(context.localizations!.login)))
            ]),
          ),
        ),
      ),
    );
  }
}
