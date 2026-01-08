import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';

void main() {
  group('AvatarPersonality', () {
    group('displayName', () {
      test('should return correct display name for authoritarianMother', () {
        expect(
          AvatarPersonality.authoritarianMother.displayName,
          'Mère Autoritaire',
        );
      });

      test('should return correct display name for sportsCoach', () {
        expect(
          AvatarPersonality.sportsCoach.displayName,
          'Coach Sportif',
        );
      });

      test('should return correct display name for doctor', () {
        expect(
          AvatarPersonality.doctor.displayName,
          'Docteur',
        );
      });

      test('should return correct display name for sarcasticFriend', () {
        expect(
          AvatarPersonality.sarcasticFriend.displayName,
          'Ami Sarcastique',
        );
      });
    });

    group('description', () {
      test('should return description for authoritarianMother', () {
        final description = AvatarPersonality.authoritarianMother.description;
        expect(description, isNotEmpty);
        expect(description, contains('Autoritaire'));
      });

      test('should return description for sportsCoach', () {
        final description = AvatarPersonality.sportsCoach.description;
        expect(description, isNotEmpty);
        expect(description, contains('Motivation'));
      });

      test('should return description for doctor', () {
        final description = AvatarPersonality.doctor.description;
        expect(description, isNotEmpty);
        expect(description, contains('scientifique'));
      });

      test('should return description for sarcasticFriend', () {
        final description = AvatarPersonality.sarcasticFriend.description;
        expect(description, isNotEmpty);
        expect(description, contains('Sarcasme'));
      });
    });

    test('should have 4 personality types', () {
      expect(AvatarPersonality.values.length, 4);
    });
  });
}
