import 'dart:convert';

class RotasLeiteModel {
  int ID;
  String DESCRICAO;
  String TRANSPORTADOR;
  int? ROTA_FINALIZADA;
  RotasLeiteModel({
    required this.ID,
    required this.DESCRICAO,
    required this.TRANSPORTADOR,
    this.ROTA_FINALIZADA,
  });

  RotasLeiteModel copyWith({
    int? ID,
    String? DESCRICAO,
    String? TRANSPORTADOR,
    int? ROTA_FINALIZADA,
  }) {
    return RotasLeiteModel(
      ID: ID ?? this.ID,
      DESCRICAO: DESCRICAO ?? this.DESCRICAO,
      TRANSPORTADOR: TRANSPORTADOR ?? this.TRANSPORTADOR,
      ROTA_FINALIZADA: ROTA_FINALIZADA ?? this.ROTA_FINALIZADA,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'DESCRICAO': DESCRICAO,
      'TRANSPORTADOR': TRANSPORTADOR,
      'ROTA_FINALIZADA': ROTA_FINALIZADA,
    };
  }

  factory RotasLeiteModel.fromMap(Map<String, dynamic> map) {
    return RotasLeiteModel(
      ID: map['ID']?.toInt() ?? 0,
      DESCRICAO: map['DESCRICAO'] ?? '',
      TRANSPORTADOR: map['TRANSPORTADOR'] ?? '',
      ROTA_FINALIZADA: map['ROTA_FINALIZADA']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory RotasLeiteModel.fromJson(String source) =>
      RotasLeiteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RotasLeiteModel(ID: $ID, DESCRICAO: $DESCRICAO, TRANSPORTADOR: $TRANSPORTADOR, ROTA_FINALIZADA: $ROTA_FINALIZADA)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RotasLeiteModel &&
        other.ID == ID &&
        other.DESCRICAO == DESCRICAO &&
        other.TRANSPORTADOR == TRANSPORTADOR &&
        other.ROTA_FINALIZADA == ROTA_FINALIZADA;
  }

  @override
  int get hashCode {
    return ID.hashCode ^
        DESCRICAO.hashCode ^
        TRANSPORTADOR.hashCode ^
        ROTA_FINALIZADA.hashCode;
  }
}
