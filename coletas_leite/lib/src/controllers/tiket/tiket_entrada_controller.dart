import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/tiket/tiket_entrada_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model_copy.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:coletas_leite/src/utils/formatters.dart';
import 'package:coletas_leite/src/utils/toast_imprimir.dart';
import 'package:mobx/mobx.dart';
import 'package:sqflite/sqflite.dart';
part 'tiket_entrada_controller.g.dart';

class TiketEntradaController = _TiketEntradaControllerBase
    with _$TiketEntradaController;

abstract class _TiketEntradaControllerBase with Store {
  late Database db;
  late BluetoothDevice? device;
  late BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @observable
  ObservableList<TiketEntradaModel> tikets = ObservableList.of([]);

  @observable
  ObservableList<TiketEntradaModel> tiketsColetas = ObservableList.of([]);

  @observable
  TiketEntradaStatus status = TiketEntradaStatus.empty;

  @action
  Future<void> getTikets(
      {required int rota,
      required int id_coleta,
      required String placa}) async {
    try {
      status = TiketEntradaStatus.loading;

      final cnpj = UtilBrasilFields.removeCaracteres(
          GlobalSettings().appSettings.user.CNPJ.substring(0, 10));

      final response = await MeuDio.dio().get('/getJson/$cnpj/rotas/clientes');

      final lista = jsonDecode(response.data)
          .map<TiketEntradaModel>(
              (elemento) => TiketEntradaModel.fromMap(elemento))
          .toList();

      tikets = ObservableList.of(lista);

      await insertProdutores(produtores: tikets);

      await buscaProdutores(rota: rota);

      if (tikets.isNotEmpty) {
        status = TiketEntradaStatus.success;
      } else {
        status = TiketEntradaStatus.error;
      }
    } catch (e) {
      await buscaProdutores(rota: rota);
      await insert(rota: rota, id_coleta: id_coleta, placa: placa);

      await busca(rota: rota, id_coleta: id_coleta);
      print('Eu sou erro das rotas $e');
    }
  }

  @action
  Future<void> geraTiketEntrada(
      {required int rota,
      required int id_coleta,
      required String placa}) async {
    try {
      await getTikets(rota: rota, id_coleta: id_coleta, placa: placa);

      status = TiketEntradaStatus.loading;

      await insert(rota: rota, id_coleta: id_coleta, placa: placa);

      await busca(rota: rota, id_coleta: id_coleta);

      if (tikets.isNotEmpty) {
        status = TiketEntradaStatus.success;
      } else {
        status = TiketEntradaStatus.error;
      }
    } catch (e) {
      status = TiketEntradaStatus.error;
      print('eu sou o erro $e');
    }
  }

  Future<void> insertProdutores(
      {required ObservableList<TiketEntradaModel> produtores}) async {
    status = TiketEntradaStatus.loading;
    db = await DB.instance.database;

    await db.transaction((txn) async {
      for (var item in produtores) {
        final List tiket = await txn.query('produtores',
            where: 'rota = ? and clifor = ? ',
            whereArgs: [item.ROTA, item.CLIFOR]);

        if (tiket.isEmpty) {
          await txn.insert('produtores', {
            'clifor': item.CLIFOR,
            'uf': item.UF,
            'municipios': item.MUNICIPIOS,
            'nome': item.NOME,
            'rota': item.ROTA,
          });
        }
      }
    });

    status = TiketEntradaStatus.success;
  }

  Future<void> buscaProdutores({required int rota}) async {
    status = TiketEntradaStatus.loading;
    db = await DB.instance.database;

    tikets.clear();

    List tiketsdb =
        await db.query('produtores', where: 'rota = ?', whereArgs: [rota]);

    if (tiketsdb.isNotEmpty) {
      final lista = tiketsdb
          .map<TiketEntradaModel>(
              (elemento) => TiketEntradaModel.fromMapDb(elemento))
          .toList();
      tikets = ObservableList.of(lista);
    }
    status = TiketEntradaStatus.success;
  }

  Future<void> insert(
      {required int rota,
      required int id_coleta,
      required String placa}) async {
    status = TiketEntradaStatus.loading;
    db = await DB.instance.database;

    await db.transaction((txn) async {
      final List tiket = await txn.query('agl_tiket_entrada',
          where: 'rota_coleta = ?  and id_coleta = ?',
          whereArgs: [rota, id_coleta]);

      if (tiket.isEmpty) {
        for (var item in tikets) {
          await txn.insert('agl_tiket_entrada', {
            'clifor': item.CLIFOR,
            'uf': item.UF,
            'municipios': item.MUNICIPIOS,
            'nome': item.NOME,
            'produto': 0,
            'data': '"' + DateTime.now().DiaMesAnoDB() + '"',
            'tiket': 1,
            'quantidade': item.QUANTIDADE,
            'per_desconto': 0.0,
            'ccusto': GlobalSettings().appSettings.user.CCUSTO,
            'rota_coleta': rota,
            'id_coleta': id_coleta,
            'crioscopia': item.CRIOSCOPIA,
            'alizarol': item.ALIZAROL! == true ? 1 : 0,
            'hora': '"' +
                DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString().padLeft(2, '0') +
                '"',
            'particao': 1,
            'observacao': item.OBSERVACAO,
            'placa': placa,
            'temperatura': item.TEMPERATURA,
            'qtd_vezes_editado': item.QTD_VEZES_EDITADO,
          });
        }
      }
    });

    status = TiketEntradaStatus.success;
  }

  Future<void> busca({required int rota, required int id_coleta}) async {
    status = TiketEntradaStatus.loading;
    db = await DB.instance.database;

    tikets.clear();

    List tiketsdb = await db.query('agl_tiket_entrada',
        where: 'rota_coleta = ? and id_coleta = ?',
        whereArgs: [rota, id_coleta]);

    if (tiketsdb.isNotEmpty)
      for (var tik in tiketsdb) {
        tikets.add(
          TiketEntradaModel(
            CLIFOR: tik['clifor'],
            UF: tik['uf'],
            MUNICIPIOS: tik['municipios'],
            ROTA: tik['rota_coleta'],
            NOME: tik['nome'],
            CCUSTO: tik['ccusto'],
            CRIOSCOPIA: tik['crioscopia'],
            ALIZAROL: tik['alizarol'] == 1 ? true : false,
            DATA: tik['data'],
            HORA: tik['hora'],
            OBSERVACAO: tik['observacao'],
            PLACA: tik['placa'],
            ID: tik['id'],
            PARTICAO: tik['particao'],
            PER_DESCONTO: tik['per_desconto'],
            PRODUTO: tik['produto'],
            QUANTIDADE: tik['quantidade'],
            TEMPERATURA: tik['temperatura'],
            ID_COLETA: tik['id_coleta'],
            TIKET: tik['tiket'],
            QTD_VEZES_EDITADO: tik['qtd_vezes_editado'],
          ),
        );
      }

    status = TiketEntradaStatus.success;
  }

  @action
  Future<void> atualizaTiket(
      {required TiketEntradaModel coleta,
      required TiketEntradaModelCopy coletaCopy}) async {
    try {
      if (coleta.QUANTIDADE! != coletaCopy.QUANTIDADE! ||
          coleta.TEMPERATURA! != coletaCopy.TEMPERATURA!) {
        coleta.QTD_VEZES_EDITADO = coleta.QTD_VEZES_EDITADO! + 1;
      }
      db = await DB.instance.database;
      await db.transaction((txn) async {
        final tiket = await txn.query('agl_tiket_entrada',
            where: 'id = ?', whereArgs: [coleta.ID]);

        if (tiket.isNotEmpty) {
          await txn.update(
              'agl_tiket_entrada',
              {
                'quantidade': coleta.QUANTIDADE,
                'temperatura': coleta.TEMPERATURA,
                'alizarol': coleta.ALIZAROL! ? 1 : 0,
                'particao': coleta.PARTICAO, //TANQUE DO CAMINHAO
                'observacao': coleta.OBSERVACAO,
                'qtd_vezes_editado': coleta.QTD_VEZES_EDITADO,
                'hora': '"' +
                    DateTime.now().hour.toString() +
                    ':' +
                    DateTime.now().minute.toString().padLeft(2, '0') +
                    '"', //MOTIVO DA NAO COLETA
              },
              where: 'id = ?',
              whereArgs: [coleta.ID]);
        }
      });
    } catch (e) {
      print('eu sou o erro ao atualizar $e');
    }
  }

  @action
  Future<void> imprimirTicket(
      {required TiketEntradaModel tiket,
      TiketEntradaModelCopy? tiketCopy}) async {
    await GlobalSettings().appSettings.readImpressora();

    device = GlobalSettings().appSettings.imp;

    if (device == null) {
      return;
    } else {
      if (!(await printer.isConnected)! && ((await printer.isOn)!))
        await printer.connect(device!);
    }

    if (tiket.QUANTIDADE == 0 && tiket.OBSERVACAO.toString().trim().isEmpty) {
      return;
    }

    if (tiket.QUANTIDADE == tiketCopy?.QUANTIDADE &&
        tiket.TEMPERATURA == tiketCopy?.TEMPERATURA &&
        tiket.ALIZAROL == tiketCopy?.ALIZAROL &&
        tiket.PARTICAO == tiketCopy?.PARTICAO &&
        tiket.OBSERVACAO == tiketCopy?.OBSERVACAO) {
      return;
    }

    status = TiketEntradaStatus.imprimindo;

    if ((await printer.isConnected)!) {
      ToastImprimir.show();

      await Future.delayed(Duration(milliseconds: 300));
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
      printer.printCustom(
          'Data: ' +
              tiket.DATA.toString().replaceAll('"', '') +
              ' Hora: ' +
              tiket.HORA.toString().replaceAll('"', ''),
          1,
          0);
      printer.printCustom('Produtor: ' + tiket.NOME.trim(), 1, 0);
      printer.printCustom(
          'Quantidade: ' +
              tiket.QUANTIDADE.toString() +
              ' Temperatura: ' +
              tiket.TEMPERATURA.toString(),
          1,
          0);
      printer.printCustom(
          'Alizarol: ' + (tiket.ALIZAROL! ? 'Positivo' : 'Negativo'), 1, 0);
      printer.printCustom('Tanque: ' + tiket.PARTICAO.toString(), 1, 0);
      printer.printCustom('Placa: ' + tiket.PLACA!, 1, 0);
      if (tiket.OBSERVACAO.toString().trim().isNotEmpty)
        printer.printCustom(
            'Motivo da Nao Coleta: ' +
                tiket.OBSERVACAO.toString().removeAcentos().trim(),
            1,
            0);
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printCustom('_____________________________________', 1, 0);
      printer.printCustom(GlobalSettings().appSettings.user.NOME!, 1, 0);
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
    }
    status = TiketEntradaStatus.success;
  }

  @action
  Future<ObservableList<TiketEntradaModel>> onSearchChanged(
      {required String value}) async {
    if (value.isEmpty) {
      status = TiketEntradaStatus.loading;
    }

    ObservableList<TiketEntradaModel> lista = ObservableList.of(tikets
        .where(
            (rota) => (rota.NOME.toLowerCase().contains(value.toLowerCase())))
        .toList());

    if (value.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (value.isEmpty) {
      status = TiketEntradaStatus.success;
    }
    return lista;
  }

  @action
  Future<void> deletaProdutores() async {
    try {
      status = TiketEntradaStatus.loading;

      db = await DB.instance.database;

      await db.delete('produtores');

      status = TiketEntradaStatus.success;
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> getProdutores() async {
    try {
      status = TiketEntradaStatus.loading;

      final cnpj = UtilBrasilFields.removeCaracteres(
          GlobalSettings().appSettings.user.CNPJ.substring(0, 10));

      final response = await MeuDio.dio().get('/getJson/$cnpj/rotas/clientes');

      final lista = jsonDecode(response.data)
          .map<TiketEntradaModel>(
              (elemento) => TiketEntradaModel.fromMap(elemento))
          .toList();

      tikets = ObservableList.of(lista);

      await insertProdutores(produtores: tikets);

      if (tikets.isNotEmpty) {
        status = TiketEntradaStatus.success;
      } else {
        status = TiketEntradaStatus.error;
      }
    } catch (e) {
      print('Eu sou erro dos produtores $e');
    }
  }

  @action
  limpaDados() {
    status = TiketEntradaStatus.loading;
    tikets.clear();
  }

  @action
  Future<void> buscaTiketPorID({required int id_coleta}) async {
    status = TiketEntradaStatus.loading;
    db = await DB.instance.database;

    tiketsColetas.clear();

    List tiketsdb = await db.query('agl_tiket_entrada',
        where: 'id_coleta = ?', whereArgs: [id_coleta]);

    if (tiketsdb.isNotEmpty)
      for (var tik in tiketsdb) {
        tiketsColetas.add(
          TiketEntradaModel(
            CLIFOR: tik['clifor'],
            UF: tik['uf'],
            MUNICIPIOS: tik['municipios'],
            ROTA: tik['rota_coleta'],
            NOME: tik['nome'],
            CCUSTO: tik['ccusto'],
            CRIOSCOPIA: tik['crioscopia'],
            ALIZAROL: tik['alizarol'] == 1 ? true : false,
            DATA: tik['data'],
            HORA: tik['hora'],
            OBSERVACAO: tik['observacao'],
            PLACA: tik['placa'],
            ID: tik['id'],
            PARTICAO: tik['particao'],
            PER_DESCONTO: tik['per_desconto'],
            PRODUTO: tik['produto'],
            QUANTIDADE: tik['quantidade'],
            TEMPERATURA: tik['temperatura'],
            ID_COLETA: tik['id_coleta'],
            TIKET: tik['tiket'],
            QTD_VEZES_EDITADO: tik['qtd_vezes_editado'],
          ),
        );
      }

    status = TiketEntradaStatus.success;
  }
}
