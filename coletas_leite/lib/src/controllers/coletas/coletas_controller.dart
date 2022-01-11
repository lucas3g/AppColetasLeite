import 'package:coletas_leite/src/controllers/coletas/coletas_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/coletas/coletas_model.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'coletas_controller.g.dart';

class ColetasController = _ColetasControllerBase with _$ColetasController;

abstract class _ColetasControllerBase with Store {
  late Database db;

  @observable
  ColetasModel coletas = ColetasModel(rota_finalizada: 0);

  @observable
  ObservableList<ColetasModel> ListaColetas = ObservableList.of([]);

  @observable
  ColetasStatus status = ColetasStatus.empty;

  @action
  Future<void> iniciaColeta(
      {required int rota,
      required String motorista,
      required String caminhao,
      required int km_inicio}) async {
    try {
      status = ColetasStatus.loading;

      coletas = ColetasModel(rota_finalizada: 0);

      db = await DB.instance.database;

      await db.transaction((txn) async {
        final coleta = await txn.query('agl_coleta',
            where: 'rota_coleta = ? and rota_finalizada = 0 and data_mov = ?',
            whereArgs: [rota, DateTime.now().toIso8601String()]);

        if (coleta.isEmpty) {
          await txn.insert('agl_coleta', {
            'data_mov': DateTime.now().toIso8601String(),
            'rota_coleta': rota,
            'km_inicio': km_inicio,
            'km_fim': 0,
            'dt_hora_ini': DateTime.now().toIso8601String(),
            'dt_hora_fim': DateTime.now().toIso8601String(),
            'transportador': caminhao,
            'motorista': motorista,
            'ccusto': 0,
            'rota_finalizada': 0,
          });
        }
      });
    } catch (e) {
      status = ColetasStatus.error;
    }
  }

  @action
  Future<void> getColetas() async {
    try {
      status = ColetasStatus.loading;

      ListaColetas.clear();

      db = await DB.instance.database;

      List coleta = await db.query('agl_coleta');

      for (var item in coleta) {
        ListaColetas.add(
          ColetasModel(
            data_mov: DateTime.parse(item['data_mov']),
            rota_coleta: item['rota_coleta'],
            motorista: item['motorista'],
            dt_hora_ini: DateTime.parse(item['dt_hora_ini']),
            dt_hora_fim: DateTime.parse(item['dt_hora_fim']),
            transportador: item['transportador'],
            rota_finalizada: item['rota_finalizada'],
            km_inicio: item['km_inicio'],
            km_fim: item['km_fim'],
            ccusto: item['ccusto'],
          ),
        );
      }
      if (ListaColetas.isNotEmpty) {
        status = ColetasStatus.success;
      } else {
        status = ColetasStatus.empty;
      }
    } catch (e) {
      print('CAIU AQUI O ERRO DA PESQUISA $e');
      status = ColetasStatus.error;
    }
  }
}
