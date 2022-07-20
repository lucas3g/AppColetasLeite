import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/coletas/coletas_status.dart';
import 'package:coletas_leite/src/controllers/envio/envio_status.dart';
import 'package:coletas_leite/src/controllers/login/login_controller.dart';
import 'package:coletas_leite/src/pages/coletas/coletas_page.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/loading_widget.dart';
import 'package:coletas_leite/src/utils/meu_toast.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final controller = GlobalSettings().controllerColetas;
  final controllerEnvio = GlobalSettings().controllerEnvio;
  final controllerLicenca = GlobalSettings().controllerLogin;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  void getColetas() async {
    await controller.getColetas();
  }

  Future<void> enableBT() async {
    BluetoothEnable.enableBluetooth.then((value) {
      if (value == 'true') {
        Navigator.pushReplacementNamed(context, '/configuracao');
      }
    });
  }

  Future<void> customEnableBT(BuildContext context) async {
    await GlobalSettings().appSettings.removeImpressora();
    await printer.disconnect();

    String dialogTitle =
        "Ei! Por favor, me dê permissão para usar o Bluetooth!";
    bool displayDialogContent = true;
    String dialogContent =
        "Este aplicativo requer Bluetooth para se conectar ao dispositivo.";

    String cancelBtnText = "Recusar";
    String acceptBtnText = "Permitir";
    double dialogRadius = 10.0;
    bool barrierDismissible = true; //

    BluetoothEnable.customBluetoothRequest(
            context,
            dialogTitle,
            displayDialogContent,
            dialogContent,
            cancelBtnText,
            acceptBtnText,
            dialogRadius,
            barrierDismissible)
        .then((value) {
      print(value);
    });
  }

  Future<void> modalEnvio() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final Size size = MediaQuery.of(context).size;
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Atenção',
                  style: AppTheme.textStyles.titleCharts.copyWith(fontSize: 20),
                ),
                Divider(),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Enviar Todas as Coletas Finalizadas para o Servidor?',
                                style: AppTheme.textStyles.dropdownText
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: PhysicalModel(
                        color: Colors.white,
                        elevation: 8,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Center(
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          height: 45,
                          width: size.width * 0.28,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Observer(builder: (_) {
                      return GestureDetector(
                        onTap: () async {
                          final value = await controllerEnvio
                              .verificaFuncionarioAutorizado(context: context);

                          switch (value) {
                            case 0:
                              MeuToast.toast(
                                title: 'Atenção',
                                message:
                                    'Funcionário não autorizado a enviar as coletas.',
                                type: TypeToast.dadosInv,
                                context: context,
                              );
                              return;
                            case 2:
                              MeuToast.toast(
                                title: 'Atenção',
                                message: 'Celular sem internet',
                                type: TypeToast.noNet,
                                context: context,
                              );
                              return;
                          }

                          if (controllerEnvio.status == EnvioStatus.empty ||
                              controllerEnvio.status == EnvioStatus.success ||
                              controllerEnvio.status == EnvioStatus.error) {
                            final result = await controllerEnvio.enviar(
                                context: context,
                                id: GlobalSettings().appSettings.logado['id'] ??
                                    '');
                            switch (result) {
                              case 200:
                                Navigator.pop(context);
                                MeuToast.toast(
                                    title: 'Sucesso',
                                    message: 'Coletas enviadas para o servidor',
                                    type: TypeToast.success,
                                    context: context);
                                await controller.getColetas();
                                break;
                              case 1:
                                Navigator.pop(context);
                                MeuToast.toast(
                                    title: 'Atenção',
                                    message: 'Celular sem internet',
                                    type: TypeToast.noNet,
                                    context: context);
                                break;
                              case 0:
                                Navigator.pop(context);
                                MeuToast.toast(
                                    title: 'Atenção',
                                    message:
                                        'Todas as coletas já foram enviadas',
                                    type: TypeToast.dadosInv,
                                    context: context);
                                break;
                              case 4:
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/login', (Route<dynamic> route) => false);
                                MeuToast.toast(
                                    title: 'Atenção',
                                    message:
                                        'Licença inativa. Por favor entre em contato com o suporte.',
                                    type: TypeToast.dadosInv,
                                    context: context);

                                break;
                              default:
                                Navigator.pop(context);
                                MeuToast.toast(
                                    title: 'Erro',
                                    message:
                                        'Não foi possível enviar os arquivos para o servidor',
                                    type: TypeToast.error,
                                    context: context);
                            }
                          }
                        },
                        child: PhysicalModel(
                          color: Colors.white,
                          elevation: 8,
                          shadowColor: AppTheme.colors.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            child: Center(
                              child: controllerEnvio.status ==
                                          EnvioStatus.loading ||
                                      controllerLicenca.status ==
                                          LoginStatus.loading
                                  ? Container(
                                      height: 25,
                                      width: 25,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Enviar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                            ),
                            height: 45,
                            width: size.width * 0.28,
                            decoration: BoxDecoration(
                              color: AppTheme.colors.secondaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> confirmarSair() async {
    final Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(bottom: 15, top: 20, right: 20, left: 20),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/sair.svg',
                  height: 130,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Deseja realmente sair da aplicação?',
                  style: AppTheme.textStyles.titleCharts.copyWith(fontSize: 16),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: PhysicalModel(
                        color: Colors.white,
                        elevation: 8,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Center(
                            child: Text(
                              'Não',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          height: 45,
                          width: size.width * 0.28,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await GlobalSettings().appSettings.removeLogado();
                        await Future.delayed(Duration(milliseconds: 150));
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (Route<dynamic> route) => false);
                      },
                      child: PhysicalModel(
                        color: Colors.white,
                        elevation: 8,
                        shadowColor: AppTheme.colors.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Center(
                              child: Text(
                            'Sim',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                          height: 45,
                          width: size.width * 0.28,
                          decoration: BoxDecoration(
                            color: AppTheme.colors.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getColetas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: AppTheme.colors.secondaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '..: Ágil Coletas :..',
              style: AppTheme.textStyles.title.copyWith(fontSize: 20),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () async {
            await enableBT();
          },
          icon: Icon(
            Icons.settings_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              await confirmarSair();
            },
          )
        ],
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Row(
              children: [
                Text(
                  'Motorista: ${GlobalSettings().appSettings.user.NOME}',
                  style: AppTheme.textStyles.title.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          preferredSize: Size(0, 30),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Lista de Coletas',
            style: AppTheme.textStyles.titleLogin.copyWith(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Observer(builder: (_) {
            return controller.status == ColetasStatus.success
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 15, top: 10),
                          itemBuilder: (_, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.grey.shade300,
                                      offset: Offset(5, 5))
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: controller.ListaColetas[index]
                                                .ROTA_FINALIZADA ==
                                            1
                                        ? AppTheme.borderStyle.borderGreen
                                        : AppTheme.borderStyle.borderRed,
                                  ),
                                  child: ListTile(
                                    onTap: () async {
                                      if (controller.ListaColetas[index]
                                              .ROTA_FINALIZADA ==
                                          0) {
                                        await Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ColetasPage(
                                                id_rota: controller
                                                    .ListaColetas[index]
                                                    .ROTA_COLETA!,
                                                coleta: controller
                                                    .ListaColetas[index],
                                                placa: controller
                                                    .ListaColetas[index]
                                                    .TRANSPORTADOR!,
                                                tanques: controller
                                                    .ListaColetas[index]
                                                    .TANQUES!,
                                              ),
                                            ),
                                            (Route<dynamic> route) => false);
                                      } else {
                                        MeuToast.toast(
                                            title: 'Rota Já Finalizada',
                                            message: controller
                                                .ListaColetas[index].ROTA_NOME!,
                                            type: TypeToast.dadosInv,
                                            context: context);
                                      }
                                    },
                                    trailing: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: controller.ListaColetas[index]
                                                      .ENVIADA ==
                                                  0
                                              ? AppTheme.colors.secondaryColor
                                              : Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    title: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller.ListaColetas[index]
                                                        .ROTA_COLETA
                                                        .toString() +
                                                    ' - ' +
                                                    controller
                                                        .ListaColetas[index]
                                                        .ROTA_NOME!,
                                                style: AppTheme
                                                    .textStyles.dropdownText
                                                    .copyWith(fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Data Mov: ',
                                              style: AppTheme
                                                  .textStyles.dropdownText
                                                  .copyWith(fontSize: 16),
                                            ),
                                            Text(
                                              controller
                                                  .ListaColetas[index].DATA_MOV!
                                                  .replaceAll('"', ''),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'KM: ',
                                              style: AppTheme
                                                  .textStyles.dropdownText
                                                  .copyWith(fontSize: 16),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${controller.ListaColetas[index].KM_INICIO!} / ${controller.ListaColetas[index].KM_FIM!}',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Placa: ',
                                              style: AppTheme
                                                  .textStyles.dropdownText
                                                  .copyWith(fontSize: 16),
                                            ),
                                            Text(
                                              controller.ListaColetas[index]
                                                  .TRANSPORTADOR!,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Rota Finalizada: ',
                                              style: AppTheme
                                                  .textStyles.dropdownText
                                                  .copyWith(fontSize: 16),
                                            ),
                                            Text(
                                              controller.ListaColetas[index]
                                                          .ROTA_FINALIZADA! ==
                                                      0
                                                  ? 'Não'
                                                  : 'Sim',
                                              style: AppTheme.textStyles.button
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Rota Enviada: ',
                                              style: AppTheme
                                                  .textStyles.dropdownText
                                                  .copyWith(fontSize: 16),
                                            ),
                                            Text(
                                              controller.ListaColetas[index]
                                                          .ENVIADA! ==
                                                      0
                                                  ? 'Não'
                                                  : 'Sim',
                                              style: AppTheme.textStyles.button
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        // ExpasionTiketsWidget(
                                        //   key: UniqueKey(),
                                        //   id_coleta: controller
                                        //       .ListaColetas[index].id!,
                                        // ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(
                                height: 20,
                              ),
                          itemCount: controller.ListaColetas.length),
                    ),
                  )
                : controller.status == ColetasStatus.empty
                    ? Center(
                        child: Text('Nenhuma coleta encontrada!'),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ListView.separated(
                                    itemBuilder: (_, __) => LoadingWidget(
                                        size: Size(double.maxFinite, 200),
                                        radius: 20),
                                    separatorBuilder: (_, __) => SizedBox(
                                          height: 15,
                                        ),
                                    itemCount: 5),
                              ),
                            ),
                          ],
                        ),
                      );
          }),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'botao1',
              onPressed: () async {
                try {
                  final result = await InternetAddress.lookup(MeuDio.baseUrl);
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    await modalEnvio();
                  }
                } on SocketException catch (_) {
                  MeuToast.toast(
                      title: 'Sem Internet',
                      message:
                          'Você precisa estar conectado na internet para enviar as coletas para o servidor',
                      type: TypeToast.noNet,
                      context: context);
                }
              },
              child: Icon(Icons.upgrade),
              backgroundColor: AppTheme.colors.secondaryColor,
            ),
            FloatingActionButton(
              heroTag: 'botao2',
              onPressed: () async {
                await Navigator.pushNamed(context, '/rotas_leite');
              },
              child: Icon(Icons.add),
              backgroundColor: AppTheme.colors.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
