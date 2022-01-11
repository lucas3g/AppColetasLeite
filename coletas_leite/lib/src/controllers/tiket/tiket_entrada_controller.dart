import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/tiket/tiket_entrada_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/coletas_clientes/coletas_clientes_model.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'tiket_entrada_controller.g.dart';

class TiketEntradaController = _TiketEntradaControllerBase
    with _$TiketEntradaController;

abstract class _TiketEntradaControllerBase with Store {
  late Database db;

  @observable
  ObservableList<TiketEntradaModel> tikets = ObservableList.of([]);

  @observable
  TiketEntradaStatus status = TiketEntradaStatus.empty;

  @action
  Future<void> getTikets() async {
    try {
      status = TiketEntradaStatus.loading;

      final cnpj = UtilBrasilFields.removeCaracteres(
          GlobalSettings().appSettings.user.cnpj.substring(0, 10));

      final response = await MeuDio.dio().get('/getJson/$cnpj/rotas/clientes');

      final lista = jsonDecode(response.data)
          .map<TiketEntradaModel>(
              (elemento) => TiketEntradaModel.fromMap(elemento))
          .toList();

      tikets = ObservableList.of(lista);

      if (tikets.isNotEmpty) {
        status = TiketEntradaStatus.success;
      } else {
        status = TiketEntradaStatus.error;
      }
    } catch (e) {
      print('Eu sou erro das rotas $e');
    }
  }

  @action
  Future<void> geraTiketEntrada({required int rota}) async {
    try {
      await getTikets();
      status = TiketEntradaStatus.loading;

      db = await DB.instance.database;

      await db.transaction((txn) async {
        final List tiketsdb = await txn.query('agl_tiket_entrada');
      });

      await db.transaction((txn) async {
        final List tiket = await txn.query('agl_tiket_entrada',
            where: 'rota_coleta = ? and data = ?',
            whereArgs: [rota, DateTime.now().toIso8601String()]);

        if (tiket.isEmpty) {
          for (var item in tikets) {
            await txn.insert('agl_tiket_entrada', {
              'clifor': item.clifor,
              'produto': 0,
              'data': DateTime.now().toIso8601String(),
              'tiket': 1,
              'quantidade': item.quantidade,
              'per_desconto': 0.0,
              'ccusto': 0,
              'rota_coleta': rota,
              'crioscopia': 0.0, //VER
              'hora': DateTime.now().toIso8601String(),
              'observacao': item.observacao,
              'temperatura': item.temperatura,
            });
          }
        }
      });

      tikets.clear();

      await db.transaction((txn) async {
        final List tiketsdb = await txn.query(
          'agl_tiket_entrada',
        );

        for (var tik in tiketsdb) {
          tikets.add(
            TiketEntradaModel(
              clifor: tik['clifor'],
              uf: tik['uf'],
              municipios: tik['municipios'],
              rota: tik['rota_coleta'],
              nome: tik['nome'],
              ccusto: tik['ccusto'],
              crioscopia: tik['crioscopia'],
              data: DateTime.parse(tik['data']),
              hora: DateTime.parse(tik['hora']),
              observacao: tik['observaoca'],
              id: tik['id'],
              particao: tik['particao'],
              per_desconto: tik['per_desconto'],
              produto: tik['produto'],
              quantidade: tik['quantidade'],
              temperatura: tik['temperatura'],
              tiket: tik['tiket'],
            ),
          );
        }
      });

      if (tikets.isNotEmpty) {
        status = TiketEntradaStatus.success;
      } else {
        status = TiketEntradaStatus.error;
      }

      status = TiketEntradaStatus.success;
    } catch (e) {
      status = TiketEntradaStatus.error;
    }
  }

  @action
  Future<void> atualizaTiket({required ColetasClientesModel coleta}) async {
    try {
      db = await DB.instance.database;
      await db.transaction((txn) async {
        final tiket = await txn.query('agl_tiket_entrada',
            where: 'id = ?', whereArgs: [coleta.id]);

        if (tiket.isNotEmpty) {
          await txn.update(
              'agl_tiket_entrada',
              {
                'quantidade': coleta.quantidade,
                'temperatura': coleta.temperatura,
                'particao': coleta.particao,
                'observacao': coleta.observacao
              },
              where: 'id = ?',
              whereArgs: [coleta.id]);
        }
      });
      status = TiketEntradaStatus.loading;
      status = TiketEntradaStatus.success;
    } catch (e) {}
  }
}
