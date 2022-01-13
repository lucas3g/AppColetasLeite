import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:coletas_leite/src/models/coletas/coletas_model.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model.dart';

class EnvioModel {
  List<ColetasModel>? coletas;
  List<TiketEntradaModel>? tikets;
  EnvioModel({
    this.coletas,
    this.tikets,
  });

  EnvioModel copyWith({
    List<ColetasModel>? coletas,
    List<TiketEntradaModel>? tikets,
  }) {
    return EnvioModel(
      coletas: coletas ?? this.coletas,
      tikets: tikets ?? this.tikets,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coletas': coletas?.map((x) => x.toMap()).toList(),
      'tikets': tikets?.map((x) => x.toMap()).toList(),
    };
  }

  factory EnvioModel.fromMap(Map<String, dynamic> map) {
    return EnvioModel(
      coletas: map['coletas'] != null
          ? List<ColetasModel>.from(
              map['coletas']?.map((x) => ColetasModel.fromMap(x)))
          : null,
      tikets: map['tikets'] != null
          ? List<TiketEntradaModel>.from(
              map['tikets']?.map((x) => TiketEntradaModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnvioModel.fromJson(String source) =>
      EnvioModel.fromMap(json.decode(source));

  @override
  String toString() => 'EnvioModel(coletas: $coletas, tikets: $tikets)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvioModel &&
        listEquals(other.coletas, coletas) &&
        listEquals(other.tikets, tikets);
  }

  @override
  int get hashCode => coletas.hashCode ^ tikets.hashCode;
}
