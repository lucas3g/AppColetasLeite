import 'package:coletas_leite/src/controllers/coletas/coletas_status.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model_copy.dart';
import 'package:coletas_leite/src/utils/formatters.dart';
import 'package:coletas_leite/src/utils/loading_widget.dart';
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
  final ColetasModel coleta;
  final String placa;
  final int tanques;
  const ColetasPage({
    Key? key,
    required this.id_rota,
    required this.coleta,
    required this.placa,
    required this.tanques,
  }) : super(key: key);

  @override
  State<ColetasPage> createState() => _ColetasPageState();
}

class _ColetasPageState extends State<ColetasPage> {
  final controller = GlobalSettings().controllerTiket;
  final controllerColeta = GlobalSettings().controllerColetas;
  final controllerConfig = GlobalSettings().controllerConfig;
  final controllerQtd = TextEditingController();
  final controllerTemp = TextEditingController();
  final controllerCrio = TextEditingController();
  final controllerMotivoNC = TextEditingController();
  final TextEditingController controllerInput = TextEditingController();
  List<TiketEntradaModel> filteredProd = [];
  late bool conectada = false;

  FocusNode temp = FocusNode();
  FocusNode qtd = FocusNode();
  FocusNode tanque = FocusNode();
  FocusNode mnc = FocusNode();

  int dropdownValue = 1;
  int id_tiket = -1;

  void gravaTikets() async {
    await controller.geraTiketEntrada(
        rota: widget.id_rota,
        id_coleta: widget.coleta.id!,
        placa: widget.placa);
    setState(() {
      filteredProd = controller.tikets;
    });
  }

  void _onSearchChanged(String value) async {
    filteredProd = await controller.onSearchChanged(value: value);
    setState(() {});
  }

  Future<void> deviceConectado() async {
    await controllerConfig.deviceConectado();
    conectada = controllerConfig.conectada;
    setState(() {});
  }

  int somaLitros() {
    int result = 0;
    for (var item in filteredProd) {
      result += item.quantidade!;
    }
    return result;
  }

  @override
  void initState() {
    super.initState();

    deviceConectado();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      gravaTikets();
    });

    temp.addListener(() {
      if (temp.hasFocus) {
        controllerTemp.selection = TextSelection(
            baseOffset: 0, extentOffset: controllerTemp.text.length);
      }
    });

    qtd.addListener(() {
      if (qtd.hasFocus) {
        controllerTemp.selection = TextSelection(
            baseOffset: 0, extentOffset: controllerTemp.text.length);
      }
    });
  }

  Future<void> modalColeta({required TiketEntradaModel tiket}) async {
    final List<int> listaTanques = [];
    for (var i = 1; i <= widget.tanques; i++) {
      listaTanques.add(i);
    }
    final GlobalKey<FormState> keyQtd = GlobalKey<FormState>();
    final GlobalKey<FormState> keyTemp = GlobalKey<FormState>();
    final GlobalKey<FormState> keyObs = GlobalKey<FormState>();
    dropdownValue = tiket.particao!;
    controllerQtd.text = tiket.quantidade.toString();
    controllerTemp.text = tiket.temperatura.toString();
    controllerCrio.text = tiket.crioscopia.toString();
    controllerMotivoNC.text = tiket.observacao.toString() == 'null'
        ? ''
        : tiket.observacao.toString();
    final TiketEntradaModelCopy tiketCopy = TiketEntradaModelCopy(
        municipios: tiket.municipios,
        nome: tiket.nome,
        rota: tiket.rota,
        uf: tiket.uf,
        alizarol: tiket.alizarol,
        ccusto: tiket.ccusto,
        clifor: tiket.clifor,
        crioscopia: tiket.crioscopia,
        data: tiket.data,
        hora: tiket.hora,
        id: tiket.id,
        id_coleta: tiket.id_coleta,
        observacao: tiket.observacao,
        particao: tiket.particao,
        per_desconto: tiket.per_desconto,
        placa: tiket.placa,
        produto: tiket.produto,
        quantidade: tiket.quantidade,
        rota_nome: tiket.rota_nome,
        temperatura: tiket.temperatura,
        tiket: tiket.tiket);
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final Size size = MediaQuery.of(context).size;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) =>
                SingleChildScrollView(
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
                        children: [
                          Row(
                            children: [
                              Text(
                                'Quantidade LT',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: keyQtd,
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                temp.requestFocus();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite uma quantidade.';
                                } else if (int.tryParse(value) == null) {
                                  return 'Quantidade Incorreta';
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.always,
                              controller: controllerQtd,
                              onTap: () => controllerQtd.selectAll(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onSaved: (value) {
                                tiket.quantidade =
                                    int.tryParse(value.toString());
                              },
                              keyboardType: TextInputType.number,
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
                          Form(
                            key: keyTemp,
                            child: TextFormField(
                              maxLength: 6,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite uma temperatura.';
                                }
                                return null;
                              },
                              focusNode: temp,
                              controller: controllerTemp,
                              onTap: () => controllerTemp.selectAll(),
                              style: AppTheme.textStyles.title.copyWith(
                                  fontSize: 16,
                                  color: AppTheme.colors.secondaryColor),
                              onSaved: (value) {
                                tiket.temperatura = double.tryParse(value!);
                              },
                              onChanged: (value) {
                                setStateDialog(() {
                                  controllerTemp.text =
                                      value.replaceAll(',', '.');
                                  controllerTemp.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: controllerTemp.text.length));
                                });
                              },
                              keyboardType: TextInputType.number,
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
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Alizarol',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                tiket.alizarol = !tiket.alizarol!;
                              });
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: tiket.alizarol,
                                    onChanged: (bool? value) {
                                      setStateDialog(() {
                                        tiket.alizarol = value;
                                      });
                                    },
                                    activeColor: AppTheme.colors.secondaryColor,
                                  ),
                                  Text('Alizarol'),
                                ],
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
                                focusNode: tanque,
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
                                items: listaTanques.map((int value) {
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
                          Form(
                            key: keyObs,
                            child: TextFormField(
                              focusNode: mnc,
                              controller: controllerMotivoNC,
                              onSaved: (value) {
                                tiket.observacao = value;
                              },
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
                          if (tiket.alizarol != tiketCopy.alizarol) {
                            tiket.alizarol = tiketCopy.alizarol;
                          }
                          if (tiket.particao != tiketCopy.particao) {
                            tiket.particao = tiketCopy.particao;
                          }
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
                            if ((!keyQtd.currentState!.validate()) ||
                                (!keyTemp.currentState!.validate())) {
                              return;
                            }

                            keyQtd.currentState!.save();
                            keyTemp.currentState!.save();
                            keyObs.currentState!.save();

                            await controller.atualizaTiket(
                                coleta: tiket, coletaCopy: tiketCopy);

                            tiket.hora = DateTime.now().hour.toString() +
                                ':' +
                                DateTime.now()
                                    .minute
                                    .toString()
                                    .padLeft(2, '0') +
                                '"';

                            await controller.imprimirTicket(
                                tiket: tiket, tiketCopy: tiketCopy);
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: PhysicalModel(
                            color: Colors.white,
                            elevation: 8,
                            shadowColor: AppTheme.colors.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              child: Center(
                                child: controller.status ==
                                        TiketEntradaStatus.imprimindo
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
                                        'Salvar',
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
          ),
        );
      },
    );
  }

  Future<void> confirmaFinalizacao(
      {required ColetasModel coleta, required BuildContext context}) async {
    final Size size = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final GlobalKey<FormState> key = GlobalKey<FormState>();
        return AlertDialog(
          actions: [
            Column(
              children: [
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          if (key.currentState!.validate()) {
                            await controllerColeta.finalizaColeta(
                                coleta: widget.coleta);

                            await controllerColeta.imprimirResumoColetas(
                                coleta: coleta);

                            Navigator.pushNamedAndRemoveUntil(context,
                                '/dashboard', (Route<dynamic> route) => false);

                            MeuToast.toast(
                                title: 'Sucesso',
                                message: 'Rota Finalizada!',
                                type: TypeToast.success,
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
                              child: controllerColeta.status ==
                                      ColetasStatus.imprimindo
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
                                      'Finalizar',
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
                ),
              ],
            ),
          ],
          title: Text(
            'Finalizar rota?',
            style: AppTheme.textStyles.titleCharts.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          titlePadding: EdgeInsets.only(top: 15),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                Form(
                  key: key,
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a KM final.';
                      } else if (int.parse(value) < coleta.km_inicio!) {
                        return 'KM final deve ser maior que a KM inicial. \nKM inicial: ' +
                            coleta.km_inicio!.toString();
                      }
                      return null;
                    },
                    onChanged: (value) {
                      coleta.km_fim = int.tryParse(value);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
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
                ),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: AppTheme.colors.secondaryColor,
        title: Text('Produtores'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              await Navigator.pushNamedAndRemoveUntil(
                  context, '/dashboard', (Route<dynamic> route) => false);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                    hintText: 'Digite o nome do produtor',
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
              height: 15,
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Litros: ${somaLitros()}',
                    style:
                        AppTheme.textStyles.titleLogin.copyWith(fontSize: 25),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Observer(builder: (_) {
              final ListColetas =
                  filteredProd.where((e) => e.rota == widget.id_rota).toList();

              ListColetas.sort((a, b) => ("${a.quantidade} ${a.temperatura}")
                  .toString()
                  .compareTo(("${b.quantidade} ${b.temperatura}").toString()));

              return (controller.status == TiketEntradaStatus.success ||
                          controller.status == TiketEntradaStatus.imprimindo) &&
                      ListColetas.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                          key: UniqueKey(),
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
                                      ? Colors.green.shade400
                                      : ListColetas[index].quantidade! == 0 &&
                                              ListColetas[index].temperatura! ==
                                                  0 &&
                                              ListColetas[index].observacao ==
                                                  ''
                                          ? Colors.grey.shade400
                                          : ListColetas[index].observacao != ''
                                              ? Colors.red.shade400
                                              : Colors.amber.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: ListColetas[index].quantidade! >
                                                    0 &&
                                                ListColetas[index]
                                                        .temperatura! !=
                                                    0
                                            ? Colors.green.shade300
                                            : ListColetas[index].quantidade! ==
                                                        0 &&
                                                    ListColetas[index]
                                                            .temperatura! ==
                                                        0 &&
                                                    ListColetas[index]
                                                            .observacao ==
                                                        ''
                                                ? Colors.grey.shade400
                                                : ListColetas[index]
                                                            .observacao !=
                                                        ''
                                                    ? Colors.red.shade300
                                                    : Colors.amber.shade200,
                                        blurRadius: 5,
                                        offset: Offset(0, 5))
                                  ]),
                              child: ListTile(
                                key: UniqueKey(),
                                onTap: () async {
                                  await modalColeta(tiket: ListColetas[index]);
                                },
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                leading: Container(
                                  height: double.maxFinite,
                                  child: Icon(
                                    ListColetas[index].quantidade! > 0 &&
                                            ListColetas[index].temperatura! != 0
                                        ? Icons.check_circle_outline
                                        : ListColetas[index].quantidade! == 0 &&
                                                ListColetas[index]
                                                        .temperatura! ==
                                                    0 &&
                                                ListColetas[index].observacao ==
                                                    ''
                                            ? Icons.person_outline
                                            : ListColetas[index].observacao !=
                                                    ''
                                                ? Icons.error_outline_rounded
                                                : Icons.warning_amber_rounded,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: conectada
                                    ? controller.status ==
                                                TiketEntradaStatus.imprimindo &&
                                            id_tiket == ListColetas[index].id
                                        ? Container(
                                            height: 25,
                                            width: 25,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.print_rounded,
                                                color: Colors.black),
                                            onPressed: () async {
                                              setState(() {
                                                id_tiket =
                                                    ListColetas[index].id!;
                                              });
                                              await controller.imprimirTicket(
                                                  tiket: ListColetas[index]);
                                            })
                                    : null,
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
                                    Text(ListColetas[index].municipios,
                                        style: TextStyle(color: Colors.black))
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : controller.status == TiketEntradaStatus.loading
                      ? Expanded(
                          child: ListView.separated(
                              itemBuilder: (_, __) => LoadingWidget(
                                  size: Size(double.maxFinite, 50), radius: 10),
                              separatorBuilder: (_, __) => SizedBox(
                                    height: 15,
                                  ),
                              itemCount: 5),
                        )
                      : Container(
                          child: Center(
                            child: Text('Nenhum produtor encontrado!'),
                          ),
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
                    elevation: 5,
                    shadowColor: AppTheme.colors.secondaryColor),
                onPressed: () async {
                  await confirmaFinalizacao(
                      coleta: widget.coleta, context: context);
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
