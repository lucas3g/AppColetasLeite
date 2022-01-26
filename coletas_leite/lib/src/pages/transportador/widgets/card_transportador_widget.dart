import 'package:coletas_leite/src/models/transportes/transportes_model.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CardTransportadorWidget extends StatelessWidget {
  final List<TransportesModel> filteredTransp;
  final String? ultPlaca;
  final int index;
  final void Function({required String caminhao, required int tanques})
      modalColeta;
  const CardTransportadorWidget(
      {Key? key,
      required this.filteredTransp,
      required this.ultPlaca,
      required this.index,
      required this.modalColeta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
          color: ultPlaca == filteredTransp[index].placa
              ? Colors.green.shade400
              : Colors.white),
      child: ListTile(
        onTap: () {
          modalColeta(
              caminhao: filteredTransp[index].placa,
              tanques: filteredTransp[index].tanques);
        },
        minLeadingWidth: 10,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        leading: Container(
          child: Icon(
            Icons.local_shipping_outlined,
            color: Colors.black,
          ),
          height: double.maxFinite,
        ),
        title: Text(
          filteredTransp[index].descricao,
          style: AppTheme.textStyles.titleLogin.copyWith(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              'Placa: ',
              style: AppTheme.textStyles.titleLogin
                  .copyWith(fontSize: 14, color: Colors.black),
            ),
            Text(filteredTransp[index].placa)
          ],
        ),
      ),
    );
  }
}
