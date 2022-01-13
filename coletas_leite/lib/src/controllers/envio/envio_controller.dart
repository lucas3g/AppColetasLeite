import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/envio/envio_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/envio/envio_model.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'envio_controller.g.dart';

class EnvioController = _EnvioControllerBase with _$EnvioController;

abstract class _EnvioControllerBase with Store {
  late Database db;
  late Database db2;

  @observable
  ObservableList<EnvioModel> ListaColetas = ObservableList.of([]);

  @observable
  EnvioStatus status = EnvioStatus.empty;

  @action
  Future<void> enviar() async {
    try {
      status = EnvioStatus.loading;

      try {
        final cnpj = UtilBrasilFields.removeCaracteres(
            GlobalSettings().appSettings.user.cnpj.substring(0, 10));

        final result = await InternetAddress.lookup(MeuDio.baseUrl);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //final response = await MeuDio.dio().get('/setJson/$cnpj/coletas');
          await montaJson();
        }
      } on SocketException catch (_) {
        print('Sem Internet Login');
      }
    } catch (e) {}
  }

  Future<void> montaJson() async {
    try {
      db = await DB.instance.database;
      db2 = await DB.instance.database;

      ListaColetas.clear();

      List<dynamic> lista = [];

      List coletas = await db.query('agl_coleta', where: 'rota_finalizada = 1');

      if (coletas.isNotEmpty) {
        for (var coleta in coletas) {
          lista.add(coleta);

          List tikets = await db2.query('agl_tiket_entrada',
              where: 'id_coleta = ?', whereArgs: [coleta['id']]);

          if (tikets.isNotEmpty) {
            lista[lista.indexOf(coleta)].tikets.add(tikets);
          }
        }
      }

      print(lista);

      db.close();
      db2.close();
    } catch (e) {
      print('EU SOU O ERRO DE INSERIR $e');
    }
  }
}
