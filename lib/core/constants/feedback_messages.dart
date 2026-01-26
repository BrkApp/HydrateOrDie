import '../../domain/entities/avatar_personality.dart';

/// Feedback messages for positive reinforcement after hydration
///
/// Each personality has a unique encouraging message shown on FeedbackScreen
/// after successful hydration validation.
const kFeedbackMessages = {
  AvatarPersonality.authoritarianMother:
      "Bien joué mon chéri ! Continue comme ça.",
  AvatarPersonality.sportsCoach: "YEAH ! Excellent ! Tu gères !",
  AvatarPersonality.doctor: "Excellent réflexe. Ton corps te remercie.",
  AvatarPersonality.sarcasticFriend:
      "Wow, tu bois de l'eau ! T'es un champion 🏆",
};
