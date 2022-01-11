import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColetasPage extends StatefulWidget {
  const ColetasPage({Key? key}) : super(key: key);

  @override
  State<ColetasPage> createState() => _ColetasPageState();
}

class _ColetasPageState extends State<ColetasPage> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = '1';
    void modalColeta() {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Informações sobre a coleta',
                    style:
                        AppTheme.textStyles.titleCharts.copyWith(fontSize: 20),
                  ),
                  Divider(),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Quantidade LT',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CentavosInputFormatter()
                            ],
                            textAlign: TextAlign.end,
                            cursorColor: AppTheme.colors.secondaryColor,
                            style: AppTheme.textStyles.title.copyWith(
                                fontSize: 16,
                                color: AppTheme.colors.secondaryColor),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppTheme.colors.secondaryColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Temperatura',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            style: AppTheme.textStyles.title.copyWith(
                                fontSize: 16,
                                color: AppTheme.colors.secondaryColor),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.start,
                            cursorColor: AppTheme.colors.secondaryColor,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppTheme.colors.secondaryColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: true,
                                  onChanged: (_) {},
                                  activeColor: AppTheme.colors.secondaryColor,
                                ),
                                Text('Alizarol')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Tanque',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              alignment: Alignment.center,
                              height: 54,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: DropdownButton(
                                  borderRadius: BorderRadius.circular(10),
                                  value: dropdownValue,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_circle_down_sharp,
                                  ),
                                  iconSize: 30,
                                  elevation: 8,
                                  iconEnabledColor:
                                      AppTheme.colors.secondaryColor,
                                  style: AppTheme.textStyles.dropdownText,
                                  underline: Container(),
                                  onChanged: (String? newValue) {},
                                  items:
                                      ['1', '2', '3', '4'].map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Motivo da Não Coleta',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            textAlign: TextAlign.start,
                            cursorColor: AppTheme.colors.secondaryColor,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppTheme.colors.secondaryColor),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
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
                                'Cancelar',
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
                        onTap: () async {},
                        child: PhysicalModel(
                          color: Colors.white,
                          elevation: 8,
                          shadowColor: AppTheme.colors.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            child: Center(
                              child: Text(
                                'Salvar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppTheme.colors.secondaryColor,
        title: Text('Produtores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                onTap: () {
                  modalColeta();
                },
                child: Row(
                  children: [
                    Icon(Icons.person_outlined),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Expanded(
                        child: Text(
                          'Lucas Emanuel Silva',
                          style: AppTheme.textStyles.titleLogin.copyWith(
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
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.person_outlined),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Expanded(
                        child: Text(
                          'Mauricio Sareto',
                          style: AppTheme.textStyles.titleLogin.copyWith(
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
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.person_outlined),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Expanded(
                        child: Text(
                          'Mateus Perego',
                          style: AppTheme.textStyles.titleLogin.copyWith(
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
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.person_outlined),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Expanded(
                        child: Text(
                          'Juan Mones',
                          style: AppTheme.textStyles.titleLogin.copyWith(
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
          ],
        ),
      ),
    );
  }
}
