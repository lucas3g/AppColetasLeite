// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sincronizar_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SincronizarController on _SincronizarControllerBase, Store {
  late final _$statusAtom =
      Atom(name: '_SincronizarControllerBase.status', context: context);

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

  late final _$baixaTodasAsyncAction =
      AsyncAction('_SincronizarControllerBase.baixaTodas', context: context);

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
