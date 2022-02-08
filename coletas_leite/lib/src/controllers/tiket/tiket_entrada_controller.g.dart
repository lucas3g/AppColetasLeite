// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiket_entrada_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TiketEntradaController on _TiketEntradaControllerBase, Store {
  final _$tiketsAtom = Atom(name: '_TiketEntradaControllerBase.tikets');

  @override
  ObservableList<TiketEntradaModel> get tikets {
    _$tiketsAtom.reportRead();
    return super.tikets;
  }

  @override
  set tikets(ObservableList<TiketEntradaModel> value) {
    _$tiketsAtom.reportWrite(value, super.tikets, () {
      super.tikets = value;
    });
  }

  final _$tiketsColetasAtom =
      Atom(name: '_TiketEntradaControllerBase.tiketsColetas');

  @override
  ObservableList<TiketEntradaModel> get tiketsColetas {
    _$tiketsColetasAtom.reportRead();
    return super.tiketsColetas;
  }

  @override
  set tiketsColetas(ObservableList<TiketEntradaModel> value) {
    _$tiketsColetasAtom.reportWrite(value, super.tiketsColetas, () {
      super.tiketsColetas = value;
    });
  }

  final _$statusAtom = Atom(name: '_TiketEntradaControllerBase.status');

  @override
  TiketEntradaStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(TiketEntradaStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$getTiketsAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.getTikets');

  @override
  Future<void> getTikets(
      {required int rota, required int id_coleta, required String placa}) {
    return _$getTiketsAsyncAction.run(
        () => super.getTikets(rota: rota, id_coleta: id_coleta, placa: placa));
  }

  final _$geraTiketEntradaAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.geraTiketEntrada');

  @override
  Future<void> geraTiketEntrada(
      {required int rota, required int id_coleta, required String placa}) {
    return _$geraTiketEntradaAsyncAction.run(() =>
        super.geraTiketEntrada(rota: rota, id_coleta: id_coleta, placa: placa));
  }

  final _$atualizaTiketAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.atualizaTiket');

  @override
  Future<void> atualizaTiket(
      {required TiketEntradaModel coleta,
      required TiketEntradaModelCopy coletaCopy}) {
    return _$atualizaTiketAsyncAction
        .run(() => super.atualizaTiket(coleta: coleta, coletaCopy: coletaCopy));
  }

  final _$imprimirTicketAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.imprimirTicket');

  @override
  Future<void> imprimirTicket(
      {required TiketEntradaModel tiket, TiketEntradaModelCopy? tiketCopy}) {
    return _$imprimirTicketAsyncAction
        .run(() => super.imprimirTicket(tiket: tiket, tiketCopy: tiketCopy));
  }

  final _$onSearchChangedAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.onSearchChanged');

  @override
  Future<ObservableList<TiketEntradaModel>> onSearchChanged(
      {required String value}) {
    return _$onSearchChangedAsyncAction
        .run(() => super.onSearchChanged(value: value));
  }

  final _$deletaProdutoresAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.deletaProdutores');

  @override
  Future<void> deletaProdutores() {
    return _$deletaProdutoresAsyncAction.run(() => super.deletaProdutores());
  }

  final _$getProdutoresAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.getProdutores');

  @override
  Future<void> getProdutores() {
    return _$getProdutoresAsyncAction.run(() => super.getProdutores());
  }

  final _$buscaTiketPorIDAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.buscaTiketPorID');

  @override
  Future<void> buscaTiketPorID({required int id_coleta}) {
    return _$buscaTiketPorIDAsyncAction
        .run(() => super.buscaTiketPorID(id_coleta: id_coleta));
  }

  final _$_TiketEntradaControllerBaseActionController =
      ActionController(name: '_TiketEntradaControllerBase');

  @override
  dynamic limpaDados() {
    final _$actionInfo = _$_TiketEntradaControllerBaseActionController
        .startAction(name: '_TiketEntradaControllerBase.limpaDados');
    try {
      return super.limpaDados();
    } finally {
      _$_TiketEntradaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tikets: ${tikets},
tiketsColetas: ${tiketsColetas},
status: ${status}
    ''';
  }
}
