import 'dart:convert';

class UserModel {
  final String cnpj;
  final String login;
  final String senha;
  UserModel({
    this.cnpj = '',
    this.login = '',
    this.senha = '',
  });

  factory UserModel.login(UserModel account) {
    return UserModel(
      cnpj: account.cnpj,
      login: account.login,
      senha: account.senha,
    );
  }

  UserModel copyWith({
    String? cnpj,
    String? login,
    String? senha,
  }) {
    return UserModel(
      cnpj: cnpj ?? this.cnpj,
      login: login ?? this.login,
      senha: senha ?? this.senha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cnpj': cnpj,
      'login': login,
      'senha': senha,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      cnpj: map['cnpj'] ?? '',
      login: map['login'] ?? '',
      senha: map['senha'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(cnpj: $cnpj, login: $login, senha: $senha)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.cnpj == cnpj &&
        other.login == login &&
        other.senha == senha;
  }

  @override
  int get hashCode => cnpj.hashCode ^ login.hashCode ^ senha.hashCode;
}
