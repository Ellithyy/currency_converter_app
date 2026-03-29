import '../entities/historical_rate_entity.dart';
import '../repositories/history_repository.dart';

class GetHistoricalRates {
  final HistoryRepository repository;

  GetHistoricalRates(this.repository);

  Future<List<HistoricalRateEntity>> call() => repository.getHistoricalRates();
}
