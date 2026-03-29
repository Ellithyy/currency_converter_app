import '../../domain/entities/historical_rate_entity.dart';

abstract class HistoryRepository {
  Future<List<HistoricalRateEntity>> getHistoricalRates();
}
