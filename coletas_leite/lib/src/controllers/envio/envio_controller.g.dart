// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envio_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EnvioController on _EnvioControllerBase, Store {
  final _$statusAtom = Atom(name: '_EnvioControllerBase.status');

  @override
  EnvioStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(EnvioStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$enviarAsyncAction = AsyncAction('_EnvioControllerBase.enviar');

  @override
  Future<int> enviar({required BuildContext context}) {
    return _$enviarAsyncAction.run(() => super.enviar(context: context));
  }

  @override
  String toString() {
    return '''
status: ${status}
    ''';
  }
}
