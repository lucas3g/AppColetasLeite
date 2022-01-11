import 'dart:convert';

class TransportesModel {
  String placa;
  String descricao;
  TransportesModel({
    required this.placa,
    required this.descricao,
  });

  TransportesModel copyWith({
    String? placa,
    String? descricao,
  }) {
    return TransportesModel(
      placa: placa ?? this.placa,
      descricao: descricao ?? this.descricao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'descricao': descricao,
    };
  }

  factory TransportesModel.fromMap(Map<String, dynamic> map) {
    return TransportesModel(
      placa: map['placa'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransportesModel.fromJson(String source) =>
      TransportesModel.fromMap(json.decode(source));

  @override
  String toString() => 'TransportesModel(placa: $placa, descricao: $descricao)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransportesModel &&
        other.placa == placa &&
        other.descricao == descricao;
  }

  @override
  int get hashCode => placa.hashCode ^ descricao.hashCode;
}
