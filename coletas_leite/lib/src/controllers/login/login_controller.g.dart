// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginController on _LoginControllerBase, Store {
  late final _$userAtom =
      Atom(name: '_LoginControllerBase.user', context: context);

  @override
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$licencaAtivaAtom =
      Atom(name: '_LoginControllerBase.licencaAtiva', context: context);

  @override
  String get licencaAtiva {
    _$licencaAtivaAtom.reportRead();
    return super.licencaAtiva;
  }

  @override
  set licencaAtiva(String value) {
    _$licencaAtivaAtom.reportWrite(value, super.licencaAtiva, () {
      super.licencaAtiva = value;
    });
  }

  late final _$statusAtom =
      Atom(name: '_LoginControllerBase.status', context: context);

  @override
  LoginStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(LoginStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$verificaLicencaAsyncAction =
      AsyncAction('_LoginControllerBase.verificaLicenca', context: context);

  @override
  Future<bool> verificaLicenca(String id) {
    return _$verificaLicencaAsyncAction.run(() => super.verificaLicenca(id));
  }

  late final _$loginAsyncAction =
      AsyncAction('_LoginControllerBase.login', context: context);

  @override
  Future<void> login(String id) {
    return _$loginAsyncAction.run(() => super.login(id));
  }

  late final _$_LoginControllerBaseActionController =
      ActionController(name: '_LoginControllerBase', context: context);

  @override
  void onChanged({String? cnpj, String? login, String? senha}) {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.onChanged');
    try {
      return super.onChanged(cnpj: cnpj, login: login, senha: senha);
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
licencaAtiva: ${licencaAtiva},
status: ${status}
    ''';
  }
}
