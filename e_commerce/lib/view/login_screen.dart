import 'package:e_commerce/extension/language/language.dart';
import 'package:e_commerce/extension/mediaQuery/media_query.dart';

import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/viewModel/auth_view_model.dart';
import 'package:e_commerce/viewModel/google_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _obsecure = ValueNotifier<bool>(true);
  final _emailfocusNode = FocusNode();
  final _paswordfocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  Future<void> addLogin() async {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    final data = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim().replaceAll(" ", "")
    };
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(
      "userpassword",
      _passwordController.text.trim()..replaceAll(" ", ""),
    );

    context.read<AuthViewModel>().login(data, context);
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _obsecure.dispose();
    _paswordfocusNode.dispose();
    _emailfocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          height: context.screenHeight -
              MediaQuery.paddingOf(context).top -
              MediaQuery.paddingOf(context).bottom,
          padding: EdgeInsets.symmetric(
            vertical: context.screenWidth * .04,
            horizontal: context.screenWidth * .05,
          ),
          child: Form(
            key: _form,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${context.localizations!.welcome}\n${context.localizations!.back}",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(_paswordfocusNode),
                    focusNode: _emailfocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return context.localizations!.pleaseenteraemail;
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: context.localizations!.youremail,
                        labelStyle:
                            const TextStyle(color: AppColors.greyColor)),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _obsecure,
                    builder: (context, value, child) => TextFormField(
                      textInputAction: TextInputAction.done,
                      focusNode: _paswordfocusNode,
                      onFieldSubmitted: (value) => addLogin(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return context
                              .localizations!.pleaseenteraconfirmpassword;
                        }

                        return null;
                      },
                      obscureText: _obsecure.value,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _obsecure.value = !_obsecure.value;
                            },
                            child: Icon(_obsecure.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          labelText: context.localizations!.password,
                          labelStyle:
                              const TextStyle(color: AppColors.greyColor)),
                    ),
                  ),
                  SizedBox(
                    height: context.screenHeight * .05,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () async {
                          addLogin();
                        },
                        child: Consumer<AuthViewModel>(
                            builder: (context, value, child) => value.isLoading2
                                ? const Center(
                                    child: SpinKitFadingCircle(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(context.localizations!.signin))),
                  ),
                  SizedBox(
                    height: context.screenHeight * .01,
                  ),
                  Center(child: Text(context.localizations!.or)),
                  SizedBox(
                    height: context.screenHeight * .01,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: () async {
                        await GoogleViewModel.handleGoogleSinIn(context)
                            .then((value) {});
                      },
                      child: Consumer<AuthViewModel>(
                        builder: (context, value, child) => value.isLoading3
                            ? const Center(
                                child: SpinKitFadingCircle(
                                  color: Colors.white,
                                ),
                              )
                            : Text(context.localizations!.signinwithgoogle),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.screenHeight * .03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.localizations!.backto,
                          style: const TextStyle(
                            color: AppColors.greyColor,
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              RouteName.signUpScreen, (route) => false);
                        },
                        child: Text(context.localizations!.signup,
                            style: const TextStyle(
                              color: AppColors.deepPurple,
                            )),
                      ),
                    ],
                  ),
                ]),
          ),
        )),
      ),
    );
  }
}
