import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWidget extends StatelessWidget implements PreferredSize {
  final Size size;
  final BuildContext context;

  AppBarWidget({Key? key, required this.size, required this.context})
      : super(key: key);

  final motorista = GlobalSettings().appSettings.user.nome;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  Future<void> enableBT() async {
    BluetoothEnable.enableBluetooth.then((value) {
      if (value == 'true') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/configuracao', (Route<dynamic> route) => false);
      }
    });
  }

  Future<void> customEnableBT(BuildContext context) async {
    await GlobalSettings().appSettings.removeImpressora();
    await printer.disconnect();

    String dialogTitle = "Hey! Please give me permission to use Bluetooth!";
    bool displayDialogContent = true;
    String dialogContent = "This app requires Bluetooth to connect to device.";
    //or
    // bool displayDialogContent = false;
    // String dialogContent = "";
    String cancelBtnText = "Nope";
    String acceptBtnText = "Sure";
    double dialogRadius = 10.0;
    bool barrierDismissible = true; //

    BluetoothEnable.customBluetoothRequest(
            context,
            dialogTitle,
            displayDialogContent,
            dialogContent,
            cancelBtnText,
            acceptBtnText,
            dialogRadius,
            barrierDismissible)
        .then((value) {
      print(value);
    });
  }

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
                        await GlobalSettings().appSettings.removeLogado();
                        await Future.delayed(Duration(milliseconds: 150));
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (Route<dynamic> route) => false);
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
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              height: constraints.maxHeight > 95 ? 110 : 95,
              decoration: BoxDecoration(
                color: AppTheme.colors.secondaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            );
          }),
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
                        onPressed: () async {
                          await enableBT();
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
  Size get preferredSize => Size.fromHeight(size.height * 0.12);
}
