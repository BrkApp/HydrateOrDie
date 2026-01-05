import type { NotificationIntensity, MessageTone } from '../types';

type MessagesMap = {
  [key in MessageTone]: {
    [key in NotificationIntensity]: string[];
  };
};

export const NOTIFICATION_MESSAGES: MessagesMap = {
  PUNITIVE: {
    NORMAL: [
      '💧 Il est temps de boire. Ne me fais pas insister.',
      '⚠️ Hydratation requise. Maintenant.',
      '🚰 Bois ou assume les conséquences.',
      '⏰ Reminder : ton corps a besoin d\'eau. Agis.',
    ],
    WARNING: [
      '⚠️ ATTENTION : Dernière chance avant spam mode.',
      '🔴 Tu as 5 minutes. Après, ça devient sérieux.',
      '⏱️ AVERTISSEMENT : Le spam arrive si tu ne bois pas.',
      '🚨 Dernier avertissement poli.',
    ],
    SPAM: [
      '🚨 SPAM MODE ACTIVÉ. BOIS. MAINTENANT.',
      '💀 DÉSHYDRATATION CRITIQUE. AGIS.',
      '⛔ TU IGNORES ENCORE ? VRAIMENT ?',
      '🔴 EAU. VERRE. BOUCHE. MAINTENANT.',
      '💥 CHAQUE MINUTE SANS EAU = UNE NOTIFICATION.',
    ],
    AGGRESSIVE: [
      '🔥 SPAM LEVEL 9000. BOIS OU DÉSINSTALLE.',
      '💀💀💀 TON CORPS TE DÉTESTE.',
      '🚨🚨🚨 URGENCE HYDRIQUE ABSOLUE.',
      '⚰️ DÉSHYDRATATION = GAME OVER.',
      '💣 DERNIÈRE NOTIFICATION AVANT MELTDOWN.',
    ],
  },
  MOTIVATIONAL: {
    NORMAL: [
      '💪 Reste hydraté, reste performant !',
      '✨ Un verre d\'eau = un pas vers tes objectifs !',
      '🎯 Tu peux le faire ! Hydrate-toi !',
      '🌟 Ton corps te remerciera !',
    ],
    WARNING: [
      '⚡ Allez, champion ! Un petit effort !',
      '🏆 Ne lâche pas maintenant ! Bois un verre !',
      '💎 Tu es si proche de ton objectif !',
      '🔥 Reste focus ! Hydrate-toi !',
    ],
    SPAM: [
      '🚀 ALLEZ ALLEZ ALLEZ ! TU PEUX LE FAIRE !',
      '⚡ CHAMPION ! UN VERRE MAINTENANT !',
      '🎯 TU Y ES PRESQUE ! BOIS !',
      '💪 FORCE ET HYDRATATION ! GO !',
    ],
    AGGRESSIVE: [
      '🔥🔥🔥 CHAMPION MODE ACTIVÉ !',
      '⚡⚡⚡ HYDRATATION EXTRÊME !',
      '💪💪💪 TU ES CAPABLE !',
      '🚀🚀🚀 FONCE !',
    ],
  },
  FRIENDLY: {
    NORMAL: [
      '😊 Hey ! C\'est l\'heure de boire un coup !',
      '💙 Un petit verre d\'eau ? Ça fait du bien !',
      '🌊 Pense à t\'hydrater, ami !',
      '☺️ Ton corps te demande de l\'eau !',
    ],
    WARNING: [
      '😅 Euh... tu as oublié de boire ?',
      '🙏 S\'il te plaît, bois un verre !',
      '😬 Ça fait un moment... un petit verre ?',
      '💧 Allez, fais-moi plaisir !',
    ],
    SPAM: [
      '😰 OK MAINTENANT JE M\'INQUIÈTE ! BOIS !',
      '😱 S\'IL TE PLAÎT ! EAU ! VITE !',
      '🆘 AIDE-MOI À T\'AIDER ! BOIS !',
      '😭 POURQUOI TU M\'IGNORES ?',
    ],
    AGGRESSIVE: [
      '😤😤😤 TU ME FORCES À SPAM !',
      '😡😡😡 BOIS OU JE CONTINUE !',
      '🤬 C\'EST PAS COMPLIQUÉ POURTANT !',
      '😠 TU L\'AURAS VOULU !',
    ],
  },
  PROFESSIONAL: {
    NORMAL: [
      '📋 Rappel : Hydratation recommandée.',
      '⏰ Planning hydratation : maintenant.',
      '📊 Objectif journalier : en cours.',
      '✅ Action requise : consommer 250ml.',
    ],
    WARNING: [
      '⚠️ Alerte : Retard d\'hydratation détecté.',
      '📈 Performance compromise. Action requise.',
      '🔔 Notification prioritaire : hydratation.',
      '⏱️ Délai expirant : 5 minutes.',
    ],
    SPAM: [
      '🚨 ALERTE CRITIQUE : HYDRATATION IMMÉDIATE.',
      '⛔ PROTOCOLE D\'URGENCE ACTIVÉ.',
      '📢 INTERVENTION REQUISE : EAU.',
      '🔴 NIVEAU D\'ALERTE MAXIMUM.',
    ],
    AGGRESSIVE: [
      '🚨🚨🚨 CODE ROUGE : HYDRATATION.',
      '⚠️⚠️⚠️ URGENCE ABSOLUE.',
      '🔴🔴🔴 PROTOCOLE DE SURVIE.',
      '💀 SITUATION CRITIQUE.',
    ],
  },
  AGGRESSIVE: {
    NORMAL: [
      '😠 Bois. Maintenant.',
      '🔥 Eau. Verre. Go.',
      '💢 Tu sais ce que tu as à faire.',
      '⚡ Arrête de procrastiner.',
    ],
    WARNING: [
      '💥 DERNIÈRE CHANCE SYMPA.',
      '🔴 APRÈS C\'EST LE SPAM.',
      '⚠️ TU VEUX VRAIMENT M\'ÉNERVER ?',
      '💢 BOIS OU ASSUME.',
    ],
    SPAM: [
      '🔥🔥🔥 TU L\'AURAS CHERCHÉ.',
      '💀 BOIS OU JE SPAM À MORT.',
      '⚡⚡⚡ MAINTENANT. TOUT DE SUITE.',
      '💥💥💥 EAU. MAINTENANT.',
    ],
    AGGRESSIVE: [
      '🔥💀⚡ GAME OVER SI TU BOIS PAS.',
      '💣💣💣 SPAM INFINI ACTIVÉ.',
      '⚰️⚰️⚰️ RIP TON HYDRATATION.',
      '🚨💀🔥 TU MEURS DE SOIF LÀ.',
    ],
  },
  HUMOROUS: {
    NORMAL: [
      '🤡 Bois ou je t\'envoie un clown.',
      '🦆 Même les canards boivent plus que toi.',
      '🐪 T\'es pas un chameau, bois.',
      '🌵 Tu veux devenir un cactus ?',
    ],
    WARNING: [
      '🎪 Le cirque arrive si tu bois pas.',
      '🤖 BOOP BEEP. EAU REQUISE. BOOP.',
      '🦖 Les dinosaures sont morts de soif.',
      '🎭 Dernière représentation avant le spam.',
    ],
    SPAM: [
      '🤡🤡🤡 LE CIRQUE EST LÀ !',
      '🦆🦆🦆 COIN COIN BOIS !',
      '🐪🐪🐪 CHAMEAU MODE OFF !',
      '🌵🌵🌵 CACTUS EN APPROCHE !',
    ],
    AGGRESSIVE: [
      '🤡💀🔥 LE CLOWN EST ÉNERVÉ !',
      '🦆💥⚡ COIN COIN ATTACK !',
      '🐪🚨💣 CHAMEAU RAGE !',
      '🌵💀🔥 CACTUS OF DOOM !',
    ],
  },
};

export function getRandomMessage(
  intensity: NotificationIntensity,
  tone: MessageTone
): string {
  const messages = NOTIFICATION_MESSAGES[tone][intensity];
  return messages[Math.floor(Math.random() * messages.length)];
}
