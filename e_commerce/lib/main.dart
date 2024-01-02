import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/model/login_model_getter.dart';
import 'package:e_commerce/provider/cart.dart';
import 'package:e_commerce/provider/change_language_.dart';
import 'package:e_commerce/provider/order.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:e_commerce/repository/google/google_authentication.dart';
import 'package:e_commerce/repository/intenet/internet_provider.dart';
import 'package:e_commerce/resources/app_colors.dart';
import 'package:e_commerce/utils/routes/route_animation.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/utils/routes/routes.dart';
import 'package:e_commerce/viewModel/auth_view_model.dart';
import 'package:e_commerce/viewModel/user_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessaginBackground);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final SharedPreferences sp = await SharedPreferences.getInstance();
  final String languageCode = sp.getString("AppLanguage") ?? '';
  runApp(MyApp(
    locale: languageCode,
  ));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessaginBackground(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  final String locale;
  const MyApp({super.key, required this.locale});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleSignInprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InternetProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginModelGetter(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeLanguage(),
        ),
      ],
      child: Consumer<ChangeLanguage>(
        builder: (context, value, child) {
          final locale = value.getLanguages();
          return MaterialApp(
            // ignore: unrelated_type_equality_checks
            locale: locale == ""
                ? const Locale("en")
                : value.appLocale ?? Locale(locale.toString()),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), //* English
              Locale('ur'), //* Urdu
            ],

            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: RouteAnimations(),
              }),
              primaryColor: ThemeData.dark().scaffoldBackgroundColor,
              drawerTheme:
                  const DrawerThemeData(backgroundColor: Color(0xff00001a)),
              cardTheme: const CardTheme(color: AppColors.deepPurple),
              colorScheme: const ColorScheme.dark().copyWith(
                  primary: AppColors.deepPurple,
                  brightness: Brightness.dark,
                  secondaryContainer: AppColors.greyColor),
              appBarTheme: AppBarTheme(
                  backgroundColor: AppColors.deepPurple.withOpacity(0.7)),
              scaffoldBackgroundColor: const Color(0xff00001a),
              textTheme: const TextTheme(
                displaySmall: TextStyle(
                  color: AppColors.white,
                ),
              ),
            ),
            theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: RouteAnimations(),
                }),
                cardTheme: const CardTheme(color: AppColors.greyColor),
                primaryColor: ThemeData.light().scaffoldBackgroundColor,
                colorScheme: const ColorScheme.light().copyWith(
                    brightness: Brightness.light,
                    primary: AppColors.deepPurple,
                    secondaryContainer: AppColors.deepPurple.withOpacity(0.5)),
                fontFamily: GoogleFonts.acme().fontFamily,
                textTheme: const TextTheme(
                    displaySmall: TextStyle(
                  color: AppColors.deepPurple,
                ))),
            initialRoute: RouteName.splashScreen,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
