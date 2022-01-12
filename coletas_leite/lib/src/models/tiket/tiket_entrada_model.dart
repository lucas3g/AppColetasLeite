import 'dart:convert';

class TiketEntradaModel {
  int rota;
  String? rota_nome;
  String nome;
  String municipios;
  String uf;
  int? clifor;
  int? produto;
  DateTime? data;
  int? tiket;
  int? quantidade;
  double? per_desconto;
  int? ccusto;
  double? crioscopia;
  DateTime? hora;
  int? particao;
  String? observacao;
  double? temperatura;
  int? id;

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
    this.temperatura,
    this.id,
  });

  TiketEntradaModel copyWith({
    int? rota,
    String? nome,
    String? rota_nome,
    String? municipios,
    String? uf,
    int? clifor,
    int? produto,
    DateTime? data,
    int? tiket,
    int? quantidade,
    double? per_desconto,
    int? ccusto,
    double? crioscopia,
    DateTime? hora,
    int? particao,
    String? observacao,
    double? temperatura,
    int? id,
  }) {
    return TiketEntradaModel(
      rota: rota ?? this.rota,
      nome: nome ?? this.nome,
      rota_nome: rota_nome ?? this.rota_nome,
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
      temperatura: temperatura ?? this.temperatura,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rota': rota,
      'nome': nome,
      'rota_nome': rota_nome,
      'municipios': municipios,
      'uf': uf,
      'clifor': clifor,
      'produto': produto,
      'data': data?.millisecondsSinceEpoch,
      'tiket': tiket,
      'quantidade': quantidade,
      'per_desconto': per_desconto,
      'ccusto': ccusto,
      'crioscopia': crioscopia,
      'hora': hora?.millisecondsSinceEpoch,
      'particao': particao,
      'observacao': observacao,
      'temperatura': temperatura,
      'id': id,
    };
  }

  factory TiketEntradaModel.fromMap(Map<String, dynamic> map) {
    return TiketEntradaModel(
      rota: map['rota']?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      rota_nome: map['rota_nome'] ?? '',
      municipios: map['municipios'] ?? '',
      uf: map['uf'] ?? '',
      clifor: map['clifor']?.toInt(),
      produto: map['produto']?.toInt(),
      data: map['data'] != null ? DateTime.now() : null,
      tiket: map['tiket']?.toInt(),
      quantidade: map['quantidade']?.toInt() ?? 0,
      per_desconto: map['per_desconto']?.toDouble() ?? 0.0,
      ccusto: map['ccusto']?.toInt() ?? 0,
      crioscopia: map['crioscopia']?.toDouble() ?? 0.0,
      hora: map['hora'] != null ? DateTime.now() : null,
      particao: map['particao']?.toInt() ?? 0,
      observacao: map['observacao'] ?? '',
      temperatura: map['temperatura']?.toDouble() ?? 0.0,
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TiketEntradaModel.fromJson(String source) =>
      TiketEntradaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TiketEntradaModel(rota: $rota, nome: $nome, municipios: $municipios, uf: $uf, clifor: $clifor, produto: $produto, data: $data, tiket: $tiket, quantidade: $quantidade, per_desconto: $per_desconto, ccusto: $ccusto, crioscopia: $crioscopia, hora: $hora, particao: $particao, observacao: $observacao, temperatura: $temperatura, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TiketEntradaModel &&
        other.rota == rota &&
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
        other.temperatura == temperatura &&
        other.id == id;
  }

  @override
  int get hashCode {
    return rota.hashCode ^
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
        temperatura.hashCode ^
        id.hashCode;
  }
}
