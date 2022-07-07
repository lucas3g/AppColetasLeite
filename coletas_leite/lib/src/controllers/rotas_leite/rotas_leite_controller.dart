import 'dart:convert';
import 'dart:io';

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
          GlobalSettings().appSettings.user.CNPJ.substring(0, 10));

      try {
        final result = await InternetAddress.lookup(MeuDio.baseUrl);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final response = await MeuDio.dio()
              .get('${MeuDio.baseURLAPP}/getJson/$cnpj/rotas/rotas');

          final lista = jsonDecode(response.data)
              .map<RotasLeiteModel>(
                  (elemento) => RotasLeiteModel.fromMap(elemento))
              .toList();

          rotas = ObservableList.of(lista);

          await gravaRotas(); //GRAVA AS ROTAS NO BANCO DO CELULAR

        }
      } on SocketException catch (_) {
        await buscaRotas();
        print('Sem Internet Login');
      }

      await buscaRotas();

      if (rotas.isNotEmpty) {
        status = RotasLeiteStatus.success;
      } else {
        status = RotasLeiteStatus.success;
      }
    } catch (e) {
      await buscaRotas();
      print('Eu sou erro das rotas porcoziu $e');
    }
  }

  @action
  Future<void> gravaRotas() async {
    status = RotasLeiteStatus.loading;
    db = await DB.instance.database;

    await db.transaction((txn) async {
      final List rota = await txn.query('rotas');

      if (rota.isEmpty) {
        for (var item in rotas) {
          await txn.insert('rotas', {
            'id': item.ID,
            'descricao': item.DESCRICAO,
            'transportador': item.TRANSPORTADOR,
            'rota_finalizada': item.ROTA_FINALIZADA,
          });
        }
      }
    });

    status = RotasLeiteStatus.success;
  }

  @action
  Future<void> buscaRotas() async {
    status = RotasLeiteStatus.loading;

    db = await DB.instance.database;

    rotas.clear();

    List rota = await db.query('rotas');

    if (rota.isNotEmpty)
      for (var item in rota) {
        rotas.add(
          RotasLeiteModel(
            ID: item['id'],
            DESCRICAO: item['descricao'],
            TRANSPORTADOR: item['transportador'],
            ROTA_FINALIZADA: item['rota_finalizada'],
          ),
        );
      }

    for (var item in rotas) {
      await retornaRotaFinalizada(rotaf: item);
    }

    if (rotas.isNotEmpty) {
      status = RotasLeiteStatus.success;
    } else {
      status = RotasLeiteStatus.error;
    }
  }

  @action
  Future<void> retornaRotaFinalizada({required RotasLeiteModel rotaf}) async {
    try {
      status = RotasLeiteStatus.loading;

      db = await DB.instance.database;

      List rota = await db
          .query('agl_coleta', where: 'rota_coleta = ?', whereArgs: [rotaf.ID]);

      if (rota.isNotEmpty) {
        rotas[rotas.indexOf(rotaf)].ROTA_FINALIZADA =
            rota.every((rota) => rota['rota_finalizada'] == 1) ? 1 : 0;
      } else {
        rotas[rotas.indexOf(rotaf)].ROTA_FINALIZADA = 1;
      }
      status = RotasLeiteStatus.success;
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<ObservableList<RotasLeiteModel>> onSearchChanged(
      {required String value}) async {
    if (value.isEmpty) {
      status = RotasLeiteStatus.loading;
    }

    ObservableList<RotasLeiteModel> lista = ObservableList.of(rotas
        .where((rota) =>
            (rota.DESCRICAO.toLowerCase().contains(value.toLowerCase())))
        .toList());

    if (value.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (value.isEmpty) {
      status = RotasLeiteStatus.success;
    }
    return lista;
  }

  @action
  Future<void> deletaRotas() async {
    try {
      status = RotasLeiteStatus.loading;

      db = await DB.instance.database;

      await db.delete('rotas');

      status = RotasLeiteStatus.success;
    } catch (e) {
      rethrow;
    }
  }

  @action
  limpaDados() {
    status = RotasLeiteStatus.loading;
    rotas.clear();
  }
}
