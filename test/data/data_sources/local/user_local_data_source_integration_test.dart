import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/database_helper.dart';
import 'package:hydrate_or_die/data/data_sources/local/user_local_data_source.dart';
import 'package:hydrate_or_die/data/models/user_dto.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Integration tests for UserLocalDataSource with real SQLite
///
/// These tests verify the full persistence stack works correctly.
void main() {
  late DatabaseHelper databaseHelper;
  late UserLocalDataSource dataSource;

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

    dataSource = UserLocalDataSourceImpl(databaseHelper);
  });

  tearDown(() async {
    // Clean up after each test
    await databaseHelper.close();
    await databaseHelper.deleteDatabase();
  });

  group('UserLocalDataSource Integration Tests - CRUD', () {
    final testTimestamp = DateTime.utc(2026, 1, 14, 10, 0, 0);
    final testUserDto = UserDto(
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
      // Act
      final result = await dataSource.getUserProfile();

      // Assert
      expect(result, isNull);
    });

    test('should save user profile to SQLite successfully', () async {
      // Act
      await dataSource.saveUserProfile(testUserDto);

      // Assert - Verify profile was saved
      final retrieved = await dataSource.getUserProfile();
      expect(retrieved, isNotNull);
      expect(retrieved!.userId, equals('test-user-123'));
      expect(retrieved.weight, equals(70.0));
      expect(retrieved.age, equals(30));
      expect(retrieved.genderString, equals('male'));
      expect(retrieved.activityLevelString, equals('moderate'));
      expect(retrieved.locationPermissionGranted, isTrue);
      expect(retrieved.dailyGoalLiters, equals(2.5));
    });

    test('should replace existing profile (singleton pattern)', () async {
      // Arrange - Save first profile
      await dataSource.saveUserProfile(testUserDto);

      // Act - Save different profile (should replace)
      final newUserDto = UserDto(
        userId: 'test-user-456',
        weight: 65.0,
        age: 25,
        genderString: 'female',
        activityLevelString: 'veryActive',
        locationPermissionGranted: false,
        dailyGoalLiters: 2.3,
        createdAt: testTimestamp.toIso8601String(),
        updatedAt: testTimestamp.toIso8601String(),
      );
      await dataSource.saveUserProfile(newUserDto);

      // Assert - Only new profile exists
      final retrieved = await dataSource.getUserProfile();
      expect(retrieved!.userId, equals('test-user-456'));
      expect(retrieved.weight, equals(65.0));
      expect(retrieved.age, equals(25));

      // Verify only one row in database
      final db = await databaseHelper.database;
      final rows = await db.query('user_profile');
      expect(rows.length, equals(1));
    });

    test('should update user profile successfully', () async {
      // Arrange - Save initial profile
      await dataSource.saveUserProfile(testUserDto);

      // Act - Update profile
      final updatedUserDto = testUserDto.copyWith(
        weight: 75.0,
        age: 31,
        dailyGoalLiters: 2.8,
      );
      await dataSource.updateUserProfile(updatedUserDto);

      // Assert - Verify updates
      final retrieved = await dataSource.getUserProfile();
      expect(retrieved!.weight, equals(75.0));
      expect(retrieved.age, equals(31));
      expect(retrieved.dailyGoalLiters, equals(2.8));
      expect(retrieved.userId, equals('test-user-123')); // ID unchanged
    });

    test('should throw DataSourceException when updating non-existent profile',
        () async {
      // Act & Assert
      expect(
        () => dataSource.updateUserProfile(testUserDto),
        throwsA(isA<DataSourceException>()),
      );
    });

    test('should delete user profile successfully', () async {
      // Arrange - Save profile
      await dataSource.saveUserProfile(testUserDto);
      expect(await dataSource.hasUserProfile(), isTrue);

      // Act - Delete profile
      await dataSource.deleteUserProfile();

      // Assert - Profile no longer exists
      final result = await dataSource.getUserProfile();
      expect(result, isNull);
      expect(await dataSource.hasUserProfile(), isFalse);
    });

    test('should handle delete when no profile exists (no-op)', () async {
      // Act & Assert - Should not throw
      await dataSource.deleteUserProfile();
      expect(await dataSource.hasUserProfile(), isFalse);
    });
  });

  group('UserLocalDataSource Integration Tests - hasUserProfile', () {
    final testUserDto = UserDto(
      userId: 'test-user-789',
      weight: 80.0,
      age: 40,
      genderString: 'other',
      activityLevelString: 'sedentary',
      locationPermissionGranted: true,
      dailyGoalLiters: 2.0,
      createdAt: DateTime.now().toUtc().toIso8601String(),
      updatedAt: DateTime.now().toUtc().toIso8601String(),
    );

    test('should return false when no profile exists', () async {
      // Act
      final result = await dataSource.hasUserProfile();

      // Assert
      expect(result, isFalse);
    });

    test('should return true when profile exists', () async {
      // Arrange
      await dataSource.saveUserProfile(testUserDto);

      // Act
      final result = await dataSource.hasUserProfile();

      // Assert
      expect(result, isTrue);
    });

    test('should return false after profile deletion', () async {
      // Arrange
      await dataSource.saveUserProfile(testUserDto);
      expect(await dataSource.hasUserProfile(), isTrue);

      // Act
      await dataSource.deleteUserProfile();

      // Assert
      expect(await dataSource.hasUserProfile(), isFalse);
    });
  });

  group('UserLocalDataSource Integration Tests - Data Persistence', () {
    test('should persist profile across data source instances', () async {
      // Arrange - Save with first instance
      final userDto = UserDto(
        userId: 'persist-test',
        weight: 70.0,
        age: 28,
        genderString: 'female',
        activityLevelString: 'veryActive',
        locationPermissionGranted: true,
        dailyGoalLiters: 3.0,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      );
      await dataSource.saveUserProfile(userDto);

      // Act - Create new data source instance (simulating app restart)
      final newDataSource = UserLocalDataSourceImpl(databaseHelper);
      final retrieved = await newDataSource.getUserProfile();

      // Assert - Data persists
      expect(retrieved, isNotNull);
      expect(retrieved!.userId, equals('persist-test'));
      expect(retrieved.weight, equals(70.0));
      expect(retrieved.age, equals(28));
    });

    test('should handle all gender values correctly', () async {
      final genders = ['male', 'female', 'other'];

      for (final gender in genders) {
        // Clean database
        await dataSource.deleteUserProfile();

        // Save profile with specific gender
        final userDto = UserDto(
          userId: 'gender-test',
          weight: 70.0,
          age: 30,
          genderString: gender,
          activityLevelString: 'moderate',
          locationPermissionGranted: false,
          dailyGoalLiters: 2.5,
          createdAt: DateTime.now().toUtc().toIso8601String(),
          updatedAt: DateTime.now().toUtc().toIso8601String(),
        );
        await dataSource.saveUserProfile(userDto);

        // Verify
        final retrieved = await dataSource.getUserProfile();
        expect(retrieved!.genderString, equals(gender));
      }
    });

    test('should handle all activity levels correctly', () async {
      final activityLevels = [
        'sedentary',
        'light',
        'moderate',
        'veryActive',
        'extremelyActive'
      ];

      for (final level in activityLevels) {
        // Clean database
        await dataSource.deleteUserProfile();

        // Save profile with specific activity level
        final userDto = UserDto(
          userId: 'activity-test',
          weight: 70.0,
          age: 30,
          genderString: 'male',
          activityLevelString: level,
          locationPermissionGranted: false,
          dailyGoalLiters: 2.5,
          createdAt: DateTime.now().toUtc().toIso8601String(),
          updatedAt: DateTime.now().toUtc().toIso8601String(),
        );
        await dataSource.saveUserProfile(userDto);

        // Verify
        final retrieved = await dataSource.getUserProfile();
        expect(retrieved!.activityLevelString, equals(level));
      }
    });

    test('should handle timestamps in UTC correctly', () async {
      // Arrange
      final testTime = DateTime.utc(2026, 1, 14, 15, 30, 45);
      final userDto = UserDto(
        userId: 'timestamp-test',
        weight: 70.0,
        age: 30,
        genderString: 'male',
        activityLevelString: 'moderate',
        locationPermissionGranted: true,
        dailyGoalLiters: 2.5,
        createdAt: testTime.toIso8601String(),
        updatedAt: testTime.toIso8601String(),
      );

      // Act
      await dataSource.saveUserProfile(userDto);
      final retrieved = await dataSource.getUserProfile();

      // Assert
      expect(retrieved!.createdAt, equals(testTime.toIso8601String()));
      expect(retrieved.updatedAt, equals(testTime.toIso8601String()));
    });

    test('should handle boolean locationPermissionGranted correctly', () async {
      // Test true
      var userDto = UserDto(
        userId: 'bool-test',
        weight: 70.0,
        age: 30,
        genderString: 'male',
        activityLevelString: 'moderate',
        locationPermissionGranted: true,
        dailyGoalLiters: 2.5,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      );
      await dataSource.saveUserProfile(userDto);
      var retrieved = await dataSource.getUserProfile();
      expect(retrieved!.locationPermissionGranted, isTrue);

      // Test false
      userDto = userDto.copyWith(locationPermissionGranted: false);
      await dataSource.saveUserProfile(userDto);
      retrieved = await dataSource.getUserProfile();
      expect(retrieved!.locationPermissionGranted, isFalse);
    });
  });

  group('UserLocalDataSource Integration Tests - Database Constraints', () {
    test('should enforce weight constraints (30-300 kg)', () async {
      // Valid weights should work
      final validUserDto = UserDto(
        userId: 'weight-test',
        weight: 70.0,
        age: 30,
        genderString: 'male',
        activityLevelString: 'moderate',
        locationPermissionGranted: false,
        dailyGoalLiters: 2.5,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      );
      await dataSource.saveUserProfile(validUserDto);
      expect(await dataSource.hasUserProfile(), isTrue);
    });

    test('should enforce age constraints (10-120 years)', () async {
      // Valid age should work
      final validUserDto = UserDto(
        userId: 'age-test',
        weight: 70.0,
        age: 30,
        genderString: 'male',
        activityLevelString: 'moderate',
        locationPermissionGranted: false,
        dailyGoalLiters: 2.5,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      );
      await dataSource.saveUserProfile(validUserDto);
      expect(await dataSource.hasUserProfile(), isTrue);
    });

    test('should enforce daily goal constraints (1.5-5.0 liters)', () async {
      // Valid goal should work
      final validUserDto = UserDto(
        userId: 'goal-test',
        weight: 70.0,
        age: 30,
        genderString: 'male',
        activityLevelString: 'moderate',
        locationPermissionGranted: false,
        dailyGoalLiters: 2.5,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      );
      await dataSource.saveUserProfile(validUserDto);
      expect(await dataSource.hasUserProfile(), isTrue);
    });
  });

  group('UserLocalDataSource Integration Tests - Singleton Pattern', () {
    test('should maintain only one profile in database', () async {
      // Save multiple profiles
      for (int i = 0; i < 5; i++) {
        final userDto = UserDto(
          userId: 'user-$i',
          weight: 70.0 + i,
          age: 30 + i,
          genderString: 'male',
          activityLevelString: 'moderate',
          locationPermissionGranted: false,
          dailyGoalLiters: 2.5,
          createdAt: DateTime.now().toUtc().toIso8601String(),
          updatedAt: DateTime.now().toUtc().toIso8601String(),
        );
        await dataSource.saveUserProfile(userDto);
      }

      // Verify only one row exists
      final db = await databaseHelper.database;
      final rows = await db.query('user_profile');
      expect(rows.length, equals(1));

      // Verify it's the last saved profile
      final retrieved = await dataSource.getUserProfile();
      expect(retrieved!.userId, equals('user-4'));
      expect(retrieved.weight, equals(74.0));
    });

    test('should use fixed singleton ID for all profiles', () async {
      // Save profile
      final userDto = UserDto(
        userId: 'custom-id',
        weight: 70.0,
        age: 30,
        genderString: 'male',
        activityLevelString: 'moderate',
        locationPermissionGranted: false,
        dailyGoalLiters: 2.5,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      );
      await dataSource.saveUserProfile(userDto);

      // Verify database uses singleton ID
      final db = await databaseHelper.database;
      final rows = await db.query('user_profile');
      expect(rows.length, equals(1));
      expect(rows.first['id'], equals('user_singleton'));
    });
  });
}
