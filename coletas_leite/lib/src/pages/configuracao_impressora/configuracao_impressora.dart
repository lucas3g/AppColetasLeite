import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/configuracao/configuracao_status.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ConfiguracaoImpressora extends StatefulWidget {
  const ConfiguracaoImpressora({Key? key}) : super(key: key);

  @override
  State<ConfiguracaoImpressora> createState() => _ConfiguracaoImpressoraState();
}

class _ConfiguracaoImpressoraState extends State<ConfiguracaoImpressora> {
  final controller = GlobalSettings().controllerConfig;

  Future<void> deviceConectado() async {
    await controller.deviceConectado();
  }

  Future<void> getDevices() async {
    await controller.getDevices();
  }

  @override
  void initState() {
    super.initState();
    getDevices();
    deviceConectado();
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Observer(builder: (context) {
                return controller.status == ConfiguracaoStatus.success ||
                        controller.status == ConfiguracaoStatus.conectando ||
                        controller.status == ConfiguracaoStatus.desconectando
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                onTap: () async {
                                  if (!controller.conectada) {
                                    await controller.conecta(
                                      device: controller.devices[index],
                                      context: context,
                                    );
                                  } else {
                                    await controller.desconecta();
                                  }
                                },
                                title: Text(controller.devices[index].name!),
                                subtitle: (controller.status ==
                                                ConfiguracaoStatus.conectando ||
                                            controller.status ==
                                                ConfiguracaoStatus
                                                    .desconectando) &&
                                        controller.id ==
                                            controller.devices[index].address
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppTheme
                                                      .colors.secondaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : controller.conectada &&
                                            controller.selectedDevice != null &&
                                            controller.id ==
                                                controller
                                                    .devices[index].address
                                        ? Text(
                                            'Impressora Conectada!',
                                            style: AppTheme
                                                .textStyles.titleLogin
                                                .copyWith(
                                              fontSize: 14,
                                              color: AppTheme
                                                  .colors.secondaryColor,
                                            ),
                                          )
                                        : Text('Pressione para Conectar!'),
                                leading: Container(
                                  height: double.maxFinite,
                                  child: Icon(
                                    Icons.print_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: controller.conectada &&
                                        controller.selectedDevice != null &&
                                        controller.id ==
                                            controller.devices[index].address
                                    ? IconButton(
                                        onPressed: () {
                                          controller.testeImpressao();
                                        },
                                        icon: Icon(
                                          Icons.print_outlined,
                                          color: AppTheme.colors.secondaryColor,
                                        ),
                                      )
                                    : null,
                                minLeadingWidth: 20,
                              ));
                        },
                        itemCount: controller.devices.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                      )
                    : Container(
                        child: Text('Nenhuma Impressora Encontrada!'),
                      );
              }),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary: AppTheme.colors.secondaryColor,
            //   ),
            //   onPressed: !conectada && selectedDevice != null
            //       ? () async {
            //           status = ConfiguracaoStatus.loading;
            //           setState(() {});
            //           if ((await printer.isConnected)!) {
            //             await printer.disconnect();
            //           }
            //           await printer.connect(selectedDevice!);
            //           await controller.setImp(device: selectedDevice!);
            //           conectada = true;
            //           setState(() {});
            //           MeuToast.toast(
            //               title: 'Sucesso',
            //               message: 'Impressora conectada!',
            //               type: TypeToast.success,
            //               context: context);
            //           status = ConfiguracaoStatus.success;
            //         }
            //       : null,
            //   child: status == ConfiguracaoStatus.loading
            //       ? Container(
            //           height: 25,
            //           width: 25,
            //           child: Center(
            //             child: CircularProgressIndicator(
            //               color: Colors.white,
            //             ),
            //           ),
            //         )
            //       : Text('Conectar'),
            // ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary: AppTheme.colors.secondaryColor,
            //   ),
            //   onPressed: conectada
            //       ? () async {
            //           status = ConfiguracaoStatus.loading;
            //           setState(() {});
            //           await printer.disconnect();
            //           await controller.removeImpressora();
            //           conectada = false;
            //           setState(() {});
            //           MeuToast.toast(
            //               title: 'Atençao',
            //               message: 'Impressora desconectada!',
            //               type: TypeToast.dadosInv,
            //               context: context);
            //           status = ConfiguracaoStatus.success;
            //         }
            //       : null,
            //   child: Text('Desconectar'),
            // ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary: AppTheme.colors.secondaryColor,
            //   ),
            //   onPressed: conectada
            //       ? () async {
            // if ((await printer.isConnected)!) {
            //   printer.printNewLine();
            //   printer.printCustom(
            //       "Sucesso voce configurou a impressora!!", 1, 1);
            //   printer.printNewLine();
            //   printer.printNewLine();
            //   printer.printNewLine();
            //   printer.printNewLine();
            //   printer.printNewLine();
            //   printer.printNewLine();
            // }
            //         }
            //       : null,
            //   child: Text('Testar Impressão'),
            // ),
          ],
        ),
      ),
    );
  }
}
