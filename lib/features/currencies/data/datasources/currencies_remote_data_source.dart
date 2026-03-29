import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/currency_model.dart';

abstract class CurrenciesRemoteDataSource {
  Future<List<CurrencyModel>> fetchCurrencies();
}

class CurrenciesRemoteDataSourceImpl implements CurrenciesRemoteDataSource {
  final DioClient dioClient;

  CurrenciesRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<CurrencyModel>> fetchCurrencies() async {
    try {
      final response = await dioClient.dio.get(
        '/${ApiConstants.apiKey}${ApiConstants.latest}/${ApiConstants.baseCurrency}',
      );

      if (response.data['result'] != 'success') {
        throw const ServerException();
      }

      final Map<String, dynamic> rates =
          response.data['conversion_rates'] as Map<String, dynamic>;

      return rates.keys
          .map((code) => CurrencyModel(code: code, name: code))
          .toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException();
    }
  }
}
