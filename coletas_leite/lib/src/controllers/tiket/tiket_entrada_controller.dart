import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/tiket/tiket_entrada_status.dart';
import 'package:coletas_leite/src/database/db.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model.dart';
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

    db.close();
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
    db.close();
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
            'ccusto': 0,
            'rota_coleta': rota,
            'id_coleta': id_coleta,
            'crioscopia': item.crioscopia,
            'hora': '"' +
                DateTime.now().hour.toString() +
                ':' +
                DateTime.now().minute.toString() +
                '"',
            'particao': 1,
            'observacao': item.observacao,
            'placa': placa,
            'temperatura': item.temperatura,
          });
        }
      }
    });

    db.close();
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
          ),
        );
      }

    db.close();
    status = TiketEntradaStatus.success;
  }

  @action
  Future<void> atualizaTiket({required TiketEntradaModel coleta}) async {
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
                'crioscopia': coleta.crioscopia,
                'particao': coleta.particao, //TANQUE DO CAMINHAO
                'observacao': coleta.observacao //MOTIVO DA NAO COLETA
              },
              where: 'id = ?',
              whereArgs: [coleta.id]);
        }
      });
      status = TiketEntradaStatus.loading;
      status = TiketEntradaStatus.success;
    } catch (e) {
      print('eu sou o erro ao atualizar $e');
    }
  }

  @action
  Future<void> imprimirTicket({required TiketEntradaModel tiket}) async {
    device = GlobalSettings().appSettings.imp;

    if (!(await printer.isConnected)!) await printer.connect(device!);

    if ((await printer.isConnected)!) {
      printer.printCustom('COOPROLAT', 1, 1);
      printer.printNewLine();
      printer.printCustom(
          'Data: ' +
              tiket.data.toString().replaceAll('"', '') +
              ' Hora: ' +
              tiket.hora.toString().replaceAll('"', ''),
          1,
          0);
      printer.printCustom('Produtor: ' + tiket.nome, 1, 0);
      printer.printCustom(
          'Quantidade: ' +
              tiket.quantidade.toString() +
              ' Temperatura: ' +
              tiket.temperatura.toString(),
          1,
          0);
      printer.printCustom('Crioscopia: ' + tiket.crioscopia.toString(), 1, 0);
      printer.printCustom('Tanque: ' + tiket.particao.toString(), 1, 0);
      printer.printCustom('Placa: ' + tiket.placa!, 1, 0);
      if (tiket.observacao.toString() != '')
        printer.printCustom(
            'Motivo da Nao Coleta: ' +
                tiket.observacao.toString().removeAcentos(),
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
  }
}
