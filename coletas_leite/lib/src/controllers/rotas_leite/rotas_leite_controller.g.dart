// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotas_leite_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RotasLeiteController on _RotasLeiteControllerBase, Store {
  final _$rotasAtom = Atom(name: '_RotasLeiteControllerBase.rotas');

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

  final _$statusAtom = Atom(name: '_RotasLeiteControllerBase.status');

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

  final _$getRotasAsyncAction =
      AsyncAction('_RotasLeiteControllerBase.getRotas');

  @override
  Future<void> getRotas() {
    return _$getRotasAsyncAction.run(() => super.getRotas());
  }

  final _$retornaRotaFinalizadaAsyncAction =
      AsyncAction('_RotasLeiteControllerBase.retornaRotaFinalizada');

  @override
  Future<void> retornaRotaFinalizada({required RotasLeiteModel rotaf}) {
    return _$retornaRotaFinalizadaAsyncAction
        .run(() => super.retornaRotaFinalizada(rotaf: rotaf));
  }

  @override
  String toString() {
    return '''
rotas: ${rotas},
status: ${status}
    ''';
  }
}
