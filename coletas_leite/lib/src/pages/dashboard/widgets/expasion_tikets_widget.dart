import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/tiket/tiket_entrada_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../theme/app_theme.dart';

class ExpasionTiketsWidget extends StatefulWidget {
  final int id_coleta;
  ExpasionTiketsWidget({Key? key, required this.id_coleta}) : super(key: key);

  @override
  State<ExpasionTiketsWidget> createState() => _ExpasionTiketsWidgetState();
}

class _ExpasionTiketsWidgetState extends State<ExpasionTiketsWidget> {
  final controller = GlobalSettings().controllerTiket;

  Future<void> buscaTikets() async {
    await controller.buscaTiketPorID(id_coleta: widget.id_coleta);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      buscaTikets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: Observer(builder: (_) {
        return controller.status == TiketEntradaStatus.success
            ? ExpansionTile(
                iconColor: AppTheme.colors.secondaryColor,
                collapsedIconColor: AppTheme.colors.secondaryColor,
                tilePadding: EdgeInsets.zero,
                title: Text(
                  'Tikets',
                  style:
                      AppTheme.textStyles.dropdownText.copyWith(fontSize: 16),
                ),
                childrenPadding: EdgeInsets.zero,
                children: controller.tiketsColetas
                    .where((tiket) => tiket.id_coleta == widget.id_coleta)
                    .map((e) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Produtor: ',
                              style: AppTheme.textStyles.dropdownText
                                  .copyWith(fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                e.nome,
                                style: AppTheme.textStyles.button.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Quantidade: ',
                              style: AppTheme.textStyles.dropdownText
                                  .copyWith(fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                e.quantidade.toString(),
                                style: AppTheme.textStyles.button.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              'Temp: ',
                              style: AppTheme.textStyles.dropdownText
                                  .copyWith(fontSize: 16),
                            ),
                            Text(
                              e.temperatura.toString(),
                              style: AppTheme.textStyles.button.copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Alizarol: ',
                              style: AppTheme.textStyles.dropdownText
                                  .copyWith(fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                e.alizarol! ? 'Positivo' : 'Negativo',
                                style: AppTheme.textStyles.button.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              'Tanque: ',
                              style: AppTheme.textStyles.dropdownText
                                  .copyWith(fontSize: 16),
                            ),
                            Text(
                              e.particao.toString(),
                              style: AppTheme.textStyles.button.copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        )
                      ],
                    ),
                  );
                }).toList(),
              )
            : Container();
      }),
    );
  }
}
