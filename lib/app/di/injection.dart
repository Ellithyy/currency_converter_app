import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';
import '../../core/database/app_database.dart';
import '../../features/currencies/data/datasources/currencies_remote_data_source.dart';
import '../../features/currencies/data/datasources/currencies_local_data_source.dart';
import '../../features/currencies/data/repositories/currencies_repository_impl.dart';
import '../../features/currencies/domain/repositories/currencies_repository.dart';
import '../../features/currencies/domain/usecases/get_supported_currencies.dart';
import '../../features/currencies/presentation/bloc/currencies_bloc.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  sl.registerLazySingleton<CurrenciesRemoteDataSource>(
    () => CurrenciesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CurrenciesLocalDataSource>(
    () => CurrenciesLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<CurrenciesRepository>(
    () => CurrenciesRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetSupportedCurrencies(sl()));

  sl.registerFactory(() => CurrenciesBloc(sl()));
}
