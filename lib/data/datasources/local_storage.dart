import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../models/user_profile.dart';
import '../models/daily_progress.dart';
import '../models/notification_settings.dart';
import '../models/app_settings.dart';

/// Service de stockage local utilisant Hive
/// Gère toutes les opérations de persistance des données
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final _logger = Logger();

  // Noms des boxes
  static const String _userBox = 'user_profile';
  static const String _progressBox = 'daily_progress';
  static const String _notificationBox = 'notification_settings';
  static const String _settingsBox = 'app_settings';

  // Boxes
  late Box<UserProfile> _userProfileBox;
  late Box<DailyProgress> _progressHistoryBox;
  late Box<NotificationSettings> _notificationSettingsBox;
  late Box<AppSettings> _appSettingsBox;

  /// Initialise Hive et enregistre les adapters
  Future<void> init() async {
    try {
      _logger.i('Initializing Hive...');

      // Initialiser Hive
      await Hive.initFlutter();

      // Enregistrer les adapters (à générer avec build_runner)
      // Note: Ces adapters seront générés automatiquement
      // Hive.registerAdapter(UserProfileAdapter());
      // Hive.registerAdapter(DailyProgressAdapter());
      // Hive.registerAdapter(WaterEntryAdapter());
      // Hive.registerAdapter(NotificationSettingsAdapter());
      // Hive.registerAdapter(AppSettingsAdapter());
      // Hive.registerAdapter(WaterSourceAdapter());
      // Hive.registerAdapter(NotificationIntensityAdapter());
      // Hive.registerAdapter(MessageToneAdapter());

      // Ouvrir les boxes
      _userProfileBox = await Hive.openBox<UserProfile>(_userBox);
      _progressHistoryBox = await Hive.openBox<DailyProgress>(_progressBox);
      _notificationSettingsBox =
          await Hive.openBox<NotificationSettings>(_notificationBox);
      _appSettingsBox = await Hive.openBox<AppSettings>(_settingsBox);

      _logger.i('Hive initialized successfully');
    } catch (e, stackTrace) {
      _logger.e('Error initializing Hive', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ==================== USER PROFILE ====================

  /// Récupère le profil utilisateur
  UserProfile? getUserProfile() {
    try {
      return _userProfileBox.get('current');
    } catch (e) {
      _logger.e('Error getting user profile: $e');
      return null;
    }
  }

  /// Sauvegarde le profil utilisateur
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _userProfileBox.put('current', profile);
      _logger.d('User profile saved');
    } catch (e) {
      _logger.e('Error saving user profile: $e');
      rethrow;
    }
  }

  /// Stream du profil utilisateur
  Stream<UserProfile?> watchUserProfile() {
    return _userProfileBox.watch(key: 'current').map((event) => event.value as UserProfile?);
  }

  // ==================== DAILY PROGRESS ====================

  /// Récupère la progression du jour
  DailyProgress? getTodayProgress() {
    try {
      final today = DateTime.now();
      final key = '${today.year}-${today.month}-${today.day}';
      return _progressHistoryBox.get(key);
    } catch (e) {
      _logger.e('Error getting today progress: $e');
      return null;
    }
  }

  /// Récupère la progression d'une date spécifique
  DailyProgress? getProgressForDate(DateTime date) {
    try {
      final key = '${date.year}-${date.month}-${date.day}';
      return _progressHistoryBox.get(key);
    } catch (e) {
      _logger.e('Error getting progress for date: $e');
      return null;
    }
  }

  /// Sauvegarde la progression quotidienne
  Future<void> saveDailyProgress(DailyProgress progress) async {
    try {
      await _progressHistoryBox.put(progress.id, progress);
      _logger.d('Daily progress saved: ${progress.id}');
    } catch (e) {
      _logger.e('Error saving daily progress: $e');
      rethrow;
    }
  }

  /// Récupère l'historique des N derniers jours
  List<DailyProgress> getProgressHistory({int days = 30}) {
    try {
      final now = DateTime.now();
      final history = <DailyProgress>[];

      for (var i = 0; i < days; i++) {
        final date = now.subtract(Duration(days: i));
        final progress = getProgressForDate(date);
        if (progress != null) {
          history.add(progress);
        }
      }

      return history;
    } catch (e) {
      _logger.e('Error getting progress history: $e');
      return [];
    }
  }

  /// Stream de la progression du jour
  Stream<DailyProgress?> watchTodayProgress() {
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';
    return _progressHistoryBox
        .watch(key: key)
        .map((event) => event.value as DailyProgress?);
  }

  /// Calcule le streak actuel
  int calculateCurrentStreak() {
    try {
      final now = DateTime.now();
      var streak = 0;
      var checkDate = now;

      // Vérifier si aujourd'hui compte
      final today = getProgressForDate(checkDate);
      if (today != null && today.goalReached) {
        streak++;
      } else if (checkDate.day == now.day) {
        // Aujourd'hui ne compte pas encore, commencer à hier
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      // Remonter dans l'historique
      while (true) {
        final progress = getProgressForDate(checkDate);
        if (progress == null || !progress.goalReached) {
          break;
        }
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));

        // Limite de sécurité
        if (streak > 1000) break;
      }

      return streak;
    } catch (e) {
      _logger.e('Error calculating streak: $e');
      return 0;
    }
  }

  // ==================== NOTIFICATION SETTINGS ====================

  /// Récupère les paramètres de notification
  NotificationSettings getNotificationSettings() {
    try {
      return _notificationSettingsBox.get('current') ??
          NotificationSettings.createDefault();
    } catch (e) {
      _logger.e('Error getting notification settings: $e');
      return NotificationSettings.createDefault();
    }
  }

  /// Sauvegarde les paramètres de notification
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    try {
      await _notificationSettingsBox.put('current', settings);
      _logger.d('Notification settings saved');
    } catch (e) {
      _logger.e('Error saving notification settings: $e');
      rethrow;
    }
  }

  /// Stream des paramètres de notification
  Stream<NotificationSettings?> watchNotificationSettings() {
    return _notificationSettingsBox
        .watch(key: 'current')
        .map((event) => event.value as NotificationSettings?);
  }

  // ==================== APP SETTINGS ====================

  /// Récupère les paramètres de l'application
  AppSettings getAppSettings() {
    try {
      return _appSettingsBox.get('current') ?? AppSettings.createDefault();
    } catch (e) {
      _logger.e('Error getting app settings: $e');
      return AppSettings.createDefault();
    }
  }

  /// Sauvegarde les paramètres de l'application
  Future<void> saveAppSettings(AppSettings settings) async {
    try {
      await _appSettingsBox.put('current', settings);
      _logger.d('App settings saved');
    } catch (e) {
      _logger.e('Error saving app settings: $e');
      rethrow;
    }
  }

  /// Stream des paramètres de l'application
  Stream<AppSettings?> watchAppSettings() {
    return _appSettingsBox
        .watch(key: 'current')
        .map((event) => event.value as AppSettings?);
  }

  // ==================== UTILITIES ====================

  /// Efface toutes les données (pour debug/reset)
  Future<void> clearAll() async {
    try {
      await _userProfileBox.clear();
      await _progressHistoryBox.clear();
      await _notificationSettingsBox.clear();
      await _appSettingsBox.clear();
      _logger.w('All data cleared');
    } catch (e) {
      _logger.e('Error clearing data: $e');
      rethrow;
    }
  }

  /// Exporte les données pour backup
  Future<Map<String, dynamic>> exportData() async {
    try {
      return {
        'user_profile': getUserProfile()?.toJson(),
        'progress_history':
            _progressHistoryBox.values.map((p) => p.toJson()).toList(),
        'notification_settings': getNotificationSettings().toJson(),
        'app_settings': getAppSettings().toJson(),
        'export_date': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      _logger.e('Error exporting data: $e');
      rethrow;
    }
  }

  /// Ferme toutes les boxes
  Future<void> close() async {
    try {
      await Hive.close();
      _logger.i('Hive closed');
    } catch (e) {
      _logger.e('Error closing Hive: $e');
    }
  }
}
