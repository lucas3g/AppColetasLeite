// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiket_entrada_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TiketEntradaController on _TiketEntradaControllerBase, Store {
  late final _$tiketsAtom =
      Atom(name: '_TiketEntradaControllerBase.tikets', context: context);

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

  late final _$tiketsColetasAtom =
      Atom(name: '_TiketEntradaControllerBase.tiketsColetas', context: context);

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

  late final _$statusAtom =
      Atom(name: '_TiketEntradaControllerBase.status', context: context);

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

  late final _$getTiketsAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.getTikets', context: context);

  @override
  Future<void> getTikets(
      {required int rota, required int id_coleta, required String placa}) {
    return _$getTiketsAsyncAction.run(
        () => super.getTikets(rota: rota, id_coleta: id_coleta, placa: placa));
  }

  late final _$geraTiketEntradaAsyncAction = AsyncAction(
      '_TiketEntradaControllerBase.geraTiketEntrada',
      context: context);

  @override
  Future<void> geraTiketEntrada(
      {required int rota, required int id_coleta, required String placa}) {
    return _$geraTiketEntradaAsyncAction.run(() =>
        super.geraTiketEntrada(rota: rota, id_coleta: id_coleta, placa: placa));
  }

  late final _$atualizaTiketAsyncAction = AsyncAction(
      '_TiketEntradaControllerBase.atualizaTiket',
      context: context);

  @override
  Future<void> atualizaTiket(
      {required TiketEntradaModel coleta,
      required TiketEntradaModelCopy coletaCopy}) {
    return _$atualizaTiketAsyncAction
        .run(() => super.atualizaTiket(coleta: coleta, coletaCopy: coletaCopy));
  }

  late final _$imprimirTicketAsyncAction = AsyncAction(
      '_TiketEntradaControllerBase.imprimirTicket',
      context: context);

  @override
  Future<void> imprimirTicket(
      {required TiketEntradaModel tiket, TiketEntradaModelCopy? tiketCopy}) {
    return _$imprimirTicketAsyncAction
        .run(() => super.imprimirTicket(tiket: tiket, tiketCopy: tiketCopy));
  }

  late final _$onSearchChangedAsyncAction = AsyncAction(
      '_TiketEntradaControllerBase.onSearchChanged',
      context: context);

  @override
  Future<ObservableList<TiketEntradaModel>> onSearchChanged(
      {required String value}) {
    return _$onSearchChangedAsyncAction
        .run(() => super.onSearchChanged(value: value));
  }

  late final _$deletaProdutoresAsyncAction = AsyncAction(
      '_TiketEntradaControllerBase.deletaProdutores',
      context: context);

  @override
  Future<void> deletaProdutores() {
    return _$deletaProdutoresAsyncAction.run(() => super.deletaProdutores());
  }

  late final _$getProdutoresAsyncAction = AsyncAction(
      '_TiketEntradaControllerBase.getProdutores',
      context: context);

  @override
  Future<void> getProdutores() {
    return _$getProdutoresAsyncAction.run(() => super.getProdutores());
  }

  late final _$buscaTiketPorIDAsyncAction = AsyncAction(
      '_TiketEntradaControllerBase.buscaTiketPorID',
      context: context);

  @override
  Future<void> buscaTiketPorID({required int id_coleta}) {
    return _$buscaTiketPorIDAsyncAction
        .run(() => super.buscaTiketPorID(id_coleta: id_coleta));
  }

  late final _$_TiketEntradaControllerBaseActionController =
      ActionController(name: '_TiketEntradaControllerBase', context: context);

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
