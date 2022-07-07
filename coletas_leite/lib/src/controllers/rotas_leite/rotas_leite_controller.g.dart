// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotas_leite_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RotasLeiteController on _RotasLeiteControllerBase, Store {
  late final _$rotasAtom =
      Atom(name: '_RotasLeiteControllerBase.rotas', context: context);

  @override
  ObservableList<RotasLeiteModel> get rotas {
    _$rotasAtom.reportRead();
    return super.rotas;
  }

  @override
  set rotas(ObservableList<RotasLeiteModel> value) {
    _$rotasAtom.reportWrite(value, super.rotas, () {
      super.rotas = value;
    });
  }

  late final _$statusAtom =
      Atom(name: '_RotasLeiteControllerBase.status', context: context);

  @override
  RotasLeiteStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(RotasLeiteStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$getRotasAsyncAction =
      AsyncAction('_RotasLeiteControllerBase.getRotas', context: context);

  @override
  Future<void> getRotas() {
    return _$getRotasAsyncAction.run(() => super.getRotas());
  }

  late final _$gravaRotasAsyncAction =
      AsyncAction('_RotasLeiteControllerBase.gravaRotas', context: context);

  @override
  Future<void> gravaRotas() {
    return _$gravaRotasAsyncAction.run(() => super.gravaRotas());
  }

  late final _$buscaRotasAsyncAction =
      AsyncAction('_RotasLeiteControllerBase.buscaRotas', context: context);

  @override
  Future<void> buscaRotas() {
    return _$buscaRotasAsyncAction.run(() => super.buscaRotas());
  }

  late final _$retornaRotaFinalizadaAsyncAction = AsyncAction(
      '_RotasLeiteControllerBase.retornaRotaFinalizada',
      context: context);

  @override
  Future<void> retornaRotaFinalizada({required RotasLeiteModel rotaf}) {
    return _$retornaRotaFinalizadaAsyncAction
        .run(() => super.retornaRotaFinalizada(rotaf: rotaf));
  }

  late final _$onSearchChangedAsyncAction = AsyncAction(
      '_RotasLeiteControllerBase.onSearchChanged',
      context: context);

  @override
  Future<ObservableList<RotasLeiteModel>> onSearchChanged(
      {required String value}) {
    return _$onSearchChangedAsyncAction
        .run(() => super.onSearchChanged(value: value));
  }

  late final _$deletaRotasAsyncAction =
      AsyncAction('_RotasLeiteControllerBase.deletaRotas', context: context);

  @override
  Future<void> deletaRotas() {
    return _$deletaRotasAsyncAction.run(() => super.deletaRotas());
  }

  late final _$_RotasLeiteControllerBaseActionController =
      ActionController(name: '_RotasLeiteControllerBase', context: context);

  @override
  dynamic limpaDados() {
    final _$actionInfo = _$_RotasLeiteControllerBaseActionController
        .startAction(name: '_RotasLeiteControllerBase.limpaDados');
    try {
      return super.limpaDados();
    } finally {
      _$_RotasLeiteControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
rotas: ${rotas},
status: ${status}
    ''';
  }
}
