import '../../domain/entities/conversion_result_entity.dart';

class ConversionRateModel extends ConversionResultEntity {
  const ConversionRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.amount,
    required super.convertedAmount,
    required super.rate,
  });

  factory ConversionRateModel.fromJson(
    Map<String, dynamic> json,
    double amount,
  ) {
    return ConversionRateModel(
      fromCurrency: json['base_code'] as String,
      toCurrency: json['target_code'] as String,
      amount: amount,
      convertedAmount: (json['conversion_result'] as num).toDouble(),
      rate: (json['conversion_rate'] as num).toDouble(),
    );
  }
}
