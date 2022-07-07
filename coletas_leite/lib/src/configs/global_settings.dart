import 'package:coletas_leite/src/configs/app_settings.dart';
import 'package:coletas_leite/src/controllers/coletas/coletas_controller.dart';
import 'package:coletas_leite/src/controllers/configuracao/configuracao_controller.dart';
import 'package:coletas_leite/src/controllers/envio/envio_controller.dart';
import 'package:coletas_leite/src/controllers/get_info_phone/get_info_phone_controller.dart';
import 'package:coletas_leite/src/controllers/login/login_controller.dart';
import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_controller.dart';
import 'package:coletas_leite/src/controllers/tiket/tiket_entrada_controller.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_controller.dart';
import 'package:get_it/get_it.dart';

class GlobalSettings {
  final appSettings = GetIt.I.get<AppSettigns>();
  final controllerRotas = GetIt.I.get<RotasLeiteController>();
  final controllerTransp = GetIt.I.get<TransportesController>();
  final controllerColetas = GetIt.I.get<ColetasController>();
  final controllerTiket = GetIt.I.get<TiketEntradaController>();
  final controllerEnvio = GetIt.I.get<EnvioController>();
  final controllerConfig = GetIt.I.get<ConfiguracaoController>();
  final controllerInfoPhone = GetIt.I.get<GetInfoPhoneController>();
  final controllerLogin = GetIt.I.get<LoginController>();

  static recursiveFunction(
      {required Function function,
      required int quantity,
      required Function? callback}) async {
    try {
      return await function();
    } catch (err) {
      if (quantity == 3) {
        if (callback != null) {
          return await callback();
        }
        return;
      } else {
        quantity++;
        return Future.delayed(Duration(milliseconds: 200)).then((value) async {
          return await recursiveFunction(
              function: function, quantity: quantity, callback: callback);
        });
      }
    }
  }
}
