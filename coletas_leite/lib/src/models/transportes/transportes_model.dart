import 'dart:convert';

class TransportesModel {
  String placa;
  String descricao;
  int tanques;

  TransportesModel({
    required this.placa,
    required this.descricao,
    required this.tanques,
  });

  TransportesModel copyWith({
    String? placa,
    String? descricao,
    int? tanques,
  }) {
    return TransportesModel(
      placa: placa ?? this.placa,
      descricao: descricao ?? this.descricao,
      tanques: tanques ?? this.tanques,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'descricao': descricao,
      'tanques': tanques,
    };
  }

  factory TransportesModel.fromMap(Map<String, dynamic> map) {
    return TransportesModel(
      placa: map['placa'] ?? '',
      descricao: map['descricao'] ?? '',
      tanques: map['tanques']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransportesModel.fromJson(String source) =>
      TransportesModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'TransportesModel(placa: $placa, descricao: $descricao, tanques: $tanques)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransportesModel &&
        other.placa == placa &&
        other.descricao == descricao &&
        other.tanques == tanques;
  }

  @override
  int get hashCode => placa.hashCode ^ descricao.hashCode ^ tanques.hashCode;
}
