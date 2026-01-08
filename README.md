# 💧 Hydrate or Die

Gamified hydration tracking app with Tamagotchi-style avatar mechanics. Stay hydrated or watch your avatar suffer the consequences!

## 📱 Project Overview

**Hydrate or Die** is a Flutter mobile application that combines:
- **Tamagotchi Avatar System**: Your avatar's health depends on your hydration
- **Photo Validation**: Take selfies with your water glass to log hydration
- **Streak Mechanics**: Build daily streaks to maintain motivation
- **Progressive Notifications**: Increasingly aggressive reminders if you forget to drink
- **Offline-First Architecture**: Works without internet, syncs when online

## 🏗️ Architecture

This project follows **Clean Architecture** principles with strict layer separation:

```
lib/
├── core/               # Constants, theme, utilities
├── domain/             # Business logic (pure Dart)
│   ├── entities/       # Domain models
│   ├── repositories/   # Repository interfaces
│   └── use_cases/      # Business use cases
├── data/               # Data layer implementation
│   ├── models/         # Data transfer objects (DTOs)
│   ├── repositories/   # Repository implementations
│   └── data_sources/   # Local (SQLite) & Remote (Firebase)
└── presentation/       # UI layer
    ├── providers/      # Riverpod state management
    ├── screens/        # App screens
    └── navigation/     # Routing
```

**Key Architectural Decisions:**
- **State Management**: Riverpod 2.x
- **Local Database**: SQLite (offline-first)
- **Backend**: Firebase (Auth, Firestore, Analytics)
- **Testing**: Unit tests (domain), Widget tests (presentation), Integration tests

For detailed architecture documentation, see [docs/architecture/](docs/architecture/).

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.38.5 or higher
- **Dart SDK**: 3.10.4 or higher
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **Firebase Account** (optional, mock config provided)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/hydrate-or-die.git
   cd hydrate-or-die
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify installation**
   ```bash
   flutter doctor
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Setup (Optional)

The project includes mock Firebase configuration for development. To use real Firebase:

1. Create Firebase projects:
   - `hydrate-or-die-dev` (development)
   - `hydrate-or-die-prod` (production)

2. Generate configuration files:
   ```bash
   flutterfire configure
   ```

3. Replace `lib/firebase_options.dart` with generated config

## 🧪 Testing

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Analyze code quality
```bash
flutter analyze
```

### Format code
```bash
dart format .
```

## 📦 Dependencies

See [docs/dependencies.md](docs/dependencies.md) for complete list of packages with justifications.

**Key Dependencies:**
- `flutter_riverpod`: State management
- `sqflite`: Local database
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Backend services
- `camera`, `image_picker`: Photo capture
- `flutter_local_notifications`: Push notifications
- `mockito`, `build_runner`: Testing

## 🔨 Build & Deploy

### Build Android APK
```bash
flutter build apk --release
```

### Build iOS IPA
```bash
flutter build ios --release
```

### CI/CD Pipeline

GitHub Actions automatically runs on every push:
- ✅ Code formatting check
- ✅ Static analysis (`flutter analyze`)
- ✅ Unit & widget tests
- ✅ Build iOS + Android
- ✅ Upload coverage to Codecov

See [.github/workflows/ci.yml](.github/workflows/ci.yml) for details.

## 📚 Documentation

- [Architecture Overview](docs/architecture/overview.md)
- [Domain Layer](docs/architecture/domain-layer.md)
- [Data Layer](docs/architecture/data-layer.md)
- [Presentation Layer](docs/architecture/presentation-layer.md)
- [Deployment Guide](docs/architecture/deployment.md)
- [Project Governance](docs/governance.md)
- [Definition of Done](docs/definition-of-done.md)

## 🤝 Contributing

This project follows strict governance rules. See [docs/governance.md](docs/governance.md) for:
- Architecture constraints
- Testing requirements (80% coverage on domain layer)
- Code conventions (Dart style guide)
- Git workflow (feature branches, PR reviews)

### Development Workflow

1. Create feature branch: `feature/epic-X-story-Y-description`
2. Implement changes following Clean Architecture
3. Write tests (unit + widget)
4. Run `flutter analyze` and `dart format`
5. Open PR to `develop` branch
6. Wait for CI/CD checks to pass
7. Request PM review

## 📄 License

Private project - All rights reserved.

## 📞 Contact

**Product Manager**: John
**Project**: Hydrate or Die MVP

---

**Built with Flutter 💙 | Clean Architecture 🏗️ | Riverpod 🔄**
