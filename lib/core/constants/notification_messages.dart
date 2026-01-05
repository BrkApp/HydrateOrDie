import 'dart:math';
import '../../data/models/notification_settings.dart';

/// Messages de notifications selon l'intensité et le ton
class NotificationMessages {
  NotificationMessages._();

  static final _random = Random();

  /// Récupère un message selon l'intensité et le ton
  static String getMessage({
    required NotificationIntensity intensity,
    required MessageTone tone,
  }) {
    switch (intensity) {
      case NotificationIntensity.normal:
        return _getNormalMessage(tone);
      case NotificationIntensity.warning:
        return _getWarningMessage(tone);
      case NotificationIntensity.spam:
        return _getSpamMessage(tone);
      case NotificationIntensity.aggressive:
        return _getAggressiveMessage(tone);
    }
  }

  // ==================== NORMAL ====================

  static String _getNormalMessage(MessageTone tone) {
    final messages = _normalMessages[tone] ?? _normalMessages[MessageTone.punitive]!;
    return messages[_random.nextInt(messages.length)];
  }

  static final Map<MessageTone, List<String>> _normalMessages = {
    MessageTone.punitive: [
      "C'est l'heure de boire... ou pas. Fais comme tu veux. 💧",
      "Ton corps te supplie. Mais bon, c'est toi qui vois.",
      "Ça fait un moment. Tu te déshydrates tranquillement.",
      "L'eau t'attend. Elle s'ennuie sans toi.",
      "Rappel: tu es fait à 60% d'eau. Penses-y.",
      "Hydratation check. Spoiler: tu as soif.",
      "Alerte déshydratation niveau 1. Bois ou assume.",
    ],
    MessageTone.motivational: [
      "💪 C'est le moment de t'hydrater champion!",
      "🌟 Une gorgée pour ton bien-être!",
      "✨ Prends soin de toi, bois un verre!",
      "🎯 Continue ta série, reste hydraté!",
      "🔥 Tu assures! Un verre d'eau?",
      "💙 Ton corps te remerciera!",
      "🌈 Hydrate-toi et brille!",
    ],
    MessageTone.friendly: [
      "Hey! Ça te dit un petit verre? 😊",
      "Coucou! On boit un coup? 💧",
      "Salut! L'eau t'appelle! 🌊",
      "C'est l'heure de la pause eau! ☺️",
      "Un petit verre ça fait du bien! 💙",
      "N'oublie pas de boire ami! 🤗",
    ],
    MessageTone.professional: [
      "Rappel d'hydratation programmé.",
      "Il est temps de boire de l'eau.",
      "Notification: hydratation requise.",
      "Rappel: objectif quotidien en cours.",
      "Pause hydratation recommandée.",
    ],
  };

  // ==================== WARNING ====================

  static String _getWarningMessage(MessageTone tone) {
    final messages = _warningMessages[tone] ?? _warningMessages[MessageTone.punitive]!;
    return messages[_random.nextInt(messages.length)];
  }

  static final Map<MessageTone, List<String>> _warningMessages = {
    MessageTone.punitive: [
      "⚠️ Deuxième avertissement. Bois. Maintenant.",
      "Tu ignores les rappels? Mauvaise idée.",
      "Ta déshydratation s'intensifie. Intelligent.",
      "C'est un jeu pour toi? Bois.",
      "Ignorance niveau 2. L'eau. Maintenant.",
      "Tu veux vraiment que je m'énerve?",
      "Dernier avertissement avant spam mode. Bois.",
    ],
    MessageTone.motivational: [
      "⚠️ Tu es capable! Ne lâche pas!",
      "💪 Allez, un petit effort!",
      "🎯 Reste focus sur ton objectif!",
      "✨ Tu y es presque, continue!",
      "💙 Ton corps compte sur toi!",
      "🔥 Ne perds pas ta série!",
    ],
    MessageTone.friendly: [
      "Hey, tu m'as oublié? 😅",
      "Ça va? Tu as besoin d'aide? 💧",
      "Je m'inquiète un peu là... 😊",
      "N'oublie pas notre deal! 💙",
      "Allez, juste un verre! 🥺",
    ],
    MessageTone.professional: [
      "⚠️ Rappel important: hydratation requise.",
      "Alerte: délai dépassé.",
      "Attention: objectif non atteint.",
      "Rappel prioritaire: boire de l'eau.",
    ],
  };

  // ==================== SPAM ====================

  static String _getSpamMessage(MessageTone tone) {
    final messages = _spamMessages[tone] ?? _spamMessages[MessageTone.punitive]!;
    return messages[_random.nextInt(messages.length)];
  }

  static final Map<MessageTone, List<String>> _spamMessages = {
    MessageTone.punitive: [
      "🚨 SPAM MODE ACTIVÉ. BOIS. MAINTENANT.",
      "🔥 TU L'AURAS VOULU. L'EAU. MAINTENANT.",
      "⚠️ MODE INTENSIF. BOIS OU SOUFFRE.",
      "💀 DÉSHYDRATATION CRITIQUE. AGIS.",
      "🚨 SPAM TOUTES LES 5 MIN. BOIS.",
      "⚡ J'AI TOUT MON TEMPS. ET TOI?",
      "🔔 DING DING DING. L'EAU. MAINTENANT.",
      "💣 SPAM MODE: NIVEAU 1. BOIS.",
      "⏰ TIC TAC. 5 MINUTES. BOIS.",
      "🎺 DOOT DOOT. C'EST L'HEURE.",
    ],
    MessageTone.motivational: [
      "💪 ALLEZ! TU PEUX LE FAIRE!",
      "🔥 C'EST IMPORTANT! BOIS!",
      "⚡ ACTION IMMÉDIATE REQUISE!",
      "🎯 NE PERDS PAS TOUT!",
      "💙 TON CORPS A BESOIN DE TOI!",
      "✨ MAINTENANT OU JAMAIS!",
    ],
    MessageTone.friendly: [
      "STP STP STP BOIS! 🥺",
      "Je t'en supplie! 💙",
      "S'il te plaît! Un verre! 💧",
      "J'insiste vraiment! 😭",
      "Allez quoi! 🙏",
    ],
    MessageTone.professional: [
      "🚨 ALERTE CRITIQUE: Hydratation requise.",
      "⚠️ ACTION IMMÉDIATE NÉCESSAIRE.",
      "🔴 PRIORITÉ HAUTE: Boire de l'eau.",
      "⏰ DÉLAI DÉPASSÉ: Action requise.",
    ],
    MessageTone.aggressive: [
      "🔥 BOIS OU JE TE SPAM À MORT.",
      "💀 TU VAS MOURIR DE SOIF IDIOT.",
      "⚡ L'EAU. MAINTENANT. POINT FINAL.",
      "💣 TU ME TESTES? BOIS.",
      "🚨 ARRÊTE DE M'IGNORER. BOIS.",
      "⚠️ JE VAIS DÉTRUIRE TON TÉLÉPHONE.",
    ],
  };

  // ==================== AGGRESSIVE ====================

  static String _getAggressiveMessage(MessageTone tone) {
    final messages = _aggressiveMessages[tone] ?? _aggressiveMessages[MessageTone.punitive]!;
    return messages[_random.nextInt(messages.length)];
  }

  static final Map<MessageTone, List<String>> _aggressiveMessages = {
    MessageTone.punitive: [
      "🔥🔥🔥 MODE ULTIME. BOIS. MAINTENANT. 🔥🔥🔥",
      "💀 TU VEUX VRAIMENT MOURIR?! BOIS!!!",
      "⚡⚡⚡ SPAM LEVEL 9000. L'EAU. NOW.",
      "🚨🚨🚨 URGENCE ABSOLUE. BOIS.",
      "💣💣💣 TU L'AURAS CHERCHÉ.",
      "⏰ CHAQUE. 2. MINUTES. BOIS.",
      "🎺🎺🎺 SPAM SYMPHONY. BOIS.",
      "🔔 NOTIFICATION N°${_random.nextInt(100) + 50}. BOIS.",
      "⚠️ J'AI GAGNÉ. TU AS PERDU. BOIS.",
      "💀 GAME OVER. INSERT WATER. CONTINUE?",
    ],
    MessageTone.motivational: [
      "💪💪💪 TU ES PLUS FORT QUE ÇA!!!",
      "🔥🔥🔥 ALLEZ!!! TU PEUX!!!",
      "⚡⚡⚡ NE LÂCHE RIEN!!!",
      "🎯🎯🎯 MAINTENANT!!!",
    ],
    MessageTone.aggressive: [
      "🔥💀 BOIS AVANT QUE JE BRIQUE TON TEL.",
      "⚡💣 TU VEUX TESTER MA PATIENCE?!",
      "🚨⚠️ DERNIÈRE CHANCE AVANT L'APOCALYPSE.",
      "💀🔥 JE VAIS TE SPAMMER DANS TES RÊVES.",
      "⚡💣 L'EAU OU LA MORT. CHOISIS.",
    ],
  };

  // ==================== SUCCESS ====================

  /// Messages de succès après avoir bu
  static String getSuccessMessage(MessageTone tone) {
    final messages = _successMessages[tone] ?? _successMessages[MessageTone.punitive]!;
    return messages[_random.nextInt(messages.length)];
  }

  static final Map<MessageTone, List<String>> _successMessages = {
    MessageTone.punitive: [
      "Enfin. C'était pas trop tôt.",
      "Bon. T'as survécu. Pour l'instant.",
      "Ok. Spam désactivé. Temporairement.",
      "Bien. Tu apprends.",
      "Validé. La prochaine fois, écoute.",
    ],
    MessageTone.motivational: [
      "🎉 Excellent! Tu gères!",
      "💪 Bravo champion!",
      "✨ Parfait! Continue!",
      "🔥 Tu assures grave!",
      "🌟 Super! Bien joué!",
    ],
    MessageTone.friendly: [
      "Merci! Ça fait plaisir! 💙",
      "Top! Tu es génial! 😊",
      "Super! À tout à l'heure! 💧",
      "Nickel! Continue! 🌊",
    ],
    MessageTone.professional: [
      "Hydratation validée.",
      "Objectif intermédiaire atteint.",
      "Confirmation reçue.",
      "Action complétée avec succès.",
    ],
    MessageTone.aggressive: [
      "ENFIN. BORDEL.",
      "C'ÉTAIT PAS COMPLIQUÉ.",
      "OK. TRÊVE TEMPORAIRE.",
      "BIEN. TU SUIS LES ORDRES.",
    ],
  };

  // ==================== FAILURE ====================

  /// Messages d'échec de validation photo
  static String getFailureMessage(MessageTone tone) {
    final messages = _failureMessages[tone] ?? _failureMessages[MessageTone.punitive]!;
    return messages[_random.nextInt(messages.length)];
  }

  static final Map<MessageTone, List<String>> _failureMessages = {
    MessageTone.punitive: [
      "🚫 TRICHE DÉTECTÉE. Nice try.",
      "❌ C'est pas de l'eau ça. Recommence.",
      "🚫 Tu me prends pour un idiot?",
      "❌ Pas de verre détecté. Essaie encore.",
      "🚫 Échec. Montre-moi vraiment l'eau.",
      "❌ Mauvaise photo. Réessaie.",
    ],
    MessageTone.motivational: [
      "❌ Pas tout à fait! Réessaie!",
      "🔄 Reprends la photo!",
      "❌ Presque! Encore une fois!",
      "🔄 Nouvelle tentative!",
    ],
    MessageTone.friendly: [
      "❌ Oups! Recommence! 😊",
      "🔄 Pas tout à fait ça! 💙",
      "❌ Réessaie stp! 💧",
    ],
    MessageTone.professional: [
      "❌ Validation échouée.",
      "🔄 Photo non conforme.",
      "❌ Détection impossible.",
    ],
    MessageTone.aggressive: [
      "🚫 TU CROIS QUE JE SUIS CON?!",
      "❌ ARRÊTE DE TRICHER ENFOIRÉ.",
      "🚫 ÇA C'EST PAS DE L'EAU IDIOT.",
    ],
  };

  // ==================== GOAL REACHED ====================

  /// Messages de félicitations pour objectif atteint
  static String getGoalReachedMessage(MessageTone tone) {
    final messages = _goalReachedMessages[tone] ?? _goalReachedMessages[MessageTone.punitive]!;
    return messages[_random.nextInt(messages.length)];
  }

  static final Map<MessageTone, List<String>> _goalReachedMessages = {
    MessageTone.punitive: [
      "🎯 Objectif atteint. Enfin. T'as bien fait.",
      "✅ Mission accomplie. Pas trop tôt.",
      "🏆 Objectif validé. T'es pas si nul.",
      "🎉 Bien. Tu sais écouter finalement.",
      "✨ Objectif du jour. Bravo. Pour une fois.",
    ],
    MessageTone.motivational: [
      "🏆🎉 OBJECTIF ATTEINT! TU ES INCROYABLE!",
      "🎯✨ PARFAIT! TU GÈRES GRAVE!",
      "💪🔥 CHAMPION! OBJECTIF VALIDÉ!",
      "🌟💙 BRAVO! TU ES AU TOP!",
      "🎊🎈 EXCELLENT! CONTINUE COMME ÇA!",
    ],
    MessageTone.friendly: [
      "🎉 Yes! Objectif atteint! 💙",
      "🏆 Trop fort! Tu as réussi! 😊",
      "✨ Super! Mission accomplie! 🌟",
      "💧 Génial! Tu es au top! 🎯",
    ],
    MessageTone.professional: [
      "✅ Objectif quotidien: Complété.",
      "🎯 Mission accomplie.",
      "✅ Cible atteinte.",
      "🏆 Performance validée.",
    ],
    MessageTone.aggressive: [
      "🎯 ENFIN BORDEL. OBJECTIF ATTEINT.",
      "✅ BIEN. T'AS SURVÉCU AUJOURD'HUI.",
      "🏆 OK. T'AS ASSURÉ. POUR UNE FOIS.",
    ],
  };
}
