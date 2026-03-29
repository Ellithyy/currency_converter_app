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
        '/${ApiConstants.apiKey}${ApiConstants.convert}/$from/$to/$amount',
      );

      if (response.data['result'] != 'success') {
        throw const ServerException();
      }

      return ConversionRateModel.fromJson(response.data, amount);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException();
    }
  }
}
