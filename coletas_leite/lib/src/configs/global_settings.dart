import 'package:coletas_leite/src/configs/app_settings.dart';
import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_controller.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_controller.dart';
import 'package:get_it/get_it.dart';

class GlobalSettings {
  final appSettings = GetIt.I.get<AppSettigns>();
  final controllerRotas = GetIt.I.get<RotasLeiteController>();
  final controllerTransp = GetIt.I.get<TransportesController>();
}
