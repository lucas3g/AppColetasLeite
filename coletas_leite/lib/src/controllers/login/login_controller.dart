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

  @observable
  String licencaAtiva = 'N';

  @action
  void onChanged({String? cnpj, String? login, String? senha}) {
    user = user.copyWith(CNPJ: cnpj, LOGIN: login, SENHA: senha);
  }

  @observable
  LoginStatus status = LoginStatus.empty;

  @action
  Future<bool> verificaLicenca(String id) async {
    try {
      status = LoginStatus.loading;
      final response = await MeuDio.dio().get(
        '${MeuDio.baseURLLicense}/licenca',
        options: Options(
          headers: {'cnpj': 'licenca', 'id': id.trim()},
        ),
      );

      if (response.statusCode != 200) {
        status = LoginStatus.semLicenca;
        return false;
      }

      if (response.data.toString() != '{}') {
        if (response.data['ATIVO'] == 'S') {
          licencaAtiva = 'S';
          await GlobalSettings()
              .appSettings
              .setLicencaAtiva(licencaAtiva: licencaAtiva);
          status = LoginStatus.licencaAtiva;
          return true;
        }

        if (response.data['ATIVO'] == 'N') {
          licencaAtiva = 'N';
          await GlobalSettings()
              .appSettings
              .setLicencaAtiva(licencaAtiva: licencaAtiva);
          status = LoginStatus.licencaInativa;
          return false;
        }
      }

      await GlobalSettings()
          .appSettings
          .setLicencaAtiva(licencaAtiva: licencaAtiva);

      status = LoginStatus.semLicenca;
      return false;
    } catch (e) {
      status = LoginStatus.error;
      return false;
    }
  }

  @action
  Future<void> login(String id) async {
    if (await verificaLicenca(id)) {
      try {
        if (user.CNPJ.isNotEmpty &&
            user.LOGIN.isNotEmpty &&
            user.SENHA.isNotEmpty) {
          status = LoginStatus.loading;

          if (!UtilBrasilFields.isCNPJValido(user.CNPJ)) {
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
              {'USUARIO': user.LOGIN.trim(), 'SENHA': user.SENHA.trim()});

          final Response<dynamic> response =
              await GlobalSettings.recursiveFunction(
                  function: () {
                    try {
                      final response = MeuDio.dio().post(
                        '${MeuDio.baseURLAPP}/login/${UtilBrasilFields.removeCaracteres(user.CNPJ.substring(0, 10))}',
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

          if (response.data.trim().isNotEmpty) {
            autorizado = jsonDecode(response.data)['APP_COLETA'];
          } else {
            autorizado = 'N';
          }

          if (autorizado == 'S') {
            user.NOME = jsonDecode(response.data)['NOME'];
            user.CCUSTO = jsonDecode(response.data)['CCUSTO'];
            user.DESC_EMPRESA = jsonDecode(response.data)['DESC_EMPRESA'];

            await GlobalSettings()
                .appSettings
                .setLogado(conectado: 'S', id: id, licencaAtiva: licencaAtiva);
            await GlobalSettings().appSettings.setUser(user: user);
            status = LoginStatus.success;
            await Future.delayed(Duration(seconds: 2));
          } else {
            await GlobalSettings()
                .appSettings
                .setLogado(conectado: 'N', id: '', licencaAtiva: 'N');
            status = LoginStatus.naoAutorizado;
          }
          // print('EU SOU RESPONSE $autorizado');
        } else {
          status = LoginStatus.error;
          await GlobalSettings()
              .appSettings
              .setLogado(conectado: 'N', id: '', licencaAtiva: 'N');
          await Future.delayed(Duration(seconds: 2));
          status = LoginStatus.empty;
        }
      } on DioError catch (e) {
        await GlobalSettings()
            .appSettings
            .setLogado(conectado: 'N', id: '', licencaAtiva: 'N');
        status = LoginStatus.error;
        print('EU SOU O ERRO $e');
      }
    }
  }
}
