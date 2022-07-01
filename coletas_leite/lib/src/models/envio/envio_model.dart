import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:coletas_leite/src/models/coletas/coletas_model.dart';
import 'package:coletas_leite/src/models/tiket/tiket_entrada_model.dart';

class EnvioModel {
  ColetasModel? COLETAS;
  List<TiketEntradaModel>? TIKETS;
  EnvioModel({
    this.COLETAS,
    this.TIKETS,
  });

  EnvioModel copyWith({
    ColetasModel? COLETAS,
    List<TiketEntradaModel>? TIKETS,
  }) {
    return EnvioModel(
      COLETAS: COLETAS ?? this.COLETAS,
      TIKETS: TIKETS ?? this.TIKETS,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'COLETAS': COLETAS?.toMap(),
      'TIKETS': TIKETS?.map((x) => x.toMap()).toList(),
    };
  }

  factory EnvioModel.fromMap(Map<String, dynamic> map) {
    return EnvioModel(
      COLETAS:
          map['COLETAS'] != null ? ColetasModel.fromMap(map['COLETAS']) : null,
      TIKETS: map['TIKETS'] != null
          ? List<TiketEntradaModel>.from(
              map['TIKETS']?.map((x) => TiketEntradaModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnvioModel.fromJson(String source) =>
      EnvioModel.fromMap(json.decode(source));

  @override
  String toString() => 'EnvioModel(COLETAS: $COLETAS, TIKETS: $TIKETS)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvioModel &&
        other.COLETAS == COLETAS &&
        listEquals(other.TIKETS, TIKETS);
  }

  @override
  int get hashCode => COLETAS.hashCode ^ TIKETS.hashCode;
}
