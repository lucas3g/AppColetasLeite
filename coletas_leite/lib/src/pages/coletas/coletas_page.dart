import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/controllers/tiket/tiket_entrada_status.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';

class ColetasPage extends StatefulWidget {
  final int id_rota;
  const ColetasPage({
    Key? key,
    required this.id_rota,
  }) : super(key: key);

  @override
  State<ColetasPage> createState() => _ColetasPageState();
}

class _ColetasPageState extends State<ColetasPage> {
  final controller = GlobalSettings().controllerTiket;

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
    String dropdownValue = '1';
    void modalColeta({required TiketEntradaModel tiket}) {
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
                    'Informações sobre a coleta',
                    style:
                        AppTheme.textStyles.titleCharts.copyWith(fontSize: 20),
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
                          TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CentavosInputFormatter()
                            ],
                            textAlign: TextAlign.end,
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
                          TextField(
                            style: AppTheme.textStyles.title.copyWith(
                                fontSize: 16,
                                color: AppTheme.colors.secondaryColor),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.start,
                            cursorColor: AppTheme.colors.secondaryColor,
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
                          Text('ID: ' + tiket.id.toString()),
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
                                  value: dropdownValue,
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
                                  onChanged: (String? newValue) {},
                                  items:
                                      ['1', '2', '3', '4'].map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              )),
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
                          TextField(
                            textAlign: TextAlign.start,
                            cursorColor: AppTheme.colors.secondaryColor,
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
                        onTap: () async {},
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
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
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
                onPressed: () {},
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
