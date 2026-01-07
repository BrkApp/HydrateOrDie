# Domain Layer (Business Logic - Pure Dart)

**Partie de:** [Architecture Document](index.md)

---

## Responsabilité

Logique métier pure, indépendante de Flutter et Firebase

## Structure

```
lib/domain/
├── entities/
│   ├── user.dart
│   ├── avatar.dart
│   ├── hydration_goal.dart
│   ├── streak.dart
│   ├── notification_state.dart
│   └── achievement.dart (V2)
├── repositories/               # INTERFACES ONLY
│   ├── avatar_repository.dart
│   ├── user_profile_repository.dart
│   ├── hydration_log_repository.dart
│   ├── streak_repository.dart
│   ├── notification_state_repository.dart
│   └── photo_storage_repository.dart
└── use_cases/
    ├── auth/
    │   ├── sign_up_use_case.dart
    │   ├── sign_in_use_case.dart
    │   └── sign_out_use_case.dart
    ├── avatar/
    │   ├── get_avatar_use_case.dart
    │   ├── update_avatar_state_use_case.dart
    │   └── select_avatar_use_case.dart
    ├── hydration/
    │   ├── record_hydration_use_case.dart
    │   ├── get_todays_logs_use_case.dart
    │   ├── calculate_hydration_goal_use_case.dart
    │   └── get_hydration_progress_use_case.dart
    ├── streak/
    │   ├── update_streak_use_case.dart
    │   ├── get_current_streak_use_case.dart
    │   └── get_monthly_status_use_case.dart
    ├── notifications/
    │   ├── calculate_notification_level_use_case.dart
    │   ├── schedule_notification_use_case.dart
    │   ├── get_notification_message_use_case.dart
    │   └── cancel_notifications_use_case.dart
    └── profile/
        ├── create_user_profile_use_case.dart
        ├── update_user_profile_use_case.dart
        ├── delete_user_data_use_case.dart
        └── get_user_profile_use_case.dart
```

## Règles Strictes

- ✅ **Zero dépendance Flutter** : Pure Dart uniquement
- ✅ **Zero dépendance Firebase** : Abstraction via interfaces
- ✅ **100% Testable** : Tous les use cases mockables via DI
- ✅ **Single Responsibility** : 1 use case = 1 action métier

## Exemple Use Case Pattern

```dart
// Interface Repository (dans domain/)
abstract class AvatarRepository {
  Future<Avatar> getAvatar();
  Future<void> updateAvatarState(AvatarState state);
}

// Use Case (dans domain/)
class UpdateAvatarStateUseCase {
  final AvatarRepository _repository;

  UpdateAvatarStateUseCase(this._repository);

  Future<void> execute(Duration timeSinceLastDrink) async {
    final newState = _calculateState(timeSinceLastDrink);
    await _repository.updateAvatarState(newState);
  }

  AvatarState _calculateState(Duration time) {
    // Pure business logic
    if (time.inHours < 2) return AvatarState.fresh;
    if (time.inHours < 4) return AvatarState.tired;
    if (time.inHours < 6) return AvatarState.dehydrated;
    return AvatarState.dead;
  }
}
```

---

[⬅️ Vue d'Ensemble](overview.md) | [➡️ Data Layer](data-layer.md)
