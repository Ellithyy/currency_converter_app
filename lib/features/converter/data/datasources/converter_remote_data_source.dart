import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/conversion_rate_model.dart';

abstract class ConverterRemoteDataSource {
  Future<ConversionRateModel> fetchConversionRate({
    required String from,
    required String to,
    required double amount,
  });
}

class ConverterRemoteDataSourceImpl implements ConverterRemoteDataSource {
  final DioClient dioClient;

  ConverterRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ConversionRateModel> fetchConversionRate({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.latest,
        queryParameters: {'from': from, 'to': to},
      );

      final rates = response.data['rates'] as Map<String, dynamic>;
      if (!rates.containsKey(to)) throw const ServerException();

      final rate = (rates[to] as num).toDouble();

      return ConversionRateModel(
        fromCurrency: from,
        toCurrency: to,
        amount: amount,
        convertedAmount: amount * rate,
        rate: rate,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException();
    }
  }
}
