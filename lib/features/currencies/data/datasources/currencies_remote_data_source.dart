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
      final response = await dioClient.dio.get(ApiConstants.currencies);

      final Map<String, dynamic> data = response.data as Map<String, dynamic>;

      return data.entries
          .map((e) => CurrencyModel(code: e.key, name: e.value as String))
          .toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException();
    }
  }
}
