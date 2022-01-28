import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_status.dart';
import 'package:coletas_leite/src/models/rotas_leite/rotas_leite_model.dart';
import 'package:coletas_leite/src/pages/rotas_leite/widgets/card_rotas_widget.dart';
import 'package:coletas_leite/src/pages/transportador/transportador_page.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/formatters.dart';
import 'package:coletas_leite/src/utils/loading_widget.dart';
import 'package:coletas_leite/src/utils/meu_toast.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RotasLeitePage extends StatefulWidget {
  const RotasLeitePage({Key? key}) : super(key: key);

  @override
  State<RotasLeitePage> createState() => _RotasLeitePageState();
}

class _RotasLeitePageState extends State<RotasLeitePage> {
  final controller = GlobalSettings().controllerRotas;
  final TextEditingController controllerInput = TextEditingController();

  List<RotasLeiteModel> filteredRotas = [];

  void getRotas() async {
    controllerInput.clear();

    await controller.getRotas();
    setState(() {
      filteredRotas = controller.rotas;
      filteredRotas.sort((a, b) => a.id.compareTo(b.id));
    });
  }

  void _onSearchChanged(String value) async {
    filteredRotas = await controller.onSearchChanged(value: value);
    filteredRotas.sort((a, b) => a.id.compareTo(b.id));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getRotas();
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
        title: Text('Selecione uma Rota'),
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
                    hintText: 'Digite o nome da rota',
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
            Observer(
              builder: (_) => controller.status == RotasLeiteStatus.success &&
                      filteredRotas.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                          itemBuilder: (_, int index) {
                            return CardRotasWidget(
                                controller: controller,
                                filteredRotas: filteredRotas,
                                index: index);
                          },
                          separatorBuilder: (_, int index) => SizedBox(
                                height: 15,
                              ),
                          itemCount: filteredRotas.length),
                    )
                  : controller.status == RotasLeiteStatus.loading
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
                            child: Text('Nenhuma rota encontrada!'),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
