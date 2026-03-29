import '../entities/conversion_result_entity.dart';

abstract class ConverterRepository {
  Future<ConversionResultEntity> convertCurrency({
    required String from,
    required String to,
    required double amount,
  });
}
