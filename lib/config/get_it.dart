import 'package:get_it/get_it.dart';
import 'package:tiny/repository/repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<ChatSettingsRepository>(
    ChatSettingsRepository(),
  );
  getIt.registerSingleton<CacheRepository>(
    CacheRepository(),
  );
  getIt.registerSingleton<ChatMessageRepository>(
    ChatMessageRepository(),
  );
  getIt.registerSingleton<ChatRepository>(ChatRepository());
  getIt.registerSingleton<DocumentMetadataRepository>(
    DocumentMetadataRepository(),
  );
  getIt.registerSingleton<StorageRepository>(
    StorageRepository(
      cacheRepository: getIt<CacheRepository>(),
      documentMetadataRepository:
          getIt<DocumentMetadataRepository>(),
    ),
  );
}
