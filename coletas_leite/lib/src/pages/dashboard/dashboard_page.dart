import 'dart:io';

import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/coletas/coletas_status.dart';
import 'package:coletas_leite/src/pages/coletas/coletas_page.dart';
import 'package:coletas_leite/src/pages/dashboard/widgets/app_bar_widget.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/loading_widget.dart';
import 'package:coletas_leite/src/utils/meu_toast.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final controller = GlobalSettings().controllerColetas;
  final controllerEnvio = GlobalSettings().controllerEnvio;

  void getColetas() async {
    await controller.getColetas();
  }

  @override
  void initState() {
    autorun((_) {
      getColetas();
    });

    super.initState();
  }

  void modalEnvio() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
                          width: 120,
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
                          final result = await controllerEnvio.enviar();
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
                                  message: 'Todas as coletas já foram enviadas',
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
                        },
                        child: PhysicalModel(
                          color: Colors.white,
                          elevation: 8,
                          shadowColor: AppTheme.colors.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            child: Center(
                              child: Text(
                                'Enviar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            height: 45,
                            width: 120,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(size: size, context: context),
      body: Column(
        children: [
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
                                      color: Colors.grey.shade200,
                                      offset: Offset(0, 7))
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: controller.ListaColetas[index]
                                                .rota_finalizada ==
                                            1
                                        ? Border(
                                            top: BorderSide(
                                                width: 10, color: Colors.green),
                                          )
                                        : null,
                                  ),
                                  child: ListTile(
                                    onTap: () async {
                                      if (controller.ListaColetas[index]
                                              .rota_finalizada ==
                                          0) {
                                        await Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ColetasPage(
                                                id_rota: controller
                                                    .ListaColetas[index]
                                                    .rota_coleta!,
                                                coleta: controller
                                                    .ListaColetas[index],
                                                placa: controller
                                                    .ListaColetas[index]
                                                    .transportador!,
                                              ),
                                            ),
                                            (Route<dynamic> route) =>
                                                route.isFirst);
                                      } else {
                                        MeuToast.toast(
                                            title: 'Rota Já Finalizada',
                                            message: controller
                                                .ListaColetas[index].rota_nome!,
                                            type: TypeToast.dadosInv,
                                            context: context);
                                      }
                                    },
                                    trailing: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: controller.ListaColetas[index]
                                                      .enviada ==
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
                                                        .rota_coleta
                                                        .toString() +
                                                    ' - ' +
                                                    controller
                                                        .ListaColetas[index]
                                                        .rota_nome!,
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
                                                  .ListaColetas[index].data_mov!
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
                                              'KM Inicial: ',
                                              style: AppTheme
                                                  .textStyles.dropdownText
                                                  .copyWith(fontSize: 16),
                                            ),
                                            Text(
                                              controller.ListaColetas[index]
                                                  .km_inicio!
                                                  .toString(),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              'KM Final: ',
                                              style: AppTheme
                                                  .textStyles.dropdownText
                                                  .copyWith(fontSize: 16),
                                            ),
                                            Text(
                                              controller
                                                  .ListaColetas[index].km_fim!
                                                  .toString(),
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
                                                  .transportador!,
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
                                                          .rota_finalizada! ==
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
                                                          .enviada! ==
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
                    ? Container(
                        child: Center(
                          child: Text('Nenhuma coleta encontrada!'),
                        ),
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
                    modalEnvio();
                  }
                } on SocketException catch (_) {
                  MeuToast.toast(
                      title: 'Sem Internet',
                      message:
                          'Você precisa esta conectado na internet para enviar as coletas para o servidor',
                      type: TypeToast.noNet,
                      context: context);
                  print('Sem Internet Login');
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
