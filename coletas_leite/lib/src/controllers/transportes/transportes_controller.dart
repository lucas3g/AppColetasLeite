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
          GlobalSettings().appSettings.user.cnpj.substring(0, 10));

      try {
        final result = await InternetAddress.lookup(MeuDio.baseUrl);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final response =
              await MeuDio.dio().get('/getJson/$cnpj/transp/transp');

          final lista = jsonDecode(response.data)
              .map<TransportesModel>(
                  (elemento) => TransportesModel.fromMap(elemento))
              .toList();
          transp = ObservableList.of(lista);

          await gravaCaminhoes(); //GRAVA AS CAMINHOES NO BANCO DO CELULAR

        }
      } on SocketException catch (_) {
        print('Sem Internet Login');
      }

      await buscaCaminhoes();

      if (transp.isNotEmpty) {
        status = TransportesStatus.success;
      } else {
        status = TransportesStatus.success;
      }
    } catch (e) {
      print('Eu sou erro das transp $e');
    }
  }

  @action
  Future<void> gravaCaminhoes() async {
    db = await DB.instance.database;

    await db.transaction((txn) async {
      final List caminhao = await txn.query('caminhoes');

      if (caminhao.isEmpty) {
        for (var item in transp) {
          await txn.insert('caminhoes', {
            'placa': item.placa,
            'descricao': item.descricao,
          });
        }
      }
    });

    db.close();
  }

  @action
  Future<void> buscaCaminhoes() async {
    db = await DB.instance.database;

    transp.clear();

    List caminhao = await db.query('caminhoes');

    if (caminhao.isNotEmpty)
      for (var item in caminhao) {
        transp.add(
          TransportesModel(
            placa: item['placa'],
            descricao: item['descricao'],
          ),
        );
      }

    db.close();
  }
}
