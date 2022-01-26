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
  TiketEntradaStatus status = TiketEntradaStatus.empty;

  @action
  Future<void> getTikets(
      {required int rota,
      required int id_coleta,
      required String placa}) async {
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
            whereArgs: [item.rota, item.clifor]);

        if (tiket.isEmpty) {
          await txn.insert('produtores', {
            'clifor': item.clifor,
            'uf': item.uf,
            'municipios': item.municipios,
            'nome': item.nome,
            'rota': item.rota,
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
              (elemento) => TiketEntradaModel.fromMap(elemento))
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
          where: 'rota_coleta = ? and data = ? and id_coleta = ?',
          whereArgs: [
            rota,
            '"' + DateTime.now().DiaMesAnoDB() + '"',
            id_coleta
          ]);

      if (tiket.isEmpty) {
        for (var item in tikets) {
          await txn.insert('agl_tiket_entrada', {
            'clifor': item.clifor,
            'uf': item.uf,
            'municipios': item.municipios,
            'nome': item.nome,
            'produto': 0,
            'data': '"' + DateTime.now().DiaMesAnoDB() + '"',
            'tiket': 1,
            'quantidade': item.quantidade,
            'per_desconto': 0.0,
            'ccusto': GlobalSettings().appSettings.user.ccusto,
            'rota_coleta': rota,
            'id_coleta': id_coleta,
            'crioscopia': item.crioscopia,
            'alizarol': item.alizarol! == true ? 1 : 0,
            'hora': '"' +
                DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString() +
                '"',
            'particao': 1,
            'observacao': item.observacao,
            'placa': placa,
            'temperatura': item.temperatura,
            'qtd_vezes_editado': item.qtd_vezes_editado,
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
        where: 'rota_coleta = ? and data = ? and id_coleta = ?',
        whereArgs: [rota, '"' + DateTime.now().DiaMesAnoDB() + '"', id_coleta]);

    if (tiketsdb.isNotEmpty)
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
            alizarol: tik['alizarol'] == 1 ? true : false,
            data: tik['data'],
            hora: tik['hora'],
            observacao: tik['observacao'],
            placa: tik['placa'],
            id: tik['id'],
            particao: tik['particao'],
            per_desconto: tik['per_desconto'],
            produto: tik['produto'],
            quantidade: tik['quantidade'],
            temperatura: tik['temperatura'],
            id_coleta: tik['id_coleta'],
            tiket: tik['tiket'],
            qtd_vezes_editado: tik['qtd_vezes_editado'],
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
      if (coleta.quantidade! != coletaCopy.quantidade! ||
          coleta.temperatura! != coletaCopy.temperatura!) {
        coleta.qtd_vezes_editado = coleta.qtd_vezes_editado! + 1;
      }
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
                'alizarol': coleta.alizarol! ? 1 : 0,
                'particao': coleta.particao, //TANQUE DO CAMINHAO
                'observacao': coleta.observacao,
                'qtd_vezes_editado':
                    coleta.qtd_vezes_editado, //MOTIVO DA NAO COLETA
              },
              where: 'id = ?',
              whereArgs: [coleta.id]);
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

    if (tiket.quantidade == 0 && tiket.observacao.toString().trim().isEmpty) {
      return;
    }

    if (tiket.quantidade == tiketCopy?.quantidade &&
        tiket.temperatura == tiketCopy?.temperatura &&
        tiket.alizarol == tiketCopy?.alizarol &&
        tiket.particao == tiketCopy?.particao &&
        tiket.observacao == tiketCopy?.observacao) {
      return;
    }

    status = TiketEntradaStatus.imprimindo;

    await Future.delayed(Duration(milliseconds: 300));

    if ((await printer.isConnected)!) {
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
      printer.printCustom(
          'Data: ' +
              tiket.data.toString().replaceAll('"', '') +
              ' Hora: ' +
              tiket.hora.toString().replaceAll('"', ''),
          1,
          0);
      printer.printCustom('Produtor: ' + tiket.nome.trim(), 1, 0);
      printer.printCustom(
          'Quantidade: ' +
              tiket.quantidade.toString() +
              ' Temperatura: ' +
              tiket.temperatura.toString(),
          1,
          0);
      printer.printCustom(
          'Alizarol: ' + (tiket.alizarol! ? 'Positivo' : 'Negativo'), 1, 0);
      printer.printCustom('Tanque: ' + tiket.particao.toString(), 1, 0);
      printer.printCustom('Placa: ' + tiket.placa!, 1, 0);
      if (tiket.observacao.toString().trim().isNotEmpty)
        printer.printCustom(
            'Motivo da Nao Coleta: ' +
                tiket.observacao.toString().removeAcentos().trim(),
            1,
            0);
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printCustom('_____________________________________', 1, 0);
      printer.printCustom(GlobalSettings().appSettings.user.nome!, 1, 0);
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
            (rota) => (rota.nome.toLowerCase().contains(value.toLowerCase())))
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
          GlobalSettings().appSettings.user.cnpj.substring(0, 10));

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
}
