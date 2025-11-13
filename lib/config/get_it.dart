import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:tiny/repository/repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<DefaultCacheManager>(DefaultCacheManager());
  getIt.registerSingleton<ChatSettingsRepository>(
    ChatSettingsRepository(),
  );
  getIt.registerSingleton<ChatMessageRepository>(
    ChatMessageRepository(),
  );
  getIt.registerSingleton<ChatRepository>(ChatRepository());
  getIt.registerSingleton<ContextDocumentsRepository>(
    ContextDocumentsRepository(),
  );
  getIt.registerSingleton<StorageRepository>(
    StorageRepository(cacheManager: getIt<DefaultCacheManager>()),
  );
}
