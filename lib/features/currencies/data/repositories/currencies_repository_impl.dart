import '../../domain/entities/currency_entity.dart';
import '../../domain/repositories/currencies_repository.dart';
import '../datasources/currencies_local_data_source.dart';
import '../datasources/currencies_remote_data_source.dart';

class CurrenciesRepositoryImpl implements CurrenciesRepository {
  final CurrenciesRemoteDataSource remoteDataSource;
  final CurrenciesLocalDataSource localDataSource;

  CurrenciesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CurrencyEntity>> getSupportedCurrencies() async {
    if (await localDataSource.hasCurrencies()) {
      final cached = await localDataSource.getCachedCurrencies();
      return cached.map((m) => m.toEntity()).toList();
    }

    final remote = await remoteDataSource.fetchCurrencies();
    await localDataSource.cacheCurrencies(remote);
    return remote.map((m) => m.toEntity()).toList();
  }
}
