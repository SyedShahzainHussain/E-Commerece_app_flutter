import 'package:e_commerce/admin/admin_screen.dart';
import 'package:e_commerce/admin/login_screen.dart';
import 'package:e_commerce/utils/routes/route_name.dart';
import 'package:e_commerce/view/cart_screen.dart';
import 'package:e_commerce/view/detail_screen.dart';
import 'package:e_commerce/view/edit_screen.dart';
import 'package:e_commerce/view/favorite_screen.dart';
import 'package:e_commerce/view/login_screen.dart';
import 'package:e_commerce/view/main_screen.dart';
import 'package:e_commerce/view/order_screen.dart';
import 'package:e_commerce/view/product_over_view_screen.dart';
import 'package:e_commerce/view/profile_screen.dart';
import 'package:e_commerce/view/sign_up_screen.dart';
import 'package:e_commerce/view/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ! splash screen
      case RouteName.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case RouteName.profileScreen:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );
      case RouteName.mainScreen:
        return MaterialPageRoute(
          builder: (context) => const MainScreen(),
        );

      case RouteName.signUpScreen:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      case RouteName.loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case RouteName.detailScreen:
        final String id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => DetailScreen(id: id),
        );
      case RouteName.favoritesScreen:
        return MaterialPageRoute(
          builder: (context) => const FavoriteScreen(),
        );
      case RouteName.cartScreen:
        return MaterialPageRoute(
          builder: (context) => const CartScreen(),
        );
      case RouteName.orderScreen:
        return MaterialPageRoute(
          builder: (context) => const OrderScreen(),
        );
      case RouteName.editScreen:
        final String? id = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => EditScreen(id: id!),
        );
      case RouteName.productOverviewScreen:
        return MaterialPageRoute(
          builder: (context) => const ProductOverviewScreen(),
        );
      // ! admin
      case RouteName.adminLoginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreenAdmin(),
        );
      case RouteName.adminScreen:
        return MaterialPageRoute(
          builder: (context) => const AdminScreen(),
        );
      default:
        return MaterialPageRoute(builder: (ctx) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
