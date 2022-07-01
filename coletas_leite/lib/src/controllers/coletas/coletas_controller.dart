import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/coletas/coletas_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/coletas/coletas_model.dart';
import 'package:coletas_leite/src/utils/formatters.dart';
import 'package:coletas_leite/src/utils/toast_imprimir.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'coletas_controller.g.dart';

class ColetasController = _ColetasControllerBase with _$ColetasController;

abstract class _ColetasControllerBase with Store {
  late Database db;
  late BluetoothDevice? device;
  late BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @observable
  ColetasModel coletas = ColetasModel(ROTA_FINALIZADA: 0);

  @observable
  ObservableList<ColetasModel> ListaColetas = ObservableList.of([]);

  @observable
  ColetasStatus status = ColetasStatus.empty;

  @action
  Future<void> iniciaColeta(
      {required int rota,
      required String rota_nome,
      required String motorista,
      required String caminhao,
      required int km_inicio,
      required int tanques}) async {
    try {
      status = ColetasStatus.loading;

      coletas = ColetasModel(ROTA_FINALIZADA: 0);

      db = await DB.instance.database;

      late int id_gerado = 0;

      await db.transaction((txn) async {
        final coleta = await txn.query('agl_coleta',
            where: 'rota_coleta = ? and rota_finalizada = 0 and data_mov = ?',
            whereArgs: [rota, '"' + DateTime.now().DiaMesAnoDB() + '"']);

        if (coleta.isEmpty) {
          id_gerado = await txn.insert('agl_coleta', {
            'data_mov': '"' + DateTime.now().DiaMesAnoDB() + '"',
            'rota_coleta': rota,
            'rota_nome': rota_nome,
            'km_inicio': km_inicio,
            'km_fim': 0,
            'dt_hora_ini': '"' +
                DateTime.now().DiaMesAnoDB() +
                ' ' +
                DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString().padLeft(2, '0') +
                '"',
            'dt_hora_fim': '',
            'transportador': caminhao,
            'tanques': tanques,
            'motorista': motorista,
            'ccusto': GlobalSettings().appSettings.user.CCUSTO,
            'rota_finalizada': 0,
            'enviada': 0,
          });
        }
      });

      db = await DB.instance.database;

      List coleta =
          await db.query('agl_coleta', where: 'id = ?', whereArgs: [id_gerado]);

      for (var item in coleta) {
        coletas.DATA_MOV = item['data_mov'];
        coletas.ROTA_COLETA = item['rota_coleta'];
        coletas.MOTORISTA = item['motorista'];
        coletas.DT_HORA_INI = item['dt_hora_ini'];
        coletas.DT_HORA_FIM = item['dt_hora_fim'];
        coletas.TRANSPORTADOR = item['transportador'];
        coletas.TANQUES = item['tanques'];
        coletas.ROTA_FINALIZADA = item['rota_finalizada'];
        coletas.ROTA_NOME = item['rota_nome'];
        coletas.KM_INICIO = item['km_inicio'];
        coletas.KM_FIM = item['km_fim'];
        coletas.CCUSTO = item['ccusto'];
        coletas.ID = item['id'];
        coletas.ENVIADA = item['enviada'];
      }

      status = ColetasStatus.success;
    } catch (e) {
      status = ColetasStatus.error;
      rethrow;
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
            DATA_MOV: item['data_mov'],
            ROTA_COLETA: item['rota_coleta'],
            MOTORISTA: item['motorista'],
            DT_HORA_INI: item['dt_hora_ini'],
            DT_HORA_FIM: item['dt_hora_fim'],
            TRANSPORTADOR: item['transportador'],
            TANQUES: item['tanques'],
            ROTA_FINALIZADA: item['rota_finalizada'],
            ROTA_NOME: item['rota_nome'],
            KM_INICIO: item['km_inicio'],
            KM_FIM: item['km_fim'],
            CCUSTO: item['ccusto'],
            ID: item['id'],
            ENVIADA: item['enviada'],
          ),
        );
      }

      ListaColetas.sort((a, b) => ("${a.ROTA_FINALIZADA}${a.ENVIADA}")
          .toString()
          .compareTo(("${b.ROTA_FINALIZADA}${b.ENVIADA}").toString()));

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

  @action
  Future<void> finalizaColeta({required ColetasModel coleta}) async {
    try {
      status = ColetasStatus.loading;

      db = await DB.instance.database;

      await db.transaction((txn) async {
        final col = await txn
            .query('agl_coleta', where: 'id = ?', whereArgs: [coleta.ID]);

        if (col.isNotEmpty) {
          await txn.update(
              'agl_coleta',
              {
                'rota_finalizada': 1,
                'dt_hora_fim': '"' +
                    DateTime.now().DiaMesAnoDB() +
                    ' ' +
                    DateTime.now().hour.toString() +
                    ':' +
                    DateTime.now().minute.toString().padLeft(2, '0') +
                    '"',
                'km_fim': coleta.KM_FIM
              },
              where: 'id = ?',
              whereArgs: [coleta.ID]);
        }

        status = ColetasStatus.success;
      });
    } catch (e) {
      status = ColetasStatus.error;
      rethrow;
    }
  }

  @action
  Future<bool> retornaRotaFinalizada({required int id}) async {
    try {
      status = ColetasStatus.loading;

      db = await DB.instance.database;

      List coleta =
          await db.query('agl_coleta', where: 'id = ?', whereArgs: [id]);

      if (coleta[0]['rota_finalizada'] == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> imprimirResumoColetas({required ColetasModel coleta}) async {
    try {
      await GlobalSettings().appSettings.readImpressora();

      device = GlobalSettings().appSettings.imp;

      if (device == null) {
        return;
      } else {
        if (!(await printer.isConnected)! && ((await printer.isOn)!))
          await printer.connect(device!);
      }

      status = ColetasStatus.imprimindo;

      if ((await printer.isConnected)!) {
        ToastImprimir.show();

        await Future.delayed(Duration(milliseconds: 300));

        db = await DB.instance.database;

        List<dynamic> listaColetas = [];

        List tikets = await db.query('agl_tiket_entrada',
            where: 'id_coleta = ?', whereArgs: [coleta.ID]);

        if (tikets.isNotEmpty) {
          listaColetas = tikets;
        }

        late int total = 0;

        printer.printCustom(
            GlobalSettings()
                .appSettings
                .user
                .DESC_EMPRESA
                .toString()
                .substring(0, 21)
                .removeAcentos(),
            1,
            1);
        printer.printNewLine();
        printer.printCustom('..:Resumo das Coletas:..', 2, 1);
        printer.printNewLine();
        for (var item in listaColetas) {
          printer.printCustom(
              'Produtor: ' +
                  item['nome']
                      .toString()
                      .substring(
                          0,
                          item['nome'].toString().length > 20
                              ? 17
                              : item['nome'].toString().length)
                      .removeAcentos() +
                  ' Qtd: ' +
                  item['quantidade'].toString(),
              1,
              0);
          total = (total + item['quantidade']!) as int;
        }

        printer.printCustom(
            '------------------------------------------------', 1, 0);

        printer.printCustom('Total: ' + total.toString(), 1, 0);

        printer.printNewLine();
        printer.printNewLine();
        printer.printNewLine();
        printer.printNewLine();
        printer.printNewLine();
      }
      status = ColetasStatus.success;
    } catch (e) {
      status = ColetasStatus.error;
    }
  }

  @action
  limpaDados() {
    status = ColetasStatus.loading;
    ListaColetas.clear();
  }
}
