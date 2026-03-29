import '../../domain/entities/historical_rate_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HistoricalRateEntity>> getHistoricalRates() {
    return remoteDataSource.fetchHistoricalRates();
  }
}
