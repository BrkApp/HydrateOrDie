import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/avatar.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';

void main() {
  group('Avatar', () {
    late Avatar testAvatar;
    late DateTime testTime;

    setUp(() {
      testTime = DateTime(2026, 1, 7, 12, 0);
      testAvatar = Avatar(
        id: 'sports_coach',
        name: 'Coach Mike',
        personality: AvatarPersonality.sportsCoach,
        currentState: AvatarState.fresh,
        lastDrinkTime: testTime,
        lastUpdated: testTime,
      );
    });

    group('constructor', () {
      test('should create avatar with all fields', () {
        expect(testAvatar.id, 'sports_coach');
        expect(testAvatar.name, 'Coach Mike');
        expect(testAvatar.personality, AvatarPersonality.sportsCoach);
        expect(testAvatar.currentState, AvatarState.fresh);
        expect(testAvatar.lastDrinkTime, testTime);
        expect(testAvatar.lastUpdated, testTime);
      });
    });

    group('calculateState', () {
      test('should return fresh for 0-2 hours', () {
        expect(
          testAvatar.calculateState(const Duration(hours: 0)),
          AvatarState.fresh,
        );
        expect(
          testAvatar.calculateState(const Duration(hours: 1)),
          AvatarState.fresh,
        );
        expect(
          testAvatar.calculateState(const Duration(hours: 1, minutes: 59)),
          AvatarState.fresh,
        );
      });

      test('should return tired for 2-4 hours', () {
        expect(
          testAvatar.calculateState(const Duration(hours: 2)),
          AvatarState.tired,
        );
        expect(
          testAvatar.calculateState(const Duration(hours: 3)),
          AvatarState.tired,
        );
        expect(
          testAvatar.calculateState(const Duration(hours: 3, minutes: 59)),
          AvatarState.tired,
        );
      });

      test('should return dehydrated for 4-6 hours', () {
        expect(
          testAvatar.calculateState(const Duration(hours: 4)),
          AvatarState.dehydrated,
        );
        expect(
          testAvatar.calculateState(const Duration(hours: 5)),
          AvatarState.dehydrated,
        );
        expect(
          testAvatar.calculateState(const Duration(hours: 5, minutes: 59)),
          AvatarState.dehydrated,
        );
      });

      test('should return dead for 6+ hours', () {
        expect(
          testAvatar.calculateState(const Duration(hours: 6)),
          AvatarState.dead,
        );
        expect(
          testAvatar.calculateState(const Duration(hours: 10)),
          AvatarState.dead,
        );
        expect(
          testAvatar.calculateState(const Duration(hours: 24)),
          AvatarState.dead,
        );
      });
    });

    group('shouldBecomeGhost', () {
      test('should return true when state is dead', () {
        final deadAvatar = testAvatar.copyWith(currentState: AvatarState.dead);
        expect(deadAvatar.shouldBecomeGhost(), true);
      });

      test('should return false when state is not dead', () {
        expect(testAvatar.shouldBecomeGhost(), false);
        expect(
          testAvatar.copyWith(currentState: AvatarState.tired).shouldBecomeGhost(),
          false,
        );
        expect(
          testAvatar.copyWith(currentState: AvatarState.ghost).shouldBecomeGhost(),
          false,
        );
      });
    });

    group('shouldResurrect', () {
      test('should return true when state is ghost', () {
        final ghostAvatar = testAvatar.copyWith(currentState: AvatarState.ghost);
        expect(ghostAvatar.shouldResurrect(), true);
      });

      test('should return false when state is not ghost', () {
        expect(testAvatar.shouldResurrect(), false);
        expect(
          testAvatar.copyWith(currentState: AvatarState.dead).shouldResurrect(),
          false,
        );
      });
    });

    group('copyWith', () {
      test('should create copy with updated state', () {
        final updated = testAvatar.copyWith(currentState: AvatarState.tired);
        expect(updated.currentState, AvatarState.tired);
        expect(updated.id, testAvatar.id);
        expect(updated.name, testAvatar.name);
      });

      test('should create copy with updated lastDrinkTime', () {
        final newTime = DateTime(2026, 1, 7, 14, 0);
        final updated = testAvatar.copyWith(lastDrinkTime: newTime);
        expect(updated.lastDrinkTime, newTime);
        expect(updated.currentState, testAvatar.currentState);
      });

      test('should keep original values when no params provided', () {
        final copy = testAvatar.copyWith();
        expect(copy, testAvatar);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final avatar2 = Avatar(
          id: 'sports_coach',
          name: 'Coach Mike',
          personality: AvatarPersonality.sportsCoach,
          currentState: AvatarState.fresh,
          lastDrinkTime: testTime,
          lastUpdated: testTime,
        );
        expect(testAvatar, avatar2);
      });

      test('should not be equal when fields differ', () {
        final avatar2 = testAvatar.copyWith(currentState: AvatarState.tired);
        expect(testAvatar, isNot(avatar2));
      });
    });

    group('toString', () {
      test('should return string representation', () {
        final str = testAvatar.toString();
        expect(str, contains('Avatar'));
        expect(str, contains('sports_coach'));
        expect(str, contains('Coach Mike'));
      });
    });
  });
}
