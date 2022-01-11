import 'package:coletas_leite/src/pages/dashboard/widgets/app_bar_widget.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(size: size, context: context),
      body: Container(
        child: Center(
          child: Text('Coletas Futuras'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/rotas_leite');
        },
        child: Icon(Icons.add),
        backgroundColor: AppTheme.colors.secondaryColor,
      ),
    );
  }
}
