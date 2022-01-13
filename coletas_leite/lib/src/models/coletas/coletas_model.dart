import 'dart:convert';

class ColetasModel {
  String? data_mov;
  int? rota_coleta;
  String? rota_nome;
  int? km_inicio;
  int? km_fim;
  String? dt_hora_ini;
  String? dt_hora_fim;
  String? transportador;
  String? motorista;
  int? ccusto;
  int? rota_finalizada;
  int? id;

  ColetasModel({
    this.data_mov,
    this.rota_coleta,
    this.rota_nome,
    this.km_inicio,
    this.km_fim,
    this.dt_hora_ini,
    this.dt_hora_fim,
    this.transportador,
    this.motorista,
    this.ccusto,
    this.rota_finalizada,
    this.id,
  });

  ColetasModel copyWith({
    String? data_mov,
    int? rota_coleta,
    String? rota_nome,
    int? km_inicio,
    int? km_fim,
    String? dt_hora_ini,
    String? dt_hora_fim,
    String? transportador,
    String? motorista,
    int? ccusto,
    int? rota_finalizada,
    int? id,
  }) {
    return ColetasModel(
      data_mov: data_mov ?? this.data_mov,
      rota_coleta: rota_coleta ?? this.rota_coleta,
      rota_nome: rota_nome ?? this.rota_nome,
      km_inicio: km_inicio ?? this.km_inicio,
      km_fim: km_fim ?? this.km_fim,
      dt_hora_ini: dt_hora_ini ?? this.dt_hora_ini,
      dt_hora_fim: dt_hora_fim ?? this.dt_hora_fim,
      transportador: transportador ?? this.transportador,
      motorista: motorista ?? this.motorista,
      ccusto: ccusto ?? this.ccusto,
      rota_finalizada: rota_finalizada ?? this.rota_finalizada,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data_mov': data_mov,
      'rota_coleta': rota_coleta,
      'rota_nome': rota_nome,
      'km_inicio': km_inicio,
      'km_fim': km_fim,
      'dt_hora_ini': dt_hora_ini,
      'dt_hora_fim': dt_hora_fim,
      'transportador': transportador,
      'motorista': motorista,
      'ccusto': ccusto,
      'rota_finalizada': rota_finalizada,
      'id': id,
    };
  }

  factory ColetasModel.fromMap(Map<String, dynamic> map) {
    return ColetasModel(
      data_mov: map['data_mov'],
      rota_coleta: map['rota_coleta']?.toInt(),
      rota_nome: map['rota_nome'],
      km_inicio: map['km_inicio']?.toInt(),
      km_fim: map['km_fim']?.toInt(),
      dt_hora_ini: map['dt_hora_ini'],
      dt_hora_fim: map['dt_hora_fim'],
      transportador: map['transportador'],
      motorista: map['motorista'],
      ccusto: map['ccusto']?.toInt(),
      rota_finalizada: map['rota_finalizada']?.toInt(),
      id: map['id']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ColetasModel.fromJson(String source) =>
      ColetasModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ColetasModel(data_mov: $data_mov, rota_coleta: $rota_coleta, rota_nome: $rota_nome, km_inicio: $km_inicio, km_fim: $km_fim, dt_hora_ini: $dt_hora_ini, dt_hora_fim: $dt_hora_fim, transportador: $transportador, motorista: $motorista, ccusto: $ccusto, rota_finalizada: $rota_finalizada, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColetasModel &&
        other.data_mov == data_mov &&
        other.rota_coleta == rota_coleta &&
        other.rota_nome == rota_nome &&
        other.km_inicio == km_inicio &&
        other.km_fim == km_fim &&
        other.dt_hora_ini == dt_hora_ini &&
        other.dt_hora_fim == dt_hora_fim &&
        other.transportador == transportador &&
        other.motorista == motorista &&
        other.ccusto == ccusto &&
        other.rota_finalizada == rota_finalizada &&
        other.id == id;
  }

  @override
  int get hashCode {
    return data_mov.hashCode ^
        rota_coleta.hashCode ^
        rota_nome.hashCode ^
        km_inicio.hashCode ^
        km_fim.hashCode ^
        dt_hora_ini.hashCode ^
        dt_hora_fim.hashCode ^
        transportador.hashCode ^
        motorista.hashCode ^
        ccusto.hashCode ^
        rota_finalizada.hashCode ^
        id.hashCode;
  }
}
