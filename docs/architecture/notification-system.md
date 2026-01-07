# Notification Architecture

**Partie de:** [Architecture Document](index.md)

---

## Local Notifications System

```
┌────────────────────────────────────────────────────┐
│         NOTIFICATION ESCALATION SYSTEM             │
├────────────────────────────────────────────────────┤
│                                                    │
│  Timer (Background) - Every 15min                  │
│       │                                            │
│       ▼                                            │
│  CalculateNotificationLevelUseCase                 │
│       │                                            │
│       ├──► Niveau CALM (0-2h)                     │
│       │    Fréquence: 1x/heure                    │
│       │    Ton: Calme, doux                        │
│       │                                            │
│       ├──► Niveau CONCERNED (2-4h)                │
│       │    Fréquence: 1x/30min                    │
│       │    Ton: Préoccupé                         │
│       │                                            │
│       ├──► Niveau DRAMATIC (4-6h)                 │
│       │    Fréquence: 1x/15min                    │
│       │    Ton: Mélodramatique, caps lock         │
│       │                                            │
│       └──► Niveau CHAOS (6h+)                     │
│            Fréquence: 5-10min RANDOM              │
│            Ton: SPAM, vulgarité censurée          │
│            Vibrations: Pattern agaçant             │
│                                                    │
│  ScheduleNotificationUseCase                       │
│       │                                            │
│       ▼                                            │
│  flutter_local_notifications                       │
│       │                                            │
│       ▼                                            │
│  OS Native Notification (iOS/Android)              │
└────────────────────────────────────────────────────┘

PAUSE NOCTURNE: 22h00 - 7h00 (configurable)
```

## Notification Message Generation

```dart
// Pattern Provider
class NotificationMessageProvider {
  String getMessage(AvatarPersonality personality, NotificationLevel level) {
    final messages = _messagesMap[personality]![level]!;
    return messages[Random().nextInt(messages.length)];
  }

  // 4 avatars × 4 niveaux = 16 pools de messages
  // Chaque pool contient 5-10 messages variés
}
```

---

[⬅️ Data Architecture](data-architecture.md) | [➡️ Photo Validation](photo-validation.md)
