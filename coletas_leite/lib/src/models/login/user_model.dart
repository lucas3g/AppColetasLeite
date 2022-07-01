import 'dart:convert';

class UserModel {
  final String CNPJ;
  final String LOGIN;
  final String SENHA;
  String? NOME;
  int? CCUSTO;
  String? DESC_EMPRESA;
  UserModel({
    this.CNPJ = '',
    this.LOGIN = '',
    this.SENHA = '',
    this.NOME,
    this.CCUSTO,
    this.DESC_EMPRESA,
  });

  factory UserModel.LOGIN(UserModel account) {
    return UserModel(
      CNPJ: account.CNPJ,
      LOGIN: account.LOGIN,
      SENHA: account.SENHA,
      NOME: account.NOME,
      CCUSTO: account.CCUSTO,
      DESC_EMPRESA: account.DESC_EMPRESA,
    );
  }

  UserModel copyWith({
    String? CNPJ,
    String? LOGIN,
    String? SENHA,
    String? NOME,
    int? CCUSTO,
    String? DESC_EMPRESA,
  }) {
    return UserModel(
      CNPJ: CNPJ ?? this.CNPJ,
      LOGIN: LOGIN ?? this.LOGIN,
      SENHA: SENHA ?? this.SENHA,
      NOME: NOME ?? this.NOME,
      CCUSTO: CCUSTO ?? this.CCUSTO,
      DESC_EMPRESA: DESC_EMPRESA ?? this.DESC_EMPRESA,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CNPJ': CNPJ,
      'LOGIN': LOGIN,
      'SENHA': SENHA,
      'NOME': NOME,
      'CCUSTO': CCUSTO,
      'DESC_EMPRESA': DESC_EMPRESA,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      CNPJ: map['CNPJ'] ?? '',
      LOGIN: map['LOGIN'] ?? '',
      SENHA: map['SENHA'] ?? '',
      NOME: map['NOME'],
      CCUSTO: map['CCUSTO']?.toInt(),
      DESC_EMPRESA: map['DESC_EMPRESA'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(CNPJ: $CNPJ, LOGIN: $LOGIN, SENHA: $SENHA, NOME: $NOME, CCUSTO: $CCUSTO, DESC_EMPRESA: $DESC_EMPRESA)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.CNPJ == CNPJ &&
        other.LOGIN == LOGIN &&
        other.SENHA == SENHA &&
        other.NOME == NOME &&
        other.CCUSTO == CCUSTO &&
        other.DESC_EMPRESA == DESC_EMPRESA;
  }

  @override
  int get hashCode {
    return CNPJ.hashCode ^
        LOGIN.hashCode ^
        SENHA.hashCode ^
        NOME.hashCode ^
        CCUSTO.hashCode ^
        DESC_EMPRESA.hashCode;
  }
}
