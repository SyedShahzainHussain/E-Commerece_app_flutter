import 'package:e_commerce/extension/language/language.dart';
import 'package:e_commerce/extension/mediaQuery/media_query.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/viewModel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpassordController =
      TextEditingController();
  final TextEditingController _phonenumerController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmpassordFocusNode = FocusNode();
  final _phonenumerFocusNode = FocusNode();

  final ValueNotifier<bool> _obsecureText1 = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obsecureText2 = ValueNotifier<bool>(true);
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpassordController.dispose();
    _phonenumerController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phonenumerFocusNode.dispose();
    _confirmpassordFocusNode.dispose();
    _obsecureText1.dispose();
    _obsecureText2.dispose();
  }

  void saveData() {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    final body = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "mobile": _phonenumerController.text.trim(),
      'organizationName': _nameController.text.trim(),
    };
    context.read<AuthViewModel>().getSignUp(body, context);
    // save Data to Sign Up
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.screenHeight * .1),
                    Text(
                      "${context.localizations!.create}\n${context.localizations!.account}",
                      style: Theme.of(context).textTheme.displaySmall,
                      
                    ),
                    TextFormField(
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_emailFocusNode),
                      textInputAction: TextInputAction.next,
                      focusNode: _nameFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return context.localizations!.pleaseenteraname;
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: context.localizations!.yourname,
                          labelStyle:
                              const TextStyle(color: AppColors.greyColor)),
                    ),
                    TextFormField(
                      onFieldSubmitted: (value) => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocusNode,
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
                      valueListenable: _obsecureText1,
                      builder: (context, value, child) => TextFormField(
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_confirmpassordFocusNode),
                        textInputAction: TextInputAction.next,
                        focusNode: _passwordFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return context.localizations!.pleaseenterapassword;
                          }
                          return null;
                        },
                        obscureText: _obsecureText1.value,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _obsecureText1.value = !_obsecureText1.value;
                              },
                              child: Icon(_obsecureText1.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            labelText: context.localizations!.password,
                            labelStyle:
                                const TextStyle(color: AppColors.greyColor)),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _obsecureText2,
                      builder: (context, value, child) => TextFormField(
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_phonenumerFocusNode),
                        textInputAction: TextInputAction.next,
                        focusNode: _confirmpassordFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return context
                                .localizations!.pleaseenteraconfirmpassword;
                          }
                          if (!_confirmpassordController.text
                              .contains(_passwordController.text)) {
                            return context
                                .localizations!.pleaseenteracorrectpassword;
                          }
                          return null;
                        },
                        obscureText: _obsecureText2.value,
                        controller: _confirmpassordController,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _obsecureText2.value = !_obsecureText2.value;
                              },
                              child: Icon(_obsecureText2.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            labelText: context.localizations!.confirmpassword,
                            labelStyle:
                                const TextStyle(color: AppColors.greyColor)),
                      ),
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      focusNode: _phonenumerFocusNode,
                      onFieldSubmitted: (value) => saveData(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return context.localizations!.pleaseenteraphonenumber;
                        }
                        return null;
                      },
                      controller: _phonenumerController,
                      decoration: InputDecoration(
                          labelText: context.localizations!.phonenumber,
                          labelStyle:
                              const TextStyle(color: AppColors.greyColor)),
                    ),
                    SizedBox(
                      height: context.screenHeight * .03,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          saveData();
                        },
                        child: Consumer<AuthViewModel>(
                            builder: (context, value, child) => value.isLoading
                                ? const Center(
                                    child: SpinKitFadingCircle(
                                      color: AppColors.white,
                                    ),
                                  )
                                : Text(context.localizations!.signup)),
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
                                RouteName.loginScreen, (route) => false);
                          },
                          child: Text(context.localizations!.signin,
                              style: const TextStyle(
                                color: AppColors.deepPurple,
                              )),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
