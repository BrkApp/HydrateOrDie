import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/models/hydration_log_dto.dart';
import 'package:hydrate_or_die/domain/entities/glass_size.dart';
import 'package:hydrate_or_die/domain/entities/hydration_log.dart';

void main() {
  group('HydrationLogDto', () {
    late HydrationLogDto testDto;
    final testTimestamp = DateTime(2026, 1, 7, 14, 30).toUtc();

    setUp(() {
      testDto = HydrationLogDto(
        id: 'log-123',
        timestamp: testTimestamp.toIso8601String(),
        photoPath: '/path/to/photo.jpg',
        glassSizeString: 'medium',
        volumeLiters: 0.25,
        validated: true,
        syncedToCloud: false,
        createdAt: DateTime.now().toUtc().toIso8601String(),
      );
    });

    group('constructor', () {
      test('should create DTO with all fields', () {
        expect(testDto.id, 'log-123');
        expect(testDto.timestamp, testTimestamp.toIso8601String());
        expect(testDto.photoPath, '/path/to/photo.jpg');
        expect(testDto.glassSizeString, 'medium');
        expect(testDto.volumeLiters, 0.25);
        expect(testDto.validated, true);
        expect(testDto.syncedToCloud, false);
      });

      test('should allow null photoPath', () {
        final dto = HydrationLogDto(
          id: 'log-456',
          timestamp: testTimestamp.toIso8601String(),
          photoPath: null,
          glassSizeString: 'small',
          volumeLiters: 0.2,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        );
        expect(dto.photoPath, null);
      });

      test('should default validated to true', () {
        final dto = HydrationLogDto(
          id: 'log-789',
          timestamp: testTimestamp.toIso8601String(),
          glassSizeString: 'large',
          volumeLiters: 0.4,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        );
        expect(dto.validated, true);
      });

      test('should default syncedToCloud to false', () {
        final dto = HydrationLogDto(
          id: 'log-101',
          timestamp: testTimestamp.toIso8601String(),
          glassSizeString: 'medium',
          volumeLiters: 0.25,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        );
        expect(dto.syncedToCloud, false);
      });
    });

    group('toJson', () {
      test('should serialize DTO to JSON map', () {
        final json = testDto.toJson();

        expect(json['id'], 'log-123');
        expect(json['timestamp'], testTimestamp.toIso8601String());
        expect(json['photoPath'], '/path/to/photo.jpg');
        expect(json['glassSize'], 'medium');
        expect(json['volumeLiters'], 0.25);
        expect(json['validated'], true);
        expect(json['syncedToCloud'], false);
        expect(json['createdAt'], isNotNull);
      });

      test('should serialize null photoPath correctly', () {
        final dto = HydrationLogDto(
          id: 'log-no-photo',
          timestamp: testTimestamp.toIso8601String(),
          photoPath: null,
          glassSizeString: 'medium',
          volumeLiters: 0.25,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        );
        final json = dto.toJson();

        expect(json['photoPath'], null);
      });
    });

    group('fromJson', () {
      test('should deserialize JSON map to DTO', () {
        final json = {
          'id': 'log-999',
          'timestamp': testTimestamp.toIso8601String(),
          'photoPath': '/test/path.jpg',
          'glassSize': 'large',
          'volumeLiters': 0.4,
          'validated': true,
          'syncedToCloud': true,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        };

        final dto = HydrationLogDto.fromJson(json);

        expect(dto.id, 'log-999');
        expect(dto.timestamp, testTimestamp.toIso8601String());
        expect(dto.photoPath, '/test/path.jpg');
        expect(dto.glassSizeString, 'large');
        expect(dto.volumeLiters, 0.4);
        expect(dto.validated, true);
        expect(dto.syncedToCloud, true);
      });

      test('should handle null photoPath in JSON', () {
        final json = {
          'id': 'log-888',
          'timestamp': testTimestamp.toIso8601String(),
          'photoPath': null,
          'glassSize': 'small',
          'volumeLiters': 0.2,
          'validated': true,
          'syncedToCloud': false,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        };

        final dto = HydrationLogDto.fromJson(json);

        expect(dto.photoPath, null);
      });
    });

    group('fromEntity', () {
      test('should create DTO from HydrationLog entity', () {
        final entity = HydrationLog(
          id: 'log-entity-1',
          timestamp: testTimestamp,
          photoPath: '/entity/photo.jpg',
          glassSize: GlassSize.medium,
          validated: true,
        );

        final dto = HydrationLogDto.fromEntity(entity);

        expect(dto.id, 'log-entity-1');
        expect(dto.timestamp, testTimestamp.toUtc().toIso8601String());
        expect(dto.photoPath, '/entity/photo.jpg');
        expect(dto.glassSizeString, 'medium');
        expect(dto.volumeLiters, 0.25);
        expect(dto.validated, true);
        expect(dto.syncedToCloud, false);
      });

      test('should handle small glass size', () {
        final entity = HydrationLog(
          id: 'log-small',
          timestamp: testTimestamp,
          glassSize: GlassSize.small,
        );

        final dto = HydrationLogDto.fromEntity(entity);

        expect(dto.glassSizeString, 'small');
        expect(dto.volumeLiters, 0.2);
      });

      test('should handle large glass size', () {
        final entity = HydrationLog(
          id: 'log-large',
          timestamp: testTimestamp,
          glassSize: GlassSize.large,
        );

        final dto = HydrationLogDto.fromEntity(entity);

        expect(dto.glassSizeString, 'large');
        expect(dto.volumeLiters, 0.4);
      });

      test('should handle null photoPath', () {
        final entity = HydrationLog(
          id: 'log-no-photo',
          timestamp: testTimestamp,
          photoPath: null,
          glassSize: GlassSize.medium,
        );

        final dto = HydrationLogDto.fromEntity(entity);

        expect(dto.photoPath, null);
      });
    });

    group('toEntity', () {
      test('should convert DTO to HydrationLog entity', () {
        final entity = testDto.toEntity();

        expect(entity.id, 'log-123');
        expect(entity.timestamp, testTimestamp);
        expect(entity.photoPath, '/path/to/photo.jpg');
        expect(entity.glassSize, GlassSize.medium);
        expect(entity.validated, true);
      });

      test('should parse small glass size', () {
        final dto = testDto.copyWith(
          glassSizeString: 'small',
          volumeLiters: 0.2,
        );

        final entity = dto.toEntity();

        expect(entity.glassSize, GlassSize.small);
      });

      test('should parse large glass size', () {
        final dto = testDto.copyWith(
          glassSizeString: 'large',
          volumeLiters: 0.4,
        );

        final entity = dto.toEntity();

        expect(entity.glassSize, GlassSize.large);
      });

      test('should handle null photoPath', () {
        final dto = HydrationLogDto(
          id: 'log-no-photo',
          timestamp: testTimestamp.toIso8601String(),
          photoPath: null,
          glassSizeString: 'medium',
          volumeLiters: 0.25,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        );
        final entity = dto.toEntity();

        expect(entity.photoPath, null);
      });

      test('should throw ArgumentError for invalid glass size', () {
        final dto = testDto.copyWith(glassSizeString: 'invalid');

        expect(() => dto.toEntity(), throwsA(isA<ArgumentError>()));
      });
    });

    group('copyWith', () {
      test('should create copy with updated glass size', () {
        final updated = testDto.copyWith(
          glassSizeString: 'large',
          volumeLiters: 0.4,
        );

        expect(updated.glassSizeString, 'large');
        expect(updated.volumeLiters, 0.4);
        expect(updated.id, testDto.id);
        expect(updated.timestamp, testDto.timestamp);
      });

      test('should create copy with updated syncedToCloud', () {
        final updated = testDto.copyWith(syncedToCloud: true);

        expect(updated.syncedToCloud, true);
        expect(updated.id, testDto.id);
      });

      test('should keep original values when no params provided', () {
        final copy = testDto.copyWith();

        expect(copy.id, testDto.id);
        expect(copy.timestamp, testDto.timestamp);
        expect(copy.photoPath, testDto.photoPath);
        expect(copy.glassSizeString, testDto.glassSizeString);
      });
    });

    group('round-trip serialization', () {
      test('should serialize and deserialize maintaining data integrity', () {
        final json = testDto.toJson();
        final deserialized = HydrationLogDto.fromJson(json);

        expect(deserialized.id, testDto.id);
        expect(deserialized.timestamp, testDto.timestamp);
        expect(deserialized.photoPath, testDto.photoPath);
        expect(deserialized.glassSizeString, testDto.glassSizeString);
        expect(deserialized.volumeLiters, testDto.volumeLiters);
        expect(deserialized.validated, testDto.validated);
        expect(deserialized.syncedToCloud, testDto.syncedToCloud);
      });

      test('should convert entity -> DTO -> JSON -> DTO -> entity', () {
        final originalEntity = HydrationLog(
          id: 'round-trip-test',
          timestamp: testTimestamp,
          photoPath: '/round/trip.jpg',
          glassSize: GlassSize.medium,
          validated: true,
        );

        final dto1 = HydrationLogDto.fromEntity(originalEntity);
        final json = dto1.toJson();
        final dto2 = HydrationLogDto.fromJson(json);
        final finalEntity = dto2.toEntity();

        expect(finalEntity.id, originalEntity.id);
        expect(finalEntity.timestamp, originalEntity.timestamp);
        expect(finalEntity.photoPath, originalEntity.photoPath);
        expect(finalEntity.glassSize, originalEntity.glassSize);
        expect(finalEntity.validated, originalEntity.validated);
      });
    });
  });
}
