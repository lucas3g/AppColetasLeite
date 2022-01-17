import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/envio/envio_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'envio_controller.g.dart';

class EnvioController = _EnvioControllerBase with _$EnvioController;

abstract class _EnvioControllerBase with Store {
  late Database db;
  late Database db2;

  @observable
  EnvioStatus status = EnvioStatus.empty;

  @action
  Future<int> enviar() async {
    try {
      status = EnvioStatus.loading;

      try {
        final cnpj = UtilBrasilFields.removeCaracteres(
            GlobalSettings().appSettings.user.cnpj.substring(0, 10));

        final result = await InternetAddress.lookup(MeuDio.baseUrl);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final List<dynamic> ListaColetas = await montaJson();
          if (ListaColetas.isNotEmpty) {
            final response = await MeuDio.dio().post(
                '/setJson/$cnpj/coletas/' +
                    DateTime.now().day.toString() +
                    DateTime.now().month.toString() +
                    DateTime.now().year.toString() +
                    '_' +
                    DateTime.now().hour.toString() +
                    '-' +
                    DateTime.now().minute.toString() +
                    '-' +
                    DateTime.now().second.toString(),
                data: ListaColetas);

            if (response.statusCode == 200) {
              for (var item in ListaColetas) {
                await atualizaRotasEnviadas(id_coleta: item['id']);
              }
              return response.statusCode!;
            } else {
              return response.statusCode!;
            }
          } else {
            return 0;
          }
        } else {
          return 1;
        }
      } on SocketException catch (_) {
        print('Sem Internet Envio');
        return 2;
      }
    } catch (e) {
      print('EU SOU O ERRO DE ENVIO $e');
      return 3;
    }
  }

  Future<List> montaJson() async {
    try {
      db = await DB.instance.database;
      db2 = await DB.instance.database;

      List<dynamic> listaColetas = [];

      List coletas = await db.query('agl_coleta',
          where: 'rota_finalizada = 1 and enviada  = 0');

      if (coletas.isNotEmpty) {
        for (var coleta in coletas) {
          List tikets = await db2.query('agl_tiket_entrada',
              where: 'id_coleta = ?', whereArgs: [coleta['id']]);

          if (tikets.isNotEmpty) {
            listaColetas = [
              {
                ...coleta,
                'tikets': tikets,
              },
              ...listaColetas
            ];
          }
        }
      }

      db.close();
      db2.close();

      return listaColetas;
    } catch (e) {
      print('EU SOU O ERRO DE INSERIR $e');
      rethrow;
    }
  }

  Future<void> atualizaRotasEnviadas({required int id_coleta}) async {
    try {
      db = await DB.instance.database;
      await db.transaction((txn) async {
        final tiket = await txn
            .query('agl_coleta', where: 'id = ?', whereArgs: [id_coleta]);

        if (tiket.isNotEmpty) {
          await txn.update(
              'agl_coleta',
              {
                'enviada': 1,
              },
              where: 'id = ?',
              whereArgs: [id_coleta]);
        }
      });
      status = EnvioStatus.loading;
      status = EnvioStatus.success;
    } catch (e) {
      print('eu sou o erro ao atualizar rotas enviadas $e');
    }
  }
}
