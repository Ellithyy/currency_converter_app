import '../../domain/entities/conversion_result_entity.dart';
import '../../domain/repositories/converter_repository.dart';
import '../datasources/converter_remote_data_source.dart';

class ConverterRepositoryImpl implements ConverterRepository {
  final ConverterRemoteDataSource remoteDataSource;

  ConverterRepositoryImpl(this.remoteDataSource);

  @override
  Future<ConversionResultEntity> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) {
    return remoteDataSource.fetchConversionRate(
      from: from,
      to: to,
      amount: amount,
    );
  }
}
