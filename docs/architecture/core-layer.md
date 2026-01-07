# Core Layer (Utilitaires Transverses)

**Partie de:** [Architecture Document](index.md)

---

## Structure

```
lib/core/
├── constants/
│   ├── app_constants.dart      # Business constants
│   ├── asset_paths.dart        # Asset file paths
│   └── notification_constants.dart
├── theme/
│   ├── app_theme.dart          # Material theme
│   ├── app_colors.dart
│   └── app_text_styles.dart
├── utils/
│   ├── date_utils.dart
│   ├── validators.dart
│   ├── formatters.dart
│   └── permission_utils.dart
├── di/
│   └── injection.dart          # get_it setup
├── errors/
│   ├── failures.dart
│   └── exceptions.dart
└── services/
    ├── notification_service.dart
    ├── analytics_service.dart
    └── background_job_service.dart
```

## Dependency Injection Setup (get_it)

```dart
// core/di/injection.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<AvatarLocalDataSource>(
    () => AvatarLocalDataSourceImpl(getIt()),
  );
  // ... autres data sources

  // Repositories
  getIt.registerLazySingleton<AvatarRepository>(
    () => AvatarRepositoryImpl(getIt(), getIt()),
  );
  // ... autres repositories

  // Use Cases
  getIt.registerLazySingleton(() => UpdateAvatarStateUseCase(getIt()));
  getIt.registerLazySingleton(() => RecordHydrationUseCase(getIt()));
  // ... autres use cases

  // Services
  getIt.registerLazySingleton(() => NotificationService());
  getIt.registerLazySingleton(() => AnalyticsService());
}
```

---

[⬅️ Presentation Layer](presentation-layer.md) | [➡️ Data Architecture](data-architecture.md)
