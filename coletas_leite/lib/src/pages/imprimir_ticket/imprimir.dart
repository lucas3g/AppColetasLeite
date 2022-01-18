import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/pages/imprimir_ticket/status_imprimir.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/meu_toast.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';

class ImprimirPage extends StatefulWidget {
  const ImprimirPage({Key? key}) : super(key: key);

  @override
  State<ImprimirPage> createState() => _ImprimirPageState();
}

class _ImprimirPageState extends State<ImprimirPage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice = GlobalSettings().appSettings.imp;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  final controller = GlobalSettings().appSettings;

  late ImprimirStatus status = ImprimirStatus.empty;

  late bool conectada = false;

  Future<void> deviceConectado() async {
    if ((await printer.isConnected)!) {
      conectada = true;
    } else {
      conectada = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDevices();
    deviceConectado();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuração da Impressora'),
        backgroundColor: AppTheme.colors.secondaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/dashboard', (Route<dynamic> route) => false);
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<BluetoothDevice>(
              value: selectedDevice,
              hint: Text('Selecione a Impressora'),
              onChanged: (device) {
                setState(() {
                  selectedDevice = device;
                });
              },
              items: devices
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(e.name!),
                      value: e,
                    ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.colors.secondaryColor,
              ),
              onPressed: !conectada
                  ? () async {
                      status = ImprimirStatus.loading;
                      setState(() {});
                      await printer.connect(selectedDevice!);
                      controller.setImp(device: selectedDevice!);
                      conectada = true;
                      setState(() {});
                      MeuToast.toast(
                          title: 'Sucesso',
                          message: 'Impressora conectada!',
                          type: TypeToast.success,
                          context: context);
                      status = ImprimirStatus.success;
                    }
                  : null,
              child: status == ImprimirStatus.loading
                  ? Container(
                      height: 25,
                      width: 25,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Text('Conectar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.colors.secondaryColor,
              ),
              onPressed: conectada
                  ? () async {
                      status = ImprimirStatus.loading;
                      setState(() {});
                      await printer.disconnect();
                      controller.removeImpressora();
                      conectada = false;
                      setState(() {});
                      MeuToast.toast(
                          title: 'Atençao',
                          message: 'Impressora desconectada!',
                          type: TypeToast.dadosInv,
                          context: context);
                      status = ImprimirStatus.success;
                    }
                  : null,
              child: Text('Desconectar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.colors.secondaryColor,
              ),
              onPressed: conectada
                  ? () async {
                      if ((await printer.isConnected)!) {
                        printer.printNewLine();
                        printer.printCustom(
                            "Sucesso voce configurou a impressora!!", 1, 1);
                        printer.printNewLine();
                        printer.printNewLine();
                        printer.printNewLine();
                        printer.printNewLine();
                        printer.printNewLine();
                        printer.printNewLine();
                      }
                    }
                  : null,
              child: Text('Testar Impressão'),
            ),
          ],
        ),
      ),
    );
  }
}
