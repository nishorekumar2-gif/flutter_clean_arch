import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_arch/presentation/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamed(context, AppRoutes.loginPage);
    });
    return Expanded(child: Image.asset("assets/images/logo.png"));
  }
}
