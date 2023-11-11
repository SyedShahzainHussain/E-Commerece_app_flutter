import 'dart:async';

import 'package:e_commerce/extension/mediaQuery/media_query.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/viewModel/services/splash_serices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      splashServices.checkAuthentication(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/splash.png",
              width: context.screenWidth * .8,
              fit: BoxFit.cover,
            ),
            const Center(
              child: SpinKitFadingCircle(
                color: AppColors.deepPurple,
              ),
            )
          ]),
    );
  }
}
