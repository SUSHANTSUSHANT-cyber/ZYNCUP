import 'package:flutter/material.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/home/screens/home_page.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const signUp = '/sign-up';
}

class AppRouter {
  AppRouter._();

  static Route<void> onGenerateRoute(
    RouteSettings settings, {
    required bool isAuthenticated,
  }) {
    final routeName = settings.name ?? AppRoutes.home;
    final guardedRoute = _guardRoute(routeName, isAuthenticated);

    return MaterialPageRoute<void>(
      builder: (_) => switch (guardedRoute) {
        AppRoutes.login => const LoginScreen(),
        AppRoutes.signUp => const SignUpScreen(),
        _ => const HomePage(),
      },
      settings: settings,
    );
  }

  static String _guardRoute(String routeName, bool isAuthenticated) {
    if (!isAuthenticated && routeName == AppRoutes.home) {
      return AppRoutes.login;
    }

    if (isAuthenticated &&
        (routeName == AppRoutes.login || routeName == AppRoutes.signUp)) {
      return AppRoutes.home;
    }

    if (routeName == AppRoutes.login ||
        routeName == AppRoutes.signUp ||
        routeName == AppRoutes.home) {
      return routeName;
    }

    return isAuthenticated ? AppRoutes.home : AppRoutes.login;
  }
}
