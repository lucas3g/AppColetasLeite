import 'dart:convert';

class LicencaModel {
  String? id;

  LicencaModel({
    this.id,
  });

  LicencaModel copyWith({
    String? id,
  }) {
    return LicencaModel(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory LicencaModel.fromMap(Map<String, dynamic> map) {
    return LicencaModel(
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LicencaModel.fromJson(String source) =>
      LicencaModel.fromMap(json.decode(source));

  @override
  String toString() => 'LicencaModel(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LicencaModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
