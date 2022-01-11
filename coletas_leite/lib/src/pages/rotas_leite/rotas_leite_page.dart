import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_status.dart';
import 'package:coletas_leite/src/pages/transportador/transportador_page.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RotasLeitePage extends StatefulWidget {
  const RotasLeitePage({Key? key}) : super(key: key);

  @override
  State<RotasLeitePage> createState() => _RotasLeitePageState();
}

class _RotasLeitePageState extends State<RotasLeitePage> {
  final controller = GlobalSettings().controllerRotas;

  void getRotas() async {
    if (controller.rotas.isEmpty) await controller.getRotas();
  }

  @override
  void initState() {
    getRotas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colors.secondaryColor,
        title: Text('Selecione uma Rota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Observer(
            builder: (_) => controller.status == RotasLeiteStatus.success
                ? SingleChildScrollView(
                    child: Column(
                      children: (controller.rotas.map(
                        (rota) => Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TransportadorPage(
                                    rota: rota.descricao,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.directions_outlined),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  child: Expanded(
                                    child: Text(
                                      rota.descricao,
                                      style: AppTheme.textStyles.titleLogin
                                          .copyWith(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  )
                : Container(
                    child: Text('Nenhuma Rota Encontrada!'),
                  )),
      ),
    );
  }
}
