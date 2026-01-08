import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/avatar_local_data_source.dart';
import 'package:hydrate_or_die/data/data_sources/local/database_helper.dart';
import 'package:hydrate_or_die/data/repositories/avatar_repository_impl.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Integration tests for AvatarRepository with real SQLite and SharedPreferences
///
/// These tests verify the full persistence stack works correctly.
void main() {
  late DatabaseHelper databaseHelper;
  late AvatarLocalDataSource localDataSource;
  late AvatarRepository repository;

  setUpAll(() {
    // Initialize FFI for desktop/unit testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Initialize in-memory database for testing
    TestWidgetsFlutterBinding.ensureInitialized();

    // Clear SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Create fresh database for each test
    databaseHelper = DatabaseHelper();
    await databaseHelper.deleteDatabase(); // Clean slate

    localDataSource = AvatarLocalDataSourceImpl(databaseHelper);
    repository = AvatarRepositoryImpl(localDataSource);
  });

  tearDown(() async {
    // Clean up after each test
    await databaseHelper.close();
    await databaseHelper.deleteDatabase();
  });

  group('AvatarRepository Integration Tests', () {
    test('should persist avatar ID in SharedPreferences', () async {
      // Act
      await repository.saveSelectedAvatar('sportsCoach');

      // Assert - Verify persistence
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString('selected_avatar_id');
      expect(savedId, equals('sportsCoach'));
    });

    test('should persist avatar state in SQLite', () async {
      // Act
      await repository.saveSelectedAvatar('doctor');

      // Get avatar to verify state was saved
      final avatar = await repository.getAvatar();

      // Assert
      expect(avatar, isNotNull);
      expect(avatar!.name, equals('Docteur'));
      expect(avatar.currentState, equals(AvatarState.fresh));
    });

    test('should retrieve avatar across repository instances', () async {
      // Save with first repository instance
      await repository.saveSelectedAvatar('authoritarianMother');

      // Create new repository instance (simulating app restart)
      final newRepository = AvatarRepositoryImpl(localDataSource);
      final avatar = await newRepository.getAvatar();

      // Assert - Data persists across instances
      expect(avatar, isNotNull);
      expect(avatar!.name, equals('Maman Autoritaire'));
      expect(avatar.currentState, equals(AvatarState.fresh));
    });

    test('should update avatar state and persist changes', () async {
      // Arrange - Save initial avatar
      await repository.saveSelectedAvatar('sarcasticFriend');

      // Act - Update state
      await repository.updateAvatarState(AvatarState.tired);

      // Assert - Verify state persisted
      final avatar = await repository.getAvatar();
      expect(avatar!.currentState, equals(AvatarState.tired));
    });

    test('should update last drink time and reset to fresh', () async {
      // Arrange - Save avatar in tired state
      await repository.saveSelectedAvatar('sportsCoach');
      await repository.updateAvatarState(AvatarState.tired);

      // Act - Update last drink time
      final newDrinkTime = DateTime.utc(2026, 1, 8, 15, 30, 0);
      await repository.updateLastDrinkTime(newDrinkTime);

      // Assert - State reset to fresh
      final avatar = await repository.getAvatar();
      expect(avatar!.currentState, equals(AvatarState.fresh));

      // Assert - Last drink time updated
      final lastDrink = await repository.getLastDrinkTime();
      expect(lastDrink!.toUtc(), equals(newDrinkTime));
    });

    test('should handle state transitions: fresh → tired → dehydrated → dead',
        () async {
      // Arrange
      await repository.saveSelectedAvatar('doctor');

      // Act & Assert - Fresh
      var avatar = await repository.getAvatar();
      expect(avatar!.currentState, equals(AvatarState.fresh));

      // Act & Assert - Tired
      await repository.updateAvatarState(AvatarState.tired);
      avatar = await repository.getAvatar();
      expect(avatar!.currentState, equals(AvatarState.tired));

      // Act & Assert - Dehydrated
      await repository.updateAvatarState(AvatarState.dehydrated);
      avatar = await repository.getAvatar();
      expect(avatar!.currentState, equals(AvatarState.dehydrated));

      // Act & Assert - Dead
      await repository.updateAvatarState(AvatarState.dead);
      avatar = await repository.getAvatar();
      expect(avatar!.currentState, equals(AvatarState.dead));

      // Act & Assert - Ghost
      await repository.updateAvatarState(AvatarState.ghost);
      avatar = await repository.getAvatar();
      expect(avatar!.currentState, equals(AvatarState.ghost));
    });

    test('should return null for getAvatar when nothing saved yet', () async {
      // Act
      final avatar = await repository.getAvatar();

      // Assert
      expect(avatar, isNull);
    });

    test('should return null for getLastDrinkTime when no avatar exists',
        () async {
      // Act
      final lastDrink = await repository.getLastDrinkTime();

      // Assert
      expect(lastDrink, isNull);
    });

    test('should handle switching between different avatars', () async {
      // Save first avatar
      await repository.saveSelectedAvatar('sportsCoach');
      var avatar = await repository.getAvatar();
      expect(avatar!.name, equals('Coach Sportif'));

      // Switch to different avatar
      await repository.saveSelectedAvatar('doctor');
      avatar = await repository.getAvatar();
      expect(avatar!.name, equals('Docteur'));

      // Switch again
      await repository.saveSelectedAvatar('sarcasticFriend');
      avatar = await repository.getAvatar();
      expect(avatar!.name, equals('Ami Sarcastique'));
    });

    test('should maintain singleton pattern for avatar_state table', () async {
      // Save multiple times
      await repository.saveSelectedAvatar('doctor');
      await repository.saveSelectedAvatar('sportsCoach');
      await repository.saveSelectedAvatar('authoritarianMother');

      // Verify only one row exists in database
      final db = await databaseHelper.database;
      final results = await db.query('avatar_state');

      expect(results.length, equals(1));
      expect(results.first['selected_avatar_id'], equals('authoritarianMother'));
    });

    test('should handle timestamps in UTC correctly', () async {
      // Arrange
      final testTime = DateTime.utc(2026, 1, 8, 10, 30, 45);
      await repository.saveSelectedAvatar('doctor');

      // Act
      await repository.updateLastDrinkTime(testTime);

      // Assert
      final retrieved = await repository.getLastDrinkTime();
      expect(retrieved!.isUtc, isTrue);
      expect(retrieved.year, equals(2026));
      expect(retrieved.month, equals(1));
      expect(retrieved.day, equals(8));
      expect(retrieved.hour, equals(10));
      expect(retrieved.minute, equals(30));
      expect(retrieved.second, equals(45));
    });
  });
}
