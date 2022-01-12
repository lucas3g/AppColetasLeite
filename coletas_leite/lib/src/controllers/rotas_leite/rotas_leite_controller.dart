import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/rotas_leite/rotas_leite_model.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'rotas_leite_controller.g.dart';

class RotasLeiteController = _RotasLeiteControllerBase
    with _$RotasLeiteController;

abstract class _RotasLeiteControllerBase with Store {
  late Database db;

  @observable
  ObservableList<RotasLeiteModel> rotas = ObservableList.of([]);

  @observable
  RotasLeiteStatus status = RotasLeiteStatus.empty;

  @action
  Future<void> getRotas() async {
    try {
      status = RotasLeiteStatus.loading;

      final cnpj = UtilBrasilFields.removeCaracteres(
          GlobalSettings().appSettings.user.cnpj.substring(0, 10));

      final response = await MeuDio.dio().get('/getJson/$cnpj/rotas/rotas');

      final lista = jsonDecode(response.data)
          .map<RotasLeiteModel>((elemento) => RotasLeiteModel.fromMap(elemento))
          .toList();

      rotas = ObservableList.of(lista);

      for (var item in rotas) {
        await retornaRotaFinalizada(rotaf: item);
      }

      if (rotas.isNotEmpty) {
        status = RotasLeiteStatus.success;
      } else {
        status = RotasLeiteStatus.success;
      }
    } catch (e) {
      print('Eu sou erro das rotas $e');
    }
  }

  @action
  Future<void> retornaRotaFinalizada({required RotasLeiteModel rotaf}) async {
    try {
      status = RotasLeiteStatus.loading;

      db = await DB.instance.database;

      List rota = await db
          .query('agl_coleta', where: 'rota_coleta = ?', whereArgs: [rotaf.id]);

      if (rota.isNotEmpty) {
        rotas[rotas.indexOf(rotaf)].rota_finalizada =
            rota.every((rota) => rota['rota_finalizada'] == 1) ? 1 : 0;
      } else {
        rotas[rotas.indexOf(rotaf)].rota_finalizada = 1;
      }

      db.close();

      status = RotasLeiteStatus.success;
    } catch (e) {
      rethrow;
    }
  }
}