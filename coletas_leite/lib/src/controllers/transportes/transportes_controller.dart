import 'dart:convert';
import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/transportes/transportes_model.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'transportes_controller.g.dart';

class TransportesController = _TransportesControllerBase
    with _$TransportesController;

abstract class _TransportesControllerBase with Store {
  late Database db;

  @observable
  ObservableList<TransportesModel> transp = ObservableList.of([]);

  @observable
  TransportesStatus status = TransportesStatus.empty;

  @action
  Future<void> getTransp() async {
    try {
      status = TransportesStatus.loading;

      final cnpj = UtilBrasilFields.removeCaracteres(
          GlobalSettings().appSettings.user.CNPJ.substring(0, 10));

      try {
        final result = await InternetAddress.lookup(MeuDio.baseUrl);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final response = await MeuDio.dio()
              .get('${MeuDio.baseURLAPP}/getJson/$cnpj/transp/transp');

          final lista = jsonDecode(response.data)
              .map<TransportesModel>(
                  (elemento) => TransportesModel.fromMap(elemento))
              .toList();

          transp = ObservableList.of(lista);

          await gravaCaminhoes(); //GRAVA AS CAMINHOES NO BANCO DO CELULAR

        }
      } on SocketException catch (_) {
        await buscaCaminhoes();
        print('Sem Internet Login');
      }

      await buscaCaminhoes();

      if (transp.isNotEmpty) {
        status = TransportesStatus.success;
      } else {
        status = TransportesStatus.success;
      }
    } catch (e) {
      await buscaCaminhoes();
      print('Eu sou erro das transp oi $e');
    }
  }

  @action
  Future<void> gravaCaminhoes() async {
    status = TransportesStatus.loading;
    db = await DB.instance.database;

    await db.transaction((txn) async {
      final List caminhao = await txn.query('caminhoes');

      if (caminhao.isEmpty) {
        for (var item in transp) {
          await txn.insert('caminhoes', {
            'placa': item.PLACA,
            'descricao': item.DESCRICAO,
            'tanques': item.TANQUES,
          });
        }
      }
    });
    status = TransportesStatus.success;
  }

  @action
  Future<void> buscaCaminhoes() async {
    status = TransportesStatus.loading;
    db = await DB.instance.database;

    transp.clear();

    List caminhao = await db.query('caminhoes');

    if (caminhao.isNotEmpty)
      for (var item in caminhao) {
        transp.add(
          TransportesModel(
              PLACA: item['placa'],
              DESCRICAO: item['descricao'],
              TANQUES: item['tanques']),
        );
      }
    status = TransportesStatus.success;
  }

  @action
  Future<ObservableList<TransportesModel>> onSearchChanged(
      {required String value}) async {
    if (value.isEmpty) {
      status = TransportesStatus.loading;
    }

    ObservableList<TransportesModel> lista = ObservableList.of(transp
        .where((rota) =>
            (rota.PLACA.toLowerCase().contains(value.toLowerCase())) ||
            (rota.DESCRICAO.toLowerCase().contains(value.toLowerCase())))
        .toList());

    if (value.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (value.isEmpty) {
      status = TransportesStatus.success;
    }
    return lista;
  }

  @action
  Future<String> retornaUltimaPlaca() async {
    try {
      db = await DB.instance.database;

      List coletas = await db.query('agl_coleta',
          columns: ['transportador'], limit: 1, orderBy: 'id desc');

      if (coletas.isNotEmpty) {
        return coletas[0]['transportador'];
      } else {
        return '';
      }
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> deletaCaminhoes() async {
    try {
      status = TransportesStatus.loading;

      db = await DB.instance.database;

      await db.delete('caminhoes');

      status = TransportesStatus.success;
    } catch (e) {
      rethrow;
    }
  }

  @action
  limpaDados() {
    status = TransportesStatus.loading;
    transp.clear();
  }

  @action
  Future<List<TransportesModel>> jogaPlacaParaPrimeiro(
      {required List<TransportesModel> lista}) async {
    status = TransportesStatus.loading;
    final ultPlaca = await retornaUltimaPlaca();
    if (ultPlaca.isNotEmpty) {
      final indexAux = lista.indexWhere((e) => e.PLACA == ultPlaca);
      final aux = lista[indexAux];
      lista.removeAt(indexAux);
      lista.insert(0, aux);
    }
    status = TransportesStatus.success;
    return lista;
  }
}
