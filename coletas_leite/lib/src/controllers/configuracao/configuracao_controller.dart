import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/configuracao/configuracao_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
part 'configuracao_controller.g.dart';

class ConfiguracaoController = _ConfiguracaoControllerBase
    with _$ConfiguracaoController;

abstract class _ConfiguracaoControllerBase with Store {
  @observable
  ObservableList<BluetoothDevice> devices = ObservableList.of([]);

  @observable
  BluetoothDevice? selectedDevice;

  @observable
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @observable
  ConfiguracaoStatus status = ConfiguracaoStatus.empty;

  @observable
  late bool conectada = false;

  @observable
  late String id = '';

  @action
  Future<void> deviceConectado() async {
    status = ConfiguracaoStatus.loading;
    await GlobalSettings().appSettings.readImpressora();
    selectedDevice = await GlobalSettings().appSettings.imp;
    id = selectedDevice != null ? selectedDevice!.address! : '';
    printer = BlueThermalPrinter.instance;
    conectada = (await printer.isConnected)! && selectedDevice != null;
    if (!(await printer.isConnected)! && selectedDevice != null) {
      await printer.connect(selectedDevice!);
      conectada = true;
    }
    status = ConfiguracaoStatus.success;
  }

  @action
  Future<void> getDevices() async {
    status = ConfiguracaoStatus.loading;
    devices = ObservableList.of(await printer.getBondedDevices());
    status = ConfiguracaoStatus.success;
  }

  @action
  Future<void> conectaImpressora() async {
    try {
      await GlobalSettings().appSettings.readImpressora();
      selectedDevice = await GlobalSettings().appSettings.imp;
      printer = BlueThermalPrinter.instance;
      if (selectedDevice != null) {
        if ((await printer.isConnected)!) {
          await printer.disconnect();
        }
        id = selectedDevice!.address!;
        await printer.connect(selectedDevice!);
        conectada = true;
      }
    } catch (e) {
      status = ConfiguracaoStatus.error;
    }
  }

  @action
  Future<void> conecta(
      {required BluetoothDevice device, required BuildContext context}) async {
    try {
      status = ConfiguracaoStatus.conectando;
      id = device.address!;
      await printer.connect(device);
      await GlobalSettings().appSettings.setImp(device: device);
      await GlobalSettings().appSettings.readImpressora();
      selectedDevice = device;
      conectada = true;
      status = ConfiguracaoStatus.success;
    } catch (e) {
      status = ConfiguracaoStatus.error;
    }
  }

  @action
  Future<void> desconecta() async {
    status = ConfiguracaoStatus.desconectando;
    await Future.delayed(Duration(milliseconds: 500));
    await printer.disconnect();
    await GlobalSettings().appSettings.removeImpressora();
    selectedDevice = null;
    conectada = false;
    id = '';
    status = ConfiguracaoStatus.success;
  }

  @action
  Future<void> testeImpressao() async {
    if ((await printer.isConnected)!) {
      printer.printNewLine();
      printer.printCustom("Sucesso voce configurou a impressora!!", 1, 1);
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
      printer.printNewLine();
    }
  }
}
