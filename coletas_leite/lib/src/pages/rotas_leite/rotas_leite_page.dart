import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_status.dart';
import 'package:coletas_leite/src/pages/transportador/transportador_page.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/loading_widget.dart';
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
    await controller.getRotas();
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
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/dashboard', (Route<dynamic> route) => false);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Observer(
          builder: (_) => controller.status == RotasLeiteStatus.success
              ? ListView.separated(
                  itemBuilder: (_, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: (controller.rotas[index].rota_finalizada == 1
                                ? true
                                : false)
                            ? Colors.white
                            : Colors.grey,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TransportadorPage(
                                rota: controller.rotas[index].descricao,
                                id_rota: controller.rotas[index].id,
                              ),
                            ),
                          );
                          await controller.getRotas();
                        },
                        minLeadingWidth: 10,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        leading: Container(
                          height: double.maxFinite,
                          child: Icon(
                            Icons.directions_outlined,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          controller.rotas[index].id.toString() +
                              ' - ' +
                              controller.rotas[index].descricao,
                          style: AppTheme.textStyles.titleLogin.copyWith(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        enabled: (controller.rotas[index].rota_finalizada == 1
                            ? true
                            : false),
                      ),
                    );
                  },
                  separatorBuilder: (_, int index) => SizedBox(
                        height: 15,
                      ),
                  itemCount: controller.rotas.length)
              : ListView.separated(
                  itemBuilder: (_, __) => LoadingWidget(
                      size: Size(double.maxFinite, 50), radius: 10),
                  separatorBuilder: (_, __) => SizedBox(
                        height: 15,
                      ),
                  itemCount: 10),
        ),
      ),
    );
  }
}
