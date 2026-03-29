import '../../domain/entities/historical_rate_entity.dart';

class HistoricalRateModel extends HistoricalRateEntity {
  const HistoricalRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.rate,
    required super.date,
  });

  factory HistoricalRateModel.fromJson({
    required Map<String, dynamic> json,
    required String targetCurrency,
  }) {
    final rates = json['conversion_rates'] as Map<String, dynamic>;
    return HistoricalRateModel(
      fromCurrency: json['base_code'] as String,
      toCurrency: targetCurrency,
      rate: (rates[targetCurrency] as num).toDouble(),
      date: DateTime(
        json['year'] as int,
        json['month'] as int,
        json['day'] as int,
      ),
    );
  }
}
