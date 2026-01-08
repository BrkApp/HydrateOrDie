import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';

void main() {
  group('HydrationGoal', () {
    group('constructor', () {
      test('should create goal with valid target', () {
        final goal = HydrationGoal(2.5);
        expect(goal.targetLiters, 2.5);
      });

      test('should accept minimum goal of 1.5L', () {
        final goal = HydrationGoal(HydrationGoal.kMinGoal);
        expect(goal.targetLiters, 1.5);
      });

      test('should accept maximum goal of 5.0L', () {
        final goal = HydrationGoal(HydrationGoal.kMaxGoal);
        expect(goal.targetLiters, 5.0);
      });

      test('should throw ArgumentError if goal < minimum', () {
        expect(
          () => HydrationGoal(1.4),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError if goal > maximum', () {
        expect(
          () => HydrationGoal(5.1),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError if goal is 0', () {
        expect(
          () => HydrationGoal(0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError if goal is negative', () {
        expect(
          () => HydrationGoal(-1.0),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('isAchieved', () {
      test('should return true when current volume equals target', () {
        final goal = HydrationGoal(2.5);
        expect(goal.isAchieved(2.5), true);
      });

      test('should return true when current volume exceeds target', () {
        final goal = HydrationGoal(2.5);
        expect(goal.isAchieved(3.0), true);
      });

      test('should return false when current volume is below target', () {
        final goal = HydrationGoal(2.5);
        expect(goal.isAchieved(2.0), false);
      });

      test('should return false when current volume is 0', () {
        final goal = HydrationGoal(2.5);
        expect(goal.isAchieved(0), false);
      });
    });

    group('getProgressPercentage', () {
      test('should return 0.0 when no volume consumed', () {
        final goal = HydrationGoal(2.5);
        expect(goal.getProgressPercentage(0), 0.0);
      });

      test('should return 0.5 when half consumed', () {
        final goal = HydrationGoal(2.0);
        expect(goal.getProgressPercentage(1.0), 0.5);
      });

      test('should return 1.0 when exactly achieved', () {
        final goal = HydrationGoal(2.5);
        expect(goal.getProgressPercentage(2.5), 1.0);
      });

      test('should return > 1.0 when exceeding goal', () {
        final goal = HydrationGoal(2.0);
        expect(goal.getProgressPercentage(3.0), 1.5);
      });

      test('should calculate correct percentage for various values', () {
        final goal = HydrationGoal(2.5);
        expect(goal.getProgressPercentage(0.5), closeTo(0.2, 0.01));
        expect(goal.getProgressPercentage(1.25), closeTo(0.5, 0.01));
        expect(goal.getProgressPercentage(2.0), closeTo(0.8, 0.01));
      });
    });

    group('equality', () {
      test('should be equal when target is the same', () {
        final goal1 = HydrationGoal(2.5);
        final goal2 = HydrationGoal(2.5);
        expect(goal1, goal2);
      });

      test('should not be equal when target is different', () {
        final goal1 = HydrationGoal(2.5);
        final goal2 = HydrationGoal(3.0);
        expect(goal1, isNot(goal2));
      });

      test('should have same hashCode for equal goals', () {
        final goal1 = HydrationGoal(2.5);
        final goal2 = HydrationGoal(2.5);
        expect(goal1.hashCode, goal2.hashCode);
      });
    });

    group('toString', () {
      test('should return string representation', () {
        final goal = HydrationGoal(2.5);
        expect(goal.toString(), 'HydrationGoal(targetLiters: 2.5)');
      });
    });
  });
}
