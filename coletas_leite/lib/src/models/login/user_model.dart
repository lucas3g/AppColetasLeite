import 'dart:convert';

class UserModel {
  final String cnpj;
  final String login;
  final String senha;
  String? nome;
  int? ccusto;
  String? descEmpresa;
  UserModel({
    this.cnpj = '',
    this.login = '',
    this.senha = '',
    this.nome,
    this.ccusto,
    this.descEmpresa,
  });

  factory UserModel.login(UserModel account) {
    return UserModel(
      cnpj: account.cnpj,
      login: account.login,
      senha: account.senha,
      nome: account.nome,
      ccusto: account.ccusto,
      descEmpresa: account.descEmpresa,
    );
  }

  UserModel copyWith({
    String? cnpj,
    String? login,
    String? senha,
    String? nome,
    int? ccusto,
    String? descEmpresa,
  }) {
    return UserModel(
      cnpj: cnpj ?? this.cnpj,
      login: login ?? this.login,
      senha: senha ?? this.senha,
      nome: nome ?? this.nome,
      ccusto: ccusto ?? this.ccusto,
      descEmpresa: descEmpresa ?? this.descEmpresa,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cnpj': cnpj,
      'login': login,
      'senha': senha,
      'nome': nome,
      'ccusto': ccusto,
      'descEmpresa': descEmpresa,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      cnpj: map['cnpj'] ?? '',
      login: map['login'] ?? '',
      senha: map['senha'] ?? '',
      nome: map['nome'],
      ccusto: map['ccusto']?.toInt(),
      descEmpresa: map['descEmpresa'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(cnpj: $cnpj, login: $login, senha: $senha, nome: $nome, ccusto: $ccusto, descEmpresa: $descEmpresa)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.cnpj == cnpj &&
        other.login == login &&
        other.senha == senha &&
        other.nome == nome &&
        other.ccusto == ccusto &&
        other.descEmpresa == descEmpresa;
  }

  @override
  int get hashCode {
    return cnpj.hashCode ^
        login.hashCode ^
        senha.hashCode ^
        nome.hashCode ^
        ccusto.hashCode ^
        descEmpresa.hashCode;
  }
}
