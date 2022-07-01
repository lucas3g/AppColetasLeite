import 'dart:convert';

import 'package:coletas_leite/src/configs/global_settings.dart';

class TiketEntradaModel {
  int ROTA;
  String? ROTA_NOME;
  String NOME;
  String MUNICIPIOS;
  String UF;
  int? CLIFOR;
  int? PRODUTO;
  String? DATA;
  int? TIKET;
  int? QUANTIDADE;
  double? PER_DESCONTO;
  int? CCUSTO;
  double? CRIOSCOPIA;
  bool? ALIZAROL;
  String? HORA;
  int? PARTICAO;
  String? OBSERVACAO;
  String? PLACA;
  double? TEMPERATURA;
  int? ID;
  int? ID_COLETA;
  int? QTD_VEZES_EDITADO;

  TiketEntradaModel({
    required this.ROTA,
    this.ROTA_NOME,
    required this.NOME,
    required this.MUNICIPIOS,
    required this.UF,
    this.CLIFOR,
    this.PRODUTO,
    this.DATA,
    this.TIKET,
    this.QUANTIDADE,
    this.PER_DESCONTO,
    this.ALIZAROL,
    this.CCUSTO,
    this.CRIOSCOPIA,
    this.HORA,
    this.PARTICAO,
    this.OBSERVACAO,
    this.PLACA,
    this.TEMPERATURA,
    this.ID,
    this.ID_COLETA,
    this.QTD_VEZES_EDITADO,
  });

  TiketEntradaModel copyWith({
    int? ROTA,
    String? ROTA_NOME,
    String? NOME,
    String? MUNICIPIOS,
    String? UF,
    int? CLIFOR,
    int? PRODUTO,
    String? DATA,
    int? TIKET,
    int? QUANTIDADE,
    double? PER_DESCONTO,
    int? CCUSTO,
    double? CRIOSCOPIA,
    bool? ALIZAROL,
    String? HORA,
    int? PARTICAO,
    String? OBSERVACAO,
    String? PLACA,
    double? TEMPERATURA,
    int? ID,
    int? ID_COLETA,
    int? QTD_VEZES_EDITADO,
  }) {
    return TiketEntradaModel(
      ROTA: ROTA ?? this.ROTA,
      ROTA_NOME: ROTA_NOME ?? this.ROTA_NOME,
      NOME: NOME ?? this.NOME,
      MUNICIPIOS: MUNICIPIOS ?? this.MUNICIPIOS,
      UF: UF ?? this.UF,
      CLIFOR: CLIFOR ?? this.CLIFOR,
      PRODUTO: PRODUTO ?? this.PRODUTO,
      DATA: DATA ?? this.DATA,
      TIKET: TIKET ?? this.TIKET,
      QUANTIDADE: QUANTIDADE ?? this.QUANTIDADE,
      PER_DESCONTO: PER_DESCONTO ?? this.PER_DESCONTO,
      CCUSTO: CCUSTO ?? this.CCUSTO,
      CRIOSCOPIA: CRIOSCOPIA ?? this.CRIOSCOPIA,
      ALIZAROL: ALIZAROL ?? this.ALIZAROL,
      HORA: HORA ?? this.HORA,
      PARTICAO: PARTICAO ?? this.PARTICAO,
      OBSERVACAO: OBSERVACAO ?? this.OBSERVACAO,
      PLACA: PLACA ?? this.PLACA,
      TEMPERATURA: TEMPERATURA ?? this.TEMPERATURA,
      ID: ID ?? this.ID,
      ID_COLETA: ID_COLETA ?? this.ID_COLETA,
      QTD_VEZES_EDITADO: QTD_VEZES_EDITADO ?? this.QTD_VEZES_EDITADO,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ROTA': ROTA,
      'ROTA_NOME': ROTA_NOME,
      'NOME': NOME,
      'MUNICIPIOS': MUNICIPIOS,
      'UF': UF,
      'CLIFOR': CLIFOR,
      'PRODUTO': PRODUTO,
      'DATA': DATA,
      'TIKET': TIKET,
      'QUANTIDADE': QUANTIDADE,
      'PER_DESCONTO': PER_DESCONTO,
      'CCUSTO': CCUSTO,
      'CRIOSCOPIA': CRIOSCOPIA,
      'ALIZAROL': ALIZAROL,
      'HORA': HORA,
      'PARTICAO': PARTICAO,
      'OBSERVACAO': OBSERVACAO,
      'TEMPERATURA': TEMPERATURA,
      'ID': ID,
      'ID_COLETA': ID_COLETA,
      'QTD_VEZES_EDITADO': QTD_VEZES_EDITADO,
    };
  }

  factory TiketEntradaModel.fromMap(Map<String, dynamic> map) {
    return TiketEntradaModel(
      ROTA: map['ROTA']?.toInt() ?? 0,
      ROTA_NOME: map['ROTA_NOME'] ?? '',
      NOME: map['NOME'] ?? '',
      MUNICIPIOS: map['MUNICIPIOS'] ?? '',
      UF: map['UF'] ?? '',
      CLIFOR: map['CLIFOR']?.toInt() ?? 0,
      PRODUTO: map['PRODUTO']?.toInt() ?? 0,
      DATA: map['DATA'] ?? '',
      TIKET: map['TIKET']?.toInt() ?? 0,
      QUANTIDADE: map['QUANTIDADE']?.toInt() ?? 0,
      PER_DESCONTO: map['PER_DESCONTO']?.toDouble() ?? 0.0,
      CCUSTO:
          map['CCUSTO']?.toInt() ?? GlobalSettings().appSettings.user.CCUSTO,
      CRIOSCOPIA: map['CRIOSCOPIA']?.toDouble() ?? 0.0,
      ALIZAROL: map['ALIZAROL'] ?? false,
      HORA: map['HORA'] ?? '',
      PARTICAO: map['PARTICAO']?.toInt() ?? 1,
      OBSERVACAO: map['OBSERVACAO'] ?? '',
      PLACA: map['PLACA'] ?? '',
      TEMPERATURA: map['TEMPERATURA']?.toDouble() ?? 0.0,
      ID: map['ID']?.toInt() ?? 0,
      ID_COLETA: map['ID_COLETA']?.toInt() ?? 0,
      QTD_VEZES_EDITADO: map['QTD_VEZES_EDITADO']?.toInt() ?? 0,
    );
  }

  factory TiketEntradaModel.fromMapDb(Map<String, dynamic> map) {
    return TiketEntradaModel(
      ROTA: map['rota']?.toInt() ?? 0,
      ROTA_NOME: map['rota_nome'] ?? '',
      NOME: map['nome'] ?? '',
      MUNICIPIOS: map['municipios'] ?? '',
      UF: map['uf'] ?? '',
      CLIFOR: map['clifor']?.toInt() ?? 0,
      PRODUTO: map['produto']?.toInt() ?? 0,
      DATA: map['data'] ?? '',
      TIKET: map['tiket']?.toInt() ?? 0,
      QUANTIDADE: map['quantidade']?.toInt() ?? 0,
      PER_DESCONTO: map['per_desconto']?.toDouble() ?? 0.0,
      CCUSTO:
          map['ccusto']?.toInt() ?? GlobalSettings().appSettings.user.CCUSTO,
      CRIOSCOPIA: map['crioscopia']?.toDouble() ?? 0.0,
      ALIZAROL: map['alizarol'] ?? false,
      HORA: map['hora'] ?? '',
      PARTICAO: map['particao']?.toInt() ?? 1,
      OBSERVACAO: map['observacao'] ?? '',
      PLACA: map['placa'] ?? '',
      TEMPERATURA: map['temperatura']?.toDouble() ?? 0.0,
      ID: map['id']?.toInt() ?? 0,
      ID_COLETA: map['id_coleta']?.toInt() ?? 0,
      QTD_VEZES_EDITADO: map['qtd_vezes_editado']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TiketEntradaModel.fromJson(String source) =>
      TiketEntradaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TiketEntradaModel(ROTA: $ROTA, ROTA_NOME: $ROTA_NOME, NOME: $NOME, MUNICIPIOS: $MUNICIPIOS, UF: $UF, CLIFOR: $CLIFOR, PRODUTO: $PRODUTO, DATA: $DATA, TIKET: $TIKET, QUANTIDADE: $QUANTIDADE, PER_DESCONTO: $PER_DESCONTO, CCUSTO: $CCUSTO, CRIOSCOPIA: $CRIOSCOPIA, ALIZAROL: $ALIZAROL, HORA: $HORA, PARTICAO: $PARTICAO, OBSERVACAO: $OBSERVACAO, TEMPERATURA: $TEMPERATURA, ID: $ID, ID_COLETA: $ID_COLETA)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TiketEntradaModel &&
        other.ROTA == ROTA &&
        other.ROTA_NOME == ROTA_NOME &&
        other.NOME == NOME &&
        other.MUNICIPIOS == MUNICIPIOS &&
        other.UF == UF &&
        other.CLIFOR == CLIFOR &&
        other.PRODUTO == PRODUTO &&
        other.DATA == DATA &&
        other.TIKET == TIKET &&
        other.QUANTIDADE == QUANTIDADE &&
        other.PER_DESCONTO == PER_DESCONTO &&
        other.CCUSTO == CCUSTO &&
        other.CRIOSCOPIA == CRIOSCOPIA &&
        other.ALIZAROL == ALIZAROL &&
        other.HORA == HORA &&
        other.PARTICAO == PARTICAO &&
        other.OBSERVACAO == OBSERVACAO &&
        other.PLACA == PLACA &&
        other.TEMPERATURA == TEMPERATURA &&
        other.ID == ID &&
        other.ID_COLETA == ID_COLETA &&
        other.QTD_VEZES_EDITADO == QTD_VEZES_EDITADO;
  }

  @override
  int get hashCode {
    return ROTA.hashCode ^
        ROTA_NOME.hashCode ^
        NOME.hashCode ^
        MUNICIPIOS.hashCode ^
        UF.hashCode ^
        CLIFOR.hashCode ^
        PRODUTO.hashCode ^
        DATA.hashCode ^
        TIKET.hashCode ^
        QUANTIDADE.hashCode ^
        PER_DESCONTO.hashCode ^
        CCUSTO.hashCode ^
        CRIOSCOPIA.hashCode ^
        ALIZAROL.hashCode ^
        HORA.hashCode ^
        PARTICAO.hashCode ^
        OBSERVACAO.hashCode ^
        PLACA.hashCode ^
        TEMPERATURA.hashCode ^
        ID.hashCode ^
        ID_COLETA.hashCode ^
        QTD_VEZES_EDITADO.hashCode;
  }
}
