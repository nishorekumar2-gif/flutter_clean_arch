import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/presentation/pages/dashboard_screen.dart';
import 'package:flutter_clean_arch/presentation/pages/home_screen.dart';
import 'package:flutter_clean_arch/presentation/pages/login_screen.dart';
import 'package:flutter_clean_arch/presentation/pages/profile_screen.dart';
import 'package:flutter_clean_arch/presentation/pages/splash_screen.dart';
import 'package:flutter_clean_arch/presentation/routes/app_routes.dart';

class AppRouter {
  AppRouter();

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case AppRoutes.loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (context) => DashboardScreen());
      case AppRoutes.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
