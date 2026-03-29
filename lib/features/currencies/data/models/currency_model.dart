import '../../domain/entities/currency_entity.dart';

class CurrencyModel extends CurrencyEntity {
  const CurrencyModel({required super.code, required super.name});

  factory CurrencyModel.fromMap(Map<String, dynamic> map) {
    return CurrencyModel(
      code: map['code'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {'code': code, 'name': name};

  CurrencyEntity toEntity() => CurrencyEntity(code: code, name: name);
}
