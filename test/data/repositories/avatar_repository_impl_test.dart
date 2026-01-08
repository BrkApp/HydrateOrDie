import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/avatar_local_data_source.dart';
import 'package:hydrate_or_die/data/models/avatar_dto.dart';
import 'package:hydrate_or_die/data/repositories/avatar_repository_impl.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'avatar_repository_impl_test.mocks.dart';

@GenerateMocks([AvatarLocalDataSource])
void main() {
  late MockAvatarLocalDataSource mockLocalDataSource;
  late AvatarRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockAvatarLocalDataSource();
    repository = AvatarRepositoryImpl(mockLocalDataSource);
  });

  group('AvatarRepositoryImpl - getAvatar', () {
    final testTimestamp = DateTime.utc(2026, 1, 8, 10, 0, 0);
    final testDto = AvatarDto(
      id: 'avatar_singleton',
      name: 'Coach Sportif',
      personalityString: 'sportsCoach',
      currentStateString: 'fresh',
      lastDrinkTime: testTimestamp.toIso8601String(),
      lastUpdated: testTimestamp.toIso8601String(),
    );

    test('should return null when no avatar selected', () async {
      // Arrange
      when(mockLocalDataSource.getSelectedAvatarId())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getAvatar();

      // Assert
      expect(result, isNull);
      verify(mockLocalDataSource.getSelectedAvatarId()).called(1);
      verifyNever(mockLocalDataSource.getAvatarState());
    });

    test('should return avatar when ID and state exist', () async {
      // Arrange
      when(mockLocalDataSource.getSelectedAvatarId())
          .thenAnswer((_) async => 'sportsCoach');
      when(mockLocalDataSource.getAvatarState())
          .thenAnswer((_) async => testDto);

      // Act
      final result = await repository.getAvatar();

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals('avatar_singleton'));
      expect(result.name, equals('Coach Sportif'));
      expect(result.currentState, equals(AvatarState.fresh));
      verify(mockLocalDataSource.getSelectedAvatarId()).called(1);
      verify(mockLocalDataSource.getAvatarState()).called(1);
    });

    test('should create default state when ID exists but no state', () async {
      // Arrange
      when(mockLocalDataSource.getSelectedAvatarId())
          .thenAnswer((_) async => 'doctor');
      when(mockLocalDataSource.getAvatarState()).thenAnswer((_) async => null);
      when(mockLocalDataSource.saveAvatarState(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getAvatar();

      // Assert
      expect(result, isNotNull);
      expect(result!.name, equals('Docteur'));
      expect(result.currentState, equals(AvatarState.fresh));
      verify(mockLocalDataSource.getSelectedAvatarId()).called(1);
      verify(mockLocalDataSource.getAvatarState()).called(1);
      verify(mockLocalDataSource.saveAvatarState(any)).called(1);
    });

    test('should throw StorageException when getSelectedAvatarId fails',
        () async {
      // Arrange
      when(mockLocalDataSource.getSelectedAvatarId())
          .thenThrow(DataSourceException('DB error'));

      // Act & Assert
      expect(
        () => repository.getAvatar(),
        throwsA(isA<StorageException>()),
      );
    });
  });

  group('AvatarRepositoryImpl - saveSelectedAvatar', () {
    test('should save avatar ID and initialize state', () async {
      // Arrange
      when(mockLocalDataSource.saveSelectedAvatarId(any))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.saveAvatarState(any))
          .thenAnswer((_) async => {});

      // Act
      await repository.saveSelectedAvatar('authoritarianMother');

      // Assert
      verify(mockLocalDataSource.saveSelectedAvatarId('authoritarianMother'))
          .called(1);
      verify(mockLocalDataSource.saveAvatarState(any)).called(1);
    });

    test('should throw StorageException for invalid avatar ID', () async {
      // Act & Assert
      expect(
        () => repository.saveSelectedAvatar('invalidAvatar'),
        throwsA(isA<StorageException>()),
      );
      verifyNever(mockLocalDataSource.saveSelectedAvatarId(any));
      verifyNever(mockLocalDataSource.saveAvatarState(any));
    });

    test('should accept all valid avatar IDs', () async {
      // Arrange
      when(mockLocalDataSource.saveSelectedAvatarId(any))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.saveAvatarState(any))
          .thenAnswer((_) async => {});

      final validIds = [
        'authoritarianMother',
        'sportsCoach',
        'doctor',
        'sarcasticFriend'
      ];

      // Act & Assert
      for (final id in validIds) {
        await repository.saveSelectedAvatar(id);
        verify(mockLocalDataSource.saveSelectedAvatarId(id)).called(1);
      }
    });

    test('should throw StorageException when save fails', () async {
      // Arrange
      when(mockLocalDataSource.saveSelectedAvatarId(any))
          .thenThrow(DataSourceException('Save failed'));

      // Act & Assert
      expect(
        () => repository.saveSelectedAvatar('doctor'),
        throwsA(isA<StorageException>()),
      );
    });
  });

  group('AvatarRepositoryImpl - updateAvatarState', () {
    test('should update avatar state to tired', () async {
      // Arrange
      when(mockLocalDataSource.updateAvatarStateField(any))
          .thenAnswer((_) async => {});

      // Act
      await repository.updateAvatarState(AvatarState.tired);

      // Assert
      verify(mockLocalDataSource.updateAvatarStateField('tired')).called(1);
    });

    test('should update avatar state to dehydrated', () async {
      // Arrange
      when(mockLocalDataSource.updateAvatarStateField(any))
          .thenAnswer((_) async => {});

      // Act
      await repository.updateAvatarState(AvatarState.dehydrated);

      // Assert
      verify(mockLocalDataSource.updateAvatarStateField('dehydrated'))
          .called(1);
    });

    test('should throw StorageException when update fails', () async {
      // Arrange
      when(mockLocalDataSource.updateAvatarStateField(any))
          .thenThrow(DataSourceException('Update failed'));

      // Act & Assert
      expect(
        () => repository.updateAvatarState(AvatarState.dead),
        throwsA(isA<StorageException>()),
      );
    });
  });

  group('AvatarRepositoryImpl - updateLastDrinkTime', () {
    test('should update last drink time and reset state to fresh', () async {
      // Arrange
      final timestamp = DateTime.utc(2026, 1, 8, 14, 30, 0);
      when(mockLocalDataSource.updateLastDrinkTime(any))
          .thenAnswer((_) async => {});

      // Act
      await repository.updateLastDrinkTime(timestamp);

      // Assert
      verify(mockLocalDataSource.updateLastDrinkTime(timestamp)).called(1);
    });

    test('should throw StorageException when update fails', () async {
      // Arrange
      final timestamp = DateTime.utc(2026, 1, 8, 14, 30, 0);
      when(mockLocalDataSource.updateLastDrinkTime(any))
          .thenThrow(DataSourceException('Update failed'));

      // Act & Assert
      expect(
        () => repository.updateLastDrinkTime(timestamp),
        throwsA(isA<StorageException>()),
      );
    });
  });

  group('AvatarRepositoryImpl - getLastDrinkTime', () {
    final testTimestamp = DateTime.utc(2026, 1, 8, 10, 0, 0);
    final testDto = AvatarDto(
      id: 'avatar_singleton',
      name: 'Coach Sportif',
      personalityString: 'sportsCoach',
      currentStateString: 'fresh',
      lastDrinkTime: testTimestamp.toIso8601String(),
      lastUpdated: testTimestamp.toIso8601String(),
    );

    test('should return last drink time from state', () async {
      // Arrange
      when(mockLocalDataSource.getAvatarState())
          .thenAnswer((_) async => testDto);

      // Act
      final result = await repository.getLastDrinkTime();

      // Assert
      expect(result, isNotNull);
      expect(result!.toUtc(), equals(testTimestamp));
      verify(mockLocalDataSource.getAvatarState()).called(1);
    });

    test('should return null when no avatar state exists', () async {
      // Arrange
      when(mockLocalDataSource.getAvatarState()).thenAnswer((_) async => null);

      // Act
      final result = await repository.getLastDrinkTime();

      // Assert
      expect(result, isNull);
      verify(mockLocalDataSource.getAvatarState()).called(1);
    });

    test('should throw StorageException when get fails', () async {
      // Arrange
      when(mockLocalDataSource.getAvatarState())
          .thenThrow(DataSourceException('DB error'));

      // Act & Assert
      expect(
        () => repository.getLastDrinkTime(),
        throwsA(isA<StorageException>()),
      );
    });
  });
}
