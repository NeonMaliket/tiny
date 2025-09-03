import 'package:get_it/get_it.dart';
import 'package:tiny/repository/repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<CacheRepository>(CacheRepository());
  getIt.registerSingleton<StorageRepository>(
    StorageRepository(cacheRepository: getIt<CacheRepository>()),
  );
}
