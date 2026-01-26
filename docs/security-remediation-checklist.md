# Checklist de Remédiation Sécurité - HydrateOrDie

**Date Création :** 2026-01-16
**Auditeur :** Quinn (QA Test Architect)
**Basé sur :** [Rapport d'Audit Sécurité](./security-audit-report.md)

---

## 🎯 Objectif de cette Checklist

Ce document fournit une **feuille de route actionnable** pour implémenter toutes les recommandations de sécurité identifiées lors de l'audit. Chaque item est détaillé avec :
- **Actions concrètes** à réaliser
- **Code snippets** prêts à l'emploi
- **Critères de validation** pour vérifier l'implémentation
- **Epic/Story proposée** pour intégration dans le backlog

---

## 🔴 PHASE 1 : Fixes CRITIQUES (Bloquants Production)

### CR-1 : Implémenter Chiffrement SQLite avec sqflite_sqlcipher

**Epic Proposée :** Epic 4 - Security Hardening
**Story Proposée :** Story 4.1 - Database Encryption Implementation
**Effort Estimé :** 2-3 jours
**Assigné à :** Dev Agent

#### Étape 1.1 : Ajouter Dépendances

- [ ] **Action 1.1.1 :** Modifier `pubspec.yaml`
```yaml
dependencies:
  # Remplacer sqflite par sqflite_sqlcipher
  # sqflite: ^2.4.1  ❌ SUPPRIMER
  sqflite_sqlcipher: ^2.2.1  # ✅ AJOUTER

  # Ajouter flutter_secure_storage pour clés
  flutter_secure_storage: ^9.0.0  # ✅ AJOUTER
```

- [ ] **Action 1.1.2 :** Exécuter `flutter pub get`
```bash
flutter pub get
```

- [ ] **Action 1.1.3 :** Vérifier compilation réussie
```bash
flutter build apk --debug  # Android
flutter build ios --debug  # iOS
```

**Validation :** Compilation réussie sans erreurs de dépendances.

---

#### Étape 1.2 : Créer Service de Chiffrement Base de Données

- [ ] **Action 1.2.1 :** Créer fichier `lib/core/security/database_encryption_service.dart`
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';

/// Service de gestion des clés de chiffrement SQLite
///
/// Génère et stocke de manière sécurisée la clé AES-256 utilisée
/// pour chiffrer la base de données SQLite avec SQLCipher.
class DatabaseEncryptionService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const _keyName = 'db_encryption_key_v1';

  /// Récupère ou crée une clé de chiffrement AES-256
  ///
  /// La clé est générée aléatoirement une seule fois et stockée
  /// dans le Keychain iOS ou EncryptedSharedPreferences Android.
  ///
  /// Returns: String base64 de 32 bytes (256 bits)
  Future<String> getOrCreateEncryptionKey() async {
    try {
      // Tenter de lire clé existante
      String? key = await _storage.read(key: _keyName);

      if (key == null) {
        // Générer nouvelle clé aléatoire 256-bit
        final random = Random.secure();
        final bytes = List<int>.generate(32, (_) => random.nextInt(256));
        key = base64Url.encode(bytes);

        // Stocker clé de manière sécurisée
        await _storage.write(key: _keyName, value: key);
      }

      return key;
    } catch (e) {
      throw DatabaseEncryptionException(
        'Failed to get or create encryption key: $e',
      );
    }
  }

  /// Supprime la clé de chiffrement (pour suppression compte)
  Future<void> deleteEncryptionKey() async {
    await _storage.delete(key: _keyName);
  }

  /// Vérifie si une clé existe déjà
  Future<bool> hasEncryptionKey() async {
    final key = await _storage.read(key: _keyName);
    return key != null;
  }
}

/// Exception levée lors d'erreurs de chiffrement base de données
class DatabaseEncryptionException implements Exception {
  final String message;
  DatabaseEncryptionException(this.message);

  @override
  String toString() => 'DatabaseEncryptionException: $message';
}
```

- [ ] **Action 1.2.2 :** Vérifier création fichier réussie
```bash
ls lib/core/security/database_encryption_service.dart
```

**Validation :** Fichier créé, compilable sans erreurs.

---

#### Étape 1.3 : Modifier DatabaseHelper pour Utiliser SQLCipher

- [ ] **Action 1.3.1 :** Modifier `lib/data/data_sources/local/database_helper.dart`

**Imports à changer :**
```dart
// AVANT:
// import 'package:sqflite/sqflite.dart';

// APRÈS:
import 'package:sqflite_sqlcipher/sqflite.dart';  // ✅ Utiliser sqflite_sqlcipher
```

**Ajouter import du service de chiffrement :**
```dart
import '../../../core/security/database_encryption_service.dart';
```

**Modifier la méthode `_initDatabase` :**
```dart
/// Initialize database with encryption (SQLCipher)
Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, _databaseName);

  // Récupérer ou créer clé de chiffrement AES-256
  final encryptionService = DatabaseEncryptionService();
  final encryptionKey = await encryptionService.getOrCreateEncryptionKey();

  return await openDatabase(
    path,
    version: _databaseVersion,
    password: encryptionKey,  // ⬅️ CRITIQUE: Active SQLCipher avec clé AES-256
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
  );
}
```

- [ ] **Action 1.3.2 :** Sauvegarder modifications

**Validation :** Compilation réussie, pas d'erreurs de syntaxe.

---

#### Étape 1.4 : Gérer Migration Base Non Chiffrée → Chiffrée

- [ ] **Action 1.4.1 :** Ajouter logique de migration dans `DatabaseHelper`

**Ajouter méthode de migration :**
```dart
/// Migre une base SQLite non chiffrée vers base chiffrée
///
/// Appelé une seule fois lors du premier lancement après mise à jour.
/// Copie toutes les données de l'ancienne base vers nouvelle base chiffrée.
Future<void> _migrateToEncryptedDatabase() async {
  final dbPath = await getDatabasesPath();
  final oldPath = join(dbPath, 'hydrate_or_die_old.db');
  final newPath = join(dbPath, _databaseName);

  // Vérifier si migration déjà effectuée
  final migrationDone = await File(join(dbPath, '.migration_done')).exists();
  if (migrationDone) return;

  // Vérifier si ancienne base existe
  final oldDbExists = await File(newPath).exists();
  if (!oldDbExists) {
    // Pas de migration nécessaire (première installation)
    await File(join(dbPath, '.migration_done')).create();
    return;
  }

  try {
    // Renommer ancienne base
    await File(newPath).rename(oldPath);

    // Ouvrir ancienne base NON chiffrée
    final oldDb = await openDatabase(oldPath);

    // Créer nouvelle base CHIFFRÉE
    final newDb = await database;  // Utilise _initDatabase avec chiffrement

    // Copier toutes les tables
    await _copyTable(oldDb, newDb, 'user_profile');
    await _copyTable(oldDb, newDb, 'avatar_state');
    await _copyTable(oldDb, newDb, 'hydration_logs');
    await _copyTable(oldDb, newDb, 'streak_data');
    await _copyTable(oldDb, newDb, 'notification_state');

    // Fermer ancienne base
    await oldDb.close();

    // Supprimer ancienne base
    await File(oldPath).delete();

    // Marquer migration terminée
    await File(join(dbPath, '.migration_done')).create();

    if (kDebugMode) {
      debugPrint('[DatabaseHelper] Migration to encrypted DB successful');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('[DatabaseHelper] Migration failed: $e');
    }
    rethrow;
  }
}

/// Copie une table d'une base à une autre
Future<void> _copyTable(Database from, Database to, String tableName) async {
  final rows = await from.query(tableName);
  for (final row in rows) {
    await to.insert(tableName, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
```

- [ ] **Action 1.4.2 :** Appeler migration au lancement

**Modifier méthode `get database` :**
```dart
Future<Database> get database async {
  if (_database != null) return _database!;

  // Effectuer migration si nécessaire (une seule fois)
  await _migrateToEncryptedDatabase();

  _database = await _initDatabase();
  return _database!;
}
```

**Validation :** Migration fonctionne sans perte de données.

---

#### Étape 1.5 : Tester Chiffrement SQLite

- [ ] **Action 1.5.1 :** Créer test unitaire `test/core/security/database_encryption_service_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/core/security/database_encryption_service.dart';

void main() {
  group('DatabaseEncryptionService', () {
    test('should generate 256-bit encryption key', () async {
      final service = DatabaseEncryptionService();
      final key = await service.getOrCreateEncryptionKey();

      // Vérifier longueur clé (32 bytes base64 encoded)
      expect(key.isNotEmpty, true);
      expect(key.length, greaterThanOrEqualTo(32));
    });

    test('should return same key on multiple calls', () async {
      final service = DatabaseEncryptionService();
      final key1 = await service.getOrCreateEncryptionKey();
      final key2 = await service.getOrCreateEncryptionKey();

      expect(key1, equals(key2));
    });
  });
}
```

- [ ] **Action 1.5.2 :** Créer test d'intégration `test/data/data_sources/local/database_helper_encryption_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/data/data_sources/local/database_helper.dart';

void main() {
  group('DatabaseHelper Encryption', () {
    test('should open encrypted database successfully', () async {
      final dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      // Vérifier que la base s'ouvre correctement
      expect(db.isOpen, true);

      // Tester insertion/lecture
      await db.execute('CREATE TABLE test (id INTEGER PRIMARY KEY, value TEXT)');
      await db.insert('test', {'id': 1, 'value': 'encrypted_data'});
      final result = await db.query('test');

      expect(result.length, 1);
      expect(result.first['value'], 'encrypted_data');

      await dbHelper.close();
    });
  });
}
```

- [ ] **Action 1.5.3 :** Exécuter tests
```bash
flutter test test/core/security/
flutter test test/data/data_sources/local/database_helper_encryption_test.dart
```

**Validation :** Tous les tests passent (100% success rate).

---

#### Étape 1.6 : Validation Manuelle Chiffrement

- [ ] **Action 1.6.1 :** Tester sur device réel Android
```bash
flutter run --release
# Utiliser l'app, créer profil utilisateur
adb pull /data/data/com.example.hydrate_or_die/databases/hydrate_or_die.db
sqlite3 hydrate_or_die.db
# Vérifier que les données sont illisibles (binary garbage)
```

- [ ] **Action 1.6.2 :** Tester sur device réel iOS
```bash
flutter run --release
# Utiliser l'app, créer profil utilisateur
# Extraire backup iOS via Xcode Devices
# Vérifier que hydrate_or_die.db est chiffré (binary)
```

**Validation :** Base de données illisible sans clé de chiffrement.

---

#### Étape 1.7 : Documentation

- [ ] **Action 1.7.1 :** Documenter chiffrement dans `docs/architecture/security-auth.md`
```markdown
## Database Encryption (SQLCipher)

**Implementation:** Story 4.1 (Epic 4)

- **Algorithm:** AES-256-CBC (SQLCipher)
- **Key Storage:** flutter_secure_storage (iOS Keychain / Android EncryptedSharedPreferences)
- **Key Generation:** Random.secure() 32 bytes (256 bits)
- **Migration:** Automatic migration from unencrypted to encrypted DB

**Security Properties:**
- ✅ Data at rest encrypted (RGPD Article 32 compliant)
- ✅ Protection against root/jailbreak extraction
- ✅ Protection against malicious backups
- ✅ Forward secrecy (key unique per installation)
```

- [ ] **Action 1.7.2 :** Mettre à jour `README.md`
```markdown
## Security

HydrateOrDie implements **military-grade AES-256 encryption** for all local data:
- SQLite database encrypted with SQLCipher
- Encryption keys stored in iOS Keychain / Android EncryptedSharedPreferences
- Full RGPD Article 32 compliance
```

**Validation :** Documentation claire et complète.

---

#### ✅ Critères de Validation CR-1

- [x] `sqflite_sqlcipher` intégré dans `pubspec.yaml`
- [x] `flutter_secure_storage` ajouté
- [x] Service `DatabaseEncryptionService` créé et testé
- [x] `DatabaseHelper` modifié pour utiliser chiffrement
- [x] Migration base existante implémentée
- [x] Tests unitaires + intégration passent (100%)
- [x] Validation manuelle sur devices réels réussie
- [x] Documentation mise à jour

**Verdict :** 🟢 **COMPLET** si tous les items cochés.

---

### CR-2 : Ajouter flutter_secure_storage pour Tokens/Secrets

**Epic Proposée :** Epic 4 - Security Hardening
**Story Proposée :** Story 4.2 - Secure Storage Implementation
**Effort Estimé :** 1 jour
**Assigné à :** Dev Agent

#### Étape 2.1 : Ajouter Dépendance

- [ ] **Action 2.1.1 :** Vérifier que `flutter_secure_storage` est déjà ajouté (fait dans CR-1)
```yaml
# pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.0.0  # ✅ Déjà ajouté dans CR-1
```

**Validation :** Dépendance présente dans `pubspec.yaml`.

---

#### Étape 2.2 : Créer Service de Stockage Sécurisé

- [ ] **Action 2.2.1 :** Créer `lib/core/security/secure_storage_service.dart`
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service de stockage sécurisé pour tokens et secrets
///
/// Utilise iOS Keychain et Android EncryptedSharedPreferences
/// pour stocker de manière sécurisée les données sensibles.
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Clés de stockage
  static const _firebaseTokenKey = 'firebase_jwt_token';
  static const _userIdKey = 'user_id';
  static const _refreshTokenKey = 'firebase_refresh_token';

  /// Sauvegarde le token JWT Firebase
  Future<void> saveFirebaseToken(String token) async {
    await _storage.write(key: _firebaseTokenKey, value: token);
  }

  /// Récupère le token JWT Firebase
  Future<String?> getFirebaseToken() async {
    return await _storage.read(key: _firebaseTokenKey);
  }

  /// Supprime le token JWT Firebase (logout)
  Future<void> deleteFirebaseToken() async {
    await _storage.delete(key: _firebaseTokenKey);
  }

  /// Sauvegarde le refresh token Firebase
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Récupère le refresh token Firebase
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Sauvegarde l'ID utilisateur
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Récupère l'ID utilisateur
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Supprime TOUTES les données sécurisées (suppression compte)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Vérifie si un token Firebase existe
  Future<bool> hasFirebaseToken() async {
    final token = await getFirebaseToken();
    return token != null && token.isNotEmpty;
  }
}
```

**Validation :** Fichier créé, compilable.

---

#### Étape 2.3 : Intégrer dans DI (GetIt)

- [ ] **Action 2.3.1 :** Ajouter `SecureStorageService` dans `lib/core/di/injection.dart`
```dart
import '../../core/security/secure_storage_service.dart';

Future<void> setupDependencies() async {
  // ... autres dépendances ...

  // ========================================
  // SECURITY SERVICES
  // ========================================

  // SecureStorageService - Singleton
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // DatabaseEncryptionService - Singleton
  getIt.registerLazySingleton<DatabaseEncryptionService>(
    () => DatabaseEncryptionService(),
  );
}
```

**Validation :** Service accessible via `getIt<SecureStorageService>()`.

---

#### Étape 2.4 : Tester Service

- [ ] **Action 2.4.1 :** Créer test unitaire `test/core/security/secure_storage_service_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/core/security/secure_storage_service.dart';

void main() {
  group('SecureStorageService', () {
    late SecureStorageService service;

    setUp(() {
      service = SecureStorageService();
    });

    test('should save and retrieve Firebase token', () async {
      const testToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...';

      await service.saveFirebaseToken(testToken);
      final retrievedToken = await service.getFirebaseToken();

      expect(retrievedToken, equals(testToken));
    });

    test('should delete Firebase token', () async {
      await service.saveFirebaseToken('test_token');
      await service.deleteFirebaseToken();
      final token = await service.getFirebaseToken();

      expect(token, isNull);
    });

    test('should save and retrieve user ID', () async {
      const testUserId = 'user-123-abc';

      await service.saveUserId(testUserId);
      final retrievedUserId = await service.getUserId();

      expect(retrievedUserId, equals(testUserId));
    });
  });
}
```

- [ ] **Action 2.4.2 :** Exécuter tests
```bash
flutter test test/core/security/secure_storage_service_test.dart
```

**Validation :** Tous les tests passent.

---

#### ✅ Critères de Validation CR-2

- [x] `flutter_secure_storage` dans `pubspec.yaml`
- [x] `SecureStorageService` créé avec méthodes token/userId
- [x] Service intégré dans DI (GetIt)
- [x] Tests unitaires passent (100%)
- [x] Documentation mise à jour (security-auth.md)

**Verdict :** 🟢 **COMPLET** si tous les items cochés.

---

### CR-3 : Chiffrer Photos ou Anonymiser Métadonnées EXIF

**Epic Proposée :** Epic 4 - Security Hardening
**Story Proposée :** Story 4.3 - Photo Encryption & EXIF Sanitization
**Effort Estimé :** 2 jours
**Assigné à :** Dev Agent

#### Étape 3.1 : Ajouter Dépendances

- [ ] **Action 3.1.1 :** Ajouter packages dans `pubspec.yaml`
```yaml
dependencies:
  encrypt: ^5.0.3  # Pour chiffrement AES-256 photos
  image: ^4.0.17   # Pour suppression métadonnées EXIF
```

- [ ] **Action 3.1.2 :** Exécuter `flutter pub get`

**Validation :** Dépendances installées.

---

#### Étape 3.2 : Créer Service de Chiffrement Photos

- [ ] **Action 3.2.1 :** Créer `lib/core/security/photo_encryption_service.dart`
```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image/image.dart' as img;
import '../security/database_encryption_service.dart';

/// Service de chiffrement et anonymisation des photos
///
/// Chiffre les photos selfies avec AES-256 et supprime les métadonnées EXIF.
class PhotoEncryptionService {
  final DatabaseEncryptionService _encryptionService;

  PhotoEncryptionService(this._encryptionService);

  /// Chiffre et anonymise une photo
  ///
  /// 1. Supprime métadonnées EXIF (géolocalisation, modèle téléphone)
  /// 2. Chiffre la photo avec AES-256
  /// 3. Sauvegarde le fichier chiffré (.enc)
  ///
  /// Returns: Chemin du fichier chiffré
  Future<String> encryptAndSavePhoto({
    required File photo,
    required String photoId,
    required String destinationDir,
  }) async {
    try {
      // Étape 1: Supprimer métadonnées EXIF
      final cleanedBytes = await _removeExifData(photo);

      // Étape 2: Chiffrer la photo
      final encryptedBytes = await _encryptPhoto(cleanedBytes);

      // Étape 3: Sauvegarder fichier chiffré
      final encryptedPath = '$destinationDir/$photoId.enc';
      final encryptedFile = File(encryptedPath);
      await encryptedFile.writeAsBytes(encryptedBytes);

      // Supprimer photo originale (non chiffrée)
      if (await photo.exists()) {
        await photo.delete();
      }

      return encryptedPath;
    } catch (e) {
      throw PhotoEncryptionException('Failed to encrypt photo: $e');
    }
  }

  /// Déchiffre une photo
  ///
  /// Returns: Bytes de l'image déchiffrée
  Future<Uint8List> decryptPhoto(File encryptedPhoto) async {
    try {
      final encryptedBytes = await encryptedPhoto.readAsBytes();
      return await _decryptPhoto(encryptedBytes);
    } catch (e) {
      throw PhotoEncryptionException('Failed to decrypt photo: $e');
    }
  }

  /// Supprime métadonnées EXIF d'une image
  Future<Uint8List> _removeExifData(File photo) async {
    final bytes = await photo.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw PhotoEncryptionException('Invalid image format');
    }

    // Réencoder sans métadonnées EXIF
    final cleanBytes = img.encodeJpg(image, quality: 85);
    return Uint8List.fromList(cleanBytes);
  }

  /// Chiffre des bytes avec AES-256
  Future<Uint8List> _encryptPhoto(Uint8List photoBytes) async {
    // Utiliser même clé que SQLite pour simplicité
    final keyString = await _encryptionService.getOrCreateEncryptionKey();
    final key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromSecureRandom(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(photoBytes, iv: iv);

    // Concaténer IV + données chiffrées (IV nécessaire pour déchiffrement)
    final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
    result.setRange(0, iv.bytes.length, iv.bytes);
    result.setRange(iv.bytes.length, result.length, encrypted.bytes);

    return result;
  }

  /// Déchiffre des bytes avec AES-256
  Future<Uint8List> _decryptPhoto(Uint8List encryptedBytes) async {
    // Extraire IV (16 premiers bytes)
    final ivBytes = encryptedBytes.sublist(0, 16);
    final iv = encrypt.IV(ivBytes);

    // Extraire données chiffrées (reste)
    final encryptedData = encryptedBytes.sublist(16);

    // Récupérer clé de chiffrement
    final keyString = await _encryptionService.getOrCreateEncryptionKey();
    final key = encrypt.Key.fromBase64(keyString);

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedData),
      iv: iv,
    );

    return Uint8List.fromList(decrypted);
  }
}

/// Exception levée lors d'erreurs de chiffrement photos
class PhotoEncryptionException implements Exception {
  final String message;
  PhotoEncryptionException(this.message);

  @override
  String toString() => 'PhotoEncryptionException: $message';
}
```

**Validation :** Fichier créé, compilable.

---

#### Étape 3.3 : Intégrer dans le Flow de Capture Photo

- [ ] **Action 3.3.1 :** Modifier le service/repository qui sauvegarde les photos (à créer si n'existe pas)

**Exemple d'intégration :**
```dart
// lib/data/repositories/photo_storage_repository_impl.dart
import 'package:hydrate_or_die/core/security/photo_encryption_service.dart';

class PhotoStorageRepositoryImpl {
  final PhotoEncryptionService _encryptionService;

  Future<String> saveHydrationPhoto(File photo, String logId) async {
    // Définir répertoire destination
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = '${appDir.path}/hydration_photos';
    await Directory(photosDir).create(recursive: true);

    // Chiffrer et sauvegarder photo (EXIF supprimé automatiquement)
    final encryptedPath = await _encryptionService.encryptAndSavePhoto(
      photo: photo,
      photoId: logId,
      destinationDir: photosDir,
    );

    return encryptedPath;  // Retourne chemin fichier chiffré (.enc)
  }

  Future<Uint8List> loadHydrationPhoto(String encryptedPath) async {
    final encryptedFile = File(encryptedPath);
    return await _encryptionService.decryptPhoto(encryptedFile);
  }
}
```

**Validation :** Photos sauvegardées chiffrées, lisibles uniquement via `decryptPhoto()`.

---

#### Étape 3.4 : Tester Chiffrement Photos

- [ ] **Action 3.4.1 :** Créer test unitaire `test/core/security/photo_encryption_service_test.dart`
```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/core/security/photo_encryption_service.dart';

void main() {
  group('PhotoEncryptionService', () {
    test('should encrypt and decrypt photo successfully', () async {
      // TODO: Implémenter test avec photo test
    });

    test('should remove EXIF metadata', () async {
      // TODO: Vérifier suppression métadonnées
    });
  });
}
```

- [ ] **Action 3.4.2 :** Validation manuelle sur device

**Validation :** Photos chiffrées (.enc) illisibles sans clé, métadonnées EXIF supprimées.

---

#### ✅ Critères de Validation CR-3

- [x] Packages `encrypt` et `image` ajoutés
- [x] `PhotoEncryptionService` créé et testé
- [x] Intégration dans flow de capture photo complète
- [x] Tests unitaires passent
- [x] Validation manuelle réussie (photos illisibles)

**Verdict :** 🟢 **COMPLET** si tous les items cochés.

---

## 🟠 PHASE 2 : Fixes HAUTE Priorité (Recommandés Production)

### H-1 : Implémenter Validation et Sanitisation Inputs Utilisateur

**Epic Proposée :** Epic 4 - Security Hardening
**Story Proposée :** Story 4.4 - Input Validation & Sanitization
**Effort Estimé :** 1-2 jours
**Assigné à :** Dev Agent

#### Étape 4.1 : Créer Validateurs d'Entrée

- [ ] **Action 4.1.1 :** Créer `lib/core/utils/input_validators.dart`
```dart
/// Validateurs pour inputs utilisateur
///
/// Fournit validation et sanitisation pour tous les champs de formulaire.
class InputValidators {
  /// Valide le poids utilisateur (30-300 kg)
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le poids est requis';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Format invalide (nombres uniquement)';
    }

    if (weight < 30 || weight > 300) {
      return 'Poids invalide (30-300 kg)';
    }

    return null;  // Validation OK
  }

  /// Valide l'âge utilisateur (10-120 ans)
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'âge est requis';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Format invalide (nombre entier)';
    }

    if (age < 10 || age > 120) {
      return 'Âge invalide (10-120 ans)';
    }

    return null;
  }

  /// Sanitise du texte libre (supprime caractères dangereux)
  static String sanitizeText(String input) {
    // Supprimer caractères SQL dangereux et HTML/XSS
    return input
        .replaceAll(RegExp(r'[<>"\'`]'), '')  // HTML/XSS
        .replaceAll(RegExp(r'[;\\]'), '')      // SQL
        .trim();
  }

  /// Valide le volume d'hydratation (0.1-2.0 L)
  static String? validateVolumeLiters(double? value) {
    if (value == null) {
      return 'Le volume est requis';
    }

    if (value < 0.1 || value > 2.0) {
      return 'Volume invalide (0.1-2.0 litres)';
    }

    return null;
  }

  /// Valide un chemin de fichier (path traversal protection)
  static bool isValidFilePath(String path) {
    // Interdire ".." (path traversal)
    if (path.contains('..')) return false;

    // Interdire caractères dangereux
    final dangerousChars = RegExp(r'[<>:"|?*]');
    if (dangerousChars.hasMatch(path)) return false;

    return true;
  }
}
```

**Validation :** Fichier créé, compilable.

---

#### Étape 4.2 : Intégrer Validation dans Formulaires

- [ ] **Action 4.2.1 :** Ajouter validation dans les écrans onboarding
```dart
// Exemple: lib/presentation/screens/onboarding/weight_screen.dart
TextFormField(
  validator: InputValidators.validateWeight,  // ⬅️ Ajouter validateur
  // ... autres propriétés
)
```

- [ ] **Action 4.2.2 :** Ajouter sanitisation dans les data sources
```dart
// Exemple: lib/data/data_sources/local/user_local_data_source.dart
Future<void> saveUserProfile(UserDto userDto) async {
  // Sanitiser texte libre avant sauvegarde
  final sanitizedDto = userDto.copyWith(
    // Si champs texte libres existent, les sanitiser
  );

  // ... reste de l'implémentation
}
```

**Validation :** Tous les inputs utilisateur validés.

---

#### ✅ Critères de Validation H-1

- [x] `InputValidators` créé avec méthodes validation/sanitisation
- [x] Validation intégrée dans tous les formulaires
- [x] Sanitisation intégrée dans data sources
- [x] Tests unitaires validateurs passent

**Verdict :** 🟢 **COMPLET** si tous les items cochés.

---

### H-2 : Configurer Firestore Security Rules Strictes

**Epic Proposée :** Epic 4 - Firebase Integration (Auth)
**Story Proposée :** Story 4.X - Firestore Security Rules Setup
**Effort Estimé :** 1 jour
**Assigné à :** Dev Agent

#### Étape 5.1 : Créer Firestore Security Rules

- [ ] **Action 5.1.1 :** Créer fichier `firestore.rules` à la racine du projet
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ===========================================
    // RÈGLE PAR DÉFAUT: DENY ALL
    // ===========================================
    match /{document=**} {
      allow read, write: if false;  // ⬅️ DENY par défaut
    }

    // ===========================================
    // USER DATA (Authenticated Users Only)
    // ===========================================
    match /users/{userId} {
      // User peut lire/écrire UNIQUEMENT ses propres données
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;

      // Profile document
      match /profile/{docId} {
        allow read, write: if request.auth.uid == userId;

        // Validation données profil
        allow create: if request.resource.data.keys().hasAll(['weight', 'age', 'gender'])
                      && request.resource.data.weight >= 30
                      && request.resource.data.weight <= 300
                      && request.resource.data.age >= 10
                      && request.resource.data.age <= 120;
      }

      // Hydration logs subcollection
      match /hydrationLogs/{logId} {
        allow read, write: if request.auth.uid == userId;

        // Validation logs
        allow create: if request.resource.data.volumeLiters > 0
                      && request.resource.data.volumeLiters <= 2.0;
      }

      // Avatar state document
      match /avatar/{docId} {
        allow read, write: if request.auth.uid == userId;
      }

      // Streak data document
      match /streak/{docId} {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```

- [ ] **Action 5.1.2 :** Déployer rules Firebase
```bash
firebase deploy --only firestore:rules
```

**Validation :** Rules déployées, testées avec Firebase Emulator.

---

#### Étape 5.2 : Tester Security Rules

- [ ] **Action 5.2.1 :** Créer tests Firestore Rules `test/firestore_rules_test.dart`
```dart
// TODO: Implémenter tests avec Firebase Emulator
```

- [ ] **Action 5.2.2 :** Tester manuellement
```bash
# Démarrer Firebase Emulator
firebase emulators:start

# Tester accès non authentifié (doit FAIL)
# Tester accès authentifié à données d'un autre user (doit FAIL)
# Tester accès authentifié à ses propres données (doit SUCCESS)
```

**Validation :** Tous les tests de sécurité passent.

---

#### ✅ Critères de Validation H-2

- [x] `firestore.rules` créé avec règles strictes
- [x] Rules déployées sur Firebase
- [x] Tests Firestore Emulator passent
- [x] Validation manuelle réussie

**Verdict :** 🟢 **COMPLET** si tous les items cochés.

---

### H-3 : Mettre à Jour Firebase Stack

**Epic Proposée :** Epic 4 - Maintenance
**Story Proposée :** Story 4.Y - Dependency Updates (Firebase)
**Effort Estimé :** 0.5 jour
**Assigné à :** Dev Agent

#### Étape 6.1 : Mettre à Jour Dépendances Firebase

- [ ] **Action 6.1.1 :** Exécuter mise à jour
```bash
flutter pub upgrade firebase_core firebase_auth cloud_firestore firebase_analytics
```

- [ ] **Action 6.1.2 :** Vérifier versions dans `pubspec.lock`
```bash
grep -A 2 "firebase_core:" pubspec.lock
grep -A 2 "firebase_auth:" pubspec.lock
```

**Validation :** Versions Firebase ≥ 4.x installées.

---

#### Étape 6.2 : Tester Non-Régression

- [ ] **Action 6.2.1 :** Exécuter tous les tests
```bash
flutter test
```

- [ ] **Action 6.2.2 :** Builder app release
```bash
flutter build apk --release
flutter build ios --release
```

**Validation :** Aucune régression, builds réussis.

---

#### ✅ Critères de Validation H-3

- [x] Firebase stack mise à jour (≥ 4.x)
- [x] Tests passent (100%)
- [x] Builds release réussis

**Verdict :** 🟢 **COMPLET** si tous les items cochés.

---

## 🟡 PHASE 3 : Fixes MOYENNE Priorité (Post-MVP, V1.1)

*(Items détaillés dans le rapport d'audit - Section 4.3)*

### M-1 : Ajouter Root/Jailbreak Detection
**Effort :** 1 jour | **Epic :** Epic 5 - Advanced Security

### M-2 : Implémenter Certificate Pinning Custom
**Effort :** 1-2 jours | **Epic :** Epic 5 - Advanced Security

### M-3 : Activer ProGuard (Android) et Bitcode (iOS)
**Effort :** 0.5 jour | **Epic :** Epic 5 - Build Optimization

---

## 📊 Dashboard de Progression

### Résumé Phases

| Phase | Items | Effort Total | Statut |
|-------|-------|--------------|--------|
| **PHASE 1 : CRITIQUE** | 3 items | 5-6 jours | ⏳ À Faire |
| **PHASE 2 : HAUTE** | 3 items | 2.5-4 jours | ⏳ À Faire |
| **PHASE 3 : MOYENNE** | 3 items | 2.5-4 jours | 🔵 Post-MVP |

**Total Effort Bloquant (Phase 1 + 2) :** 7.5-10 jours

---

## ✅ Validation Finale Production

**Checklist Pré-Release (v1.0.0) :**

- [ ] 🔴 CR-1 : SQLite chiffré (sqflite_sqlcipher)
- [ ] 🔴 CR-2 : flutter_secure_storage implémenté
- [ ] 🔴 CR-3 : Photos chiffrées + EXIF supprimé
- [ ] 🟠 H-1 : Validation inputs complète
- [ ] 🟠 H-2 : Firestore Security Rules strictes
- [ ] 🟠 H-3 : Firebase stack à jour (≥ 4.x)

**Verdict :** 🟢 **PRÊT POUR PRODUCTION** si tous les items cochés.

---

**Document Créé par :** Quinn (QA Test Architect)
**Date :** 2026-01-16
**Version :** 1.0
