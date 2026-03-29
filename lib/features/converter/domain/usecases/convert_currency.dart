import '../entities/conversion_result_entity.dart';
import '../repositories/converter_repository.dart';

class ConvertCurrency {
  final ConverterRepository repository;

  ConvertCurrency(this.repository);

  Future<ConversionResultEntity> call({
    required String from,
    required String to,
    required double amount,
  }) =>
      repository.convertCurrency(from: from, to: to, amount: amount);
}
