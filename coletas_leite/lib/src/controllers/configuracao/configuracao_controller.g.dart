// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuracao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConfiguracaoController on _ConfiguracaoControllerBase, Store {
  late final _$devicesAtom =
      Atom(name: '_ConfiguracaoControllerBase.devices', context: context);

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

  late final _$selectedDeviceAtom = Atom(
      name: '_ConfiguracaoControllerBase.selectedDevice', context: context);

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

  late final _$printerAtom =
      Atom(name: '_ConfiguracaoControllerBase.printer', context: context);

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

  late final _$statusAtom =
      Atom(name: '_ConfiguracaoControllerBase.status', context: context);

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

  late final _$conectadaAtom =
      Atom(name: '_ConfiguracaoControllerBase.conectada', context: context);

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

  late final _$idAtom =
      Atom(name: '_ConfiguracaoControllerBase.id', context: context);

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

  late final _$deviceConectadoAsyncAction = AsyncAction(
      '_ConfiguracaoControllerBase.deviceConectado',
      context: context);

  @override
  Future<void> deviceConectado() {
    return _$deviceConectadoAsyncAction.run(() => super.deviceConectado());
  }

  late final _$getDevicesAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.getDevices', context: context);

  @override
  Future<void> getDevices() {
    return _$getDevicesAsyncAction.run(() => super.getDevices());
  }

  late final _$conectaImpressoraAsyncAction = AsyncAction(
      '_ConfiguracaoControllerBase.conectaImpressora',
      context: context);

  @override
  Future<void> conectaImpressora() {
    return _$conectaImpressoraAsyncAction.run(() => super.conectaImpressora());
  }

  late final _$conectaAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.conecta', context: context);

  @override
  Future<void> conecta(
      {required BluetoothDevice device, required BuildContext context}) {
    return _$conectaAsyncAction
        .run(() => super.conecta(device: device, context: context));
  }

  late final _$desconectaAsyncAction =
      AsyncAction('_ConfiguracaoControllerBase.desconecta', context: context);

  @override
  Future<void> desconecta() {
    return _$desconectaAsyncAction.run(() => super.desconecta());
  }

  late final _$testeImpressaoAsyncAction = AsyncAction(
      '_ConfiguracaoControllerBase.testeImpressao',
      context: context);

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
