
import 'package:flutter/material.dart';
import 'package:jot_notes/screens/home.dart';
import 'package:jot_notes/screens/mainScreen.dart';

import '../screens/login/login_page.dart';
import '../screens/registration/registration_screen.dart';
import '../screens/splash/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final arg = settings.arguments;

    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RegistrationScreen.routeName:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());

      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());




      default:
        _onPageNotFound();
    }
  }

  static Route<dynamic> _onPageNotFound() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(body: Text("Page not found")),
    );
  }
}
