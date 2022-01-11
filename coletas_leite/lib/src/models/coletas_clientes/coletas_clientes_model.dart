import 'dart:convert';

class ColetasClientesModel {
  int clifor;
  int rota;
  String nome;
  String municipios;
  String uf;
  int? quantidade;
  double? temperatura;
  int? particao;
  String? observacao;
  int? id;

  ColetasClientesModel({
    required this.clifor,
    required this.rota,
    required this.nome,
    required this.municipios,
    required this.uf,
    this.quantidade = 0,
    this.temperatura = 0,
    this.particao = 0,
    this.observacao = '',
    this.id = 0,
  });

  ColetasClientesModel copyWith({
    int? clifor,
    int? rota,
    String? nome,
    String? municipios,
    String? uf,
    int? quantidade,
    double? temperatura,
    int? particao,
    String? observacao,
    int? id,
  }) {
    return ColetasClientesModel(
      clifor: clifor ?? this.clifor,
      rota: rota ?? this.rota,
      nome: nome ?? this.nome,
      municipios: municipios ?? this.municipios,
      uf: uf ?? this.uf,
      quantidade: quantidade ?? this.quantidade,
      temperatura: temperatura ?? this.temperatura,
      particao: particao ?? this.particao,
      observacao: observacao ?? this.observacao,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clifor': clifor,
      'rota': rota,
      'nome': nome,
      'municipios': municipios,
      'uf': uf,
      'quantidade': quantidade,
      'temperatura': temperatura,
      'particao': particao,
      'observacao': observacao,
      'id': id,
    };
  }

  factory ColetasClientesModel.fromMap(Map<String, dynamic> map) {
    return ColetasClientesModel(
      clifor: map['clifor']?.toInt() ?? 0,
      rota: map['rota']?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      municipios: map['municipios'] ?? '',
      uf: map['uf'] ?? '',
      quantidade: map['quantidade']?.toInt() ?? 0,
      temperatura: map['temperatura']?.toDouble() ?? 0.0,
      particao: map['particao']?.toInt() ?? 0,
      observacao: map['observacao'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ColetasClientesModel.fromJson(String source) =>
      ColetasClientesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ColetasClientesModel(clifor: $clifor, rota: $rota, nome: $nome, municipios: $municipios, uf: $uf, quantidade: $quantidade, temperatura: $temperatura, particao: $particao, observacao: $observacao, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColetasClientesModel &&
        other.clifor == clifor &&
        other.rota == rota &&
        other.nome == nome &&
        other.municipios == municipios &&
        other.uf == uf &&
        other.quantidade == quantidade &&
        other.temperatura == temperatura &&
        other.particao == particao &&
        other.observacao == observacao &&
        other.id == id;
  }

  @override
  int get hashCode {
    return clifor.hashCode ^
        rota.hashCode ^
        nome.hashCode ^
        municipios.hashCode ^
        uf.hashCode ^
        quantidade.hashCode ^
        temperatura.hashCode ^
        particao.hashCode ^
        observacao.hashCode ^
        id.hashCode;
  }
}
