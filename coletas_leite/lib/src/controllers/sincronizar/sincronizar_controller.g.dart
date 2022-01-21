// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sincronizar_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SincronizarController on _SincronizarControllerBase, Store {
  final _$statusAtom = Atom(name: '_SincronizarControllerBase.status');

  @override
  SincronizarStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(SincronizarStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$baixaTodasAsyncAction =
      AsyncAction('_SincronizarControllerBase.baixaTodas');

  @override
  Future<void> baixaTodas() {
    return _$baixaTodasAsyncAction.run(() => super.baixaTodas());
  }

  @override
  String toString() {
    return '''
status: ${status}
    ''';
  }
}
