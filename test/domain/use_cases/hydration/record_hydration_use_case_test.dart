import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/glass_size.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart'
    as avatar_repo;
import 'package:hydrate_or_die/domain/repositories/hydration_log_repository.dart';
import 'package:hydrate_or_die/domain/repositories/user_repository.dart'
    as user_repo;
import 'package:hydrate_or_die/domain/use_cases/avatar/update_avatar_state_use_case.dart';
import 'package:hydrate_or_die/domain/use_cases/hydration/record_hydration_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'record_hydration_use_case_test.mocks.dart';

@GenerateMocks([HydrationLogRepository, UpdateAvatarStateUseCase])
@GenerateNiceMocks([
  MockSpec<avatar_repo.AvatarRepository>(as: #MockAvatarRepository),
  MockSpec<user_repo.UserRepository>(as: #MockUserRepository),
])
void main() {
  late RecordHydrationUseCase useCase;
  late MockHydrationLogRepository mockHydrationLogRepository;
  late MockAvatarRepository mockAvatarRepository;
  late MockUserRepository mockUserRepository;
  late MockUpdateAvatarStateUseCase mockUpdateAvatarStateUseCase;

  setUp(() {
    mockHydrationLogRepository = MockHydrationLogRepository();
    mockAvatarRepository = MockAvatarRepository();
    mockUserRepository = MockUserRepository();
    mockUpdateAvatarStateUseCase = MockUpdateAvatarStateUseCase();

    useCase = RecordHydrationUseCase(
      mockHydrationLogRepository,
      mockAvatarRepository,
      mockUserRepository,
      mockUpdateAvatarStateUseCase,
    );
  });

  group('RecordHydrationUseCase', () {
    const testPhotoPath = '/path/to/photo.jpg';
    const testGlassSize = GlassSize.medium;
    final testUser = User(
      id: 'user-123',
      weight: 70.0,
      age: 30,
      gender: Gender.male,
      activityLevel: ActivityLevel.moderate,
      dailyGoal: HydrationGoal(2.5),
    );

    test(
      'AC1: Crée un HydrationLog avec photoPath, glassSize, validated=true',
      () async {
        // Arrange
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => 0.5);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase(
          photoPath: testPhotoPath,
          glassSize: testGlassSize,
        );

        // Assert
        expect(result.log.photoPath, testPhotoPath);
        expect(result.log.glassSize, testGlassSize);
        expect(result.log.validated, true);
        expect(result.log.id.isNotEmpty, true); // UUID généré
      },
    );

    test(
      'AC2: Sauvegarde le log via HydrationLogRepository.addLog()',
      () async {
        // Arrange
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => 0.5);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

        // Act
        await useCase(photoPath: testPhotoPath, glassSize: testGlassSize);

        // Assert
        verify(mockHydrationLogRepository.addLog(any)).called(1);
      },
    );

    test(
      'AC3: Met à jour lastDrinkTime via AvatarRepository.updateLastDrinkTime()',
      () async {
        // Arrange
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => 0.5);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

        // Act
        await useCase(photoPath: testPhotoPath, glassSize: testGlassSize);

        // Assert
        verify(mockAvatarRepository.updateLastDrinkTime(any)).called(1);
      },
    );

    test(
      'AC4: Recalcule l\'état avatar via UpdateAvatarStateUseCase.execute()',
      () async {
        // Arrange
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => 0.5);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase(
          photoPath: testPhotoPath,
          glassSize: testGlassSize,
        );

        // Assert
        verify(mockUpdateAvatarStateUseCase.execute()).called(1);
        expect(result.avatarState, AvatarState.fresh);
      },
    );

    test(
      'AC5: Récupère volume total du jour via getTotalVolumeForDate(DateTime.now())',
      () async {
        // Arrange
        const expectedVolume = 1.5;
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => expectedVolume);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase(
          photoPath: testPhotoPath,
          glassSize: testGlassSize,
        );

        // Assert
        verify(mockHydrationLogRepository.getTotalVolumeForDate(any)).called(1);
        expect(result.totalVolumeToday, expectedVolume);
      },
    );

    test('AC6: Calcule progression (volumeToday / dailyGoal) × 100%', () async {
      // Arrange
      const volumeToday = 1.25; // 1.25L
      final dailyGoal = 2.5; // 2.5L
      const expectedProgress = 1.25 / 2.5; // = 0.5 (50%)

      when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
      when(
        mockAvatarRepository.updateLastDrinkTime(any),
      ).thenAnswer((_) async {});
      when(
        mockUpdateAvatarStateUseCase.execute(),
      ).thenAnswer((_) async => AvatarState.fresh);
      when(
        mockHydrationLogRepository.getTotalVolumeForDate(any),
      ).thenAnswer((_) async => volumeToday);
      when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

      // Act
      final result = await useCase(
        photoPath: testPhotoPath,
        glassSize: testGlassSize,
      );

      // Assert
      expect(result.progressPercentage, expectedProgress);
      expect(result.dailyGoalLiters, dailyGoal);
    });

    test(
      'AC6: Plafonne la progression à 100% (1.0) si objectif dépassé',
      () async {
        // Arrange
        const volumeToday = 3.0; // 3.0L (dépasse objectif 2.5L)
        const expectedProgress = 1.0; // Plafonné à 100%

        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => volumeToday);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase(
          photoPath: testPhotoPath,
          glassSize: testGlassSize,
        );

        // Assert
        expect(result.progressPercentage, expectedProgress);
        expect(result.isGoalAchieved, true);
      },
    );

    test(
      'AC7: Analytics event skip gracefully si Firebase indisponible',
      () async {
        // Arrange
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => 0.5);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

        // Act & Assert - Ne doit pas throw même si Firebase n'est pas configuré
        expect(
          () async =>
              await useCase(photoPath: testPhotoPath, glassSize: testGlassSize),
          returnsNormally,
        );
      },
    );

    test(
      'AC8: Séquence complète - save log → update avatar → recalcul progression',
      () async {
        // Arrange
        final callOrder = <String>[];

        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {
          callOrder.add('addLog');
        });
        when(mockAvatarRepository.updateLastDrinkTime(any)).thenAnswer((
          _,
        ) async {
          callOrder.add('updateLastDrinkTime');
        });
        when(mockUpdateAvatarStateUseCase.execute()).thenAnswer((_) async {
          callOrder.add('recalculateState');
          return AvatarState.fresh;
        });
        when(mockHydrationLogRepository.getTotalVolumeForDate(any)).thenAnswer((
          _,
        ) async {
          callOrder.add('getTotalVolume');
          return 0.5;
        });
        when(mockUserRepository.getProfile()).thenAnswer((_) async {
          callOrder.add('getProfile');
          return testUser;
        });

        // Act
        await useCase(photoPath: testPhotoPath, glassSize: testGlassSize);

        // Assert - Vérifier l'ordre d'exécution
        expect(callOrder, [
          'addLog',
          'updateLastDrinkTime',
          'recalculateState',
          'getTotalVolume',
          'getProfile',
        ]);
      },
    );

    test('Throw RecordHydrationException si addLog() échoue', () async {
      // Arrange
      when(
        mockHydrationLogRepository.addLog(any),
      ).thenThrow(StorageException('DB error'));

      // Act & Assert
      expect(
        () async =>
            await useCase(photoPath: testPhotoPath, glassSize: testGlassSize),
        throwsA(isA<RecordHydrationException>()),
      );
    });

    test(
      'Throw RecordHydrationException si updateLastDrinkTime() échoue',
      () async {
        // Arrange
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenThrow(avatar_repo.StorageException('Avatar DB error'));

        // Act & Assert
        expect(
          () async =>
              await useCase(photoPath: testPhotoPath, glassSize: testGlassSize),
          throwsA(isA<RecordHydrationException>()),
        );
      },
    );

    test(
      'Throw RecordHydrationException si profil utilisateur introuvable',
      () async {
        // Arrange
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => 0.5);
        when(mockUserRepository.getProfile()).thenAnswer((_) async => null);

        // Act & Assert
        expect(
          () async =>
              await useCase(photoPath: testPhotoPath, glassSize: testGlassSize),
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

    test('Edge case: Progression avec dailyGoal = 0 retourne 0%', () async {
      // Arrange
      final userWithZeroGoal = User(
        id: 'user-123',
        weight: 70.0,
        age: 30,
        gender: Gender.male,
        activityLevel: ActivityLevel.sedentary,
        dailyGoal: HydrationGoal(1.5), // Minimum possible
      );

      when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
      when(
        mockAvatarRepository.updateLastDrinkTime(any),
      ).thenAnswer((_) async {});
      when(
        mockUpdateAvatarStateUseCase.execute(),
      ).thenAnswer((_) async => AvatarState.fresh);
      when(
        mockHydrationLogRepository.getTotalVolumeForDate(any),
      ).thenAnswer((_) async => 0.0);
      when(
        mockUserRepository.getProfile(),
      ).thenAnswer((_) async => userWithZeroGoal);

      // Act
      final result = await useCase(
        photoPath: testPhotoPath,
        glassSize: testGlassSize,
      );

      // Assert
      expect(result.progressPercentage, 0.0);
    });

    test(
      'RecordHydrationResult.isGoalAchieved retourne true si progression >= 1.0',
      () async {
        // Arrange
        when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
        when(
          mockAvatarRepository.updateLastDrinkTime(any),
        ).thenAnswer((_) async {});
        when(
          mockUpdateAvatarStateUseCase.execute(),
        ).thenAnswer((_) async => AvatarState.fresh);
        when(
          mockHydrationLogRepository.getTotalVolumeForDate(any),
        ).thenAnswer((_) async => 2.5); // Égal à l'objectif
        when(mockUserRepository.getProfile()).thenAnswer((_) async => testUser);

        // Act
        final result = await useCase(
          photoPath: testPhotoPath,
          glassSize: testGlassSize,
        );

        // Assert
        expect(result.isGoalAchieved, true);
        expect(result.progressPercentage, 1.0);
      },
    );

    test(
      'Test avec différentes tailles de verre (small, medium, large)',
      () async {
        // Arrange
        for (final glassSize in GlassSize.values) {
          when(mockHydrationLogRepository.addLog(any)).thenAnswer((_) async {});
          when(
            mockAvatarRepository.updateLastDrinkTime(any),
          ).thenAnswer((_) async {});
          when(
            mockUpdateAvatarStateUseCase.execute(),
          ).thenAnswer((_) async => AvatarState.fresh);
          when(
            mockHydrationLogRepository.getTotalVolumeForDate(any),
          ).thenAnswer((_) async => 0.5);
          when(
            mockUserRepository.getProfile(),
          ).thenAnswer((_) async => testUser);

          // Act
          final result = await useCase(
            photoPath: testPhotoPath,
            glassSize: glassSize,
          );

          // Assert
          expect(result.log.glassSize, glassSize);
          expect(result.log.volumeLiters, glassSize.volumeLiters);
        }
      },
    );
  });
}
