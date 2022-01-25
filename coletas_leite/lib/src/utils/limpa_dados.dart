import 'package:coletas_leite/src/configs/global_settings.dart';

class LimpaDados {
  final coletas = GlobalSettings().controllerColetas;
  final rotas = GlobalSettings().controllerRotas;
  final tiket = GlobalSettings().controllerTiket;
  final transp = GlobalSettings().controllerTransp;

  limpaDados() {
    coletas.limpaDados();
    rotas.limpaDados();
    tiket.limpaDados();
    transp.limpaDados();
  }
}
