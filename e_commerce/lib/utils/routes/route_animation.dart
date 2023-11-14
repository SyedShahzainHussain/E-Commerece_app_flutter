import 'package:flutter/material.dart';

class RouteAnimations extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == "/") {
      return child;
    }

    Offset begin = const  Offset(1.0, 0.0);
    Offset end = const  Offset(0.0, 0.0);

    Animation<Offset> slideAnimation =
        Tween(begin: begin, end: end).animate(animation);

    return SlideTransition(position: slideAnimation, child: child);
  }
}
