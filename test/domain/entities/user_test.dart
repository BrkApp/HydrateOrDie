import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/activity_level.dart';
import 'package:hydrate_or_die/domain/entities/gender.dart';
import 'package:hydrate_or_die/domain/entities/hydration_goal.dart';
import 'package:hydrate_or_die/domain/entities/user.dart';

void main() {
  group('User', () {
    late User testUser;
    late HydrationGoal testGoal;

    setUp(() {
      testGoal = HydrationGoal(2.5);
      testUser = User(
        id: 'user-123',
        weight: 75.0,
        age: 30,
        gender: Gender.male,
        activityLevel: ActivityLevel.moderate,
        dailyGoal: testGoal,
      );
    });

    group('constructor', () {
      test('should create user with all fields', () {
        expect(testUser.id, 'user-123');
        expect(testUser.weight, 75.0);
        expect(testUser.age, 30);
        expect(testUser.gender, Gender.male);
        expect(testUser.activityLevel, ActivityLevel.moderate);
        expect(testUser.dailyGoal, testGoal);
      });
    });

    group('needsGoalRecalculation', () {
      test('should return true when weight changes', () {
        final oldUser = testUser;
        final newUser = testUser.copyWith(weight: 80.0);
        expect(newUser.needsGoalRecalculation(oldUser), true);
      });

      test('should return true when age changes', () {
        final oldUser = testUser;
        final newUser = testUser.copyWith(age: 31);
        expect(newUser.needsGoalRecalculation(oldUser), true);
      });

      test('should return true when gender changes', () {
        final oldUser = testUser;
        final newUser = testUser.copyWith(gender: Gender.female);
        expect(newUser.needsGoalRecalculation(oldUser), true);
      });

      test('should return true when activity level changes', () {
        final oldUser = testUser;
        final newUser = testUser.copyWith(activityLevel: ActivityLevel.veryActive);
        expect(newUser.needsGoalRecalculation(oldUser), true);
      });

      test('should return false when only goal changes', () {
        final oldUser = testUser;
        final newUser = testUser.copyWith(dailyGoal: HydrationGoal(3.0));
        expect(newUser.needsGoalRecalculation(oldUser), false);
      });

      test('should return false when nothing changes', () {
        final oldUser = testUser;
        final newUser = testUser.copyWith();
        expect(newUser.needsGoalRecalculation(oldUser), false);
      });
    });

    group('copyWith', () {
      test('should create copy with updated weight', () {
        final updated = testUser.copyWith(weight: 80.0);
        expect(updated.weight, 80.0);
        expect(updated.age, testUser.age);
        expect(updated.gender, testUser.gender);
      });

      test('should create copy with updated activity level', () {
        final updated = testUser.copyWith(activityLevel: ActivityLevel.veryActive);
        expect(updated.activityLevel, ActivityLevel.veryActive);
        expect(updated.weight, testUser.weight);
      });

      test('should keep original values when no params provided', () {
        final copy = testUser.copyWith();
        expect(copy, testUser);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final user2 = User(
          id: 'user-123',
          weight: 75.0,
          age: 30,
          gender: Gender.male,
          activityLevel: ActivityLevel.moderate,
          dailyGoal: HydrationGoal(2.5),
        );
        expect(testUser, user2);
      });

      test('should not be equal when fields differ', () {
        final user2 = testUser.copyWith(weight: 80.0);
        expect(testUser, isNot(user2));
      });
    });

    group('toString', () {
      test('should return string representation', () {
        final str = testUser.toString();
        expect(str, contains('User'));
        expect(str, contains('user-123'));
        expect(str, contains('75.0'));
      });
    });
  });
}
