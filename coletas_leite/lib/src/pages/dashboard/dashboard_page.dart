import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/coletas/coletas_status.dart';
import 'package:coletas_leite/src/pages/coletas/coletas_page.dart';
import 'package:coletas_leite/src/pages/dashboard/widgets/app_bar_widget.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/formatters.dart';
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
                          left: 20, right: 20, bottom: 20),
                      child: ListView.separated(
                          itemBuilder: (_, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: controller.ListaColetas[index]
                                              .rota_finalizada ==
                                          0
                                      ? Colors.grey.withOpacity(0.5)
                                      : Colors.green.withOpacity(0.5),
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ColetasPage(
                                        id_rota: controller
                                            .ListaColetas[index].rota_coleta!,
                                      ),
                                    ),
                                  );
                                },
                                title: Column(
                                  children: [
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
                                              .DiaMesAno(),
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
                                height: 15,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/rotas_leite');
        },
        child: Icon(Icons.add),
        backgroundColor: AppTheme.colors.secondaryColor,
      ),
    );
  }
}
