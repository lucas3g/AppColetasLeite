import 'package:coletas_leite/src/utils/meu_toast.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/tiket/tiket_entrada_status.dart';
import 'package:coletas_leite/src/models/coletas/coletas_model.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';

class ColetasPage extends StatefulWidget {
  final int id_rota;
  final ColetasModel? coleta;
  const ColetasPage({
    Key? key,
    required this.id_rota,
    this.coleta,
  }) : super(key: key);

  @override
  State<ColetasPage> createState() => _ColetasPageState();
}

class _ColetasPageState extends State<ColetasPage> {
  final controller = GlobalSettings().controllerTiket;
  final controllerColeta = GlobalSettings().controllerColetas;
  String dropdownValue = '1';

  void gravaTikets() async {
    await controller.geraTiketEntrada(rota: widget.id_rota);
  }

  @override
  void initState() {
    gravaTikets();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void modalColeta({required TiketEntradaModel tiket}) {
      dropdownValue = tiket.particao.toString();
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateDialog) =>
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Informações sobre a coleta',
                      style: AppTheme.textStyles.titleCharts
                          .copyWith(fontSize: 20),
                    ),
                    Divider(),
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Quantidade LT',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                tiket.quantidade = int.tryParse(value);
                              },
                              initialValue: tiket.quantidade!.toString(),
                              textAlign: TextAlign.end,
                              cursorColor: AppTheme.colors.secondaryColor,
                              style: AppTheme.textStyles.title.copyWith(
                                  fontSize: 16,
                                  color: AppTheme.colors.secondaryColor),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: AppTheme.colors.secondaryColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Temperatura',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: AppTheme.textStyles.title.copyWith(
                                  fontSize: 16,
                                  color: AppTheme.colors.secondaryColor),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                tiket.temperatura = double.tryParse(value);
                              },
                              initialValue: tiket.temperatura!.toString(),
                              textAlign: TextAlign.start,
                              cursorColor: AppTheme.colors.secondaryColor,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: AppTheme.colors.secondaryColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: true,
                                    onChanged: (_) {},
                                    activeColor: AppTheme.colors.secondaryColor,
                                  ),
                                  Text('Alizarol')
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Tanque',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 54,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: DropdownButton(
                                  borderRadius: BorderRadius.circular(10),
                                  value: tiket.particao,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_circle_down_sharp,
                                  ),
                                  iconSize: 30,
                                  elevation: 8,
                                  iconEnabledColor:
                                      AppTheme.colors.secondaryColor,
                                  style: AppTheme.textStyles.dropdownText,
                                  underline: Container(),
                                  onChanged: (int? newValue) {
                                    setStateDialog(() {
                                      tiket.particao = newValue!;
                                    });
                                  },
                                  items: [1, 2, 3, 4].map((int value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Motivo da Não Coleta',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              onChanged: (value) {
                                tiket.observacao = value;
                              },
                              initialValue: tiket.observacao,
                              textAlign: TextAlign.start,
                              cursorColor: AppTheme.colors.secondaryColor,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black),
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
                          onTap: () async {
                            setState(() {});
                            await controller.atualizaTiket(coleta: tiket);
                            Navigator.pop(context);
                          },
                          child: PhysicalModel(
                            color: Colors.white,
                            elevation: 8,
                            shadowColor: AppTheme.colors.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Salvar',
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
            ),
          );
        },
      );
    }

    void confirmaFinalizacao({required ColetasModel coleta}) {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Finalizar rota?',
                      style: AppTheme.textStyles.titleCharts
                          .copyWith(fontSize: 20),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'KM Final',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        coleta.km_fim = int.tryParse(value);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      cursorColor: AppTheme.colors.secondaryColor,
                      style: AppTheme.textStyles.title.copyWith(
                          fontSize: 16, color: AppTheme.colors.secondaryColor),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppTheme.colors.secondaryColor),
                        ),
                      ),
                    ),
                    Divider(),
                    Row(
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
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {});
                            await controllerColeta.finalizaColeta(
                                coleta: widget.coleta!);

                            Navigator.popAndPushNamed(context, '/dashboard');

                            MeuToast.toast(
                                title: 'Sucesso',
                                message: 'Rota Finalizada!',
                                type: TypeToast.success,
                                context: context);
                          },
                          child: PhysicalModel(
                            color: Colors.white,
                            elevation: 8,
                            shadowColor: AppTheme.colors.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Finalizar',
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
            ),
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppTheme.colors.secondaryColor,
        title: Text('Produtores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Observer(builder: (_) {
              final ListColetas = controller.tikets
                  .where((e) => e.rota == widget.id_rota)
                  .toList();

              ListColetas.sort((a, b) => ("${a.quantidade} ${a.temperatura}")
                  .toString()
                  .compareTo(("${b.quantidade} ${b.temperatura}").toString()));

              return controller.status == TiketEntradaStatus.success
                  ? Expanded(
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                                height: 15,
                              ),
                          itemCount: ListColetas.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: ListColetas[index].quantidade! > 0 &&
                                          ListColetas[index].temperatura! != 0
                                      ? Colors.green.shade500
                                      : ListColetas[index].quantidade! == 0 &&
                                              ListColetas[index].temperatura! ==
                                                  0
                                          ? Colors.grey.shade400
                                          : Colors.amber.shade400,
                                  border: Border.all(
                                      color: ListColetas[index].quantidade! >
                                                  0 &&
                                              ListColetas[index].temperatura! !=
                                                  0
                                          ? Colors.green.shade500
                                          : ListColetas[index].quantidade! ==
                                                      0 &&
                                                  ListColetas[index]
                                                          .temperatura! ==
                                                      0
                                              ? Colors.grey.shade400
                                              : Colors.amber.shade400),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: ListColetas[index].quantidade! >
                                                    0 &&
                                                ListColetas[index]
                                                        .temperatura! !=
                                                    0
                                            ? Colors.green.shade500
                                            : ListColetas[index].quantidade! ==
                                                        0 &&
                                                    ListColetas[index]
                                                            .temperatura! ==
                                                        0
                                                ? Colors.grey.shade400
                                                : Colors.amber.shade400,
                                        blurRadius: 5,
                                        offset: Offset(0, 5))
                                  ]),
                              child: ListTile(
                                onTap: () {
                                  modalColeta(tiket: ListColetas[index]);
                                },
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                leading: Container(
                                  height: double.maxFinite,
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                minLeadingWidth: 10,
                                title: Text(ListColetas[index].nome,
                                    style: AppTheme.textStyles.titleLogin
                                        .copyWith(
                                            fontSize: 16, color: Colors.black)),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      'Município: ',
                                      style: AppTheme.textStyles.titleLogin
                                          .copyWith(
                                              fontSize: 14,
                                              color: Colors.black),
                                    ),
                                    Text(ListColetas[index].municipios)
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : Container(
                      child: Text('Nenhum tiket encontrado!'),
                    );
            }),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 50),
                  primary: AppTheme.colors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  confirmaFinalizacao(coleta: widget.coleta!);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Finalizar Rota',
                      style:
                          AppTheme.textStyles.labelInput.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
    );
  }
}
