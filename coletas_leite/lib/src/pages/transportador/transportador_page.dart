import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/transportes/transportes_status.dart';
import 'package:coletas_leite/src/pages/coletas/coletas_page.dart';
import 'package:flutter/material.dart';

import 'package:coletas_leite/src/theme/app_theme.dart';

class TransportadorPage extends StatefulWidget {
  final String rota;
  const TransportadorPage({
    Key? key,
    required this.rota,
  }) : super(key: key);

  @override
  State<TransportadorPage> createState() => _TransportadorPageState();
}

class _TransportadorPageState extends State<TransportadorPage> {
  final controller = GlobalSettings().controllerTransp;

  void getTransp() async {
    if (controller.transp.isEmpty) await controller.getTransp();
  }

  @override
  void initState() {
    getTransp();
    super.initState();
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
            controller.status == TransportesStatus.success
                ? Expanded(
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                              height: 15,
                            ),
                        itemCount: controller.transp.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ColetasPage(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.local_shipping_outlined),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        '${controller.transp[index].placa} | ${controller.transp[index].descricao}',
                                        style: AppTheme.textStyles.titleLogin
                                            .copyWith(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
