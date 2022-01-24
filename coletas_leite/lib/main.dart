import 'dart:async';

import 'package:coletas_leite/app_widget.dart';
import 'package:coletas_leite/src/configs/app_settings.dart';
import 'package:coletas_leite/src/controllers/coletas/coletas_controller.dart';
import 'package:coletas_leite/src/controllers/configuracao/configuracao_controller.dart';
import 'package:coletas_leite/src/controllers/envio/envio_controller.dart';
import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_controller.dart';
import 'package:coletas_leite/src/controllers/tiket/tiket_entrada_controller.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await initializeDateFormatting(await findSystemLocale(), '');
      GetIt getIt = GetIt.I;
      getIt.registerSingleton<AppSettigns>(AppSettigns());
      getIt.registerSingleton<RotasLeiteController>(RotasLeiteController());
      getIt.registerSingleton<TransportesController>(TransportesController());
      getIt.registerSingleton<ColetasController>(ColetasController());
      getIt.registerSingleton<TiketEntradaController>(TiketEntradaController());
      getIt.registerSingleton<EnvioController>(EnvioController());
      getIt.registerSingleton<ConfiguracaoController>(ConfiguracaoController());

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
      ));
      runApp(AppWidget());
    },
    (error, st) => print(error),
  );
}
