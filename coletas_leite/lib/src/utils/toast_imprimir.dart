import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastImprimir {
  static show() {
    Fluttertoast.showToast(msg: 'Imprimindo...', backgroundColor: Colors.black);
  }
}
