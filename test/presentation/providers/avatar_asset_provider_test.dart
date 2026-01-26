import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/avatar_personality.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/presentation/providers/avatar_asset_provider.dart';

void main() {
  group('AvatarAssetProvider', () {
    late AvatarAssetProvider provider;

    setUp(() {
      provider = AvatarAssetProvider();
    });

    group('getEmojiAsset()', () {
      test('should return correct emoji for authoritarianMother fresh', () {
        final result = provider.getEmojiAsset(
          AvatarPersonality.authoritarianMother,
          AvatarState.fresh,
        );
        expect(result, '👩😊');
      });

      test('should return correct emoji for sportsCoach tired', () {
        final result = provider.getEmojiAsset(
          AvatarPersonality.sportsCoach,
          AvatarState.tired,
        );
        expect(result, '💪😐');
      });

      test('should return correct emoji for doctor dehydrated', () {
        final result = provider.getEmojiAsset(
          AvatarPersonality.doctor,
          AvatarState.dehydrated,
        );
        expect(result, '🧑‍⚕️😟');
      });

      test('should return correct emoji for sarcasticFriend dead', () {
        final result = provider.getEmojiAsset(
          AvatarPersonality.sarcasticFriend,
          AvatarState.dead,
        );
        expect(result, '🤝💀');
      });

      test('should return ghost emoji for any personality in ghost state', () {
        for (final personality in AvatarPersonality.values) {
          final result = provider.getEmojiAsset(personality, AvatarState.ghost);
          expect(result, '👻', reason: 'Ghost state for ${personality.name}');
        }
      });

      test('should return emoji for all 20 combinations', () {
        // Test all 4 personalities × 5 states = 20 combinations
        for (final personality in AvatarPersonality.values) {
          for (final state in AvatarState.values) {
            final result = provider.getEmojiAsset(personality, state);
            expect(
              result.isNotEmpty,
              true,
              reason: 'Asset missing for ${personality.name}/${state.name}',
            );
          }
        }
      });
    });

    group('getAssetPath()', () {
      test('should return correct path for doctor fresh', () {
        final path = provider.getAssetPath(
          AvatarPersonality.doctor,
          AvatarState.fresh,
        );
        expect(path, 'assets/avatars/doctor/fresh.txt');
      });

      test('should return correct path for sportsCoach ghost', () {
        final path = provider.getAssetPath(
          AvatarPersonality.sportsCoach,
          AvatarState.ghost,
        );
        expect(path, 'assets/avatars/sportsCoach/ghost.txt');
      });

      test('should return correct path for authoritarianMother dehydrated', () {
        final path = provider.getAssetPath(
          AvatarPersonality.authoritarianMother,
          AvatarState.dehydrated,
        );
        expect(path, 'assets/avatars/authoritarianMother/dehydrated.txt');
      });

      test('should return correct path for sarcasticFriend tired', () {
        final path = provider.getAssetPath(
          AvatarPersonality.sarcasticFriend,
          AvatarState.tired,
        );
        expect(path, 'assets/avatars/sarcasticFriend/tired.txt');
      });

      test('should follow naming convention for all combinations', () {
        for (final personality in AvatarPersonality.values) {
          for (final state in AvatarState.values) {
            final path = provider.getAssetPath(personality, state);
            expect(
              path,
              startsWith('assets/avatars/${personality.name}/'),
              reason: 'Path format for ${personality.name}/${state.name}',
            );
            expect(
              path,
              endsWith('${state.name}.txt'),
              reason: 'Path format for ${personality.name}/${state.name}',
            );
          }
        }
      });
    });

    group('validateAllAssetsExist()', () {
      test('should return true when all 20 assets are mapped', () {
        expect(provider.validateAllAssetsExist(), true);
      });

      test('should validate all personalities have all states', () {
        // Ensure each personality has all 5 states
        for (final personality in AvatarPersonality.values) {
          for (final state in AvatarState.values) {
            // This should not throw
            expect(
              () => provider.getEmojiAsset(personality, state),
              returnsNormally,
              reason: 'Missing asset for ${personality.name}/${state.name}',
            );
          }
        }
      });
    });

    group('totalAssetCount', () {
      test('should return 20 (4 personalities × 5 states)', () {
        expect(provider.totalAssetCount, 20);
      });
    });

    group('Edge cases', () {
      test(
        'getEmojiAsset should handle all personality/state combinations',
        () {
          // Test authoritarianMother
          expect(
            provider.getEmojiAsset(
              AvatarPersonality.authoritarianMother,
              AvatarState.fresh,
            ),
            '👩😊',
          );
          expect(
            provider.getEmojiAsset(
              AvatarPersonality.authoritarianMother,
              AvatarState.tired,
            ),
            '👩😐',
          );
          expect(
            provider.getEmojiAsset(
              AvatarPersonality.authoritarianMother,
              AvatarState.dehydrated,
            ),
            '👩😟',
          );
          expect(
            provider.getEmojiAsset(
              AvatarPersonality.authoritarianMother,
              AvatarState.dead,
            ),
            '👩💀',
          );

          // Test sportsCoach
          expect(
            provider.getEmojiAsset(
              AvatarPersonality.sportsCoach,
              AvatarState.fresh,
            ),
            '💪😊',
          );
          expect(
            provider.getEmojiAsset(
              AvatarPersonality.sportsCoach,
              AvatarState.dehydrated,
            ),
            '💪😟',
          );

          // Test doctor
          expect(
            provider.getEmojiAsset(AvatarPersonality.doctor, AvatarState.fresh),
            '🧑‍⚕️😊',
          );
          expect(
            provider.getEmojiAsset(AvatarPersonality.doctor, AvatarState.dead),
            '🧑‍⚕️💀',
          );

          // Test sarcasticFriend
          expect(
            provider.getEmojiAsset(
              AvatarPersonality.sarcasticFriend,
              AvatarState.fresh,
            ),
            '🤝😊',
          );
          expect(
            provider.getEmojiAsset(
              AvatarPersonality.sarcasticFriend,
              AvatarState.dehydrated,
            ),
            '🤝😟',
          );
        },
      );

      test('should have unique emojis for each personality (except ghost)', () {
        final emojis = <String>{};

        for (final personality in AvatarPersonality.values) {
          for (final state in AvatarState.values) {
            if (state != AvatarState.ghost) {
              final emoji = provider.getEmojiAsset(personality, state);
              expect(
                emojis.contains(emoji),
                false,
                reason:
                    'Duplicate emoji $emoji for ${personality.name}/${state.name}',
              );
              emojis.add(emoji);
            }
          }
        }

        // Should have 16 unique emojis (4 personalities × 4 non-ghost states)
        expect(emojis.length, 16);
      });

      test('ghost state should use same emoji for all personalities', () {
        final ghostEmoji = provider.getEmojiAsset(
          AvatarPersonality.doctor,
          AvatarState.ghost,
        );

        for (final personality in AvatarPersonality.values) {
          expect(
            provider.getEmojiAsset(personality, AvatarState.ghost),
            ghostEmoji,
            reason: 'Ghost emoji should be consistent',
          );
        }
      });
    });

    group('Asset path structure', () {
      test('should maintain consistent directory structure', () {
        final paths = <String>[];

        for (final personality in AvatarPersonality.values) {
          for (final state in AvatarState.values) {
            paths.add(provider.getAssetPath(personality, state));
          }
        }

        // All paths should start with assets/avatars/
        for (final path in paths) {
          expect(path.startsWith('assets/avatars/'), true);
          expect(path.endsWith('.txt'), true);
        }

        // Should have 20 unique paths
        expect(paths.toSet().length, 20);
      });
    });
  });
}
