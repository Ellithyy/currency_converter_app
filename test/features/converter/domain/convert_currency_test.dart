import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter_app/features/converter/domain/entities/conversion_result_entity.dart';
import 'package:currency_converter_app/features/converter/domain/repositories/converter_repository.dart';
import 'package:currency_converter_app/features/converter/domain/usecases/convert_currency.dart';

class MockConverterRepository extends Mock implements ConverterRepository {}

void main() {
  late MockConverterRepository mockRepository;
  late ConvertCurrency useCase;

  setUp(() {
    mockRepository = MockConverterRepository();
    useCase = ConvertCurrency(mockRepository);
  });

  const tResult = ConversionResultEntity(
    fromCurrency: 'USD',
    toCurrency: 'EUR',
    amount: 100,
    convertedAmount: 91.83,
    rate: 0.9183,
  );

  group('ConvertCurrency', () {
    test('returns the result from the repository', () async {
      when(
        () => mockRepository.convertCurrency(
          from: 'USD',
          to: 'EUR',
          amount: 100,
        ),
      ).thenAnswer((_) async => tResult);

      final result = await useCase(from: 'USD', to: 'EUR', amount: 100);

      expect(result, tResult);
      verify(
        () => mockRepository.convertCurrency(
          from: 'USD',
          to: 'EUR',
          amount: 100,
        ),
      ).called(1);
    });
  });
}
