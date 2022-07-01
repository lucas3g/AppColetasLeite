import 'dart:convert';

class TransportesModel {
  String PLACA;
  String DESCRICAO;
  int TANQUES;

  TransportesModel({
    required this.PLACA,
    required this.DESCRICAO,
    required this.TANQUES,
  });

  TransportesModel copyWith({
    String? PLACA,
    String? DESCRICAO,
    int? TANQUES,
  }) {
    return TransportesModel(
      PLACA: PLACA ?? this.PLACA,
      DESCRICAO: DESCRICAO ?? this.DESCRICAO,
      TANQUES: TANQUES ?? this.TANQUES,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PLACA': PLACA,
      'DESCRICAO': DESCRICAO,
      'TANQUES': TANQUES,
    };
  }

  factory TransportesModel.fromMap(Map<String, dynamic> map) {
    return TransportesModel(
      PLACA: map['PLACA'] ?? '',
      DESCRICAO: map['DESCRICAO'] ?? '',
      TANQUES: map['TANQUES']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransportesModel.fromJson(String source) =>
      TransportesModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'TransportesModel(PLACA: $PLACA, DESCRICAO: $DESCRICAO, TANQUES: $TANQUES)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransportesModel &&
        other.PLACA == PLACA &&
        other.DESCRICAO == DESCRICAO &&
        other.TANQUES == TANQUES;
  }

  @override
  int get hashCode => PLACA.hashCode ^ DESCRICAO.hashCode ^ TANQUES.hashCode;
}
