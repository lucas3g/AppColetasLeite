import 'dart:convert';

class TiketEntradaModel {
  int rota;
  String? rota_nome;
  String nome;
  String municipios;
  String uf;
  int? clifor;
  int? produto;
  String? data;
  int? tiket;
  int? quantidade;
  double? per_desconto;
  int? ccusto;
  double? crioscopia;
  String? hora;
  int? particao;
  String? observacao;
  String? placa;
  double? temperatura;
  int? id;
  int? id_coleta;
  TiketEntradaModel({
    required this.rota,
    this.rota_nome,
    required this.nome,
    required this.municipios,
    required this.uf,
    this.clifor,
    this.produto,
    this.data,
    this.tiket,
    this.quantidade,
    this.per_desconto,
    this.ccusto,
    this.crioscopia,
    this.hora,
    this.particao,
    this.observacao,
    this.placa,
    this.temperatura,
    this.id,
    this.id_coleta,
  });

  TiketEntradaModel copyWith({
    int? rota,
    String? rota_nome,
    String? nome,
    String? municipios,
    String? uf,
    int? clifor,
    int? produto,
    String? data,
    int? tiket,
    int? quantidade,
    double? per_desconto,
    int? ccusto,
    double? crioscopia,
    String? hora,
    int? particao,
    String? observacao,
    String? placa,
    double? temperatura,
    int? id,
    int? id_coleta,
  }) {
    return TiketEntradaModel(
      rota: rota ?? this.rota,
      rota_nome: rota_nome ?? this.rota_nome,
      nome: nome ?? this.nome,
      municipios: municipios ?? this.municipios,
      uf: uf ?? this.uf,
      clifor: clifor ?? this.clifor,
      produto: produto ?? this.produto,
      data: data ?? this.data,
      tiket: tiket ?? this.tiket,
      quantidade: quantidade ?? this.quantidade,
      per_desconto: per_desconto ?? this.per_desconto,
      ccusto: ccusto ?? this.ccusto,
      crioscopia: crioscopia ?? this.crioscopia,
      hora: hora ?? this.hora,
      particao: particao ?? this.particao,
      observacao: observacao ?? this.observacao,
      placa: placa ?? this.placa,
      temperatura: temperatura ?? this.temperatura,
      id: id ?? this.id,
      id_coleta: id_coleta ?? this.id_coleta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rota': rota,
      'rota_nome': rota_nome,
      'nome': nome,
      'municipios': municipios,
      'uf': uf,
      'clifor': clifor,
      'produto': produto,
      'data': data,
      'tiket': tiket,
      'quantidade': quantidade,
      'per_desconto': per_desconto,
      'ccusto': ccusto,
      'crioscopia': crioscopia,
      'hora': hora,
      'particao': particao,
      'observacao': observacao,
      'temperatura': temperatura,
      'id': id,
      'id_coleta': id_coleta,
    };
  }

  factory TiketEntradaModel.fromMap(Map<String, dynamic> map) {
    return TiketEntradaModel(
      rota: map['rota']?.toInt() ?? 0,
      rota_nome: map['rota_nome'] ?? '',
      nome: map['nome'] ?? '',
      municipios: map['municipios'] ?? '',
      uf: map['uf'] ?? '',
      clifor: map['clifor']?.toInt() ?? 0,
      produto: map['produto']?.toInt() ?? 0,
      data: map['data'] ?? '',
      tiket: map['tiket']?.toInt() ?? 0,
      quantidade: map['quantidade']?.toInt() ?? 0,
      per_desconto: map['per_desconto']?.toDouble() ?? 0.0,
      ccusto: map['ccusto']?.toInt() ?? 0,
      crioscopia: map['crioscopia']?.toDouble() ?? 0.0,
      hora: map['hora'] ?? '',
      particao: map['particao']?.toInt() ?? 0,
      observacao: map['observacao'] ?? '',
      placa: map['placa'] ?? '',
      temperatura: map['temperatura']?.toDouble() ?? 0.0,
      id: map['id']?.toInt() ?? 0,
      id_coleta: map['id_coleta']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TiketEntradaModel.fromJson(String source) =>
      TiketEntradaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TiketEntradaModel(rota: $rota, rota_nome: $rota_nome, nome: $nome, municipios: $municipios, uf: $uf, clifor: $clifor, produto: $produto, data: $data, tiket: $tiket, quantidade: $quantidade, per_desconto: $per_desconto, ccusto: $ccusto, crioscopia: $crioscopia, hora: $hora, particao: $particao, observacao: $observacao, temperatura: $temperatura, id: $id, id_coleta: $id_coleta)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TiketEntradaModel &&
        other.rota == rota &&
        other.rota_nome == rota_nome &&
        other.nome == nome &&
        other.municipios == municipios &&
        other.uf == uf &&
        other.clifor == clifor &&
        other.produto == produto &&
        other.data == data &&
        other.tiket == tiket &&
        other.quantidade == quantidade &&
        other.per_desconto == per_desconto &&
        other.ccusto == ccusto &&
        other.crioscopia == crioscopia &&
        other.hora == hora &&
        other.particao == particao &&
        other.observacao == observacao &&
        other.placa == placa &&
        other.temperatura == temperatura &&
        other.id == id &&
        other.id_coleta == id_coleta;
  }

  @override
  int get hashCode {
    return rota.hashCode ^
        rota_nome.hashCode ^
        nome.hashCode ^
        municipios.hashCode ^
        uf.hashCode ^
        clifor.hashCode ^
        produto.hashCode ^
        data.hashCode ^
        tiket.hashCode ^
        quantidade.hashCode ^
        per_desconto.hashCode ^
        ccusto.hashCode ^
        crioscopia.hashCode ^
        hora.hashCode ^
        particao.hashCode ^
        observacao.hashCode ^
        placa.hashCode ^
        temperatura.hashCode ^
        id.hashCode ^
        id_coleta.hashCode;
  }
}
