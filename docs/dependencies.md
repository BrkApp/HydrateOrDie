# 📦 Dependencies Documentation

**Project**: Hydrate or Die MVP
**Version**: 1.0.0
**Last Updated**: 2026-01-07

---

## 📋 Complete Package List

### Production Dependencies

| Package | Version | Category | Justification |
|---------|---------|----------|---------------|
| `flutter_riverpod` | ^2.6.1 | State Management | Recommended by PO. Type-safe, performant, compile-time safety. Better than Bloc for this project's complexity. |
| `sqflite` | ^2.4.1 | Database | Offline-first architecture. SQLite is the source of truth for all data. Fast, reliable, proven Flutter package. |
| `path_provider` | ^2.1.5 | Storage | Required for SQLite database file paths. Official Flutter package, essential for file system access. |
| `shared_preferences` | ^2.3.3 | Storage | Simple key-value storage for user preferences (theme, notifications settings). Lightweight, official package. |
| `firebase_core` | ^3.8.1 | Backend | Firebase initialization. Required for all Firebase services. |
| `firebase_auth` | ^5.3.4 | Authentication | User authentication (email/password, Google, Apple Sign-In). Cloud sync requires authenticated users. |
| `firebase_analytics` | ^11.3.6 | Analytics | Track user behavior, retention metrics, feature usage. Critical for MVP validation. |
| `cloud_firestore` | ^5.5.2 | Database | Cloud backup of local SQLite data. Multi-device sync, GDPR-compliant data deletion. |
| `camera` | ^0.11.0+2 | Camera | Photo validation feature (selfie with water glass). Core MVP feature. |
| `image_picker` | ^1.1.2 | Camera | Alternative photo selection (gallery). Fallback if camera fails. |
| `flutter_local_notifications` | ^18.0.1 | Notifications | Progressive notification system (gentle → aggressive reminders). Core MVP retention mechanic. |
| `intl` | ^0.20.1 | Utilities | Date/time formatting, localization support (future i18n). |
| `uuid` | ^4.5.1 | Utilities | Generate unique IDs for entities (hydration logs, photos). |
| `http` | ^1.2.2 | Network | HTTP client for potential future API integrations (ML photo validation, weather API). |
| `cupertino_icons` | ^1.0.8 | UI | iOS-style icons. Standard Flutter package. |

### Development Dependencies

| Package | Version | Category | Justification |
|---------|---------|----------|---------------|
| `flutter_test` | sdk | Testing | Official Flutter testing framework. Unit tests, widget tests. |
| `flutter_lints` | ^6.0.0 | Code Quality | Official Flutter lint rules. Enforces Dart best practices. |
| `mockito` | ^5.4.4 | Testing | Mock dependencies for unit tests. Industry standard for Dart/Flutter testing. |
| `build_runner` | ^2.4.13 | Code Generation | Required by Mockito for generating mock classes. |

---

## 🎯 Dependency Strategy

### Version Pinning Policy

- **Production**: Use caret (`^`) for patch/minor updates, lock major versions
- **Critical packages** (firebase_*, sqflite): Monitor breaking changes closely
- **Testing packages**: More lenient, update regularly

### Update Cadence

- **Monthly**: Check `flutter pub outdated`
- **Quarterly**: Major version updates (test thoroughly)
- **Critical security patches**: Immediate update

### Alternatives Considered

#### State Management: Why Riverpod over Bloc?

| Riverpod | Bloc | Decision |
|----------|------|----------|
| Less boilerplate | More boilerplate | ✅ Riverpod (faster development) |
| Compile-time safety | Runtime safety | ✅ Riverpod (catch errors earlier) |
| Smaller bundle size | Larger bundle size | ✅ Riverpod |
| Recommended by PO | Industry standard | ✅ Riverpod (PO preference) |

**Verdict**: Riverpod chosen for simplicity and PO recommendation.

#### Database: Why SQLite over Hive?

| SQLite (sqflite) | Hive | Decision |
|------------------|------|----------|
| SQL queries | Key-value + boxes | ✅ SQLite (complex queries needed) |
| Mature ecosystem | Newer, faster | ✅ SQLite (proven stability) |
| ACID transactions | No transactions | ✅ SQLite (data integrity) |
| Relational data | Document-based | ✅ SQLite (user/logs/streaks relations) |

**Verdict**: SQLite for relational data integrity and complex queries (streak calculations).

#### Notifications: Why flutter_local_notifications?

- Official Flutter Community package
- Cross-platform (iOS + Android)
- Supports scheduled notifications (critical for hydration reminders)
- **Alternative**: firebase_messaging (cloud-based) → Not needed, local notifications sufficient for MVP

---

## 🚨 Breaking Change Risks

### High Risk Packages

1. **firebase_core** (3.8.1 → 4.x)
   - Major version bump expected soon
   - Risk: Breaking API changes
   - Mitigation: Pin to 3.x until 4.x is stable

2. **flutter_riverpod** (2.6.1 → 3.x)
   - Version 3.x released, but not yet adopted
   - Risk: State management refactor needed
   - Mitigation: Stay on 2.x for MVP, upgrade in V2

### Medium Risk Packages

- `sqflite`: Stable, low risk
- `camera`: Breaking changes in major versions, pin to 0.11.x
- `flutter_local_notifications`: Pin to 18.x

---

## 📊 Bundle Size Impact

**Estimated APK Size Impact:**

- Firebase packages: ~2.5 MB
- Riverpod: ~50 KB
- sqflite: ~1 MB
- camera + image_picker: ~3 MB
- flutter_local_notifications: ~500 KB

**Total overhead**: ~7 MB (acceptable for MVP)

**Optimization opportunities for V2:**
- Use `firebase_core` tree-shaking
- Lazy-load camera package (only when photo validation accessed)

---

## 🔐 Security Considerations

### Packages with Native Code

- `sqflite`: C++ native (iOS/Android) → Regular updates for security patches
- `camera`: Platform channels → Ensure permissions handled correctly
- `firebase_*`: Google-maintained → Trustworthy, auto-updated

### Known Vulnerabilities

- **None at time of writing** (checked with `flutter pub outdated`)
- Monitor: https://github.com/advisories

---

## 🧪 Testing Dependencies

### Why Mockito over Manual Mocks?

- **Code generation**: Automatic mock class creation
- **Type safety**: Compile-time checks
- **Community standard**: Most Flutter projects use Mockito
- **Alternative**: Manual mocks → Too much boilerplate for 50+ repositories/use cases

### build_runner

- Required by Mockito for code generation
- Also useful for future JSON serialization (json_serializable)
- Run: `flutter pub run build_runner build` to generate mocks

---

## 📈 Future Dependencies (Post-MVP)

### V2 Planned Additions

| Package | Purpose | Priority |
|---------|---------|----------|
| `go_router` | Navigation 2.0 | High (better than Navigator 1.0) |
| `json_serializable` | JSON serialization | Medium (cleaner models) |
| `flutter_secure_storage` | Secure token storage | High (auth tokens) |
| `freezed` | Immutable models | Low (nice-to-have) |
| `dio` | Advanced HTTP client | Medium (replace `http` if needed) |
| `cached_network_image` | Image caching | Low (only if remote avatars added) |

---

## 🛠️ Maintenance Commands

### Check for updates
```bash
flutter pub outdated
```

### Update all packages (within constraints)
```bash
flutter pub upgrade
```

### Update specific package
```bash
flutter pub upgrade firebase_core
```

### Check dependency tree
```bash
flutter pub deps
```

### Analyze package size impact
```bash
flutter build apk --analyze-size
```

---

## ✅ Approval Status

**All dependencies listed above are PRE-APPROVED by PM John.**

Any new dependency MUST be validated via:
1. Justification document (this file)
2. PM approval
3. Update to this dependencies.md

**No exceptions.**

---

**Document maintained by**: Dev Agent James
**Next review date**: 2026-02-07 (monthly)
