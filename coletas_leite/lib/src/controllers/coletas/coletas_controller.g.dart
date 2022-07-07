// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coletas_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ColetasController on _ColetasControllerBase, Store {
  late final _$coletasAtom =
      Atom(name: '_ColetasControllerBase.coletas', context: context);

  @override
  ColetasModel get coletas {
    _$coletasAtom.reportRead();
    return super.coletas;
  }

  @override
  set coletas(ColetasModel value) {
    _$coletasAtom.reportWrite(value, super.coletas, () {
      super.coletas = value;
    });
  }

  late final _$ListaColetasAtom =
      Atom(name: '_ColetasControllerBase.ListaColetas', context: context);

  @override
  ObservableList<ColetasModel> get ListaColetas {
    _$ListaColetasAtom.reportRead();
    return super.ListaColetas;
  }

  @override
  set ListaColetas(ObservableList<ColetasModel> value) {
    _$ListaColetasAtom.reportWrite(value, super.ListaColetas, () {
      super.ListaColetas = value;
    });
  }

  late final _$statusAtom =
      Atom(name: '_ColetasControllerBase.status', context: context);

  @override
  ColetasStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(ColetasStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$iniciaColetaAsyncAction =
      AsyncAction('_ColetasControllerBase.iniciaColeta', context: context);

  @override
  Future<void> iniciaColeta(
      {required int rota,
      required String rota_nome,
      required String motorista,
      required String caminhao,
      required int km_inicio,
      required int tanques}) {
    return _$iniciaColetaAsyncAction.run(() => super.iniciaColeta(
        rota: rota,
        rota_nome: rota_nome,
        motorista: motorista,
        caminhao: caminhao,
        km_inicio: km_inicio,
        tanques: tanques));
  }

  late final _$getColetasAsyncAction =
      AsyncAction('_ColetasControllerBase.getColetas', context: context);

  @override
  Future<void> getColetas() {
    return _$getColetasAsyncAction.run(() => super.getColetas());
  }

  late final _$finalizaColetaAsyncAction =
      AsyncAction('_ColetasControllerBase.finalizaColeta', context: context);

  @override
  Future<void> finalizaColeta({required ColetasModel coleta}) {
    return _$finalizaColetaAsyncAction
        .run(() => super.finalizaColeta(coleta: coleta));
  }

  late final _$retornaRotaFinalizadaAsyncAction = AsyncAction(
      '_ColetasControllerBase.retornaRotaFinalizada',
      context: context);

  @override
  Future<bool> retornaRotaFinalizada({required int id}) {
    return _$retornaRotaFinalizadaAsyncAction
        .run(() => super.retornaRotaFinalizada(id: id));
  }

  late final _$imprimirResumoColetasAsyncAction = AsyncAction(
      '_ColetasControllerBase.imprimirResumoColetas',
      context: context);

  @override
  Future<void> imprimirResumoColetas({required ColetasModel coleta}) {
    return _$imprimirResumoColetasAsyncAction
        .run(() => super.imprimirResumoColetas(coleta: coleta));
  }

  late final _$_ColetasControllerBaseActionController =
      ActionController(name: '_ColetasControllerBase', context: context);

  @override
  dynamic limpaDados() {
    final _$actionInfo = _$_ColetasControllerBaseActionController.startAction(
        name: '_ColetasControllerBase.limpaDados');
    try {
      return super.limpaDados();
    } finally {
      _$_ColetasControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
coletas: ${coletas},
ListaColetas: ${ListaColetas},
status: ${status}
    ''';
  }
}
