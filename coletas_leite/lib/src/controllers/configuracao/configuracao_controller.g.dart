// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuracao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConfiguracaoController on _ConfiguracaoControllerBase, Store {
  final _$devicesAtom = Atom(name: '_ConfiguracaoControllerBase.devices');

  @override
  ObservableList<BluetoothDevice> get devices {
    _$devicesAtom.reportRead();
    return super.devices;
  }

  @override
  set devices(ObservableList<BluetoothDevice> value) {
    _$devicesAtom.reportWrite(value, super.devices, () {
      super.devices = value;
    });
  }

  final _$selectedDeviceAtom =
      Atom(name: '_ConfiguracaoControllerBase.selectedDevice');

  @override
  BluetoothDevice? get selectedDevice {
    _$selectedDeviceAtom.reportRead();
    return super.selectedDevice;
  }

  @override
  set selectedDevice(BluetoothDevice? value) {
    _$selectedDeviceAtom.reportWrite(value, super.selectedDevice, () {
      super.selectedDevice = value;
    });
  }

  final _$printerAtom = Atom(name: '_ConfiguracaoControllerBase.printer');

  @override
  BlueThermalPrinter get printer {
    _$printerAtom.reportRead();
    return super.printer;
  }

  @override
  set printer(BlueThermalPrinter value) {
    _$printerAtom.reportWrite(value, super.printer, () {
      super.printer = value;
    });
  }

  final _$statusAtom = Atom(name: '_ConfiguracaoControllerBase.status');

  @override
  ConfiguracaoStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(ConfiguracaoStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$conectadaAtom = Atom(name: '_ConfiguracaoControllerBase.conectada');

  @override
  bool get conectada {
    _$conectadaAtom.reportRead();
    return super.conectada;
  }

  @override
  set conectada(bool value) {
    _$conectadaAtom.reportWrite(value, super.conectada, () {
      super.conectada = value;
    });
  }

  final _$idAtom = Atom(name: '_ConfiguracaoControllerBase.id');

  @override
  String get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(String value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  final _$deviceConectadoAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.deviceConectado');

  @override
  Future<void> deviceConectado() {
    return _$deviceConectadoAsyncAction.run(() => super.deviceConectado());
  }

  final _$getDevicesAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.getDevices');

  @override
  Future<void> getDevices() {
    return _$getDevicesAsyncAction.run(() => super.getDevices());
  }

  final _$conectaImpressoraAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.conectaImpressora');

  @override
  Future<void> conectaImpressora() {
    return _$conectaImpressoraAsyncAction.run(() => super.conectaImpressora());
  }

  final _$conectaAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.conecta');

  @override
  Future<void> conecta(
      {required BluetoothDevice device, required BuildContext context}) {
    return _$conectaAsyncAction
        .run(() => super.conecta(device: device, context: context));
  }

  final _$desconectaAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.desconecta');

  @override
  Future<void> desconecta() {
    return _$desconectaAsyncAction.run(() => super.desconecta());
  }

  final _$testeImpressaoAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.testeImpressao');

  @override
  Future<void> testeImpressao() {
    return _$testeImpressaoAsyncAction.run(() => super.testeImpressao());
  }

  @override
  String toString() {
    return '''
devices: ${devices},
selectedDevice: ${selectedDevice},
printer: ${printer},
status: ${status},
conectada: ${conectada},
id: ${id}
    ''';
  }
}
