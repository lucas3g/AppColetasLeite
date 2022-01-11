import 'package:coletas_leite/src/models/login/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettigns extends ChangeNotifier {
  late SharedPreferences _prefs;

  Map<String, String> logado = {'conectado': 'N'};
  UserModel user = UserModel();

  AppSettigns() {
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
    await _readLogado();
    if (_prefs.getString('conectado') == 'S') await _readUser();
  }

  Future<void> _startPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _readLogado() {
    final logadoApp = _prefs.getString('conectado') ?? 'N';

    logado = {'conectado': logadoApp};

    notifyListeners();
  }

  _readUser() {
    final userApp = _prefs.getString('user') ?? '';

    user = UserModel.fromJson(userApp);

    notifyListeners();
  }

  setLogado({required String conectado}) async {
    await _prefs.setString('conectado', conectado);

    await _readLogado();
  }

  setUser({required UserModel user}) async {
    await _prefs.setString('user', user.toJson());

    await _readUser();
  }

  removeLogado() async {
    //final controller = LimpaDadosController();
    await _prefs.remove('conectado');
    await _prefs.remove('user');
    //controller.limpaDados();
    await _readLogado();
  }
}
