import '../entities/currency_entity.dart';
import '../repositories/currencies_repository.dart';

class GetSupportedCurrencies {
  final CurrenciesRepository repository;

  GetSupportedCurrencies(this.repository);

  Future<List<CurrencyEntity>> call() => repository.getSupportedCurrencies();
}
