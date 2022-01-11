import 'package:another_flushbar/flushbar.dart';
import 'package:coletas_leite/src/utils/types_toast.dart';
import 'package:flutter/material.dart';

class MeuToast {
  static Flushbar _flushbar = new Flushbar();

  static Flushbar toast(
      {required String title,
      required String message,
      required TypeToast type,
      required BuildContext context}) {
    _flushbar = Flushbar(
      duration: Duration(seconds: message.length >= 80 ? 6 : 4),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      title: title,
      backgroundColor: backgroundColor(type: type),
      margin: EdgeInsets.all(20),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      icon: icon(type: type),
    )..show(context);

    return _flushbar;
  }

  static Icon icon({required TypeToast type}) {
    switch (type) {
      case TypeToast.success:
        return Icon(
          Icons.beenhere,
          color: Colors.white,
        );
      case TypeToast.error:
        return Icon(
          Icons.error,
          color: Colors.white,
        );
      case TypeToast.noNet:
        return Icon(
          Icons.signal_wifi_connected_no_internet_4,
          color: Colors.white,
        );
      case TypeToast.dadosInv:
        return Icon(
          Icons.warning,
          color: Colors.white,
        );
    }
  }

  static Color backgroundColor({required TypeToast type}) {
    switch (type) {
      case TypeToast.success:
        return Colors.green;
      case TypeToast.error:
        return Color(0xffcf1f36);
      case TypeToast.noNet:
        return Color(0xFFFF7F26);
      case TypeToast.dadosInv:
        return Color(0xff0026ff);
    }
  }
}
