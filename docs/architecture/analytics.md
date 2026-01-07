# Analytics & Monitoring

**Partie de:** [Architecture Document](index.md)

---

## Events Tracked (Firebase Analytics)

### User Events

- `app_open`
- `onboarding_completed`
- `avatar_selected` (props: avatarId, personality)
- `hydration_validated` (props: glassSize, photoTaken)
- `notification_sent` (props: level, personality, timeSinceLastDrink)
- `notification_opened`
- `streak_milestone` (props: days)
- `avatar_died`
- `avatar_resurrected`
- `goal_achieved` (props: volumeTotal, percentOver)

### Technical Events

- `photo_validation_failed` (props: reason)
- `sync_failed` (props: operation, error)
- `permission_denied` (props: permissionType)

### Crashlytics

- Automatic crash reports
- Custom logs pour debug

---

[⬅️ Security & Auth](security-auth.md) | [➡️ Deployment & CI/CD](deployment.md)
