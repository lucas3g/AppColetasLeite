import 'dart:convert';
import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:coletas_leite/src/configs/global_settings.dart';
import 'package:coletas_leite/src/models/login/user_model.dart';
import 'package:coletas_leite/src/services/dio.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'login_status.dart';
export 'login_status.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  @observable
  UserModel user = UserModel();

  @action
  void onChanged({String? cnpj, String? login, String? senha}) {
    user = user.copyWith(cnpj: cnpj, login: login, senha: senha);
  }

  @observable
  LoginStatus status = LoginStatus.empty;

  @action
  Future<void> login() async {
    try {
      if (user.cnpj.isNotEmpty &&
          user.login.isNotEmpty &&
          user.senha.isNotEmpty) {
        status = LoginStatus.loading;

        if (!UtilBrasilFields.isCNPJValido(user.cnpj)) {
          status = LoginStatus.invalidCNPJ;
          return;
        }

        try {
          final result = await InternetAddress.lookup(MeuDio.baseUrl);
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('Tem Internet');
          }
        } on SocketException catch (_) {
          print('Sem Internet Login');
          status = LoginStatus.semInternet;
          return;
        }

        await Future.delayed(Duration(seconds: 2));

        final authConfig = jsonEncode(
            {'USUARIO': user.login.trim(), 'SENHA': user.senha.trim()});

        final Response<dynamic> response =
            await GlobalSettings.recursiveFunction(
                function: () {
                  try {
                    final response = MeuDio.dio().post(
                      '/login/${UtilBrasilFields.removeCaracteres(user.cnpj.substring(0, 10))}',
                      data: authConfig,
                    );
                    return response;
                  } on DioError catch (e) {
                    print('EU SOU O ERRO DO DIO $e');
                  }
                },
                quantity: 0,
                callback: () {
                  status = LoginStatus.error;
                  return;
                });

        late String autorizado = 'N';

        if (response.data.isNotEmpty) {
          autorizado = jsonDecode(response.data)['app_coleta'];
        } else {
          autorizado = 'N';
        }

        if (autorizado == 'S') {
          user.nome = jsonDecode(response.data)['nome'];
          user.ccusto = jsonDecode(response.data)['ccusto'];
          user.descEmpresa = jsonDecode(response.data)['descEmpresa'];

          await GlobalSettings().appSettings.setLogado(conectado: 'S');
          await GlobalSettings().appSettings.setUser(user: user);
          status = LoginStatus.success;
          await Future.delayed(Duration(seconds: 2));
        } else {
          await GlobalSettings().appSettings.setLogado(conectado: 'N');
          status = LoginStatus.naoAutorizado;
        }
        // print('EU SOU RESPONSE $autorizado');
      } else {
        status = LoginStatus.error;
        await GlobalSettings().appSettings.setLogado(conectado: 'N');
        await Future.delayed(Duration(seconds: 2));
        status = LoginStatus.empty;
      }
    } on DioError catch (e) {
      await GlobalSettings().appSettings.setLogado(conectado: 'N');
      status = LoginStatus.error;
      print('EU SOU O ERRO $e');
    }
  }
}
