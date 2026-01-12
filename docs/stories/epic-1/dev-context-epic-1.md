# Epic 1 - Dev Context (État Actuel du Développement)

> **Objectif:** Ce fichier maintient le contexte de développement pour tous les agents @dev travaillant sur Epic 1. Il est mis à jour après chaque story complétée pour éviter les duplications et assurer la cohérence.

**Dernière mise à jour:** 2026-01-09 (après Story 1.6)


RAPPEL IMPORTANT : tout reports et Dod vont dans le dossier de l'épic en cours 
exemple pour l'épic 1 : docs/stories/epic-1/reports/
---

## 📊 Vue d'Ensemble Epic 1

**Epic:** Foundation & Avatar Core System
**Progression:** 6/8 stories complétées (75%)

```
✅ Story 1.1 - Flutter Setup + CI/CD
✅ Story 1.2 - Domain Models (10 entities)
✅ Story 1.3 - Avatar Repository (SQLite + DTOs)
✅ Story 1.4 - Avatar Assets (20 emojis + AvatarDisplay widget)
✅ Story 1.5 - Dehydration Logic (Use Case + Timer Service)
✅ Story 1.6 - Home Screen (PREMIER ÉCRAN UI VISIBLE!)
⏳ Story 1.7 - Ghost System (PROCHAINE)
⏳ Story 1.8 - Avatar Selection
```

---

## ✅ Story 1.1 - Flutter Setup + CI/CD

### Fichiers Clés Créés
```
lib/main.dart                          - Entry point avec ProviderScope + Firebase init
lib/firebase_options.dart              - Config Firebase MOCK
.github/workflows/ci.yml               - Pipeline CI/CD (build + test + analyze)
pubspec.yaml                           - 19 dépendances MVP configurées
test/widget_test.dart                  - 3 tests widget de base
```

### Structure Créée
```
lib/
├── core/           - Constants, theme, utils (vide pour l'instant)
├── domain/         - Entities, repositories, use_cases
├── data/           - Models, repositories impl, data_sources
└── presentation/   - Providers, screens, widgets, navigation
```

### Technologies Configurées
- **State Management:** Riverpod (ProviderScope dans main.dart)
- **Database:** sqflite + path_provider
- **Firebase:** firebase_core, firebase_auth, firebase_analytics, cloud_firestore (MODE MOCK)
- **Camera:** camera, image_picker
- **Notifications:** flutter_local_notifications
- **Storage:** shared_preferences
- **Testing:** mockito, build_runner

### À Savoir pour la Suite
- ✅ Firebase en mode MOCK (firebase_options.dart avec config bidon)
- ✅ Riverpod configuré globalement (ProviderScope wrapping MyApp)
- ✅ CI/CD pipeline teste automatiquement chaque commit
- ✅ Canary screen "Hydrate or Die - Coming Soon" s'affiche au lancement
- ⚠️ Ne pas réinitialiser Firebase, c'est déjà fait dans main.dart
- ⚠️ Ne pas recréer pubspec.yaml, toutes les deps MVP sont déjà là

### Commandes Validées
```bash
flutter test           # 3/3 tests passent ✅
flutter analyze        # 0 issues ✅
flutter run            # Lance app avec canary screen ✅
```

---

## ✅ Story 1.2 - Domain Models (10 Entities)

### Fichiers Clés Créés
```
lib/domain/entities/
├── gender.dart                 - Enum Gender (male, female, other)
├── activity_level.dart         - Enum ActivityLevel (sedentary → extreme)
├── avatar_personality.dart     - Enum AvatarPersonality (4 types)
├── avatar_state.dart           - Enum AvatarState (5 états)
├── glass_size.dart             - Enum GlassSize (small, medium, large)
├── hydration_goal.dart         - Value Object HydrationGoal
├── avatar.dart                 - Entity Avatar
├── user.dart                   - Entity User
├── hydration_log.dart          - Entity HydrationLog
└── streak.dart                 - Entity Streak

test/domain/entities/
├── avatar_personality_test.dart
├── avatar_state_test.dart
├── avatar_test.dart
├── glass_size_test.dart
├── hydration_goal_test.dart
├── hydration_log_test.dart
├── streak_test.dart
└── user_test.dart
```

### Concepts Métier Importants

#### **4 Avatars (AvatarPersonality)**
```dart
enum AvatarPersonality {
  doctor,      // 🧑‍⚕️ Docteur (ton professionnel)
  coach,       // 💪 Coach sportif (ton motivant)
  mother,      // 👩 Mère autoritaire (ton maternel/strict)
  friend       // 🤝 Pote (ton décontracté)
}
```

#### **5 États Avatar (AvatarState)**
```dart
enum AvatarState {
  fresh,                    // 😊 75-100% hydratation (vert)
  slightlyDehydrated,       // 😐 50-74% hydratation (jaune)
  dehydrated,               // 😟 25-49% hydratation (orange)
  dead,                     // 💀 0-24% hydratation (rouge)
  ghost                     // 👻 État fantôme après mort
}
```

**Transitions d'état:**
- `getNextState(currentHydration)` - Calcule le prochain état selon %
- `shouldDie(currentHydration)` - Retourne true si < 25%

#### **Calcul Objectif Hydratation (HydrationGoal)**
```dart
// Formule: baseAmount (selon poids) + ajustements (âge, activité, température, altitude)
// Exemple: Homme 75kg, 30 ans, actif → ~2500ml/jour
```

### À Savoir pour la Suite
- ✅ Toutes les entities utilisent **Equatable** (comparaison par valeur)
- ✅ Toutes les entities sont **immutables** (final properties, copyWith())
- ✅ Dartdoc complet sur toutes les classes
- ✅ Null-safety total (pas de null! sauf où explicite)
- ✅ 100% coverage tests Domain Layer (109 tests)
- ⚠️ **NE PAS MODIFIER ces entities** - Elles sont le contrat métier
- ⚠️ Avatar entity N'A PAS de méthodes toJson/fromJson (c'est le rôle des DTOs)

### Tests Validés
```bash
flutter test test/domain/    # 109/109 tests passent ✅
# Coverage: 100% (164/164 lignes)
```

---

## ✅ Story 1.3 - Avatar Repository (Data Layer)

### Fichiers Clés Créés

#### **Domain Layer (Interfaces)**
```
lib/domain/repositories/
└── avatar_repository.dart      - Interface AvatarRepository (5 méthodes)
```

#### **Data Layer (Implémentations)**
```
lib/data/
├── data_sources/local/
│   ├── database_helper.dart              - SQLite helper (5 tables)
│   └── avatar_local_data_source.dart     - Data source local
├── models/
│   ├── avatar_dto.dart + .g.dart         - DTO Avatar avec json_serializable
│   ├── user_dto.dart + .g.dart           - DTO User
│   ├── hydration_log_dto.dart + .g.dart  - DTO HydrationLog
│   └── streak_dto.dart + .g.dart         - DTO Streak
└── repositories/
    └── avatar_repository_impl.dart       - Implémentation AvatarRepository
```

#### **Core Layer (DI)**
```
lib/core/di/
└── injection.dart                        - Dependency Injection avec get_it
```

#### **Tests**
```
test/data/
├── models/
│   ├── avatar_dto_test.dart
│   └── user_dto_test.dart
└── repositories/
    ├── avatar_repository_impl_test.dart          - 16 unit tests
    ├── avatar_repository_impl_test.mocks.dart    - Mocks générés
    └── avatar_repository_integration_test.dart   - Integration tests SQLite
```

### Architecture Data Layer

#### **Base de Données SQLite (5 tables)**
```sql
-- Table: avatar_state
CREATE TABLE avatar_state (
  id TEXT PRIMARY KEY,
  personality TEXT NOT NULL,
  state TEXT NOT NULL,
  last_updated TEXT NOT NULL
);

-- Table: users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  weight REAL NOT NULL,
  age INTEGER NOT NULL,
  gender TEXT NOT NULL,
  activity_level TEXT NOT NULL,
  daily_goal INTEGER NOT NULL,
  created_at TEXT NOT NULL
);

-- Table: hydration_logs
CREATE TABLE hydration_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  amount INTEGER NOT NULL,
  timestamp TEXT NOT NULL,
  photo_path TEXT,
  glass_size TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table: streaks
CREATE TABLE streaks (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  current_streak INTEGER NOT NULL,
  longest_streak INTEGER NOT NULL,
  last_drink_date TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table: settings
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
```

#### **Méthodes AvatarRepository**
```dart
Future<void> saveSelectedAvatar(AvatarPersonality personality);
Future<AvatarPersonality?> getSelectedAvatar();
Future<void> updateAvatarState(AvatarState state);
Future<AvatarState> getAvatarState();
Future<void> clearAvatarData();
```

#### **DTOs (Data Transfer Objects)**
Tous les DTOs utilisent `json_serializable` pour générer `toJson()` / `fromJson()`:
```dart
// Exemple AvatarDto
@JsonSerializable()
class AvatarDto {
  final String id;
  final String personality;
  final String state;

  // fromEntity() - Convertit Avatar (domain) → AvatarDto (data)
  // toEntity() - Convertit AvatarDto (data) → Avatar (domain)
  // toJson() - Sérialise vers Map<String, dynamic>
  // fromJson() - Désérialise depuis Map<String, dynamic>
}
```

#### **Dependency Injection (get_it)**
```dart
// Configuration dans lib/core/di/injection.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Data Sources
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<AvatarLocalDataSource>(
    () => AvatarLocalDataSource(getIt<DatabaseHelper>())
  );

  // Repositories
  getIt.registerLazySingleton<AvatarRepository>(
    () => AvatarRepositoryImpl(getIt<AvatarLocalDataSource>())
  );
}
```

### À Savoir pour la Suite
- ✅ **DatabaseHelper est SINGLETON** - Ne pas recréer, utiliser `getIt<DatabaseHelper>()`
- ✅ **AvatarRepository déjà injectable** - `getIt<AvatarRepository>()`
- ✅ **5 tables SQLite créées** - Schéma complet prêt (avatar_state, users, hydration_logs, streaks, settings)
- ✅ **DTOs pour 4 entities** - Avatar, User, HydrationLog, Streak (avec json_serializable)
- ✅ **SharedPreferences pour avatar ID** - getSelectedAvatar() / saveSelectedAvatar()
- ✅ **SQLite pour état avatar** - getAvatarState() / updateAvatarState()
- ✅ **Timestamps en UTC ISO 8601** - Format standardisé
- ⚠️ **NE PAS recréer DatabaseHelper** - Il existe déjà et gère 5 tables
- ⚠️ **NE PAS redéfinir les DTOs** - Ils sont dans lib/data/models/ avec .g.dart générés
- ⚠️ **Appeler setupDependencies() dans main.dart** - Si pas déjà fait

### Tests Validés
```bash
flutter test test/data/      # 16/16 unit tests passent ✅
flutter test                 # 128/128 total tests passent ✅
# Coverage Data Layer: ≥80%
```

### Génération Code (json_serializable)
```bash
# Si modifications DTOs, regénérer les .g.dart:
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## ✅ Story 1.4 - Avatar Assets + Display Widget

### Fichiers Clés Créés

#### **Assets (20 placeholders emoji)**
```
assets/avatars/
├── doctor/ (🧑‍⚕️)
│   ├── fresh.txt (😊), tired.txt (😐), dehydrated.txt (😟)
│   ├── dead.txt (💀), ghost.txt (👻)
├── sportsCoach/ (💪) - idem 5 états
├── authoritarianMother/ (👩) - idem 5 états
└── sarcasticFriend/ (🤝) - idem 5 états
```

#### **Presentation Layer**
```
lib/presentation/
├── providers/
│   └── avatar_asset_provider.dart    - Service chargement assets (145 lignes)
└── widgets/
    └── avatar_display.dart           - Widget affichage avatar (102 lignes, ConsumerWidget)

test/presentation/
├── providers/
│   └── avatar_asset_provider_test.dart   - 18 unit tests
└── widgets/
    └── avatar_display_test.dart          - 33 widget tests
```

#### **Dependency Injection**
```
lib/core/di/injection.dart - AvatarAssetProvider enregistré dans get_it
```

### Architecture Implémentée

#### **AvatarAssetProvider**
```dart
class AvatarAssetProvider {
  String getAssetPath(AvatarPersonality personality, AvatarState state);
  // Retourne: assets/avatars/{personality}/{state}.txt
}
```

#### **AvatarDisplay Widget**
```dart
class AvatarDisplay extends ConsumerWidget {
  final AvatarPersonality personality;
  final AvatarState state;
  final double? size;

  // Utilise AvatarAssetProvider pour charger l'asset correct
  // Affiche emoji placeholder (Text widget avec fontSize)
}
```

### À Savoir pour la Suite
- ✅ **20 assets emoji créés** - Placeholders .txt dans assets/avatars/
- ✅ **AvatarDisplay widget prêt** - Peut afficher n'importe quelle combinaison personality + state
- ✅ **Provider injectable** - `getIt<AvatarAssetProvider>()`
- ✅ **Mapping personality → nom dossier:**
  - `doctor` → "doctor"
  - `coach` → "sportsCoach"
  - `mother` → "authoritarianMother"
  - `friend` → "sarcasticFriend"
- ✅ **Mapping state → nom fichier:**
  - `fresh` → "fresh.txt"
  - `slightlyDehydrated` → "tired.txt" (note: pas "slightly_dehydrated")
  - `dehydrated` → "dehydrated.txt"
  - `dead` → "dead.txt"
  - `ghost` → "ghost.txt"
- ⚠️ **Assets sont des fichiers .txt** avec emojis (pas .png pour l'instant)
- ⚠️ **Structure prête pour vraies images** - Remplacer .txt par .png plus tard

### Tests Validés
```bash
flutter test test/presentation/  # 51/51 tests passent ✅
# AvatarAssetProvider: 18 tests (100% coverage)
# AvatarDisplay: 33 tests (toutes combinaisons)
```

---

## ✅ Story 1.4 - Avatar Assets + Display Widget

### Fichiers Clés Créés

#### **Assets (20 placeholders emoji)**
```
assets/avatars/
├── doctor/ (🧑‍⚕️)
│   ├── fresh.txt (😊), tired.txt (😐), dehydrated.txt (😟)
│   ├── dead.txt (💀), ghost.txt (👻)
├── sportsCoach/ (💪) - idem 5 états
├── authoritarianMother/ (👩) - idem 5 états
└── sarcasticFriend/ (🤝) - idem 5 états
```

#### **Presentation Layer**
```
lib/presentation/
├── providers/
│   └── avatar_asset_provider.dart    - Service chargement assets (145 lignes)
└── widgets/
    └── avatar_display.dart           - Widget affichage avatar (102 lignes, ConsumerWidget)

test/presentation/
├── providers/
│   └── avatar_asset_provider_test.dart   - 18 unit tests
└── widgets/
    └── avatar_display_test.dart          - 33 widget tests
```

#### **Dependency Injection**
```
lib/core/di/injection.dart - AvatarAssetProvider enregistré dans get_it
```

### Architecture Implémentée

#### **AvatarAssetProvider**
```dart
class AvatarAssetProvider {
  String getEmojiAsset(AvatarPersonality personality, AvatarState state);
  String getAssetPath(AvatarPersonality personality, AvatarState state);
  bool validateAllAssetsExist();
  int get totalAssetCount; // Returns 20
  // Retourne: assets/avatars/{personality}/{state}.txt
}
```

#### **AvatarDisplay Widget**
```dart
class AvatarDisplay extends ConsumerWidget {
  final AvatarPersonality personality;
  final AvatarState state;
  final double? size;

  // Utilise AvatarAssetProvider pour charger l'asset correct
  // Affiche emoji placeholder (Text widget avec fontSize)
  // Background coloré selon état (vert/jaune/orange/rouge/gris)
}
```

### À Savoir pour la Suite
- ✅ **20 assets emoji créés** - Placeholders .txt dans assets/avatars/
- ✅ **AvatarDisplay widget prêt** - Peut afficher n'importe quelle combinaison personality + state
- ✅ **Provider injectable** - `getIt<AvatarAssetProvider>()`
- ✅ **Mapping personality → nom dossier:**
  - `doctor` → "doctor"
  - `coach` → "sportsCoach"
  - `mother` → "authoritarianMother"
  - `friend` → "sarcasticFriend"
- ✅ **Mapping state → nom fichier:**
  - `fresh` → "fresh.txt"
  - `slightlyDehydrated` → "tired.txt" (note: pas "slightly_dehydrated")
  - `dehydrated` → "dehydrated.txt"
  - `dead` → "dead.txt"
  - `ghost` → "ghost.txt"
- ✅ **Background colors par état:**
  - Fresh: Light green `#E8F5E9`
  - Tired: Light yellow `#FFF9C4`
  - Dehydrated: Light orange `#FFE0B2`
  - Dead: Light red `#FFCDD2`
  - Ghost: Light gray `#EEEEEE`
- ⚠️ **Assets sont des fichiers .txt** avec emojis (pas .png pour l'instant)
- ⚠️ **Structure prête pour vraies images** - Remplacer .txt par .png plus tard

### Tests Validés
```bash
flutter test test/presentation/  # 51/51 tests passent ✅
# AvatarAssetProvider: 18 tests (100% coverage)
# AvatarDisplay: 33 tests (toutes combinaisons personality × state)
```

### Usage pour Story 1.6 (Home Screen)
```dart
import 'package:hydrate_or_die/presentation/widgets/avatar_display.dart';

// Dans HomeScreen build method:
AvatarDisplay(
  personality: selectedPersonality, // from AvatarRepository
  state: currentState,              // calculated from dehydration logic
  size: 200.0,                      // optional (default: 150.0)
)
```

---

## ✅ Story 1.5 - Dehydration Logic (Use Case + Timer Service)

### Fichiers Clés Créés

#### **Domain Layer (Use Case)**
```
lib/domain/use_cases/avatar/
└── update_avatar_state_use_case.dart    - Calcul état selon temps écoulé (110 lignes)

test/domain/use_cases/avatar/
└── update_avatar_state_use_case_test.dart - 15 tests scénarios temporels
```

#### **Presentation Layer (Timer Service)**
```
lib/presentation/services/
└── dehydration_timer_service.dart       - Timer periodic 30min (95 lignes)

test/presentation/services/
└── dehydration_timer_service_test.dart  - 20 tests timer lifecycle
```

#### **Dependency Injection**
```
lib/core/di/injection.dart - Ajout UpdateAvatarStateUseCase + DehydrationTimerService
```

### Architecture Implémentée

#### **UpdateAvatarStateUseCase**
```dart
class UpdateAvatarStateUseCase {
  final AvatarRepository repository;

  // Constantes seuils
  static const kFreshToTired = Duration(hours: 2);
  static const kTiredToDehydrated = Duration(hours: 4);
  static const kDehydratedToDead = Duration(hours: 6);

  Future<AvatarState> execute();
  // 1. Récupère lastDrinkTime depuis repository
  // 2. Calcule temps écoulé (DateTime.now() - lastDrinkTime)
  // 3. Détermine nouvel état selon seuils
  // 4. Met à jour repository si état changé
  // 5. Log transitions pour debug
}
```

#### **DehydrationTimerService**
```dart
class DehydrationTimerService {
  final UpdateAvatarStateUseCase updateAvatarStateUseCase;
  Timer? _timer;

  void start();        // Démarre timer + exécution immédiate
  void dispose();      // Annule timer proprement (cleanup)
  void forceUpdate();  // Mise à jour manuelle
  bool get isRunning;  // Statut timer

  // Timer.periodic: Intervalle de 30 minutes
}
```

### Règles Métier Implémentées

**Transitions d'état (AC #2):**
```
Fresh (0-2h)       → 😊 Vert
  ↓ après 2h exactement
Tired (2-4h)       → 😐 Jaune
  ↓ après 4h exactement
Dehydrated (4-6h)  → 😟 Orange
  ↓ après 6h exactement
Dead (6h+)         → 💀 Rouge
```

**Seuils validés par tests:**
- 2h exactement: Fresh → Tired ✅
- 4h exactement: Tired → Dehydrated ✅
- 6h exactement: Dehydrated → Dead ✅

### À Savoir pour la Suite

- ✅ **Use Case injectable** - `getIt<UpdateAvatarStateUseCase>()`
- ✅ **Timer Service singleton** - `getIt<DehydrationTimerService>()`
- ✅ **Seuils temporels fixes** - 2h, 4h, 6h (constantes dans use case)
- ✅ **Logging avec print()** - Pour debug MVP (AC #6 validé)
- ✅ **Timer périodique 30min** - Exécution automatique en background
- ✅ **Pas de lastDrinkTime** - Retourne Fresh par défaut (premier lancement)
- ⚠️ **Warnings avoid_print attendus** - 11 warnings normaux (logging intentionnel)
- ⚠️ **Timer doit être démarré** - Appeler `service.start()` dans main.dart ou app init
- ⚠️ **Timer doit être disposé** - Appeler `service.dispose()` dans app dispose

### Tests Validés
```bash
flutter test test/domain/use_cases/avatar/        # 15/15 tests passent ✅
flutter test test/presentation/services/          # 20/20 tests passent ✅
# Total nouveaux tests: 35 (100% coverage use case + service)
# Scénarios: 0h, 1h, 3h, 5h, 7h + seuils exacts + edge cases
```

### Intégration pour Story 1.6 (Home Screen)
```dart
// Dans main.dart ou app_widget.dart initState:
void initState() {
  super.initState();
  final timerService = getIt<DehydrationTimerService>();
  timerService.start(); // Démarre timer background
}

// Dans dispose:
@override
void dispose() {
  final timerService = getIt<DehydrationTimerService>();
  timerService.dispose(); // Cleanup propre
  super.dispose();
}

// Pour refresh manuel dans HomeScreen:
final useCase = getIt<UpdateAvatarStateUseCase>();
final newState = await useCase.execute(); // Calcule et met à jour l'état
```

---

## ✅ Story 1.6 - Home Screen (Premier Écran UI Visible!)

### Fichiers Clés Créés

#### **Presentation Layer (Screens)**
```
lib/presentation/screens/home/
└── home_screen.dart                - Écran principal complet (200+ lignes)

test/presentation/screens/home/
└── home_screen_test.dart           - 18 widget tests
```

#### **Presentation Layer (Providers)**
```
lib/presentation/providers/
└── home_provider.dart              - Provider Riverpod + auto-refresh 60s (150+ lignes)

test/presentation/providers/
├── home_provider_test.dart         - 10 unit tests
└── home_provider_test.mocks.dart   - Mocks générés
```

#### **Presentation Layer (Widgets)**
```
lib/presentation/widgets/
├── hydration_progress_bar.dart     - Progress bar animée (80+ lignes)
└── avatar_message_widget.dart      - Messages personnalisés (120+ lignes)

test/presentation/widgets/
├── hydration_progress_bar_test.dart     - 12 widget tests
└── avatar_message_widget_test.dart      - 25 widget tests
```

### Architecture Implémentée

#### **HomeScreen (ConsumerWidget)**
Layout complet selon wireframe (front-end-spec lignes 1206-1236):
- Header: Logo + heure + streak (placeholder "0 jours") + settings
- Avatar Display: 200×200px centré, état réactif
- Message Widget: Personnalisé selon personality + state
- Progress Bar: 0.0L / 2.5L (0%) placeholder
- Temps écoulé: "il y a Xh Ymin" ou "Jamais encore bu aujourd'hui"
- Bouton "💧 JE BOIS 💧": UI uniquement, `onPressed: null`
- Bottom Nav: 3 items (Calendrier/Home/Profil) - UI uniquement

#### **HomeProvider (Riverpod StateNotifier)**
```dart
class HomeState {
  final AvatarPersonality personality;
  final AvatarState state;
  final DateTime? lastDrinkTime;
  final bool isLoading;
  final String? error;
}

class HomeNotifier extends StateNotifier<HomeState> {
  // Timer.periodic(Duration(seconds: 60)) auto-refresh
  // Integration UpdateAvatarStateUseCase + AvatarRepository
  void startAutoRefresh();  // Démarre timer 60s
  void dispose();           // Annule timer proprement
}
```

#### **HydrationProgressBar Widget**
- Affichage: "1.5L / 2.5L (60%)" ou "0.0L / 2.5L (0%)"
- Animation smooth fill 500ms (AnimatedContainer)
- Dégradé bleu hydratation (LinearGradient)
- Support > 100% (overflow display)
- Height 40px, radius 8px

#### **AvatarMessageWidget**
**20 messages uniques (4 personnalités × 5 états):**

**Doctor (Professionnel):**
- Fresh: "Votre hydratation est optimale 💙"
- Tired: "Je constate une légère déshydratation 💧"
- Dehydrated: "Hydratation critique, buvez immédiatement! 🚨"
- Dead: "Décès par déshydratation... 💀"
- Ghost: "👻"

**Coach (Motivant):**
- Fresh: "En pleine forme champion ! 💪"
- Tired: "Allez champion, bois maintenant ! 💪"
- Dehydrated: "C'EST MAINTENANT OU JAMAIS ! 💪🔥"
- Dead: "Game over... on repart demain 💀"
- Ghost: "👻"

**Mother (Autoritaire):**
- Fresh: "Très bien mon petit 😊"
- Tired: "Tu devrais boire maintenant..."
- Dehydrated: "Tu veux que je m'inquiète ?! 😟"
- Dead: "Je suis très déçue... 💀"
- Ghost: "👻"

**Friend (Sarcastique):**
- Fresh: "Nickel poto ! 😎"
- Tired: "T'as soif ou quoi ? 🤔"
- Dehydrated: "Mec, sérieux là... 😰"
- Dead: "Mec, j'ai crevé... 💀"
- Ghost: "👻"

**Couleurs selon état:**
- Fresh: Vert `#4CAF50`
- Tired: Orange `#FF9800`
- Dehydrated: Rouge `#F44336`
- Ghost: Gris `#9E9E9E`

### À Savoir pour la Suite

- ✅ **HomeScreen complet** - Premier écran UI visible de l'app!
- ✅ **Auto-refresh 60s** - Timer periodic dans HomeProvider
- ✅ **Messages personnalisés** - 20 messages (4 perso × 5 états)
- ✅ **Progress bar placeholder** - 0.0L / 2.5L (sera implémenté Story 3.8)
- ✅ **Streak placeholder** - "0 jours" hardcodé (sera implémenté Epic 4)
- ✅ **Bouton non fonctionnel** - `onPressed: null` (sera implémenté Story 3.8)
- ✅ **Bottom nav UI uniquement** - Pas de routing pour l'instant
- ⚠️ **Temps écoulé formaté** - "il y a Xh Ymin" calculé depuis lastDrinkTime
- ⚠️ **Default personality** - AvatarPersonality.doctor si getSelectedAvatar() retourne null

### Tests Validés
```bash
flutter test test/presentation/  # 129/129 tests passent ✅
# Nouveaux tests Story 1.6: 65 tests
# - HomeProvider: 10 unit tests (auto-refresh, state management)
# - HomeScreen: 18 widget tests (4 états minimum)
# - HydrationProgressBar: 12 widget tests (0%, 50%, 100%, >100%)
# - AvatarMessageWidget: 25 widget tests (4 perso × 5 états)
```

### Intégration pour Story 1.7 (Ghost System)
Le HomeScreen est déjà prêt pour afficher l'état `ghost`:
- Avatar affiche emoji 👻 (AvatarDisplay widget)
- Message affiche "👻" (AvatarMessageWidget)
- Couleur grise #9E9E9E

Story 1.7 devra implémenter:
- Logique transition Dead → Ghost (automatique le jour suivant)
- Logique résurrection Ghost → Fresh (minuit)
- Streak non incrémenté si mode ghost actif

---

## 📚 Références Importantes

### Documentation à Consulter
- `docs/contracts/database-schema.md` - Schéma complet SQLite
- `docs/contracts/data-models.md` - Specs entities et DTOs
- `docs/architecture/data-layer.md` - Architecture Data Layer
- `docs/front-end-spec.md` - Specs UI/UX (section avatars)
- `docs/instructions-claude.md` - **Instructions MANDATORY pour tous les devs**

### Commandes Utiles
```bash
# Tests
flutter test                    # Tous les tests
flutter test test/domain/       # Tests Domain Layer uniquement
flutter test test/data/         # Tests Data Layer uniquement
flutter test --coverage         # Avec coverage

# Analyse
flutter analyze                 # Analyse statique (0 issues attendu)

# Build Runner (DTOs)
flutter pub run build_runner build --delete-conflicting-outputs

# Run
flutter run                     # Lance app (Chrome ou Android)
flutter devices                 # Liste devices disponibles
```

### Standards de Code
- **Entities (Domain):** Immutables, Equatable, pas de sérialisation JSON
- **DTOs (Data):** json_serializable, méthodes fromEntity/toEntity
- **Repositories:** Interface dans domain/, implémentation dans data/
- **Tests:** Coverage minimum 80% (Domain 90%+)
- **Naming:** snake_case fichiers, camelCase variables, PascalCase classes
- **Imports:** Toujours `package:hydrate_or_die/...` (pas de relative paths)

---

## ⚠️ POINTS D'ATTENTION CRITIQUES

### NE PAS FAIRE (Éviter Duplications)
- ❌ Ne pas recréer `DatabaseHelper` - Il existe déjà avec 5 tables
- ❌ Ne pas redéfinir les DTOs - Ils sont dans `lib/data/models/` avec `.g.dart`
- ❌ Ne pas réinitialiser Firebase dans main.dart - C'est déjà fait
- ❌ Ne pas modifier les entities Domain sans raison critique
- ❌ Ne pas ajouter de dépendances dans pubspec.yaml sans consulter

### TOUJOURS FAIRE
- ✅ Lire `docs/instructions-claude.md` avant de commencer
- ✅ Lire ce fichier `dev-context.md` pour comprendre l'existant
- ✅ Consulter la story markdown dans `docs/stories/epic-1/story-X.Y-*.md`
- ✅ Vérifier les contracts dans `docs/contracts/`
- ✅ Tester avec `flutter test` avant de terminer
- ✅ Créer les rapports dans `docs/stories/epic-1/reports/`
- ✅ Respecter Clean Architecture (Domain ← Data ← Presentation)

---

**Dernière mise à jour:** 2026-01-09 après Story 1.6
**Prochaine mise à jour:** Après Story 1.7 (Ghost System)

---

*Ce fichier est maintenu par @bmad-master pour assurer continuité entre agents @dev.*
