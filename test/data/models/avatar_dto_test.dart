import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/models/avatar_dto.dart';
import 'package:hydrate_or_die/domain/entities/avatar.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';

void main() {
  group('AvatarDto', () {
    final testTimestamp = DateTime.utc(2026, 1, 7, 14, 30, 0);
    final testLastUpdated = DateTime.utc(2026, 1, 7, 16, 0, 0);

    final validJson = {
      'id': 'sports_coach',
      'name': 'Coach Mike',
      'personality': 'sportsCoach',
      'currentState': 'fresh',
      'lastDrinkTime': '2026-01-07T14:30:00.000Z',
      'lastUpdated': '2026-01-07T16:00:00.000Z',
    };

    final validDto = AvatarDto(
      id: 'sports_coach',
      name: 'Coach Mike',
      personalityString: 'sportsCoach',
      currentStateString: 'fresh',
      lastDrinkTime: '2026-01-07T14:30:00.000Z',
      lastUpdated: '2026-01-07T16:00:00.000Z',
    );

    final validEntity = Avatar(
      id: 'sports_coach',
      name: 'Coach Mike',
      personality: AvatarPersonality.sportsCoach,
      currentState: AvatarState.fresh,
      lastDrinkTime: testTimestamp,
      lastUpdated: testLastUpdated,
    );

    group('fromJson', () {
      test('should deserialize valid JSON correctly', () {
        final result = AvatarDto.fromJson(validJson);

        expect(result.id, equals('sports_coach'));
        expect(result.name, equals('Coach Mike'));
        expect(result.personalityString, equals('sportsCoach'));
        expect(result.currentStateString, equals('fresh'));
        expect(result.lastDrinkTime, equals('2026-01-07T14:30:00.000Z'));
        expect(result.lastUpdated, equals('2026-01-07T16:00:00.000Z'));
      });

      test('should handle all personality types', () {
        for (final personality in AvatarPersonality.values) {
          final json = {...validJson, 'personality': personality.name};
          final result = AvatarDto.fromJson(json);
          expect(result.personalityString, equals(personality.name));
        }
      });

      test('should handle all avatar states', () {
        for (final state in AvatarState.values) {
          final json = {...validJson, 'currentState': state.name};
          final result = AvatarDto.fromJson(json);
          expect(result.currentStateString, equals(state.name));
        }
      });
    });

    group('toJson', () {
      test('should serialize to valid JSON', () {
        final result = validDto.toJson();

        expect(result['id'], equals('sports_coach'));
        expect(result['name'], equals('Coach Mike'));
        expect(result['personality'], equals('sportsCoach'));
        expect(result['currentState'], equals('fresh'));
        expect(result['lastDrinkTime'], equals('2026-01-07T14:30:00.000Z'));
        expect(result['lastUpdated'], equals('2026-01-07T16:00:00.000Z'));
      });

      test('should be reversible with fromJson', () {
        final json = validDto.toJson();
        final deserialized = AvatarDto.fromJson(json);

        expect(deserialized.id, equals(validDto.id));
        expect(deserialized.name, equals(validDto.name));
        expect(
            deserialized.personalityString, equals(validDto.personalityString));
        expect(deserialized.currentStateString,
            equals(validDto.currentStateString));
        expect(deserialized.lastDrinkTime, equals(validDto.lastDrinkTime));
        expect(deserialized.lastUpdated, equals(validDto.lastUpdated));
      });
    });

    group('fromEntity', () {
      test('should convert Avatar entity to DTO correctly', () {
        final result = AvatarDto.fromEntity(validEntity);

        expect(result.id, equals('sports_coach'));
        expect(result.name, equals('Coach Mike'));
        expect(result.personalityString, equals('sportsCoach'));
        expect(result.currentStateString, equals('fresh'));
        expect(result.lastDrinkTime, equals('2026-01-07T14:30:00.000Z'));
        expect(result.lastUpdated, equals('2026-01-07T16:00:00.000Z'));
      });

      test('should handle all personality types', () {
        for (final personality in AvatarPersonality.values) {
          final entity = validEntity.copyWith(personality: personality);
          final result = AvatarDto.fromEntity(entity);
          expect(result.personalityString, equals(personality.name));
        }
      });

      test('should handle all avatar states', () {
        for (final state in AvatarState.values) {
          final entity = validEntity.copyWith(currentState: state);
          final result = AvatarDto.fromEntity(entity);
          expect(result.currentStateString, equals(state.name));
        }
      });

      test('should convert timestamps to UTC ISO 8601', () {
        final localTime = DateTime(2026, 1, 7, 14, 30, 0); // Local time
        final entity = validEntity.copyWith(
          lastDrinkTime: localTime,
          lastUpdated: localTime,
        );

        final result = AvatarDto.fromEntity(entity);

        // Should be in UTC format
        expect(result.lastDrinkTime, contains('Z'));
        expect(result.lastUpdated, contains('Z'));
        expect(DateTime.parse(result.lastDrinkTime).isUtc, isTrue);
        expect(DateTime.parse(result.lastUpdated).isUtc, isTrue);
      });
    });

    group('toEntity', () {
      test('should convert DTO to Avatar entity correctly', () {
        final result = validDto.toEntity();

        expect(result.id, equals('sports_coach'));
        expect(result.name, equals('Coach Mike'));
        expect(result.personality, equals(AvatarPersonality.sportsCoach));
        expect(result.currentState, equals(AvatarState.fresh));
        expect(result.lastDrinkTime, equals(testTimestamp));
        expect(result.lastUpdated, equals(testLastUpdated));
      });

      test('should be reversible with fromEntity', () {
        final dto = AvatarDto.fromEntity(validEntity);
        final entity = dto.toEntity();

        expect(entity.id, equals(validEntity.id));
        expect(entity.name, equals(validEntity.name));
        expect(entity.personality, equals(validEntity.personality));
        expect(entity.currentState, equals(validEntity.currentState));
        expect(entity.lastDrinkTime.toUtc(),
            equals(validEntity.lastDrinkTime.toUtc()));
        expect(entity.lastUpdated.toUtc(),
            equals(validEntity.lastUpdated.toUtc()));
      });

      test('should throw ArgumentError for invalid personality', () {
        final invalidDto = validDto.copyWith(personalityString: 'invalidType');

        expect(() => invalidDto.toEntity(), throwsArgumentError);
      });

      test('should throw ArgumentError for invalid state', () {
        final invalidDto = validDto.copyWith(currentStateString: 'invalidState');

        expect(() => invalidDto.toEntity(), throwsArgumentError);
      });
    });

    group('copyWith', () {
      test('should create copy with updated id', () {
        final result = validDto.copyWith(id: 'doctor');
        expect(result.id, equals('doctor'));
        expect(result.name, equals(validDto.name));
      });

      test('should create copy with updated name', () {
        final result = validDto.copyWith(name: 'Dr. Smith');
        expect(result.name, equals('Dr. Smith'));
        expect(result.id, equals(validDto.id));
      });

      test('should create copy with updated personality', () {
        final result = validDto.copyWith(personalityString: 'doctor');
        expect(result.personalityString, equals('doctor'));
      });

      test('should create copy with updated state', () {
        final result = validDto.copyWith(currentStateString: 'tired');
        expect(result.currentStateString, equals('tired'));
      });

      test('should preserve all fields when no arguments provided', () {
        final result = validDto.copyWith();
        expect(result.id, equals(validDto.id));
        expect(result.name, equals(validDto.name));
        expect(result.personalityString, equals(validDto.personalityString));
        expect(result.currentStateString, equals(validDto.currentStateString));
        expect(result.lastDrinkTime, equals(validDto.lastDrinkTime));
        expect(result.lastUpdated, equals(validDto.lastUpdated));
      });
    });
  });
}
