import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/glass_size.dart';
import 'package:hydrate_or_die/domain/entities/hydration_log.dart';

void main() {
  group('HydrationLog', () {
    late HydrationLog testLog;
    late DateTime testTime;

    setUp(() {
      testTime = DateTime(2026, 1, 7, 14, 30);
      testLog = HydrationLog(
        id: 'log-123',
        timestamp: testTime,
        photoPath: '/path/to/photo.jpg',
        glassSize: GlassSize.medium,
        validated: true,
      );
    });

    group('constructor', () {
      test('should create log with all fields', () {
        expect(testLog.id, 'log-123');
        expect(testLog.timestamp, testTime);
        expect(testLog.photoPath, '/path/to/photo.jpg');
        expect(testLog.glassSize, GlassSize.medium);
        expect(testLog.validated, true);
      });

      test('should allow null photoPath', () {
        final log = HydrationLog(
          id: 'log-456',
          timestamp: testTime,
          photoPath: null,
          glassSize: GlassSize.small,
        );
        expect(log.photoPath, null);
      });

      test('should default validated to true', () {
        final log = HydrationLog(
          id: 'log-789',
          timestamp: testTime,
          glassSize: GlassSize.large,
        );
        expect(log.validated, true);
      });
    });

    group('volumeLiters', () {
      test('should return correct volume for small glass', () {
        final log = testLog.copyWith(glassSize: GlassSize.small);
        expect(log.volumeLiters, 0.2);
      });

      test('should return correct volume for medium glass', () {
        expect(testLog.volumeLiters, 0.25);
      });

      test('should return correct volume for large glass', () {
        final log = testLog.copyWith(glassSize: GlassSize.large);
        expect(log.volumeLiters, 0.4);
      });
    });

    group('isToday', () {
      test('should return true for today\'s date', () {
        final today = DateTime.now();
        final log = testLog.copyWith(timestamp: today);
        expect(log.isToday(), true);
      });

      test('should return false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final log = testLog.copyWith(timestamp: yesterday);
        expect(log.isToday(), false);
      });

      test('should return false for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final log = testLog.copyWith(timestamp: tomorrow);
        expect(log.isToday(), false);
      });

      test('should ignore time when checking date', () {
        final todayMorning = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          1,
          0,
        );
        final log = testLog.copyWith(timestamp: todayMorning);
        expect(log.isToday(), true);
      });
    });

    group('copyWith', () {
      test('should create copy with updated glass size', () {
        final updated = testLog.copyWith(glassSize: GlassSize.large);
        expect(updated.glassSize, GlassSize.large);
        expect(updated.id, testLog.id);
        expect(updated.timestamp, testLog.timestamp);
      });

      test('should create copy with updated photoPath', () {
        final updated = testLog.copyWith(photoPath: '/new/path.jpg');
        expect(updated.photoPath, '/new/path.jpg');
        expect(updated.glassSize, testLog.glassSize);
      });

      test('should keep original values when no params provided', () {
        final copy = testLog.copyWith();
        expect(copy, testLog);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final log2 = HydrationLog(
          id: 'log-123',
          timestamp: testTime,
          photoPath: '/path/to/photo.jpg',
          glassSize: GlassSize.medium,
          validated: true,
        );
        expect(testLog, log2);
      });

      test('should not be equal when fields differ', () {
        final log2 = testLog.copyWith(glassSize: GlassSize.large);
        expect(testLog, isNot(log2));
      });
    });

    group('toString', () {
      test('should return string representation', () {
        final str = testLog.toString();
        expect(str, contains('HydrationLog'));
        expect(str, contains('log-123'));
        expect(str, contains('medium'));
      });
    });
  });
}
