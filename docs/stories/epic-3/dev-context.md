# Epic 3 - Dev Context

**Epic:** Epic 3 - Validation Photo & Feedback Positif
**Date Début:** 2026-01-15
**Dernière MAJ:** 2026-01-19
**Branche Actuelle:** `feature/epic-3-hydration-logging`
**Tag:** `epic-2-hotfix-4` (sur main)

---

## 📍 État Actuel

### Epics Précédents
- ✅ **Epic 1:** Core Avatar System (8/8 stories) - MERGED
- ✅ **Epic 2:** User Onboarding (10/10 stories + 4 hotfixes) - MERGED

### Epic 3 Progress
**Stories:** 6/10 complétées (60%)
- ✅ Story 3.1 - Hydration Log Model (créé pendant Epic 1) - sur main
- ✅ Story 3.2 - Hydration Log Repository (CRUD SQLite) - sur main
- ✅ Story 3.3 - Camera Interface (PhotoValidationScreen) - sur main
- ✅ Story 3.4 - Photo Capture Storage (CapturePhotoUseCase + cleanup) - sur feature branch
- 🔜 Story 3.5 - Glass Detection (Mock ML - optionnelle MVP)
- 🚀 Story 3.6 - Record Hydration (RecordHydrationUseCase) - EN COURS
- 🔜 Story 3.7 - Avatar Feedback Animation
- ✅ Story 3.8 - Drink Button (HomeScreen navigation) - sur main
- 🔜 Story 3.9 - Glass Size Selection
- ✅ Story 3.10 - Camera Permissions (CameraPermissionService) - sur main

---

## 🏗️ Architecture Existante

### Domain Layer (lib/domain/)

**Entities:**
```
entities/
├── avatar_personality.dart       ✅ Epic 1
├── avatar_state.dart             ✅ Epic 1
├── gender.dart                   ✅ Epic 2
├── activity_level.dart           ✅ Epic 2
├── user.dart                     ✅ Epic 2
├── hydration_goal.dart           ✅ Epic 2
├── glass_size.dart               ✅ Epic 1 (préparation)
├── hydration_log.dart            ✅ Epic 1 (préparation)
└── streak.dart                   ✅ Epic 1 (préparation)
```

**Use Cases:**
```
usecases/
├── calculate_hydration_goal_usecase.dart    ✅ Epic 2
├── dehydration_timer_usecase.dart           ✅ Epic 1
├── update_avatar_state_usecase.dart         ✅ Epic 1
├── capture_photo_usecase.dart               ✅ Epic 3 (Story 3.4)
└── record_hydration_usecase.dart            🚀 Epic 3 (Story 3.6 - EN COURS)
```

**Repositories (Interfaces):**
```
repositories/
├── avatar_repository.dart        ✅ Epic 1
├── user_repository.dart          ✅ Epic 2
└── hydration_log_repository.dart ✅ Epic 3 (Story 3.2)
```

### Data Layer (lib/data/)

**Models/DTOs:**
```
models/
├── avatar_personality_dto.dart   ✅ Epic 1
├── avatar_state_dto.dart         ✅ Epic 1
├── user_dto.dart                 ✅ Epic 2
├── hydration_log_dto.dart        ✅ Epic 1 (préparation)
└── streak_dto.dart               ✅ Epic 1 (préparation)
```

**Data Sources:**
```
datasources/
├── avatar_local_datasource.dart         ✅ Epic 1
├── user_local_datasource.dart           ✅ Epic 2
└── hydration_log_local_datasource.dart  ✅ Epic 3 (Story 3.2)
```

**Repositories (Implementations):**
```
repositories/
├── avatar_repository_impl.dart         ✅ Epic 1
├── user_repository_impl.dart           ✅ Epic 2
└── hydration_log_repository_impl.dart  ✅ Epic 3 (Story 3.2)
```

**Database:**
- ✅ SQLite avec Sqflite
- ✅ Tables: `users`, `avatars`, `hydration_logs`
- ✅ Database version: V5 (hydration_logs ajoutée Epic 3)

### Presentation Layer (lib/presentation/)

**Providers (Riverpod):**
```
providers/
├── avatar_provider.dart          ✅ Epic 1
├── onboarding_provider.dart      ✅ Epic 2
└── user_provider.dart            ✅ Epic 2
```

**Screens:**
```
screens/
├── avatar/
│   └── avatar_selection_screen.dart         ✅ Epic 1
├── onboarding/
│   ├── onboarding_flow_screen.dart          ✅ Epic 2
│   ├── onboarding_weight_screen.dart        ✅ Epic 2
│   ├── onboarding_age_screen.dart           ✅ Epic 2
│   ├── onboarding_gender_screen.dart        ✅ Epic 2
│   ├── onboarding_activity_screen.dart      ✅ Epic 2
│   ├── onboarding_location_screen.dart      ✅ Epic 2
│   └── onboarding_summary_screen.dart       ✅ Epic 2
├── home/
│   └── home_screen.dart                     ✅ Epic 3 (Story 3.8)
└── photo_validation/
    └── photo_validation_screen.dart         ✅ Epic 3 (Story 3.3)
```

**Widgets:**
```
widgets/
├── avatar_display.dart                      ✅ Epic 1
└── embedded_onboarding_context.dart         ✅ Epic 2
```

**Navigation:**
```dart
// Routes définies (lib/main.dart)
'/': SplashScreen
'/avatar_selection': AvatarSelectionScreen
'/onboarding_flow': OnboardingFlowScreen
'/home': HomeScreen                         ✅ Epic 3 (Story 3.8)
'/photo_validation': PhotoValidationScreen  ✅ Epic 3 (Story 3.3)
```

---

## 🚨 Points Bloquants Actuels

### ✅ Bloquants Résolus (Stories 3.1-3.4, 3.8, 3.10)
- ✅ Route `/home` créée (Story 3.8)
- ✅ HydrationLog persistence complète (Story 3.2)
- ✅ Camera integration (Stories 3.3, 3.10)
- ✅ Photo capture & storage (Story 3.4)

### 🚀 Story en Cours
**Story 3.6 - Record Hydration:**
- Créer `RecordHydrationUseCase` pour coordonner:
  - Save log via HydrationLogRepository
  - Update avatar lastDrinkTime
  - Recalculate avatar state
  - Calculate progression %
  - Log analytics (optional Firebase)

### 🔜 Prochains Bloquants
**Story 3.9 - Glass Size Selection:**
- Dépend de Story 3.6 (RecordHydrationUseCase)
- UI pour sélectionner taille verre (200ml/250ml/400ml)
- Navigation depuis PhotoValidationScreen

**Story 3.7 - Avatar Feedback Animation:**
- Animations avatar après validation
- Feedback visuel positif

---

## 📦 Dépendances Actuelles

```yaml
# pubspec.yaml (packages pertinents Epic 3)
dependencies:
  flutter_riverpod: ^2.6.1        ✅ State management
  sqflite: ^2.4.1                 ✅ SQLite database
  path_provider: ^2.1.5           ✅ File paths
  get_it: ^8.0.2                  ✅ Dependency injection
  camera: ^0.10.5+5               ✅ Camera access (Story 3.10)
  permission_handler: ^11.4.0     ✅ Runtime permissions (Story 3.10)
  image: ^4.0.17                  ✅ Photo compression (Story 3.4)
  intl: ^0.18.1                   ✅ DateFormat (Story 3.4)
```

---

## 🧪 Tests

### Test Coverage Actuel
- **Epic 1:** 98% coverage (Domain)
- **Epic 2:** 95.3% pass rate (549/576 tests)
- **Epic 3:** Stories 3.1-3.4, 3.8, 3.10 complètes avec tests
  - ✅ HydrationLog entity/DTO tests (Story 3.1)
  - ✅ HydrationLogRepository tests unitaires + intégration (Story 3.2)
  - ✅ CameraPermissionService tests (Story 3.10)
  - ✅ PhotoValidationScreen widget tests (Story 3.3)
  - ✅ CapturePhotoUseCase tests (Story 3.4)
  - ✅ HomeScreen widget tests (Story 3.8)

### Tests en Cours
- 🚀 RecordHydrationUseCase tests (Story 3.6)
- 🚀 Integration test record hydration flow (Story 3.6)

### Tests Manquants Epic 3
- ❌ GlassSizeSelectionScreen widget tests (Story 3.9)
- ❌ Avatar feedback animation tests (Story 3.7)

---

## 🎨 UI/UX Notes

### Design System (Epic 1-2)
- ✅ Theme configuré (`lib/core/theme/app_theme.dart`)
- ✅ Colors: Primary blue, accent colors définis
- ✅ Typography: Material 3 defaults
- ✅ Avatar assets: Emoji placeholders (`.txt` files)

### Epic 3 UI Requirements
1. **HomeScreen:**
   - Avatar display (center)
   - Daily progress bar (goal % completion)
   - Drink button (CTA principal)
   - Hydration history (list des logs)

2. **Camera Screen:**
   - Camera preview (fullscreen)
   - Capture button
   - Gallery button (alternative)
   - Glass size selector overlay

3. **Feedback Animations:**
   - Avatar state transitions (smooth)
   - Progress bar animation (fill effect)
   - Success feedback (confetti/particles)

---

## 🔐 Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
**Permissions Configurées:**
- ✅ INTERNET
- ✅ ACCESS_FINE_LOCATION (Epic 2 - Story 2.8)
- ✅ ACCESS_COARSE_LOCATION
- ✅ CAMERA (Epic 3 - Story 3.10)
- ✅ CAMERA hardware feature (Epic 3 - Story 3.10)

### iOS (`ios/Runner/Info.plist`)
**Permissions Configurées:**
- ✅ NSCameraUsageDescription (Epic 3 - Story 3.10)
- ✅ NSPhotoLibraryUsageDescription (Epic 3 - Story 3.10)

---

## 📋 Ordre d'Implémentation (Réalisé vs Planifié)

### ✅ Phase 1 - Foundation (COMPLETE)
1. ✅ Story 3.1 - HydrationLog model
2. ✅ Story 3.2 - HydrationLog repository (DB V5 + CRUD)
3. ✅ Story 3.8 - HomeScreen + Drink button (route `/home` active)

### ✅ Phase 2 - Camera (COMPLETE)
4. ✅ Story 3.10 - Camera permissions (CameraPermissionService)
5. ✅ Story 3.3 - Camera interface (PhotoValidationScreen)
6. ✅ Story 3.4 - Photo capture & storage (CapturePhotoUseCase + cleanup 90j)

### 🚀 Phase 3 - Logic (EN COURS)
7. 🚀 Story 3.6 - Record hydration (RecordHydrationUseCase) - EN COURS
8. 🔜 Story 3.9 - Glass size selection UI
9. ⏭️ Story 3.5 - Glass detection (mock AI - optionnelle MVP)

### 🔜 Phase 4 - Feedback
10. 🔜 Story 3.7 - Avatar feedback animation

---

## 🚧 Risques & Notes

1. ✅ **Navigation:** Route `/home` créée (Story 3.8)
2. ✅ **Camera Permissions:** Configurées Android + iOS (Story 3.10)
3. ✅ **DB Migration:** Table `hydration_logs` créée en V5 (Story 3.2)
4. 📝 **Story 3.5:** Glass Detection = optionnelle MVP, peut être sautée si timeline serrée
5. 🎯 **Epic 3 Progress:** 60% complete (6/10 stories), 4 stories restantes pour MVP

---

## 💡 Notes Techniques

### Database Schema (À Créer)
```sql
CREATE TABLE hydration_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  photo_path TEXT,
  glass_size TEXT NOT NULL,
  volume_ml INTEGER NOT NULL,
  validated INTEGER DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX idx_logs_user_date ON hydration_logs(user_id, timestamp);
```

### Photo Storage Strategy (Implémenté - Story 3.4)
- **Path:** `app_documents_dir/` (direct, pas de subdirectory)
- **Format:** `hydration_YYYYMMDD_HHmmss.jpg` (ex: hydration_20260119_153045.jpg)
- **Compression:** 80% quality JPEG (via package `image`)
- **Retention:** 90 jours (cleanup automatique au démarrage app dans main.dart)
- **Cleanup:** Foreground only (pas background task, cross-platform)

### Glass Detection (Placeholder)
```dart
// lib/core/services/glass_detection_service.dart
// Mock implementation - Always returns true
// Future: ML model (TensorFlow Lite) pour vraie détection
```

---

## 📚 Références

**Documentation Projet:**
- `docs/governance.md` - Règles non négociables
- `docs/architecture.md` - System design
- `docs/definition-of-done.md` - Checklist avant merge

**Stories Epic 3:**
- `docs/stories/epic-3/story-3.X-*.md` (10 stories)

**Code Existant:**
- Epic 1: Avatar system complet
- Epic 2: Onboarding flow complet

---

**Dernière mise à jour:** 2026-01-19
**Créé par:** @bmad-master
**Pour:** @dev agent continuité Epic 3

---

## 📝 Changelog

### 2026-01-19
- ✅ Stories 3.4, 3.6 en cours
- ✅ Photo capture & storage implémentés (CapturePhotoUseCase)
- ✅ Cleanup automatique 90j ajouté dans main.dart
- 🚀 RecordHydrationUseCase en développement (Story 3.6)
- 📝 Epic 3 Progress: 60% (6/10 stories)

### 2026-01-15
- ✅ Epic 3 démarré
- ✅ Stories 3.1, 3.2, 3.3, 3.8, 3.10 complètes
- ✅ Branche feature/epic-3-hydration-logging créée
- ✅ Foundation (DB, Camera, HomeScreen) prête
