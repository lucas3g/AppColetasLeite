import 'dart:io';

import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/meu_toast.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void verificaInternet() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        inicializar();
      }
    } on SocketException catch (_) {
      await GlobalSettings().appSettings.removeLogado();

      MeuToast.toast(
          title: 'Ops... :(',
          message: 'Parece que você está sem Internet',
          type: TypeToast.noNet,
          context: context);
      Navigator.popAndPushNamed(context, '/login');
      return;
    }
  }

  void inicializar() async {
    await Future.delayed(Duration(seconds: 2));
    final String conectado = GlobalSettings().appSettings.logado['conectado']!;

    if (conectado == 'N') {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  void initState() {
    verificaInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppTheme.colors.backgroundPrimary),
        child: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 24),
                  Row(
                    children: [
                      SizedBox(height: 60),
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/images/barra-direita.png',
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                height: 78,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 0,
                      child: Text('Coletas',
                          style: AppTheme.textStyles.titleLogin
                              .copyWith(fontSize: 70)),
                    ),
                    Flexible(
                      child: Text(
                        ' Plus',
                        style: AppTheme.textStyles.titleLogin.copyWith(
                          color: Color(0xFF525252),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/images/barra-esquerda.png',
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
