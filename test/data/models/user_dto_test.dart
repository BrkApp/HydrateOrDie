import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/models/user_dto.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';

void main() {
  group('UserDto', () {
    final validJson = {
      'userId': '550e8400-e29b-41d4-a716-446655440000',
      'weight': 75.0,
      'age': 30,
      'gender': 'male',
      'activityLevel': 'moderate',
      'locationPermissionGranted': false,
      'dailyGoalLiters': 2.5,
      'createdAt': '2026-01-07T10:00:00.000Z',
      'updatedAt': '2026-01-07T10:00:00.000Z',
    };

    final validDto = UserDto(
      userId: '550e8400-e29b-41d4-a716-446655440000',
      weight: 75.0,
      age: 30,
      genderString: 'male',
      activityLevelString: 'moderate',
      locationPermissionGranted: false,
      dailyGoalLiters: 2.5,
      createdAt: '2026-01-07T10:00:00.000Z',
      updatedAt: '2026-01-07T10:00:00.000Z',
    );

    final validEntity = User(
      id: '550e8400-e29b-41d4-a716-446655440000',
      weight: 75.0,
      age: 30,
      gender: Gender.male,
      activityLevel: ActivityLevel.moderate,
      dailyGoal: HydrationGoal(2.5),
    );

    group('fromJson', () {
      test('should deserialize valid JSON correctly', () {
        final result = UserDto.fromJson(validJson);

        expect(result.userId, equals('550e8400-e29b-41d4-a716-446655440000'));
        expect(result.weight, equals(75.0));
        expect(result.age, equals(30));
        expect(result.genderString, equals('male'));
        expect(result.activityLevelString, equals('moderate'));
        expect(result.locationPermissionGranted, equals(false));
        expect(result.dailyGoalLiters, equals(2.5));
        expect(result.createdAt, equals('2026-01-07T10:00:00.000Z'));
        expect(result.updatedAt, equals('2026-01-07T10:00:00.000Z'));
      });

      test('should handle all gender types', () {
        for (final gender in Gender.values) {
          final json = {...validJson, 'gender': gender.name};
          final result = UserDto.fromJson(json);
          expect(result.genderString, equals(gender.name));
        }
      });

      test('should handle all activity levels', () {
        for (final level in ActivityLevel.values) {
          final json = {...validJson, 'activityLevel': level.name};
          final result = UserDto.fromJson(json);
          expect(result.activityLevelString, equals(level.name));
        }
      });

      test('should handle permission true', () {
        final json = {...validJson, 'locationPermissionGranted': true};
        final result = UserDto.fromJson(json);
        expect(result.locationPermissionGranted, isTrue);
      });
    });

    group('toJson', () {
      test('should serialize to valid JSON', () {
        final result = validDto.toJson();

        expect(result['userId'], equals('550e8400-e29b-41d4-a716-446655440000'));
        expect(result['weight'], equals(75.0));
        expect(result['age'], equals(30));
        expect(result['gender'], equals('male'));
        expect(result['activityLevel'], equals('moderate'));
        expect(result['locationPermissionGranted'], equals(false));
        expect(result['dailyGoalLiters'], equals(2.5));
        expect(result['createdAt'], equals('2026-01-07T10:00:00.000Z'));
        expect(result['updatedAt'], equals('2026-01-07T10:00:00.000Z'));
      });

      test('should be reversible with fromJson', () {
        final json = validDto.toJson();
        final deserialized = UserDto.fromJson(json);

        expect(deserialized.userId, equals(validDto.userId));
        expect(deserialized.weight, equals(validDto.weight));
        expect(deserialized.age, equals(validDto.age));
        expect(deserialized.genderString, equals(validDto.genderString));
        expect(deserialized.activityLevelString,
            equals(validDto.activityLevelString));
        expect(deserialized.dailyGoalLiters, equals(validDto.dailyGoalLiters));
      });
    });

    group('fromEntity', () {
      test('should convert User entity to DTO correctly', () {
        final result = UserDto.fromEntity(validEntity);

        expect(result.userId, equals('550e8400-e29b-41d4-a716-446655440000'));
        expect(result.weight, equals(75.0));
        expect(result.age, equals(30));
        expect(result.genderString, equals('male'));
        expect(result.activityLevelString, equals('moderate'));
        expect(result.dailyGoalLiters, equals(2.5));
        expect(result.locationPermissionGranted, equals(false));
      });

      test('should handle all gender types', () {
        for (final gender in Gender.values) {
          final entity = validEntity.copyWith(gender: gender);
          final result = UserDto.fromEntity(entity);
          expect(result.genderString, equals(gender.name));
        }
      });

      test('should handle all activity levels', () {
        for (final level in ActivityLevel.values) {
          final entity = validEntity.copyWith(activityLevel: level);
          final result = UserDto.fromEntity(entity);
          expect(result.activityLevelString, equals(level.name));
        }
      });

      test('should convert timestamps to UTC ISO 8601', () {
        final result = UserDto.fromEntity(validEntity);

        expect(result.createdAt, contains('Z'));
        expect(result.updatedAt, contains('Z'));
        expect(DateTime.parse(result.createdAt).isUtc, isTrue);
        expect(DateTime.parse(result.updatedAt).isUtc, isTrue);
      });
    });

    group('toEntity', () {
      test('should convert DTO to User entity correctly', () {
        final result = validDto.toEntity();

        expect(result.id, equals('550e8400-e29b-41d4-a716-446655440000'));
        expect(result.weight, equals(75.0));
        expect(result.age, equals(30));
        expect(result.gender, equals(Gender.male));
        expect(result.activityLevel, equals(ActivityLevel.moderate));
        expect(result.dailyGoal.targetLiters, equals(2.5));
      });

      test('should throw ArgumentError for invalid gender', () {
        final invalidDto = validDto.copyWith(genderString: 'invalidGender');

        expect(() => invalidDto.toEntity(), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid activity level', () {
        final invalidDto =
            validDto.copyWith(activityLevelString: 'invalidLevel');

        expect(() => invalidDto.toEntity(), throwsArgumentError);
      });

      test('should be reversible with fromEntity', () {
        final dto = UserDto.fromEntity(validEntity);
        final entity = dto.toEntity();

        expect(entity.id, equals(validEntity.id));
        expect(entity.weight, equals(validEntity.weight));
        expect(entity.age, equals(validEntity.age));
        expect(entity.gender, equals(validEntity.gender));
        expect(entity.activityLevel, equals(validEntity.activityLevel));
        expect(entity.dailyGoal.targetLiters,
            equals(validEntity.dailyGoal.targetLiters));
      });
    });

    group('isComplete', () {
      test('should return true for valid complete profile', () {
        expect(validDto.isComplete(), isTrue);
      });

      test('should return false for empty userId', () {
        final dto = validDto.copyWith(userId: '');
        expect(dto.isComplete(), isFalse);
      });

      test('should return false for weight below minimum (30kg)', () {
        final dto = validDto.copyWith(weight: 29.9);
        expect(dto.isComplete(), isFalse);
      });

      test('should return false for weight above maximum (300kg)', () {
        final dto = validDto.copyWith(weight: 300.1);
        expect(dto.isComplete(), isFalse);
      });

      test('should return true for weight exactly at minimum (30kg)', () {
        final dto = validDto.copyWith(weight: 30.0);
        expect(dto.isComplete(), isTrue);
      });

      test('should return true for weight exactly at maximum (300kg)', () {
        final dto = validDto.copyWith(weight: 300.0);
        expect(dto.isComplete(), isTrue);
      });

      test('should return false for age below minimum (10)', () {
        final dto = validDto.copyWith(age: 9);
        expect(dto.isComplete(), isFalse);
      });

      test('should return false for age above maximum (120)', () {
        final dto = validDto.copyWith(age: 121);
        expect(dto.isComplete(), isFalse);
      });

      test('should return false for goal below minimum (1.5L)', () {
        final dto = validDto.copyWith(dailyGoalLiters: 1.4);
        expect(dto.isComplete(), isFalse);
      });

      test('should return false for goal above maximum (5.0L)', () {
        final dto = validDto.copyWith(dailyGoalLiters: 5.1);
        expect(dto.isComplete(), isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated weight', () {
        final result = validDto.copyWith(weight: 80.0);
        expect(result.weight, equals(80.0));
        expect(result.userId, equals(validDto.userId));
      });

      test('should create copy with updated age', () {
        final result = validDto.copyWith(age: 25);
        expect(result.age, equals(25));
      });

      test('should create copy with updated gender', () {
        final result = validDto.copyWith(genderString: 'female');
        expect(result.genderString, equals('female'));
      });

      test('should create copy with updated activity level', () {
        final result = validDto.copyWith(activityLevelString: 'veryActive');
        expect(result.activityLevelString, equals('veryActive'));
      });

      test('should create copy with updated permission', () {
        final result = validDto.copyWith(locationPermissionGranted: true);
        expect(result.locationPermissionGranted, isTrue);
      });

      test('should preserve all fields when no arguments provided', () {
        final result = validDto.copyWith();
        expect(result.userId, equals(validDto.userId));
        expect(result.weight, equals(validDto.weight));
        expect(result.age, equals(validDto.age));
        expect(result.genderString, equals(validDto.genderString));
        expect(result.activityLevelString, equals(validDto.activityLevelString));
        expect(result.dailyGoalLiters, equals(validDto.dailyGoalLiters));
      });
    });
  });
}
