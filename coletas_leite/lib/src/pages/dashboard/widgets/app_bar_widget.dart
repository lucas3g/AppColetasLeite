import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/pages/imprimir_ticket/imprimir.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWidget extends StatelessWidget implements PreferredSize {
  final Size size;
  final BuildContext context;

  AppBarWidget({Key? key, required this.size, required this.context})
      : super(key: key);

  final motorista = GlobalSettings().appSettings.user.nome;

  void confirmarSair() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(bottom: 15, top: 20, right: 20, left: 20),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/sair.svg',
                  height: 130,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Deseja realmente sair da aplicação?',
                  style: AppTheme.textStyles.titleCharts.copyWith(fontSize: 16),
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
                              'Não',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          height: 45,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        //await GetIt.I.get<AppSettigns>().removeLogado();
                        await Future.delayed(Duration(milliseconds: 150));
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: PhysicalModel(
                        color: Colors.white,
                        elevation: 8,
                        shadowColor: AppTheme.colors.secondaryColor,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Center(
                              child: Text(
                            'Sim',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                          height: 45,
                          width: 120,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Widget get child => Stack(
        children: [
          Container(
            height: size.height * 0.13,
            decoration: BoxDecoration(
              color: AppTheme.colors.secondaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ImprimirPage(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                        )),
                    Text(
                      'Coletas Plus',
                      style: AppTheme.textStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        confirmarSair();
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Motorista: $motorista',
                  style: AppTheme.textStyles.title.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      );

  @override
  Size get preferredSize => size.height >= 850.99
      ? Size.fromHeight(size.height * 0.10)
      : Size.fromHeight(size.height * 0.12);
}