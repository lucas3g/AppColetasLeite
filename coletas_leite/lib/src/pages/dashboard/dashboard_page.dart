import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/coletas/coletas_status.dart';
import 'package:coletas_leite/src/pages/coletas/coletas_page.dart';
import 'package:coletas_leite/src/pages/dashboard/widgets/app_bar_widget.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
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
                                'Enviar Todas as Rotas Finalizadas para o Servidor?',
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
                          await controllerEnvio.enviar();
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
                                  color: controller.ListaColetas[index]
                                              .rota_finalizada ==
                                          0
                                      ? Colors.grey.withOpacity(0.5)
                                      : Colors.green.shade500,
                                  boxShadow: [
                                    BoxShadow(
                                      color: controller.ListaColetas[index]
                                                  .rota_finalizada ==
                                              0
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.green.shade500,
                                      blurRadius: 5,
                                      offset: Offset(0, 5),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                onTap: () async {
                                  if (controller.ListaColetas[index]
                                          .rota_finalizada ==
                                      0) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ColetasPage(
                                          id_rota: controller
                                              .ListaColetas[index].rota_coleta!,
                                          coleta:
                                              controller.ListaColetas[index],
                                        ),
                                      ),
                                    );
                                    controller.getColetas();
                                  } else {
                                    MeuToast.toast(
                                        title: 'Rota Já Finalizada',
                                        message: controller
                                            .ListaColetas[index].rota_nome!,
                                        type: TypeToast.dadosInv,
                                        context: context);
                                  }
                                },
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
                                                controller.ListaColetas[index]
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
                                              .ListaColetas[index].data_mov!,
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
                                          controller
                                              .ListaColetas[index].km_inicio!
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
                                          controller.ListaColetas[index].km_fim!
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
                                  ],
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
                : Container(
                    child: Center(child: Text('Nenhuma Coleta Encontrada')),
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
              onPressed: () {
                modalEnvio();
              },
              child: Icon(Icons.upgrade),
              backgroundColor: AppTheme.colors.secondaryColor,
            ),
            FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/rotas_leite');
                controller.getColetas();
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
