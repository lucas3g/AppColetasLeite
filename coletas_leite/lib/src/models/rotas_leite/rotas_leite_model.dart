import 'dart:convert';

class RotasLeiteModel {
  int id;
  String descricao;
  String transportador;
  RotasLeiteModel({
    required this.id,
    required this.descricao,
    required this.transportador,
  });

  RotasLeiteModel copyWith({
    int? id,
    String? descricao,
    String? transportador,
  }) {
    return RotasLeiteModel(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      transportador: transportador ?? this.transportador,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'transportador': transportador,
    };
  }

  factory RotasLeiteModel.fromMap(Map<String, dynamic> map) {
    return RotasLeiteModel(
      id: map['id']?.toInt() ?? 0,
      descricao: map['descricao'] ?? '',
      transportador: map['transportador'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RotasLeiteModel.fromJson(String source) =>
      RotasLeiteModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RotasLeiteModel(id: $id, descricao: $descricao, transportador: $transportador)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RotasLeiteModel &&
        other.id == id &&
        other.descricao == descricao &&
        other.transportador == transportador;
  }

  @override
  int get hashCode => id.hashCode ^ descricao.hashCode ^ transportador.hashCode;
}
