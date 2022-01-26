import 'package:coletas_leite/src/controllers/rotas_leite/rotas_leite_controller.dart';
import 'package:coletas_leite/src/models/rotas_leite/rotas_leite_model.dart';
import 'package:coletas_leite/src/pages/transportador/transportador_page.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/meu_toast.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';

class CardRotasWidget extends StatelessWidget {
  final RotasLeiteController controller;
  final List<RotasLeiteModel> filteredRotas;
  final int index;
  const CardRotasWidget(
      {Key? key,
      required this.controller,
      required this.filteredRotas,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: (filteredRotas[index].rota_finalizada == 1 ? true : false)
            ? Colors.white
            : Colors.grey.shade400,
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () async {
          if (filteredRotas[index].rota_finalizada == 0) {
            await MeuToast.toast(
                title: 'Atenção',
                message: 'Rota pendente de finalização.',
                type: TypeToast.error,
                context: context);
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => TransportadorPage(
                  rota: filteredRotas[index].descricao,
                  id_rota: filteredRotas[index].id,
                ),
              ),
            );
            await controller.getRotas();
          }
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
          filteredRotas[index].id.toString() +
              ' - ' +
              filteredRotas[index].descricao,
          style: AppTheme.textStyles.titleLogin.copyWith(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
