# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Gamified hydration tracking app with Tamagotchi-style avatar mechanics.**
Offline-first Flutter app using Clean Architecture, Riverpod, SQLite & Firebase.

## Commands

### Development
- Run: `flutter run`
- Test: `flutter test` (Unit/Widget)
- Integration Tests: `flutter test integration_test/`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Build Runner: `dart run build_runner build --delete-conflicting-outputs`

### Testing & Coverage
- Coverage: `flutter test --coverage`
- Single test: `flutter test test/path/to/test_file.dart`

### Build
- Build APK: `flutter build apk --release`
- Build iOS: `flutter build ios --release`
- Clean: `flutter clean && flutter pub get`

## Architecture & Rules (Strict)

### Clean Architecture Layers
```
lib/
├── core/           # DI (GetIt), constants, theme, utils
├── domain/         # Pure Dart - Entities, Repository interfaces, Use Cases
├── data/           # DTOs/Models, Repository implementations, Data Sources (SQLite + Firebase)
└── presentation/   # Riverpod providers, Screens, Widgets, Navigation
```

### Patterns & Technologies
- **Pattern:** Clean Architecture (Presentation -> Domain -> Data)
- **State Management:** Riverpod 2.x
- **DI:** GetIt
- **Persistence:** Sqflite (Local), Firebase (Remote - optional for dev)
- **Testing:** Domain >= 80%, Data >= 70%, Presentation >= 50%

### Code Conventions
- **Files:** snake_case filenames
- **Classes:** PascalCase
- **Variables/Functions:** camelCase
- **Constants:** kPrefixCamelCase
- **Dartdoc:** Mandatory for all public members
- **Dependencies:** NO new packages without explicit PM validation

## BMad Workflow

### Starting a Story
1. **ALWAYS read first:** `docs/stories/epic-X/dev-context*`
   - Shows current state, what exists, what's been completed
   - **CRITICAL:** Prevents recreating existing code
2. **Read assigned story:** `docs/stories/epic-X/story-X.Y-*.md`
   - Contains ALL Acceptance Criteria (AC)
   - Technical Notes with implementation details
3. **Review governance:** `docs/governance.md` & `docs/definition-of-done.md`
4. **Check existing code** in relevant `lib/` subdirectories

### Completing a Story
- **Reports location:** `docs/stories/epic-X/reports/`
  - `story-X.Y-completion-report.md`
  - `story-X.Y-dod-report.md`
- **IMPORTANT:** Reports go in epic-specific reports folder, NOT in root

### Notes
- `docs/front-end-spec.md` is ignored by Claude (.claudeignore)
- Relevant UI/UX sections are copied into individual story files

## Git & Workflow

- **Commits:** `[EPIC-X.Y] Description` (Atomic commits)
- **Branches:** `feature/epic-X-story-Y-short-description`
- **Validation:** Check `docs/definition-of-done.md` before marking story complete
- **No direct commits to main:** Always use feature branches → PR to develop

## Project Specifics

### Avatar System
- 4 personalities: authoritarianMother, sportsCoach, doctor, sarcasticFriend
- 5 states per personality: fresh, tired, dehydrated, dead, ghost
- Assets: Currently emoji placeholders in `.txt` files (will be replaced with PNGs)

### Key Features
- **Photo Validation:** Camera integration for hydration logging
- **Offline-First:** App works fully offline, syncs with Firebase when online
- **Streak Mechanics:** Daily hydration streaks with progressive notifications
- **Firebase:** Optional (mock config provided for development)

## Error Handling & Edge Cases

- **All async operations** wrapped in try-catch
- **User-facing errors:** Clear, actionable messages (no raw stack traces)
- **Fallbacks:**
  - Firebase down → Offline mode continues working
  - Camera permission denied → Redirect to settings
  - Photo validation fails → Manual fallback option
- **Edge cases:** Empty states, null values, invalid data must be handled

## Critical Rules

- ❌ NEVER modify `docs/governance.md` or `docs/architecture.md` without explicit permission
- ✅ ALWAYS run `flutter test` before finishing a task
- ✅ ALWAYS check `flutter analyze` returns 0 issues
- ✅ ALWAYS read `dev-context.md` before starting (prevents duplication)
- ✅ Handle all errors gracefully - No raw crashes allowed
- ✅ All tests must pass (100% pass rate required)
- ✅ Coverage minimums must be met (Domain >= 80%, Data >= 70%, Presentation >= 50%)

## Quick Reference

**Governance:** `docs/governance.md` (non-negotiable rules)
**DoD Checklist:** `docs/definition-of-done.md` (mandatory before story completion)
**Architecture:** `docs/architecture.md` (system design)
**Dependencies:** `docs/dependencies.md` (approved packages)
