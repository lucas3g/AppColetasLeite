// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transportes_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransportesController on _TransportesControllerBase, Store {
  late final _$transpAtom =
      Atom(name: '_TransportesControllerBase.transp', context: context);

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

  late final _$statusAtom =
      Atom(name: '_TransportesControllerBase.status', context: context);

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

  late final _$getTranspAsyncAction =
      AsyncAction('_TransportesControllerBase.getTransp', context: context);

  @override
  Future<void> getTransp() {
    return _$getTranspAsyncAction.run(() => super.getTransp());
  }

  late final _$gravaCaminhoesAsyncAction = AsyncAction(
      '_TransportesControllerBase.gravaCaminhoes',
      context: context);

  @override
  Future<void> gravaCaminhoes() {
    return _$gravaCaminhoesAsyncAction.run(() => super.gravaCaminhoes());
  }

  late final _$buscaCaminhoesAsyncAction = AsyncAction(
      '_TransportesControllerBase.buscaCaminhoes',
      context: context);

  @override
  Future<void> buscaCaminhoes() {
    return _$buscaCaminhoesAsyncAction.run(() => super.buscaCaminhoes());
  }

  late final _$onSearchChangedAsyncAction = AsyncAction(
      '_TransportesControllerBase.onSearchChanged',
      context: context);

  @override
  Future<ObservableList<TransportesModel>> onSearchChanged(
      {required String value}) {
    return _$onSearchChangedAsyncAction
        .run(() => super.onSearchChanged(value: value));
  }

  late final _$retornaUltimaPlacaAsyncAction = AsyncAction(
      '_TransportesControllerBase.retornaUltimaPlaca',
      context: context);

  @override
  Future<String> retornaUltimaPlaca() {
    return _$retornaUltimaPlacaAsyncAction
        .run(() => super.retornaUltimaPlaca());
  }

  late final _$deletaCaminhoesAsyncAction = AsyncAction(
      '_TransportesControllerBase.deletaCaminhoes',
      context: context);

  @override
  Future<void> deletaCaminhoes() {
    return _$deletaCaminhoesAsyncAction.run(() => super.deletaCaminhoes());
  }

  late final _$jogaPlacaParaPrimeiroAsyncAction = AsyncAction(
      '_TransportesControllerBase.jogaPlacaParaPrimeiro',
      context: context);

  @override
  Future<List<TransportesModel>> jogaPlacaParaPrimeiro(
      {required List<TransportesModel> lista}) {
    return _$jogaPlacaParaPrimeiroAsyncAction
        .run(() => super.jogaPlacaParaPrimeiro(lista: lista));
  }

  late final _$_TransportesControllerBaseActionController =
      ActionController(name: '_TransportesControllerBase', context: context);

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
