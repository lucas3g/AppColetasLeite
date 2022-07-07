import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/components/el_input_widget.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/controllers/login/login_controller.dart';
import 'package:coletas_leite/src/controllers/sincronizar/sincronizar_controller.dart';
import 'package:coletas_leite/src/theme/app_theme.dart';
import 'package:coletas_leite/src/utils/formatters.dart';
import 'package:coletas_leite/src/utils/meu_toast.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginInputButtonWidget extends StatefulWidget {
  LoginInputButtonWidget({Key? key}) : super(key: key);

  @override
  State<LoginInputButtonWidget> createState() => _LoginInputButtonWidgetState();
}

class _LoginInputButtonWidgetState extends State<LoginInputButtonWidget> {
  final controllerLogin = LoginController();
  final SincronizarController controllerSincronizar = SincronizarController();
  final getInfoPhoneController = GlobalSettings().controllerInfoPhone;
  late Map<String, String> logado;
  var visiblePassword = false;

  FocusNode login = FocusNode();
  FocusNode senha = FocusNode();

  Future getInfoPhone() async {
    await getInfoPhoneController.getInfoPhone();
    await mostraInfoPhone();
  }

  @override
  void initState() {
    autorun((_) async {
      if (controllerLogin.status == LoginStatus.success) {
        BotToast.showLoading();
        BotToast.showText(text: 'Buscando dados do Servidor');
        await Future.delayed(Duration(seconds: 1));
        await controllerSincronizar.baixaTodas();
        await Future.delayed(Duration(seconds: 1));
        BotToast.closeAllLoading();
        BotToast.cleanAll();
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (controllerLogin.status == LoginStatus.error) {
        MeuToast.toast(
            title: 'Ops... :(',
            message: 'Não Foi Possivel Fazer Login.Verifique seus Dados.',
            type: TypeToast.error,
            context: context);
      } else if (controllerLogin.status == LoginStatus.semInternet) {
        MeuToast.toast(
            title: 'Ops... :(',
            message: 'Parece que você está sem Internet',
            type: TypeToast.noNet,
            context: context);
      } else if (controllerLogin.status == LoginStatus.invalidCNPJ) {
        MeuToast.toast(
            title: 'Ops... :(',
            message: 'Você digitou um CNPJ inválido.',
            type: TypeToast.dadosInv,
            context: context);
      } else if (controllerLogin.status == LoginStatus.naoAutorizado) {
        MeuToast.toast(
            title: 'Ops... :(',
            message:
                'Seu usuário não tem permissão para acessar o aplicativo.\nVerifique seu usuário e/ou senha.',
            type: TypeToast.dadosInv,
            context: context);
      } else if (controllerLogin.status == LoginStatus.semLicenca) {
        MeuToast.toast(
            title: 'Ops... :(',
            message:
                'Não foi encontrado nenhuma licença. Por favor entre em contato com o suporte.',
            type: TypeToast.dadosInv,
            context: context);
      } else if (controllerLogin.status == LoginStatus.licencaInativa) {
        MeuToast.toast(
            title: 'Ops... :(',
            message:
                'Sua licença esta inativa. Por favor entre em contato com o suporte.',
            type: TypeToast.dadosInv,
            context: context);
      }
    });
    super.initState();
    getInfoPhone();
  }

  Future mostraInfoPhone() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 8,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Código de Autenticação: ${getInfoPhoneController.licenca.id}',
                    style: AppTheme.textStyles.dropdownText
                        .copyWith(fontSize: 16)),
                Text(
                  'Se você já tem uma licença por favor ignore essa mensagem.',
                  style: TextStyle(fontSize: 13),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffcf1f36),
                        ),
                        onPressed: () async {
                          await openWhatsapp(
                            context: context,
                            text:
                                'Código: ${getInfoPhoneController.licenca.id}',
                            number: '+5554999712433',
                          );
                        },
                        icon: const Icon(Icons.whatsapp_rounded),
                        label: const Text('Enviar código'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> openWhatsapp(
      {required BuildContext context,
      required String text,
      required String number}) async {
    var whatsapp = number; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(
          Uri.parse(
            whatsappURLIos,
          ),
        );
      } else {}
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.backgroundPrimary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Entre com sua conta',
              style: AppTheme.textStyles.title.copyWith(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ELInputWidget(
              onFieldSubmitted: (value) {
                login.requestFocus();
              },
              controllerLogin: controllerLogin,
              keyboardType: TextInputType.number,
              hintText: 'CNPJ',
              mascaraCnpj: true,
              type: 'CNPJ',
              obscureText: false,
              focusNode: login,
              inputFormaters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfOuCnpjFormatter()
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ELInputWidget(
              inputFormaters: [UpperCaseTextFormatter()],
              onFieldSubmitted: (value) {
                senha.requestFocus();
              },
              focusNode: login,
              controllerLogin: controllerLogin,
              keyboardType: TextInputType.text,
              hintText: 'Login',
              mascaraCnpj: false,
              type: 'LOGIN',
              obscureText: false,
            ),
            SizedBox(
              height: 15,
            ),
            ELInputWidget(
              inputFormaters: [UpperCaseTextFormatter()],
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
                controllerLogin.login(getInfoPhoneController.licenca.id ?? '');
              },
              focusNode: senha,
              controllerLogin: controllerLogin,
              keyboardType: TextInputType.text,
              hintText: 'Senha',
              mascaraCnpj: false,
              type: 'SENHA',
              obscureText: !visiblePassword,
              sufixIcon: GestureDetector(
                child: Icon(
                  visiblePassword ? Icons.visibility : Icons.visibility_off,
                  size: 25,
                  color: visiblePassword
                      ? AppTheme.colors.secondaryColor
                      : Color(0xFF666666),
                ),
                onTap: () {
                  visiblePassword = !visiblePassword;
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Observer(
              builder: (_) => GestureDetector(
                onTap: () {
                  if (controllerLogin.status == LoginStatus.empty ||
                      controllerLogin.status == LoginStatus.naoAutorizado ||
                      controllerLogin.status == LoginStatus.error ||
                      controllerLogin.status == LoginStatus.invalidCNPJ ||
                      controllerLogin.status == LoginStatus.semInternet ||
                      controllerLogin.status == LoginStatus.semLicenca) {
                    controllerLogin
                        .login(getInfoPhoneController.licenca.id ?? '');
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 45,
                  width: controllerLogin.status == LoginStatus.loading ||
                          controllerLogin.status == LoginStatus.success
                      ? 45
                      : MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: controllerLogin.status == LoginStatus.success
                          ? Colors.green
                          : Color(0xffcf1f36),
                      boxShadow: [
                        BoxShadow(
                          color: controllerLogin.status == LoginStatus.success
                              ? Colors.green
                              : Color(0xffcf1f36),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        )
                      ]),
                  alignment: Alignment.center,
                  child: AnimatedCrossFade(
                    firstChild: controllerLogin.status != LoginStatus.success
                        ? Text(
                            'Entrar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        : Icon(
                            Icons.done,
                            size: 35,
                            color: Colors.white,
                          ),
                    secondChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    crossFadeState:
                        controllerLogin.status == LoginStatus.loading
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 200),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await getInfoPhone();
              },
              child: Text(
                'Licenca para acessar',
                style: TextStyle(
                  color: Color(0xffcf1f36),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Não tem uma conta?',
                      style: AppTheme.textStyles.title
                          .copyWith(fontSize: 12, color: Color(0xFF525252))),
                  TextSpan(
                      text: ' Entre em contato conosco.',
                      style: AppTheme.textStyles.title
                          .copyWith(fontSize: 12, color: Color(0xFF525252)))
                ],
              ),
            ),
            Spacer(),
            Text(
              'EL Sistemas - 2021 - 54 3364 1588',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
