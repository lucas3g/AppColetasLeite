import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_status.dart';
import 'package:coletas_leite/src/pages/coletas/coletas_page.dart';
import 'package:flutter/material.dart';

import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TransportadorPage extends StatefulWidget {
  final String rota;
  final int id_rota;
  const TransportadorPage({
    Key? key,
    required this.rota,
    required this.id_rota,
  }) : super(key: key);

  @override
  State<TransportadorPage> createState() => _TransportadorPageState();
}

class _TransportadorPageState extends State<TransportadorPage> {
  final controller = GlobalSettings().controllerTransp;
  final controllerColetas = GlobalSettings().controllerColetas;
  final motorista = GlobalSettings().appSettings.user.nome;

  void getTransp() async {
    if (controller.transp.isEmpty) await controller.getTransp();
  }

  void iniciaRota({required String caminhao, required int km_inicio}) async {
    await controllerColetas.iniciaColeta(
        rota: widget.id_rota,
        rota_nome: widget.rota,
        motorista: motorista!,
        caminhao: caminhao,
        km_inicio: km_inicio);
  }

  @override
  void initState() {
    getTransp();

    super.initState();
  }

  void modalColeta({required String caminhao}) {
    late int km_inicio;

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
                  'Informações',
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
                            Text(
                              'Rota: ',
                              style: AppTheme.textStyles.dropdownText
                                  .copyWith(fontSize: 16),
                            ),
                            Expanded(child: Text(widget.rota)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Motorista: ',
                              style: AppTheme.textStyles.dropdownText
                                  .copyWith(fontSize: 16),
                            ),
                            Expanded(child: Text(motorista!)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Caminhão: ',
                              style: AppTheme.textStyles.dropdownText
                                  .copyWith(fontSize: 16),
                            ),
                            Expanded(child: Text(caminhao)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'KM Inicial',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              km_inicio = int.parse(value);
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          cursorColor: AppTheme.colors.secondaryColor,
                          style: AppTheme.textStyles.title.copyWith(
                              fontSize: 16,
                              color: AppTheme.colors.secondaryColor),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppTheme.colors.secondaryColor),
                            ),
                          ),
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
                    GestureDetector(
                      onTap: () {
                        iniciaRota(caminhao: caminhao, km_inicio: km_inicio);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ColetasPage(
                              id_rota: widget.id_rota,
                              coleta: controllerColetas.coletas,
                            ),
                          ),
                        );
                      },
                      child: PhysicalModel(
                        color: Colors.white,
                        elevation: 8,
                        shadowColor: AppTheme.colors.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Center(
                            child: Text(
                              'Iniciar Rota',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.secondaryColor,
        title: Text('Selecione o Caminhão'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rota seleciona: ',
                  style:
                      AppTheme.textStyles.dropdownText.copyWith(fontSize: 20),
                ),
                Expanded(
                  child: Text(
                    '${widget.rota}',
                    style: AppTheme.textStyles.button.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Observer(
                builder: (_) => controller.status == TransportesStatus.success
                    ? Expanded(
                        child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                                      height: 15,
                                    ),
                            itemCount: controller.transp.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  onTap: () {
                                    modalColeta(
                                        caminhao:
                                            controller.transp[index].placa);
                                  },
                                  minLeadingWidth: 10,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  leading: Container(
                                    child: Icon(
                                      Icons.local_shipping_outlined,
                                      color: Colors.black,
                                    ),
                                    height: double.maxFinite,
                                  ),
                                  title: Text(
                                    controller.transp[index].descricao,
                                    style:
                                        AppTheme.textStyles.titleLogin.copyWith(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        'Placa: ',
                                        style: AppTheme.textStyles.titleLogin
                                            .copyWith(
                                                fontSize: 14,
                                                color: Colors.black),
                                      ),
                                      Text(controller.transp[index].placa)
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    : Container()),
          ],
        ),
      ),
    );
  }
}
