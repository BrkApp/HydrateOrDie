import 'package:get_it/get_it.dart';

import '../../data/data_sources/local/avatar_local_data_source.dart';
import '../../data/data_sources/local/database_helper.dart';
import '../../data/repositories/avatar_repository_impl.dart';
import '../../domain/repositories/avatar_repository.dart';
import '../../presentation/providers/avatar_asset_provider.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Setup dependency injection for the app
///
/// Call this in main() before runApp().
/// Registers all dependencies in correct order:
/// 1. Data sources (DatabaseHelper)
/// 2. Local data sources (AvatarLocalDataSource)
/// 3. Repositories (AvatarRepository)
/// 4. Use cases (future stories)
Future<void> setupDependencies() async {
  // ========================================
  // DATA SOURCES
  // ========================================

  // DatabaseHelper - Singleton
  getIt.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper(),
  );

  // AvatarLocalDataSource - Singleton
  getIt.registerLazySingleton<AvatarLocalDataSource>(
    () => AvatarLocalDataSourceImpl(getIt<DatabaseHelper>()),
  );

  // ========================================
  // REPOSITORIES
  // ========================================

  // AvatarRepository - Singleton
  getIt.registerLazySingleton<AvatarRepository>(
    () => AvatarRepositoryImpl(getIt<AvatarLocalDataSource>()),
  );

  // ========================================
  // USE CASES (Future stories)
  // ========================================

  // Use cases will be registered here in future stories

  // ========================================
  // PROVIDERS (Presentation Layer)
  // ========================================

  // AvatarAssetProvider - Singleton
  getIt.registerLazySingleton<AvatarAssetProvider>(
    () => AvatarAssetProvider(),
  );
}

/// Reset all dependencies (for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
