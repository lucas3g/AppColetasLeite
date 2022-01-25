import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:coletas_leite/src/models/login/user_model.dart';
import 'package:coletas_leite/src/utils/limpa_dados.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettigns extends ChangeNotifier {
  late SharedPreferences _prefs;

  Map<String, String> logado = {'conectado': 'N'};
  UserModel user = UserModel();
  BluetoothDevice? imp;

  AppSettigns() {
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
    await _readLogado();
    await readImpressora();
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

  readImpressora() {
    final impressora = _prefs.getString('impressora') ?? '';

    if (impressora.isNotEmpty)
      imp = BluetoothDevice.fromMap(json.decode(impressora));

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

  setImp({required BluetoothDevice device}) async {
    await _prefs.setString('impressora', json.encode(device.toMap()));

    await _readUser();
  }

  removeLogado() async {
    final controller = LimpaDados();
    await _prefs.remove('conectado');
    await _prefs.remove('user');
    await _prefs.remove('impressora');
    controller.limpaDados();
    await _readLogado();
  }

  removeImpressora() async {
    await _prefs.remove('impressora');
  }
}
