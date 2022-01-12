import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Formatters {}

extension MoneyDouble on double {
  String reais() {
    final format = NumberFormat.simpleCurrency(locale: 'pt_br');
    return format.format(this);
  }
}

extension LitroDouble on double {
  String Litros() {
    final format = NumberFormat.simpleCurrency(locale: 'pt_br', name: '');
    return format.format(this);
  }
}

extension LitroInt on int {
  String LitrosInt() {
    final format = NumberFormat.simpleCurrency(locale: 'pt_br', name: '');
    return format.format(this);
  }
}

extension PorcentagemDouble on double {
  String Porcentagem() {
    final format = NumberFormat.simpleCurrency(locale: 'pt_br', name: '');
    return format.format(this);
  }
}

extension DateTimeString on DateTime {
  String diaMes() {
    final format = DateFormat('d MMMM', 'pt_br');
    return format.format(this);
  }
}

extension DataString on DateTime {
  String AnoMesDia() {
    final format = DateFormat('yyyy-MM-dd');
    return format.format(this);
  }
}

extension DiaMesAnoString on DateTime {
  String DiaMesAno() {
    final format = DateFormat("d 'de' MMMM 'de' yyyy", 'pt_br');
    return format.format(this);
  }
}

extension DiasMesAnoDB on DateTime {
  String DiaMesAnoDB() {
    final format = DateFormat('dd-MM-yyyy', 'pt_br');
    return format.format(this);
  }
}

extension DiaString on DateTime {
  String Dia() {
    final format = DateFormat('dd');
    return format.format(this);
  }
}

extension DiaMesString on DateTime {
  String DiaMes() {
    final format = DateFormat('dd/MM');
    return format.format(this);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
