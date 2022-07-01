import 'dart:convert';

import 'package:coletas_leite/src/configs/global_settings.dart';

class ColetasModel {
  String? DATA_MOV;
  int? ROTA_COLETA;
  String? ROTA_NOME;
  int? KM_INICIO;
  int? KM_FIM;
  String? DT_HORA_INI;
  String? DT_HORA_FIM;
  String? TRANSPORTADOR;
  int? TANQUES;
  String? MOTORISTA;
  int? CCUSTO;
  int? ROTA_FINALIZADA;
  int? ID;
  int? ENVIADA;
  ColetasModel({
    this.DATA_MOV,
    this.ROTA_COLETA,
    this.ROTA_NOME,
    this.KM_INICIO,
    this.KM_FIM,
    this.DT_HORA_INI,
    this.DT_HORA_FIM,
    this.TRANSPORTADOR,
    this.TANQUES,
    this.MOTORISTA,
    this.CCUSTO,
    this.ROTA_FINALIZADA,
    this.ID,
    this.ENVIADA,
  });

  ColetasModel copyWith({
    String? DATA_MOV,
    int? ROTA_COLETA,
    String? ROTA_NOME,
    int? KM_INICIO,
    int? KM_FIM,
    String? DT_HORA_INI,
    String? DT_HORA_FIM,
    String? TRANSPORTADOR,
    int? TANQUES,
    String? MOTORISTA,
    int? CCUSTO,
    int? ROTA_FINALIZADA,
    int? ID,
    int? ENVIADA,
  }) {
    return ColetasModel(
      DATA_MOV: DATA_MOV ?? this.DATA_MOV,
      ROTA_COLETA: ROTA_COLETA ?? this.ROTA_COLETA,
      ROTA_NOME: ROTA_NOME ?? this.ROTA_NOME,
      KM_INICIO: KM_INICIO ?? this.KM_INICIO,
      KM_FIM: KM_FIM ?? this.KM_FIM,
      DT_HORA_INI: DT_HORA_INI ?? this.DT_HORA_INI,
      DT_HORA_FIM: DT_HORA_FIM ?? this.DT_HORA_FIM,
      TRANSPORTADOR: TRANSPORTADOR ?? this.TRANSPORTADOR,
      TANQUES: TANQUES ?? this.TANQUES,
      MOTORISTA: MOTORISTA ?? this.MOTORISTA,
      CCUSTO: CCUSTO ?? this.CCUSTO,
      ROTA_FINALIZADA: ROTA_FINALIZADA ?? this.ROTA_FINALIZADA,
      ID: ID ?? this.ID,
      ENVIADA: ENVIADA ?? this.ENVIADA,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'DATA_MOV': DATA_MOV,
      'ROTA_COLETA': ROTA_COLETA,
      'ROTA_NOME': ROTA_NOME,
      'KM_INICIO': KM_INICIO,
      'KM_FIM': KM_FIM,
      'DT_HORA_INI': DT_HORA_INI,
      'DT_HORA_FIM': DT_HORA_FIM,
      'TRANSPORTADOR': TRANSPORTADOR,
      'TANQUES': TANQUES,
      'MOTORISTA': MOTORISTA,
      'CCUSTO': CCUSTO,
      'ROTA_FINALIZADA': ROTA_FINALIZADA,
      'ID': ID,
      'ENVIADA': ENVIADA,
    };
  }

  factory ColetasModel.fromMap(Map<String, dynamic> map) {
    return ColetasModel(
      DATA_MOV: map['DATA_MOV'],
      ROTA_COLETA: map['ROTA_COLETA']?.toInt(),
      ROTA_NOME: map['ROTA_NOME'],
      KM_INICIO: map['KM_INICIO']?.toInt(),
      KM_FIM: map['KM_FIM']?.toInt(),
      DT_HORA_INI: map['DT_HORA_INI'],
      DT_HORA_FIM: map['DT_HORA_FIM'],
      TRANSPORTADOR: map['TRANSPORTADOR'],
      TANQUES: map['TANQUES']?.toInt(),
      MOTORISTA: map['MOTORISTA'],
      CCUSTO:
          map['CCUSTO']?.toInt() ?? GlobalSettings().appSettings.user.CCUSTO,
      ROTA_FINALIZADA: map['ROTA_FINALIZADA']?.toInt(),
      ID: map['ID']?.toInt(),
      ENVIADA: map['ENVIADA']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ColetasModel.fromJson(String source) =>
      ColetasModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ColetasModel(DATA_MOV: $DATA_MOV, ROTA_COLETA: $ROTA_COLETA, ROTA_NOME: $ROTA_NOME, KM_INICIO: $KM_INICIO, KM_FIM: $KM_FIM, DT_HORA_INI: $DT_HORA_INI, DT_HORA_FIM: $DT_HORA_FIM, TRANSPORTADOR: $TRANSPORTADOR, TANQUES: $TANQUES, MOTORISTA: $MOTORISTA, CCUSTO: $CCUSTO, ROTA_FINALIZADA: $ROTA_FINALIZADA, ID: $ID, ENVIADA: $ENVIADA)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColetasModel &&
        other.DATA_MOV == DATA_MOV &&
        other.ROTA_COLETA == ROTA_COLETA &&
        other.ROTA_NOME == ROTA_NOME &&
        other.KM_INICIO == KM_INICIO &&
        other.KM_FIM == KM_FIM &&
        other.DT_HORA_INI == DT_HORA_INI &&
        other.DT_HORA_FIM == DT_HORA_FIM &&
        other.TRANSPORTADOR == TRANSPORTADOR &&
        other.TANQUES == TANQUES &&
        other.MOTORISTA == MOTORISTA &&
        other.CCUSTO == CCUSTO &&
        other.ROTA_FINALIZADA == ROTA_FINALIZADA &&
        other.ID == ID &&
        other.ENVIADA == ENVIADA;
  }

  @override
  int get hashCode {
    return DATA_MOV.hashCode ^
        ROTA_COLETA.hashCode ^
        ROTA_NOME.hashCode ^
        KM_INICIO.hashCode ^
        KM_FIM.hashCode ^
        DT_HORA_INI.hashCode ^
        DT_HORA_FIM.hashCode ^
        TRANSPORTADOR.hashCode ^
        TANQUES.hashCode ^
        MOTORISTA.hashCode ^
        CCUSTO.hashCode ^
        ROTA_FINALIZADA.hashCode ^
        ID.hashCode ^
        ENVIADA.hashCode;
  }
}
