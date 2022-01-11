import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_status.dart';
import 'package:coletas_leite/src/models/transportes/transportes_model.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:mobx/mobx.dart';
part 'transportes_controller.g.dart';

class TransportesController = _TransportesControllerBase
    with _$TransportesController;

abstract class _TransportesControllerBase with Store {
  @observable
  ObservableList<TransportesModel> transp = ObservableList.of([]);

  @observable
  TransportesStatus status = TransportesStatus.empty;

  @action
  Future<void> getTransp() async {
    try {
      status = TransportesStatus.loading;

      final cnpj = UtilBrasilFields.removeCaracteres(
          GlobalSettings().appSettings.user.cnpj.substring(0, 10));

      final response = await MeuDio.dio().get('/getJson/$cnpj/transp/transp');

      final lista = jsonDecode(response.data)
          .map<TransportesModel>(
              (elemento) => TransportesModel.fromMap(elemento))
          .toList();

      transp = ObservableList.of(lista);

      if (transp.isNotEmpty) {
        status = TransportesStatus.success;
      } else {
        status = TransportesStatus.success;
      }
    } catch (e) {
      print('Eu sou erro das transp $e');
    }
  }
}
