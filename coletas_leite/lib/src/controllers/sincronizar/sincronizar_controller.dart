import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/sincronizar/sincronizar_status.dart';
import 'package:mobx/mobx.dart';
part 'sincronizar_controller.g.dart';

class SincronizarController = _SincronizarControllerBase
    with _$SincronizarController;

abstract class _SincronizarControllerBase with Store {
  final controllerRotas = GlobalSettings().controllerRotas;
  final controllerTransp = GlobalSettings().controllerTransp;
  final controllerTiket = GlobalSettings().controllerTiket;

  @observable
  SincronizarStatus status = SincronizarStatus.empty;

  @action
  Future<void> baixaTodas() async {
    try {
      status = SincronizarStatus.loading;

      await controllerRotas.deletaRotas();
      await controllerRotas.getRotas();
      await controllerTransp.deletaCaminhoes();
      await controllerTransp.getTransp();
      await controllerTiket.deletaProdutores();
      await controllerTiket.getProdutores();
    } catch (e) {}
  }
}
