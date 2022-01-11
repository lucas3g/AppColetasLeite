import 'dart:async';

import 'package:coletas_leite/app_widget.dart';
import 'package:coletas_leite/src/configs/app_settings.dart';
import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_controller.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      GetIt getIt = GetIt.I;
      getIt.registerSingleton<AppSettigns>(AppSettigns());
      getIt.registerSingleton<RotasLeiteController>(RotasLeiteController());
      getIt.registerSingleton<TransportesController>(TransportesController());
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
      ));
      runApp(AppWidget());
    },
    (error, st) => print(error),
  );
}
