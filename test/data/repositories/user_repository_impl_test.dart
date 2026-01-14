import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/user_local_data_source.dart';
import 'package:hydrate_or_die/data/models/user_dto.dart';
import 'package:hydrate_or_die/data/repositories/user_repository_impl.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';
import 'package:hydrate_or_die/domain/repositories/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UserLocalDataSource])
void main() {
  late MockUserLocalDataSource mockLocalDataSource;
  late UserRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockUserLocalDataSource();
    repository = UserRepositoryImpl(mockLocalDataSource);
  });

  group('UserRepositoryImpl - getProfile', () {
    final testTimestamp = DateTime.utc(2026, 1, 14, 10, 0, 0);
    final testDto = UserDto(
      userId: 'test-user-123',
      weight: 70.0,
      age: 30,
      genderString: 'male',
      activityLevelString: 'moderate',
      locationPermissionGranted: true,
      dailyGoalLiters: 2.5,
      createdAt: testTimestamp.toIso8601String(),
      updatedAt: testTimestamp.toIso8601String(),
    );

    test('should return null when no profile exists', () async {
      // Arrange
      when(mockLocalDataSource.getUserProfile())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getProfile();

      // Assert
      expect(result, isNull);
      verify(mockLocalDataSource.getUserProfile()).called(1);
    });

    test('should return User entity when profile exists', () async {
      // Arrange
      when(mockLocalDataSource.getUserProfile())
          .thenAnswer((_) async => testDto);

      // Act
      final result = await repository.getProfile();

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals('test-user-123'));
      expect(result.weight, equals(70.0));
      expect(result.age, equals(30));
      expect(result.gender, equals(Gender.male));
      expect(result.activityLevel, equals(ActivityLevel.moderate));
      expect(result.dailyGoal.targetLiters, equals(2.5));
      verify(mockLocalDataSource.getUserProfile()).called(1);
    });

    test('should throw StorageException when data source fails', () async {
      // Arrange
      when(mockLocalDataSource.getUserProfile())
          .thenThrow(DataSourceException('DB error'));

      // Act & Assert
      expect(
        () => repository.getProfile(),
        throwsA(isA<StorageException>()),
      );
    });

    test('should throw StorageException with correct error code', () async {
      // Arrange
      when(mockLocalDataSource.getUserProfile())
          .thenThrow(DataSourceException('DB error'));

      // Act & Assert
      try {
        await repository.getProfile();
        fail('Should have thrown StorageException');
      } catch (e) {
        expect(e, isA<StorageException>());
        final exception = e as StorageException;
        expect(exception.code, equals('GET_PROFILE_FAILED'));
        expect(exception.message, contains('Failed to get user profile'));
      }
    });
  });

  group('UserRepositoryImpl - saveProfile', () {
    final testUser = User(
      id: 'test-user-456',
      weight: 65.0,
      age: 25,
      gender: Gender.female,
      activityLevel: ActivityLevel.veryActive,
      dailyGoal: HydrationGoal(2.3),
    );

    test('should save user profile successfully', () async {
      // Arrange
      when(mockLocalDataSource.saveUserProfile(any))
          .thenAnswer((_) async => {});

      // Act
      await repository.saveProfile(testUser);

      // Assert
      verify(mockLocalDataSource.saveUserProfile(any)).called(1);
    });

    test('should convert entity to DTO correctly', () async {
      // Arrange
      UserDto? capturedDto;
      when(mockLocalDataSource.saveUserProfile(any)).thenAnswer((invocation) {
        capturedDto = invocation.positionalArguments[0] as UserDto;
        return Future.value();
      });

      // Act
      await repository.saveProfile(testUser);

      // Assert
      expect(capturedDto, isNotNull);
      expect(capturedDto!.userId, equals('test-user-456'));
      expect(capturedDto!.weight, equals(65.0));
      expect(capturedDto!.age, equals(25));
      expect(capturedDto!.genderString, equals('female'));
      expect(capturedDto!.activityLevelString, equals('veryActive'));
      expect(capturedDto!.dailyGoalLiters, equals(2.3));
    });

    test('should throw StorageException when save fails', () async {
      // Arrange
      when(mockLocalDataSource.saveUserProfile(any))
          .thenThrow(DataSourceException('Save failed'));

      // Act & Assert
      expect(
        () => repository.saveProfile(testUser),
        throwsA(isA<StorageException>()),
      );
    });

    test('should throw StorageException with correct error code on failure',
        () async {
      // Arrange
      when(mockLocalDataSource.saveUserProfile(any))
          .thenThrow(DataSourceException('Save failed'));

      // Act & Assert
      try {
        await repository.saveProfile(testUser);
        fail('Should have thrown StorageException');
      } catch (e) {
        expect(e, isA<StorageException>());
        final exception = e as StorageException;
        expect(exception.code, equals('SAVE_PROFILE_FAILED'));
        expect(exception.message, contains('Failed to save user profile'));
      }
    });
  });

  group('UserRepositoryImpl - updateProfile', () {
    final testUser = User(
      id: 'test-user-789',
      weight: 72.0,
      age: 35,
      gender: Gender.other,
      activityLevel: ActivityLevel.veryActive,
      dailyGoal: HydrationGoal(3.0),
    );

    test('should update profile successfully when profile exists', () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile()).thenAnswer((_) async => true);
      when(mockLocalDataSource.updateUserProfile(any))
          .thenAnswer((_) async => {});

      // Act
      await repository.updateProfile(testUser);

      // Assert
      verify(mockLocalDataSource.hasUserProfile()).called(1);
      verify(mockLocalDataSource.updateUserProfile(any)).called(1);
    });

    test('should throw ProfileNotFoundException when profile does not exist',
        () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile()).thenAnswer((_) async => false);

      // Act & Assert
      expect(
        () => repository.updateProfile(testUser),
        throwsA(isA<ProfileNotFoundException>()),
      );
      verify(mockLocalDataSource.hasUserProfile()).called(1);
      verifyNever(mockLocalDataSource.updateUserProfile(any));
    });

    test('should convert entity to DTO correctly for update', () async {
      // Arrange
      UserDto? capturedDto;
      when(mockLocalDataSource.hasUserProfile()).thenAnswer((_) async => true);
      when(mockLocalDataSource.updateUserProfile(any))
          .thenAnswer((invocation) {
        capturedDto = invocation.positionalArguments[0] as UserDto;
        return Future.value();
      });

      // Act
      await repository.updateProfile(testUser);

      // Assert
      expect(capturedDto, isNotNull);
      expect(capturedDto!.userId, equals('test-user-789'));
      expect(capturedDto!.weight, equals(72.0));
      expect(capturedDto!.age, equals(35));
      expect(capturedDto!.genderString, equals('other'));
      expect(capturedDto!.activityLevelString, equals('veryActive'));
      expect(capturedDto!.dailyGoalLiters, equals(3.0));
    });

    test('should throw StorageException when update fails', () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile()).thenAnswer((_) async => true);
      when(mockLocalDataSource.updateUserProfile(any))
          .thenThrow(DataSourceException('Update failed'));

      // Act & Assert
      expect(
        () => repository.updateProfile(testUser),
        throwsA(isA<StorageException>()),
      );
    });

    test('should throw StorageException with correct error code on failure',
        () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile()).thenAnswer((_) async => true);
      when(mockLocalDataSource.updateUserProfile(any))
          .thenThrow(DataSourceException('Update failed'));

      // Act & Assert
      try {
        await repository.updateProfile(testUser);
        fail('Should have thrown StorageException');
      } catch (e) {
        expect(e, isA<StorageException>());
        final exception = e as StorageException;
        expect(exception.code, equals('UPDATE_PROFILE_FAILED'));
        expect(exception.message, contains('Failed to update user profile'));
      }
    });

    test('should rethrow ProfileNotFoundException without wrapping', () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile()).thenAnswer((_) async => false);

      // Act & Assert
      try {
        await repository.updateProfile(testUser);
        fail('Should have thrown ProfileNotFoundException');
      } catch (e) {
        expect(e, isA<ProfileNotFoundException>());
        expect(e, isNot(isA<StorageException>()));
      }
    });
  });

  group('UserRepositoryImpl - deleteProfile', () {
    test('should delete profile successfully', () async {
      // Arrange
      when(mockLocalDataSource.deleteUserProfile())
          .thenAnswer((_) async => {});

      // Act
      await repository.deleteProfile();

      // Assert
      verify(mockLocalDataSource.deleteUserProfile()).called(1);
    });

    test('should throw StorageException when delete fails', () async {
      // Arrange
      when(mockLocalDataSource.deleteUserProfile())
          .thenThrow(DataSourceException('Delete failed'));

      // Act & Assert
      expect(
        () => repository.deleteProfile(),
        throwsA(isA<StorageException>()),
      );
    });

    test('should throw StorageException with correct error code on failure',
        () async {
      // Arrange
      when(mockLocalDataSource.deleteUserProfile())
          .thenThrow(DataSourceException('Delete failed'));

      // Act & Assert
      try {
        await repository.deleteProfile();
        fail('Should have thrown StorageException');
      } catch (e) {
        expect(e, isA<StorageException>());
        final exception = e as StorageException;
        expect(exception.code, equals('DELETE_PROFILE_FAILED'));
        expect(exception.message, contains('Failed to delete user profile'));
      }
    });
  });

  group('UserRepositoryImpl - hasProfile', () {
    test('should return true when profile exists', () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile()).thenAnswer((_) async => true);

      // Act
      final result = await repository.hasProfile();

      // Assert
      expect(result, isTrue);
      verify(mockLocalDataSource.hasUserProfile()).called(1);
    });

    test('should return false when profile does not exist', () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile()).thenAnswer((_) async => false);

      // Act
      final result = await repository.hasProfile();

      // Assert
      expect(result, isFalse);
      verify(mockLocalDataSource.hasUserProfile()).called(1);
    });

    test('should throw StorageException when check fails', () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile())
          .thenThrow(DataSourceException('Check failed'));

      // Act & Assert
      expect(
        () => repository.hasProfile(),
        throwsA(isA<StorageException>()),
      );
    });

    test('should throw StorageException with correct error code on failure',
        () async {
      // Arrange
      when(mockLocalDataSource.hasUserProfile())
          .thenThrow(DataSourceException('Check failed'));

      // Act & Assert
      try {
        await repository.hasProfile();
        fail('Should have thrown StorageException');
      } catch (e) {
        expect(e, isA<StorageException>());
        final exception = e as StorageException;
        expect(exception.code, equals('HAS_PROFILE_FAILED'));
        expect(
            exception.message, contains('Failed to check profile existence'));
      }
    });
  });
}
