import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/historical_rate_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoricalRateModel>> fetchHistoricalRates();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final DioClient dioClient;

  HistoryRemoteDataSourceImpl(this.dioClient);

  // EGP is not available in Frankfurter (ECB data). Using EUR + GBP.
  static const _targets = ['EUR', 'GBP'];

  @override
  Future<List<HistoricalRateModel>> fetchHistoricalRates() async {
    try {
      final end = DateTime.now().subtract(const Duration(days: 1));
      final start = end.subtract(const Duration(days: 6));

      // One request: GET /{start}..{end}?from=USD&to=EUR,GBP
      final response = await dioClient.dio.get(
        '/${_fmt(start)}..${ _fmt(end)}',
        queryParameters: {'from': 'USD', 'to': _targets.join(',')},
      );

      final ratesMap = response.data['rates'] as Map<String, dynamic>;
      final result = <HistoricalRateModel>[];

      for (final entry in ratesMap.entries) {
        final date = DateTime.parse(entry.key);
        final dayRates = entry.value as Map<String, dynamic>;

        for (final target in _targets) {
          if (dayRates.containsKey(target)) {
            result.add(HistoricalRateModel(
              fromCurrency: 'USD',
              toCurrency: target,
              rate: (dayRates[target] as num).toDouble(),
              date: date,
            ));
          }
        }
      }

      return result;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException();
    }
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
