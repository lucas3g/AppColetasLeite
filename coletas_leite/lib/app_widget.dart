import 'package:coletas_leite/src/pages/dashboard/dashboard_page.dart';
import 'package:coletas_leite/src/pages/login/login_page.dart';
import 'package:coletas_leite/src/pages/rotas_leite/rotas_leite_page.dart';
import 'package:coletas_leite/src/pages/splash/splash_page.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppTheme.colors.secondaryColor),
      title: 'Coletas Plus', //1. call BotToastInit
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashPage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashBoardPage(),
        '/rotas_leite': (context) => RotasLeitePage(),
      },
    );
  }
}
