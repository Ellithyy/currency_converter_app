import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
}
