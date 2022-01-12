import 'dart:convert';

class RotasLeiteModel {
  int id;
  String descricao;
  String transportador;
  int? rota_finalizada;
  RotasLeiteModel({
    required this.id,
    required this.descricao,
    required this.transportador,
    this.rota_finalizada,
  });

  RotasLeiteModel copyWith({
    int? id,
    String? descricao,
    String? transportador,
    int? rota_finalizada,
  }) {
    return RotasLeiteModel(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      transportador: transportador ?? this.transportador,
      rota_finalizada: rota_finalizada ?? this.rota_finalizada,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'transportador': transportador,
      'rota_finalizada': rota_finalizada,
    };
  }

  factory RotasLeiteModel.fromMap(Map<String, dynamic> map) {
    return RotasLeiteModel(
      id: map['id']?.toInt() ?? 0,
      descricao: map['descricao'] ?? '',
      transportador: map['transportador'] ?? '',
      rota_finalizada: map['rota_finalizada']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory RotasLeiteModel.fromJson(String source) =>
      RotasLeiteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RotasLeiteModel(id: $id, descricao: $descricao, transportador: $transportador, rota_finalizada: $rota_finalizada)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RotasLeiteModel &&
        other.id == id &&
        other.descricao == descricao &&
        other.transportador == transportador &&
        other.rota_finalizada == rota_finalizada;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        descricao.hashCode ^
        transportador.hashCode ^
        rota_finalizada.hashCode;
  }
}
