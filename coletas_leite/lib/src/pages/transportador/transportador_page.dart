import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_status.dart';
import 'package:coletas_leite/src/models/transportes/transportes_model.dart';
import 'package:coletas_leite/src/pages/coletas/coletas_page.dart';
import 'package:coletas_leite/src/pages/transportador/widgets/card_transportador_widget.dart';
import 'package:coletas_leite/src/utils/formatters.dart';
import 'package:coletas_leite/src/utils/loading_widget.dart';
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
  final TextEditingController controllerInput = TextEditingController();
  List<TransportesModel> filteredTransp = [];
  late String? ultPlaca = '';

  void ultimaPlaca() async {
    ultPlaca = (await controller.retornaUltimaPlaca());
    setState(() {});
  }

  void getTransp() async {
    if (controller.transp.isEmpty) await controller.getTransp();
    filteredTransp = controller.transp;
    filteredTransp =
        await controller.jogaPlacaParaPrimeiro(lista: filteredTransp);
    setState(() {});
  }

  void _onSearchChanged(String value) async {
    filteredTransp = await controller.onSearchChanged(value: value);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      ultimaPlaca();
      getTransp();
    });
  }

  void modalColeta({required String caminhao, required int tanques}) async {
    late int km_inicio;
    final Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final GlobalKey<FormState> key = GlobalKey<FormState>();
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) =>
                SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Informações',
                    style:
                        AppTheme.textStyles.titleCharts.copyWith(fontSize: 20),
                  ),
                  Divider(),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                          Form(
                            key: key,
                            child: TextFormField(
                              autofocus: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe os KM iniciais.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setStateDialog(() {
                                  km_inicio = int.tryParse(value.toString())!;
                                });
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
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
                      GestureDetector(
                        onTap: () async {
                          if (key.currentState!.validate()) {
                            key.currentState!.save();
                            await controllerColetas.iniciaColeta(
                                rota: widget.id_rota,
                                rota_nome: widget.rota,
                                motorista: motorista!,
                                caminhao: caminhao,
                                km_inicio: km_inicio,
                                tanques: tanques);

                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ColetasPage(
                                    id_rota: widget.id_rota,
                                    coleta: controllerColetas.coletas,
                                    placa: caminhao,
                                    tanques: tanques,
                                  ),
                                ),
                                (route) => false);
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
                                'Iniciar Rota',
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
        title: Text('Selecione o Caminhão'),
        // leading: IconButton(
        //   onPressed: () async {
        //     await Navigator.pushNamedAndRemoveUntil(
        //         context, '/rotas_leite', (Route<dynamic> route) => false);
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
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
            Theme(
              data: ThemeData(
                colorScheme: ThemeData().colorScheme.copyWith(
                      primary: AppTheme.colors.secondaryColor,
                    ),
              ),
              child: PhysicalModel(
                color: Colors.white,
                elevation: 8,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  controller: controllerInput,
                  inputFormatters: [UpperCaseTextFormatter()],
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                  cursorColor: AppTheme.colors.primaryColor,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 25,
                    ),
                    suffixIcon: controllerInput.value.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 25,
                            ),
                            onPressed: () {
                              controllerInput.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    hintText: 'Digite a placa ou descrição do caminhão',
                    hintStyle: TextStyle(fontSize: 14),
                    alignLabelWithHint: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: AppTheme.colors.secondaryColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Observer(builder: (_) {
              return controller.status == TransportesStatus.success &&
                      filteredTransp.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                                height: 15,
                              ),
                          itemCount: filteredTransp.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CardTransportadorWidget(
                                filteredTransp: filteredTransp,
                                ultPlaca: ultPlaca,
                                index: index,
                                modalColeta: modalColeta);
                          }),
                    )
                  : controller.status == TransportesStatus.loading
                      ? Expanded(
                          child: ListView.separated(
                              itemBuilder: (_, __) => LoadingWidget(
                                  size: Size(double.maxFinite, 50), radius: 10),
                              separatorBuilder: (_, __) => SizedBox(
                                    height: 15,
                                  ),
                              itemCount: 10),
                        )
                      : Container(
                          child: Center(
                            child: Text('Nenhum caminhão encontrado!'),
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }
}
