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
  Future<void> getTikets() {
    return _$getTiketsAsyncAction.run(() => super.getTikets());
  }

  final _$geraTiketEntradaAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.geraTiketEntrada');

  @override
  Future<void> geraTiketEntrada({required int rota}) {
    return _$geraTiketEntradaAsyncAction
        .run(() => super.geraTiketEntrada(rota: rota));
  }

  final _$atualizaTiketAsyncAction =
      AsyncAction('_TiketEntradaControllerBase.atualizaTiket');

  @override
  Future<void> atualizaTiket({required ColetasClientesModel coleta}) {
    return _$atualizaTiketAsyncAction
        .run(() => super.atualizaTiket(coleta: coleta));
  }

  @override
  String toString() {
    return '''
tikets: ${tikets},
status: ${status}
    ''';
  }
}
