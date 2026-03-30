import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter_app/features/converter/domain/entities/conversion_result_entity.dart';
import 'package:currency_converter_app/features/converter/domain/usecases/convert_currency.dart';
import 'package:currency_converter_app/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter_app/features/converter/presentation/bloc/converter_event.dart';
import 'package:currency_converter_app/features/converter/presentation/bloc/converter_state.dart';

class MockConvertCurrency extends Mock implements ConvertCurrency {}

void main() {
  late MockConvertCurrency mockUseCase;

  setUpAll(() {
    registerFallbackValue(const ConversionResultEntity(
      fromCurrency: 'USD',
      toCurrency: 'EUR',
      amount: 0,
      convertedAmount: 0,
      rate: 0,
    ));
  });

  setUp(() {
    mockUseCase = MockConvertCurrency();
  });

  const tEvent = ConvertRequested(from: 'USD', to: 'EUR', amount: 100);

  const tResult = ConversionResultEntity(
    fromCurrency: 'USD',
    toCurrency: 'EUR',
    amount: 100,
    convertedAmount: 91.83,
    rate: 0.9183,
  );

  group('ConverterBloc', () {
    blocTest<ConverterBloc, ConverterState>(
      'emits [ConverterLoading, ConverterLoaded] when conversion succeeds',
      build: () {
        when(
          () => mockUseCase(from: 'USD', to: 'EUR', amount: 100),
        ).thenAnswer((_) async => tResult);
        return ConverterBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<ConverterLoading>(),
        isA<ConverterLoaded>()
            .having((s) => s.result, 'result', tResult),
      ],
    );

    blocTest<ConverterBloc, ConverterState>(
      'emits [ConverterLoading, ConverterError] when conversion throws',
      build: () {
        when(
          () => mockUseCase(from: 'USD', to: 'EUR', amount: 100),
        ).thenThrow(Exception('network error'));
        return ConverterBloc(mockUseCase);
      },
      act: (bloc) => bloc.add(tEvent),
      expect: () => [
        isA<ConverterLoading>(),
        isA<ConverterError>(),
      ],
    );
  });
}
