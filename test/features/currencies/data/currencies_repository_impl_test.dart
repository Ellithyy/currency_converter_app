import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:currency_converter_app/features/currencies/data/datasources/currencies_local_data_source.dart';
import 'package:currency_converter_app/features/currencies/data/datasources/currencies_remote_data_source.dart';
import 'package:currency_converter_app/features/currencies/data/models/currency_model.dart';
import 'package:currency_converter_app/features/currencies/data/repositories/currencies_repository_impl.dart';
import 'package:currency_converter_app/features/currencies/domain/entities/currency_entity.dart';

class MockRemoteDataSource extends Mock implements CurrenciesRemoteDataSource {}

class MockLocalDataSource extends Mock implements CurrenciesLocalDataSource {}

void main() {
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late CurrenciesRepositoryImpl repository;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = CurrenciesRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  final tModels = [
    const CurrencyModel(code: 'USD', name: 'US Dollar'),
    const CurrencyModel(code: 'EUR', name: 'Euro'),
  ];

  final tEntities = tModels.map((m) => m.toEntity()).toList();

  group('CurrenciesRepositoryImpl.getSupportedCurrencies', () {
    test('returns cached currencies when local data exists', () async {
      when(() => mockLocal.hasCurrencies()).thenAnswer((_) async => true);
      when(() => mockLocal.getCachedCurrencies())
          .thenAnswer((_) async => tModels);

      final result = await repository.getSupportedCurrencies();

      expect(result, tEntities);
      verifyNever(() => mockRemote.fetchCurrencies());
    });

    test('fetches from remote and caches when local data is empty', () async {
      when(() => mockLocal.hasCurrencies()).thenAnswer((_) async => false);
      when(() => mockRemote.fetchCurrencies())
          .thenAnswer((_) async => tModels);
      when(() => mockLocal.cacheCurrencies(tModels))
          .thenAnswer((_) async {});

      final result = await repository.getSupportedCurrencies();

      expect(result, tEntities);
      verify(() => mockRemote.fetchCurrencies()).called(1);
      verify(() => mockLocal.cacheCurrencies(tModels)).called(1);
    });
  });
}
