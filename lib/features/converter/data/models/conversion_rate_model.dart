import '../../domain/entities/conversion_result_entity.dart';

class ConversionRateModel extends ConversionResultEntity {
  const ConversionRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.amount,
    required super.convertedAmount,
    required super.rate,
  });
}
