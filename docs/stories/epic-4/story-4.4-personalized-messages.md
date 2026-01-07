# Story 4.4: Messages Personnalisés par Avatar et Niveau

**Epic:** Epic 4 - Système de Notifications Punitives
**Story ID:** 4.4
**Status:** Not Started
**Priority:** High
**Estimated Effort:** 5 hours

---

## User Story

**As a** user,
**I want** que les messages de notification reflètent la personnalité de mon avatar,
**so that** l'expérience est cohérente et mémorable.

---

## Acceptance Criteria

1. Une classe `NotificationMessageProvider` génère les messages basés sur `AvatarPersonality` et `NotificationLevel`
2. Chaque combinaison (4 avatars × 4 niveaux = 16 cas) a un pool de 5-10 messages variés
3. **Mère Autoritaire** : Calm: "Mon chéri, pense à boire de l'eau 💧" / Concerned: "Ça fait 3h que tu n'as pas bu ! Je m'inquiète..." / Dramatic: "TU VEUX FINIR AUX URGENCES ?! BOIS MAINTENANT !" / Chaos: "P*T@IN MAIS BOIS !!! 😤😤😤"
4. **Coach Sportif** : Calm: "Hydrate-toi champion ! 💪" / Concerned: "Allez, un p'tit verre ! Ton corps en a besoin !" / Dramatic: "NO PAIN NO GAIN MAIS LÀ C'EST JUSTE STUPIDE ! BOIS !!" / Chaos: "BOUUUUGE-TOI !!! 🔥 EAU MAINTENANT !!! 🔥"
5. **Docteur** : Calm: "Je vous recommande de vous hydrater." / Concerned: "Vos reins souffrent. Hydratation nécessaire." / Dramatic: "DÉSHYDRATATION CRITIQUE ! Intervention requise !" / Chaos: "CODE ROUGE ! H2O STAT !!! 🚨"
6. **Ami Sarcastique** : Calm: "Yo, tu devrais boire un coup (d'eau hein)" / Concerned: "Sérieux, tu ressembles à une plante morte là..." / Dramatic: "Bon bah RIP toi je suppose 💀 C'était sympa te connaître" / Chaos: "BORDEL BOIS OU JE DÉMISSIONNE !!! 😡"
7. Les messages incluent emojis, vulgarité censurée (p*t@in, b*rd*l), et références pop culture
8. La méthode `getRandomMessage(personality, level)` retourne un message aléatoire du pool
9. Tests unitaires valident qu'un message existe pour chaque combinaison et contient le bon ton

---

## Technical Notes

- Location: `lib/domain/providers/notification_message_provider.dart`
- Structure: Map of maps (personality → level → list of messages)
- Randomization: Use Random() for variety
- Tests: `test/domain/providers/notification_message_provider_test.dart`

---

## Dependencies

- Story 1.2 (Avatar personalities) doit être complétée
- Story 4.1 (NotificationLevel enum) doit être complétée

---

## Definition of Done

- [ ] Tous les AC validés
- [ ] Tests unitaires passent
- [ ] All 16 combinations covered
- [ ] Messages reviewed for tone
- [ ] Code suit conventions
- [ ] PM approval

---

## Links

- Epic: [epic-4-notifications.md](../../epics/epic-4-notifications.md)
- Previous: [story-4.3-notification-state-repository.md](story-4.3-notification-state-repository.md)
- Next: [story-4.5-notification-scheduling.md](story-4.5-notification-scheduling.md)
