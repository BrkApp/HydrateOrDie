# Presentation Layer (UI & State Management)

**Partie de:** [Architecture Document](index.md)

---

## Responsabilité

Interface utilisateur, gestion d'état réactif, navigation

## Structure

```
lib/presentation/
├── providers/              # Riverpod StateNotifiers
│   ├── home_provider.dart
│   ├── onboarding_provider.dart
│   ├── avatar_state_provider.dart
│   ├── photo_validation_provider.dart
│   ├── notification_provider.dart
│   ├── streak_provider.dart
│   └── calendar_provider.dart
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── onboarding/
│   │   ├── avatar_selection_screen.dart
│   │   ├── weight_screen.dart
│   │   ├── age_screen.dart
│   │   ├── gender_screen.dart
│   │   ├── activity_screen.dart
│   │   ├── location_screen.dart
│   │   └── summary_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── avatar_display.dart
│   │       ├── progress_bar.dart
│   │       └── hydration_summary.dart
│   ├── photo/
│   │   ├── photo_validation_screen.dart
│   │   ├── glass_size_selection_screen.dart
│   │   └── feedback_screen.dart
│   ├── calendar/
│   │   ├── calendar_screen.dart
│   │   └── widgets/
│   │       ├── month_view.dart
│   │       └── day_detail_modal.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── notification_settings_screen.dart
│   │   └── achievements_screen.dart (V2)
│   └── common/
│       └── widgets/
│           ├── streak_display.dart
│           ├── custom_button.dart
│           └── loading_overlay.dart
└── navigation/
    └── app_router.dart         # GoRouter config
```

## Technologies

- Flutter Material Design 3
- Riverpod 2.x (State Management)
- GoRouter (Navigation 2.0)

## Règles

- ✅ Les screens ne contiennent AUCUNE logique métier
- ✅ Toute logique passe par les Use Cases via Providers
- ✅ Les widgets sont réutilisables et composables
- ✅ Les providers observent les repositories via Riverpod streams

---

[⬅️ Data Layer](data-layer.md) | [➡️ Core Layer](core-layer.md)
