import '../../domain/entities/historical_rate_entity.dart';

class HistoricalRateModel extends HistoricalRateEntity {
  const HistoricalRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.rate,
    required super.date,
  });
}
