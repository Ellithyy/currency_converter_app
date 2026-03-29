import '../../domain/entities/currency_entity.dart';

abstract class CurrenciesRepository {
  Future<List<CurrencyEntity>> getSupportedCurrencies();
}
