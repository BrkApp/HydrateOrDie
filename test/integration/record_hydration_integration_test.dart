import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/database_helper.dart';
import 'package:hydrate_or_die/data/data_sources/local/hydration_log_local_data_source.dart';
import 'package:hydrate_or_die/data/repositories/hydration_log_repository_impl.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/glass_size.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';
import 'package:hydrate_or_die/domain/repositories/hydration_log_repository.dart';
import 'package:hydrate_or_die/domain/use_cases/hydration/record_hydration_use_case.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../domain/use_cases/hydration/record_hydration_use_case_test.mocks.dart';

/// Test d'intégration end-to-end pour RecordHydrationUseCase
///
/// Valide le flow complet avec persistence réelle SQLite (AC9):
/// - HydrationLogRepository avec SQLite réel
/// - Mocks légers pour AvatarRepository, UserRepository, UpdateAvatarStateUseCase
///
/// Story 3.6 - Record Hydration - AC9
void main() {
  late DatabaseHelper databaseHelper;
  late HydrationLogRepository hydrationLogRepository;
  late MockAvatarRepository mockAvatarRepository;
  late MockUserRepository mockUserRepository;
  late MockUpdateAvatarStateUseCase mockUpdateAvatarStateUseCase;
  late RecordHydrationUseCase recordHydrationUseCase;

  setUpAll(() {
    // Initialize FFI for desktop/unit testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Initialize in-memory database for testing
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create fresh database for each test
    databaseHelper = DatabaseHelper();
    await databaseHelper.deleteDatabase(); // Clean slate

    // Real persistence for HydrationLog (SQLite)
    final hydrationLogDataSource = HydrationLogLocalDataSourceImpl(
      databaseHelper,
    );
    hydrationLogRepository = HydrationLogRepositoryImpl(hydrationLogDataSource);

    // Mock avatar and user repositories
    mockAvatarRepository = MockAvatarRepository();
    mockUserRepository = MockUserRepository();
    mockUpdateAvatarStateUseCase = MockUpdateAvatarStateUseCase();

    recordHydrationUseCase = RecordHydrationUseCase(
      hydrationLogRepository,
      mockAvatarRepository,
      mockUserRepository,
      mockUpdateAvatarStateUseCase,
    );
  });

  tearDown(() async {
    // Clean up after each test
    await databaseHelper.close();
    await databaseHelper.deleteDatabase();
  });

  group('RecordHydrationUseCase - Integration Tests (AC9)', () {
    final testUser = User(
      id: 'integration-test-user',
      weight: 70.0,
      age: 30,
      gender: Gender.male,
      activityLevel: ActivityLevel.moderate,
      dailyGoal: HydrationGoal(2.5),
    );

    test('AC9: Flow end-to-end avec persistence réelle SQLite', () async {
      // ========================================
      // ARRANGE: Setup mocks
      // ========================================

      when(
        mockAvatarRepository.updateLastDrinkTime(any),
      ).thenAnswer((_) async {});
      when(
        mockUpdateAvatarStateUseCase.execute(),
      ).thenAnswer((_) async => AvatarState.fresh);
      when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

      // ========================================
      // ACT: Enregistrer une hydratation
      // ========================================

      const testPhotoPath = '/test/photo/path.jpg';
      const testGlassSize = GlassSize.medium;

      final result = await recordHydrationUseCase(
        photoPath: testPhotoPath,
        glassSize: testGlassSize,
      );

      // ========================================
      // ASSERT 1: Vérifier le résultat retourné
      // ========================================

      expect(result.log.photoPath, testPhotoPath);
      expect(result.log.glassSize, testGlassSize);
      expect(result.log.validated, true);
      expect(result.log.id.isNotEmpty, true);

      expect(result.totalVolumeToday, testGlassSize.volumeLiters); // 0.25L
      expect(result.dailyGoalLiters, 2.5);
      expect(result.progressPercentage, 0.25 / 2.5); // 10% (0.1) = 0.25L / 2.5L

      // Avatar doit être fresh (mock)
      expect(result.avatarState, AvatarState.fresh);

      // ========================================
      // ASSERT 2: Vérifier persistence SQLite réelle
      // ========================================

      // Vérifier que le log est bien persisté dans SQLite
      final logsToday = await hydrationLogRepository.getTodayLogs();
      expect(logsToday.length, 1);
      expect(logsToday.first.id, result.log.id);
      expect(logsToday.first.glassSize, testGlassSize);
      expect(logsToday.first.photoPath, testPhotoPath);

      // Vérifier que le volume total est correct (lecture depuis SQLite)
      final totalVolume = await hydrationLogRepository.getTotalVolumeForDate(
        DateTime.now(),
      );
      expect(totalVolume, testGlassSize.volumeLiters);

      // ========================================
      // ASSERT 3: Ajouter un 2ème log et vérifier progression
      // ========================================

      final result2 = await recordHydrationUseCase(
        photoPath: '/test/photo/path2.jpg',
        glassSize: GlassSize.large, // 0.4L
      );

      // Volume total = 0.25L + 0.4L = 0.65L
      expect(result2.totalVolumeToday, 0.65);
      // Progression = 0.65 / 2.5 = 26% (0.26)
      expect(result2.progressPercentage, closeTo(0.26, 0.01));

      // Vérifier persistence SQLite
      final logsAfterSecond = await hydrationLogRepository.getTodayLogs();
      expect(logsAfterSecond.length, 2);

      // ========================================
      // ASSERT 4: Atteindre 100% et vérifier plafonnement
      // ========================================

      // Ajouter des logs pour dépasser l'objectif
      // Total actuel: 0.65L
      // Objectif: 2.5L
      // Reste à boire: 1.85L
      // Boire 5 grands verres (5 × 0.4L = 2.0L) → Total = 2.65L > 2.5L

      for (int i = 0; i < 5; i++) {
        await recordHydrationUseCase(
          photoPath: '/test/photo/path${i + 3}.jpg',
          glassSize: GlassSize.large,
        );
      }

      final finalResult = await recordHydrationUseCase(
        photoPath: '/test/photo/final.jpg',
        glassSize: GlassSize.small,
      );

      // Volume total doit être > 2.5L (objectif dépassé)
      expect(finalResult.totalVolumeToday, greaterThan(2.5));

      // Progression plafonnée à 100% (1.0)
      expect(finalResult.progressPercentage, 1.0);
      expect(finalResult.isGoalAchieved, true);

      // ========================================
      // VERIFY: Tous les logs sont persistés dans SQLite
      // ========================================

      final allLogs = await hydrationLogRepository.getTodayLogs();
      expect(allLogs.length, 8); // 2 initiaux + 5 boucle + 1 final

      // Vérifier que chaque log est récupérable depuis SQLite
      for (final log in allLogs) {
        expect(log.id.isNotEmpty, true);
        expect(log.validated, true);
        expect(log.glassSize, isNotNull);
      }
    });

    test('Integration: Multiple logs sur plusieurs jours (SQLite)', () async {
      // Setup mocks
      when(
        mockAvatarRepository.updateLastDrinkTime(any),
      ).thenAnswer((_) async {});
      when(
        mockUpdateAvatarStateUseCase.execute(),
      ).thenAnswer((_) async => AvatarState.fresh);
      when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

      // Enregistrer un log aujourd'hui
      final resultToday = await recordHydrationUseCase(
        photoPath: '/test/today.jpg',
        glassSize: GlassSize.large,
      );

      expect(resultToday.totalVolumeToday, 0.4);

      // Vérifier que getTotalVolumeForDate retourne 0 pour hier
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final volumeYesterday = await hydrationLogRepository
          .getTotalVolumeForDate(yesterday);
      expect(volumeYesterday, 0.0);

      // Vérifier logs aujourd'hui seulement dans SQLite
      final logsToday = await hydrationLogRepository.getTodayLogs();
      expect(logsToday.length, 1);
      expect(logsToday.first.glassSize, GlassSize.large);
    });

    test('Integration: Vérifier séquence des appels aux dépendances', () async {
      // Setup mocks
      final callOrder = <String>[];

      when(mockAvatarRepository.updateLastDrinkTime(any)).thenAnswer((_) async {
        callOrder.add('updateLastDrinkTime');
      });
      when(mockUpdateAvatarStateUseCase.execute()).thenAnswer((_) async {
        callOrder.add('recalculateState');
        return AvatarState.fresh;
      });
      when(mockUserRepository.getProfile()).thenAnswer((_) async {
        callOrder.add('getProfile');
        return testUser;
      });

      // Act
      await recordHydrationUseCase(
        photoPath: '/test/photo.jpg',
        glassSize: GlassSize.medium,
      );

      // Assert - Vérifier l'ordre d'exécution
      expect(callOrder, [
        'updateLastDrinkTime',
        'recalculateState',
        // getTotalVolumeForDate (SQLite) appelé mais pas tracé
        'getProfile',
      ]);

      // Vérifier que le log a bien été sauvegardé dans SQLite
      final logs = await hydrationLogRepository.getTodayLogs();
      expect(logs.length, 1);
    });

    test(
      'Integration: Throw exception si profil utilisateur manquant',
      () async {
        // Setup mocks
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () async => await recordHydrationUseCase(
            photoPath: '/test/photo.jpg',
            glassSize: GlassSize.medium,
          ),
          throwsA(
            isA<RecordHydrationException>().having(
              (e) => e.message,
              'message',
              contains('Profil utilisateur introuvable'),
            ),
          ),
        );
      },
    );
  });
}
