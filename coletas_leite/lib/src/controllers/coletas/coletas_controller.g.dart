// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coletas_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ColetasController on _ColetasControllerBase, Store {
  final _$coletasAtom = Atom(name: '_ColetasControllerBase.coletas');

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

  final _$ListaColetasAtom = Atom(name: '_ColetasControllerBase.ListaColetas');

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

  final _$statusAtom = Atom(name: '_ColetasControllerBase.status');

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

  final _$iniciaColetaAsyncAction =
      AsyncAction('_ColetasControllerBase.iniciaColeta');

  @override
  Future<void> iniciaColeta(
      {required int rota,
      required String rota_nome,
      required String motorista,
      required String caminhao,
      required int km_inicio}) {
    return _$iniciaColetaAsyncAction.run(() => super.iniciaColeta(
        rota: rota,
        rota_nome: rota_nome,
        motorista: motorista,
        caminhao: caminhao,
        km_inicio: km_inicio));
  }

  final _$getColetasAsyncAction =
      AsyncAction('_ColetasControllerBase.getColetas');

  @override
  Future<void> getColetas() {
    return _$getColetasAsyncAction.run(() => super.getColetas());
  }

  final _$finalizaColetaAsyncAction =
      AsyncAction('_ColetasControllerBase.finalizaColeta');

  @override
  Future<void> finalizaColeta({required ColetasModel coleta}) {
    return _$finalizaColetaAsyncAction
        .run(() => super.finalizaColeta(coleta: coleta));
  }

  final _$retornaRotaFinalizadaAsyncAction =
      AsyncAction('_ColetasControllerBase.retornaRotaFinalizada');

  @override
  Future<bool> retornaRotaFinalizada({required int id}) {
    return _$retornaRotaFinalizadaAsyncAction
        .run(() => super.retornaRotaFinalizada(id: id));
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
