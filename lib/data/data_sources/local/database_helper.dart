import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// SQLite database helper for Hydrate or Die
///
/// Manages database initialization, migrations, and access.
/// Implements singleton pattern for single database instance.
class DatabaseHelper {
  static const String _databaseName = 'hydrate_or_die.db';
  static const int _databaseVersion = 4;

  static Database? _database;

  /// Get database instance (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database with tables and indexes
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create all tables on first database creation
  Future<void> _onCreate(Database db, int version) async {
    // Table: user_profile (singleton)
    await db.execute('''
      CREATE TABLE user_profile (
        id TEXT PRIMARY KEY NOT NULL,
        user_id TEXT NOT NULL,
        weight REAL NOT NULL CHECK(weight >= 30.0 AND weight <= 300.0),
        age INTEGER NOT NULL CHECK(age >= 10 AND age <= 120),
        gender TEXT NOT NULL CHECK(gender IN ('male', 'female', 'other')),
        activity_level TEXT NOT NULL,
        location_permission_granted INTEGER NOT NULL DEFAULT 0,
        daily_goal_liters REAL NOT NULL CHECK(daily_goal_liters >= 1.5 AND daily_goal_liters <= 5.0),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Table: avatar_state (singleton)
    await db.execute('''
      CREATE TABLE avatar_state (
        id TEXT PRIMARY KEY NOT NULL DEFAULT 'avatar_singleton',
        name TEXT NOT NULL,
        personality TEXT NOT NULL,
        currentState TEXT NOT NULL,
        lastDrinkTime TEXT NOT NULL,
        death_time TEXT,
        lastUpdated TEXT NOT NULL
      )
    ''');

    // Table: hydration_logs
    await db.execute('''
      CREATE TABLE hydration_logs (
        id TEXT PRIMARY KEY NOT NULL,
        timestamp TEXT NOT NULL,
        photo_path TEXT,
        glass_size TEXT NOT NULL DEFAULT 'medium',
        volume_liters REAL NOT NULL CHECK(volume_liters > 0),
        validated INTEGER NOT NULL DEFAULT 1,
        synced_to_cloud INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Indexes for hydration_logs
    await db.execute(
        'CREATE INDEX idx_hydration_logs_timestamp ON hydration_logs(timestamp)');
    await db.execute(
        'CREATE INDEX idx_hydration_logs_synced ON hydration_logs(synced_to_cloud)');

    // Table: streak_data (singleton)
    await db.execute('''
      CREATE TABLE streak_data (
        id TEXT PRIMARY KEY NOT NULL DEFAULT 'streak_singleton',
        current_streak INTEGER NOT NULL DEFAULT 0 CHECK(current_streak >= 0),
        longest_streak INTEGER NOT NULL DEFAULT 0 CHECK(longest_streak >= 0),
        last_streak_date TEXT NOT NULL,
        streak_active INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL
      )
    ''');

    // Table: notification_state (singleton)
    await db.execute('''
      CREATE TABLE notification_state (
        id TEXT PRIMARY KEY NOT NULL DEFAULT 'notification_singleton',
        current_level TEXT NOT NULL DEFAULT 'calm',
        last_notification_time TEXT,
        notifications_sent_today INTEGER NOT NULL DEFAULT 0 CHECK(notifications_sent_today >= 0),
        updated_at TEXT NOT NULL
      )
    ''');
  }

  /// Handle database migrations for future versions
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migration V1 → V2: Add death_time column to avatar_state (Story 1.7)
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE avatar_state ADD COLUMN death_time TEXT');
      print('[DatabaseHelper] Migration V1→V2: Added death_time column');
    }

    // Migration V2 → V3: Rebuild avatar_state table with correct JSON schema (Story 1.8 bugfix)
    if (oldVersion < 3) {
      print('[DatabaseHelper] Migration V2→V3: Rebuilding avatar_state table');

      // Step 1: Create backup of existing data (if any)
      final existingData = await db.query('avatar_state');

      // Step 2: Drop old table
      await db.execute('DROP TABLE IF EXISTS avatar_state');

      // Step 3: Create new table with correct JSON column names
      await db.execute('''
        CREATE TABLE avatar_state (
          id TEXT PRIMARY KEY NOT NULL DEFAULT 'avatar_singleton',
          name TEXT NOT NULL,
          personality TEXT NOT NULL,
          currentState TEXT NOT NULL,
          lastDrinkTime TEXT NOT NULL,
          death_time TEXT,
          lastUpdated TEXT NOT NULL
        )
      ''');

      // Step 4: Migrate existing data if any (map old columns to new)
      if (existingData.isNotEmpty) {
        final oldRow = existingData.first;
        await db.insert('avatar_state', {
          'id': oldRow['id'],
          'name': oldRow['name'] ?? 'Avatar', // Default if missing
          'personality': oldRow['selected_avatar_id'] ?? 'doctor', // Map old column
          'currentState': oldRow['current_state'] ?? 'fresh',
          'lastDrinkTime': oldRow['last_drink_time'] ?? DateTime.now().toUtc().toIso8601String(),
          'death_time': oldRow['death_time'],
          'lastUpdated': oldRow['last_updated'] ?? DateTime.now().toUtc().toIso8601String(),
        });
        print('[DatabaseHelper] Migration V2→V3: Migrated existing avatar data');
      }
    }

    // Migration V3 → V4: Add user_profile table (Story 2.3)
    if (oldVersion < 4) {
      print('[DatabaseHelper] Migration V3→V4: Adding user_profile table');

      await db.execute('''
        CREATE TABLE user_profile (
          id TEXT PRIMARY KEY NOT NULL,
          user_id TEXT NOT NULL,
          weight REAL NOT NULL CHECK(weight >= 30.0 AND weight <= 300.0),
          age INTEGER NOT NULL CHECK(age >= 10 AND age <= 120),
          gender TEXT NOT NULL CHECK(gender IN ('male', 'female', 'other')),
          activity_level TEXT NOT NULL,
          location_permission_granted INTEGER NOT NULL DEFAULT 0,
          daily_goal_liters REAL NOT NULL CHECK(daily_goal_liters >= 1.5 AND daily_goal_liters <= 5.0),
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      print('[DatabaseHelper] Migration V3→V4: user_profile table created successfully');
    }
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Delete database (for testing or account deletion)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
