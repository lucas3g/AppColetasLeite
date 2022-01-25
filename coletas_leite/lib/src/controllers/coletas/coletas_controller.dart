import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/coletas/coletas_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/coletas/coletas_model.dart';
import 'package:coletas_leite/src/utils/formatters.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'coletas_controller.g.dart';

class ColetasController = _ColetasControllerBase with _$ColetasController;

abstract class _ColetasControllerBase with Store {
  late Database db;
  late BluetoothDevice? device;
  late BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @observable
  ColetasModel coletas = ColetasModel(rota_finalizada: 0);

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

      coletas = ColetasModel(rota_finalizada: 0);

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
                DateTime.now().minute.toString() +
                '"',
            'dt_hora_fim': '',
            'transportador': caminhao,
            'tanques': tanques,
            'motorista': motorista,
            'ccusto': GlobalSettings().appSettings.user.ccusto,
            'rota_finalizada': 0,
            'enviada': 0,
          });
        }
      });

      db = await DB.instance.database;

      List coleta =
          await db.query('agl_coleta', where: 'id = ?', whereArgs: [id_gerado]);

      for (var item in coleta) {
        coletas.data_mov = item['data_mov'];
        coletas.rota_coleta = item['rota_coleta'];
        coletas.motorista = item['motorista'];
        coletas.dt_hora_ini = item['dt_hora_ini'];
        coletas.dt_hora_fim = item['dt_hora_fim'];
        coletas.transportador = item['transportador'];
        coletas.tanques = item['tanques'];
        coletas.rota_finalizada = item['rota_finalizada'];
        coletas.rota_nome = item['rota_nome'];
        coletas.km_inicio = item['km_inicio'];
        coletas.km_fim = item['km_fim'];
        coletas.ccusto = item['ccusto'];
        coletas.id = item['id'];
        coletas.enviada = item['enviada'];
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
            data_mov: item['data_mov'],
            rota_coleta: item['rota_coleta'],
            motorista: item['motorista'],
            dt_hora_ini: item['dt_hora_ini'],
            dt_hora_fim: item['dt_hora_fim'],
            transportador: item['transportador'],
            tanques: item['tanques'],
            rota_finalizada: item['rota_finalizada'],
            rota_nome: item['rota_nome'],
            km_inicio: item['km_inicio'],
            km_fim: item['km_fim'],
            ccusto: item['ccusto'],
            id: item['id'],
            enviada: item['enviada'],
          ),
        );
      }

      ListaColetas.sort((a, b) => ("${a.rota_finalizada}${a.enviada}")
          .toString()
          .compareTo(("${b.rota_finalizada}${b.enviada}").toString()));

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
            .query('agl_coleta', where: 'id = ?', whereArgs: [coleta.id]);

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
                    DateTime.now().minute.toString() +
                    '"',
                'km_fim': coleta.km_fim
              },
              where: 'id = ?',
              whereArgs: [coleta.id]);
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

      await Future.delayed(Duration(milliseconds: 300));

      if ((await printer.isConnected)!) {
        db = await DB.instance.database;

        List<dynamic> listaColetas = [];

        List tikets = await db.query('agl_tiket_entrada',
            where: 'id_coleta = ?', whereArgs: [coleta.id]);

        if (tikets.isNotEmpty) {
          listaColetas = tikets;
        }

        late int total = 0;

        printer.printCustom(
            GlobalSettings()
                .appSettings
                .user
                .descEmpresa
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
