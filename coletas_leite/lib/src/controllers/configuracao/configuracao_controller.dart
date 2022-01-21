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
  BluetoothDevice? selectedDevice = GlobalSettings().appSettings.imp;

  @observable
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @observable
  ConfiguracaoStatus status = ConfiguracaoStatus.empty;

  @observable
  late bool conectada = false;

  @observable
  late String id = selectedDevice != null ? selectedDevice!.address! : '';

  @action
  Future<void> deviceConectado() async {
    conectada = (await printer.isConnected)! && selectedDevice != null;
  }

  @action
  Future<void> getDevices() async {
    status = ConfiguracaoStatus.loading;
    devices = ObservableList.of(await printer.getBondedDevices());
    status = ConfiguracaoStatus.success;
  }

  @action
  Future<void> conectaImpressora() async {
    if (selectedDevice != null) {
      if ((await printer.isConnected)!) {
        await printer.disconnect();
      }
      id = selectedDevice!.address!;
      await printer.connect(selectedDevice!);
      conectada = true;
    }
  }

  @action
  Future<void> conecta(
      {required BluetoothDevice device, required BuildContext context}) async {
    status = ConfiguracaoStatus.conectando;
    id = device.address!;
    //await Future.delayed(Duration(seconds: 2));
    await printer.connect(device);
    await GlobalSettings().appSettings.setImp(device: device);
    await GlobalSettings().appSettings.readImpressora();
    selectedDevice = device;
    conectada = true;
    status = ConfiguracaoStatus.success;
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
