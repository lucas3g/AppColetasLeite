import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/configuracao/configuracao_controller.dart';
import 'package:coletas_leite/src/controllers/sincronizar/sincronizar_controller.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SincronizarController controllerSincronizar = SincronizarController();
  final controllerConfig = GlobalSettings().controllerConfig;

  Future<void> inicializar() async {
    await Future.delayed(Duration(milliseconds: 500));
    final String conectado = GlobalSettings().appSettings.logado['conectado']!;

    if (conectado == 'N') {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      try {
        if ((await controllerConfig.printer.isOn)!)
          await controllerConfig.conectaImpressora();
        final result = await InternetAddress.lookup(MeuDio.baseUrl);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          BotToast.showLoading();
          BotToast.showText(text: 'Buscando dados do Servidor');
          await Future.delayed(Duration(seconds: 1));
          await controllerSincronizar.baixaTodas();
          await Future.delayed(Duration(seconds: 1));
          BotToast.closeAllLoading();
          BotToast.cleanAll();
        }
      } on SocketException catch (_) {
        print('Sem Internet Para Sincronizar');
      }
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void verificaInternet() async {
    await inicializar();
  }

  @override
  void initState() {
    super.initState();
    verificaInternet();
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Ágil',
                      style: AppTheme.textStyles.titleLogin
                          .copyWith(fontSize: 70)),
                  Text(
                    'Coletas',
                    style: AppTheme.textStyles.titleLogin
                        .copyWith(color: Color(0xFF525252), fontSize: 50),
                  ),
                ],
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
