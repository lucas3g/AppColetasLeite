import 'dart:convert';

class ColetasClientesModel {
  int CLIFOR;
  int ROTA;
  String NOME;
  String MUNICIPIOS;
  String UF;
  int? QUANTIDADE;
  double? TEMPERATURA;
  int? PARTICAO;
  String? OBSERVACAO;
  int? ID;

  ColetasClientesModel({
    required this.CLIFOR,
    required this.ROTA,
    required this.NOME,
    required this.MUNICIPIOS,
    required this.UF,
    this.QUANTIDADE = 0,
    this.TEMPERATURA = 0,
    this.PARTICAO = 0,
    this.OBSERVACAO = '',
    this.ID = 0,
  });

  ColetasClientesModel copyWith({
    int? CLIFOR,
    int? ROTA,
    String? NOME,
    String? MUNICIPIOS,
    String? UF,
    int? QUANTIDADE,
    double? TEMPERATURA,
    int? PARTICAO,
    String? OBSERVACAO,
    int? ID,
  }) {
    return ColetasClientesModel(
      CLIFOR: CLIFOR ?? this.CLIFOR,
      ROTA: ROTA ?? this.ROTA,
      NOME: NOME ?? this.NOME,
      MUNICIPIOS: MUNICIPIOS ?? this.MUNICIPIOS,
      UF: UF ?? this.UF,
      QUANTIDADE: QUANTIDADE ?? this.QUANTIDADE,
      TEMPERATURA: TEMPERATURA ?? this.TEMPERATURA,
      PARTICAO: PARTICAO ?? this.PARTICAO,
      OBSERVACAO: OBSERVACAO ?? this.OBSERVACAO,
      ID: ID ?? this.ID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CLIFOR': CLIFOR,
      'ROTA': ROTA,
      'NOME': NOME,
      'MUNICIPIOS': MUNICIPIOS,
      'UF': UF,
      'QUANTIDADE': QUANTIDADE,
      'TEMPERATURA': TEMPERATURA,
      'PARTICAO': PARTICAO,
      'OBSERVACAO': OBSERVACAO,
      'ID': ID,
    };
  }

  factory ColetasClientesModel.fromMap(Map<String, dynamic> map) {
    return ColetasClientesModel(
      CLIFOR: map['CLIFOR']?.toInt() ?? 0,
      ROTA: map['ROTA']?.toInt() ?? 0,
      NOME: map['NOME'] ?? '',
      MUNICIPIOS: map['MUNICIPIOS'] ?? '',
      UF: map['UF'] ?? '',
      QUANTIDADE: map['QUANTIDADE']?.toInt() ?? 0,
      TEMPERATURA: map['TEMPERATURA']?.toDouble() ?? 0.0,
      PARTICAO: map['PARTICAO']?.toInt() ?? 0,
      OBSERVACAO: map['OBSERVACAO'] ?? '',
      ID: map['ID']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ColetasClientesModel.fromJson(String source) =>
      ColetasClientesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ColetasClientesModel(CLIFOR: $CLIFOR, ROTA: $ROTA, NOME: $NOME, MUNICIPIOS: $MUNICIPIOS, UF: $UF, QUANTIDADE: $QUANTIDADE, TEMPERATURA: $TEMPERATURA, PARTICAO: $PARTICAO, OBSERVACAO: $OBSERVACAO, ID: $ID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColetasClientesModel &&
        other.CLIFOR == CLIFOR &&
        other.ROTA == ROTA &&
        other.NOME == NOME &&
        other.MUNICIPIOS == MUNICIPIOS &&
        other.UF == UF &&
        other.QUANTIDADE == QUANTIDADE &&
        other.TEMPERATURA == TEMPERATURA &&
        other.PARTICAO == PARTICAO &&
        other.OBSERVACAO == OBSERVACAO &&
        other.ID == ID;
  }

  @override
  int get hashCode {
    return CLIFOR.hashCode ^
        ROTA.hashCode ^
        NOME.hashCode ^
        MUNICIPIOS.hashCode ^
        UF.hashCode ^
        QUANTIDADE.hashCode ^
        TEMPERATURA.hashCode ^
        PARTICAO.hashCode ^
        OBSERVACAO.hashCode ^
        ID.hashCode;
  }
}
