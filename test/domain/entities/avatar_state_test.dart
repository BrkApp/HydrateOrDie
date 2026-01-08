import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';

void main() {
  group('AvatarState', () {
    group('getNextState', () {
      test('should transition fresh to tired', () {
        expect(AvatarState.fresh.getNextState(), AvatarState.tired);
      });

      test('should transition tired to dehydrated', () {
        expect(AvatarState.tired.getNextState(), AvatarState.dehydrated);
      });

      test('should transition dehydrated to dead', () {
        expect(AvatarState.dehydrated.getNextState(), AvatarState.dead);
      });

      test('should transition dead to ghost', () {
        expect(AvatarState.dead.getNextState(), AvatarState.ghost);
      });

      test('should transition ghost to fresh (resurrection)', () {
        expect(AvatarState.ghost.getNextState(), AvatarState.fresh);
      });
    });

    group('shouldDie', () {
      test('should return false if time < 6 hours', () {
        expect(AvatarState.fresh.shouldDie(const Duration(hours: 0)), false);
        expect(AvatarState.fresh.shouldDie(const Duration(hours: 2)), false);
        expect(AvatarState.fresh.shouldDie(const Duration(hours: 5)), false);
      });

      test('should return true if time >= 6 hours', () {
        expect(AvatarState.fresh.shouldDie(const Duration(hours: 6)), true);
        expect(AvatarState.fresh.shouldDie(const Duration(hours: 10)), true);
        expect(AvatarState.fresh.shouldDie(const Duration(hours: 24)), true);
      });
    });

    group('shouldBecomeGhost', () {
      test('should return true only for dead state', () {
        expect(AvatarState.fresh.shouldBecomeGhost(), false);
        expect(AvatarState.tired.shouldBecomeGhost(), false);
        expect(AvatarState.dehydrated.shouldBecomeGhost(), false);
        expect(AvatarState.dead.shouldBecomeGhost(), true);
        expect(AvatarState.ghost.shouldBecomeGhost(), false);
      });
    });

    group('getAssetPath', () {
      test('should return correct path for sports coach fresh', () {
        final path = AvatarState.fresh
            .getAssetPath(AvatarPersonality.sportsCoach);
        expect(path, 'assets/images/avatars/sportsCoach/fresh.png');
      });

      test('should return correct path for doctor tired', () {
        final path = AvatarState.tired
            .getAssetPath(AvatarPersonality.doctor);
        expect(path, 'assets/images/avatars/doctor/tired.png');
      });

      test('should return correct path for authoritarian mother dead', () {
        final path = AvatarState.dead
            .getAssetPath(AvatarPersonality.authoritarianMother);
        expect(path, 'assets/images/avatars/authoritarianMother/dead.png');
      });

      test('should return correct path for sarcastic friend ghost', () {
        final path = AvatarState.ghost
            .getAssetPath(AvatarPersonality.sarcasticFriend);
        expect(path, 'assets/images/avatars/sarcasticFriend/ghost.png');
      });
    });
  });
}
