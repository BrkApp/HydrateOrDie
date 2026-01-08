import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/streak.dart';

void main() {
  group('Streak', () {
    late Streak testStreak;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2026, 1, 7);
      testStreak = Streak(
        currentStreak: 5,
        longestStreak: 10,
        lastStreakDate: testDate,
        streakActive: true,
      );
    });

    group('constructor', () {
      test('should create streak with all fields', () {
        expect(testStreak.currentStreak, 5);
        expect(testStreak.longestStreak, 10);
        expect(testStreak.lastStreakDate, testDate);
        expect(testStreak.streakActive, true);
      });
    });

    group('incrementStreak', () {
      test('should increment current streak', () {
        final newDate = DateTime(2026, 1, 8);
        final updated = testStreak.incrementStreak(newDate);
        expect(updated.currentStreak, 6);
        expect(updated.lastStreakDate, newDate);
        expect(updated.streakActive, true);
      });

      test('should not update longest if current is still lower', () {
        final newDate = DateTime(2026, 1, 8);
        final updated = testStreak.incrementStreak(newDate);
        expect(updated.longestStreak, 10);
      });

      test('should update longest if current exceeds it', () {
        final streak = testStreak.copyWith(currentStreak: 10);
        final newDate = DateTime(2026, 1, 8);
        final updated = streak.incrementStreak(newDate);
        expect(updated.currentStreak, 11);
        expect(updated.longestStreak, 11);
      });

      test('should update longest when current equals it', () {
        final streak = testStreak.copyWith(currentStreak: 9);
        final newDate = DateTime(2026, 1, 8);
        final updated = streak.incrementStreak(newDate);
        expect(updated.currentStreak, 10);
        expect(updated.longestStreak, 10);
      });
    });

    group('breakStreak', () {
      test('should reset current streak to 0', () {
        final broken = testStreak.breakStreak();
        expect(broken.currentStreak, 0);
        expect(broken.streakActive, false);
      });

      test('should preserve longest streak', () {
        final broken = testStreak.breakStreak();
        expect(broken.longestStreak, 10);
      });

      test('should preserve last streak date', () {
        final broken = testStreak.breakStreak();
        expect(broken.lastStreakDate, testDate);
      });
    });

    group('isStreakActiveToday', () {
      test('should return true if streak is active and date is today', () {
        final today = DateTime.now();
        final streak = testStreak.copyWith(
          lastStreakDate: today,
          streakActive: true,
        );
        expect(streak.isStreakActiveToday(), true);
      });

      test('should return false if streak is inactive', () {
        final today = DateTime.now();
        final streak = testStreak.copyWith(
          lastStreakDate: today,
          streakActive: false,
        );
        expect(streak.isStreakActiveToday(), false);
      });

      test('should return false if last date is not today', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final streak = testStreak.copyWith(
          lastStreakDate: yesterday,
          streakActive: true,
        );
        expect(streak.isStreakActiveToday(), false);
      });
    });

    group('shouldIncrementToday', () {
      test('should return true if last streak was yesterday', () {
        final today = DateTime(2026, 1, 8);
        final yesterday = DateTime(2026, 1, 7);
        final streak = testStreak.copyWith(lastStreakDate: yesterday);
        expect(streak.shouldIncrementToday(today), true);
      });

      test('should return false if last streak was today', () {
        final today = DateTime(2026, 1, 7);
        final streak = testStreak.copyWith(lastStreakDate: today);
        expect(streak.shouldIncrementToday(today), false);
      });

      test('should return false if last streak was 2 days ago', () {
        final today = DateTime(2026, 1, 9);
        final twoDaysAgo = DateTime(2026, 1, 7);
        final streak = testStreak.copyWith(lastStreakDate: twoDaysAgo);
        expect(streak.shouldIncrementToday(today), false);
      });
    });

    group('copyWith', () {
      test('should create copy with updated currentStreak', () {
        final updated = testStreak.copyWith(currentStreak: 7);
        expect(updated.currentStreak, 7);
        expect(updated.longestStreak, testStreak.longestStreak);
      });

      test('should create copy with updated streakActive', () {
        final updated = testStreak.copyWith(streakActive: false);
        expect(updated.streakActive, false);
        expect(updated.currentStreak, testStreak.currentStreak);
      });

      test('should keep original values when no params provided', () {
        final copy = testStreak.copyWith();
        expect(copy, testStreak);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final streak2 = Streak(
          currentStreak: 5,
          longestStreak: 10,
          lastStreakDate: testDate,
          streakActive: true,
        );
        expect(testStreak, streak2);
      });

      test('should not be equal when fields differ', () {
        final streak2 = testStreak.copyWith(currentStreak: 6);
        expect(testStreak, isNot(streak2));
      });
    });

    group('toString', () {
      test('should return string representation', () {
        final str = testStreak.toString();
        expect(str, contains('Streak'));
        expect(str, contains('currentStreak: 5'));
        expect(str, contains('longestStreak: 10'));
      });
    });
  });
}
