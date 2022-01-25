// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transportes_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TransportesController on _TransportesControllerBase, Store {
  final _$transpAtom = Atom(name: '_TransportesControllerBase.transp');

  @override
  ObservableList<TransportesModel> get transp {
    _$transpAtom.reportRead();
    return super.transp;
  }

  @override
  set transp(ObservableList<TransportesModel> value) {
    _$transpAtom.reportWrite(value, super.transp, () {
      super.transp = value;
    });
  }

  final _$statusAtom = Atom(name: '_TransportesControllerBase.status');

  @override
  TransportesStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(TransportesStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$getTranspAsyncAction =
      AsyncAction('_TransportesControllerBase.getTransp');

  @override
  Future<void> getTransp() {
    return _$getTranspAsyncAction.run(() => super.getTransp());
  }

  final _$gravaCaminhoesAsyncAction =
      AsyncAction('_TransportesControllerBase.gravaCaminhoes');

  @override
  Future<void> gravaCaminhoes() {
    return _$gravaCaminhoesAsyncAction.run(() => super.gravaCaminhoes());
  }

  final _$buscaCaminhoesAsyncAction =
      AsyncAction('_TransportesControllerBase.buscaCaminhoes');

  @override
  Future<void> buscaCaminhoes() {
    return _$buscaCaminhoesAsyncAction.run(() => super.buscaCaminhoes());
  }

  final _$onSearchChangedAsyncAction =
      AsyncAction('_TransportesControllerBase.onSearchChanged');

  @override
  Future<ObservableList<TransportesModel>> onSearchChanged(
      {required String value}) {
    return _$onSearchChangedAsyncAction
        .run(() => super.onSearchChanged(value: value));
  }

  final _$retornaUltimaCaminhaoAsyncAction =
      AsyncAction('_TransportesControllerBase.retornaUltimaCaminhao');

  @override
  Future<String> retornaUltimaCaminhao() {
    return _$retornaUltimaCaminhaoAsyncAction
        .run(() => super.retornaUltimaCaminhao());
  }

  final _$deletaCaminhoesAsyncAction =
      AsyncAction('_TransportesControllerBase.deletaCaminhoes');

  @override
  Future<void> deletaCaminhoes() {
    return _$deletaCaminhoesAsyncAction.run(() => super.deletaCaminhoes());
  }

  final _$_TransportesControllerBaseActionController =
      ActionController(name: '_TransportesControllerBase');

  @override
  dynamic limpaDados() {
    final _$actionInfo = _$_TransportesControllerBaseActionController
        .startAction(name: '_TransportesControllerBase.limpaDados');
    try {
      return super.limpaDados();
    } finally {
      _$_TransportesControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
transp: ${transp},
status: ${status}
    ''';
  }
}
