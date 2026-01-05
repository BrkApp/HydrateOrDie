import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../models/user_profile.dart';
import '../models/daily_progress.dart';
import '../models/notification_settings.dart';
import '../models/app_settings.dart';

/// Service de stockage local utilisant Hive
/// Stocke les objets en JSON (pas besoin de TypeAdapters)
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

  // Boxes (stockage JSON)
  late Box _userProfileBox;
  late Box _progressHistoryBox;
  late Box _notificationSettingsBox;
  late Box _appSettingsBox;

  /// Initialise Hive
  Future<void> init() async {
    try {
      _logger.i('Initializing Hive...');

      // Initialiser Hive
      await Hive.initFlutter();

      // Ouvrir les boxes (pas de type spécifique, on stocke en Map)
      _userProfileBox = await Hive.openBox(_userBox);
      _progressHistoryBox = await Hive.openBox(_progressBox);
      _notificationSettingsBox = await Hive.openBox(_notificationBox);
      _appSettingsBox = await Hive.openBox(_settingsBox);

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
      final json = _userProfileBox.get('current') as Map<dynamic, dynamic>?;
      if (json == null) return null;
      return UserProfile.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      _logger.e('Error getting user profile: $e');
      return null;
    }
  }

  /// Sauvegarde le profil utilisateur
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _userProfileBox.put('current', profile.toJson());
      _logger.d('User profile saved');
    } catch (e) {
      _logger.e('Error saving user profile: $e');
      rethrow;
    }
  }

  /// Stream du profil utilisateur
  Stream<UserProfile?> watchUserProfile() {
    return _userProfileBox.watch(key: 'current').map((event) {
      if (event.value == null) return null;
      final json = event.value as Map<dynamic, dynamic>;
      return UserProfile.fromJson(Map<String, dynamic>.from(json));
    });
  }

  // ==================== DAILY PROGRESS ====================

  /// Récupère la progression du jour
  DailyProgress? getTodayProgress() {
    try {
      final today = DateTime.now();
      final key = '${today.year}-${today.month}-${today.day}';
      final json = _progressHistoryBox.get(key) as Map<dynamic, dynamic>?;
      if (json == null) return null;
      return DailyProgress.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      _logger.e('Error getting today progress: $e');
      return null;
    }
  }

  /// Récupère la progression d'une date spécifique
  DailyProgress? getProgressForDate(DateTime date) {
    try {
      final key = '${date.year}-${date.month}-${date.day}';
      final json = _progressHistoryBox.get(key) as Map<dynamic, dynamic>?;
      if (json == null) return null;
      return DailyProgress.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      _logger.e('Error getting progress for date: $e');
      return null;
    }
  }

  /// Sauvegarde la progression quotidienne
  Future<void> saveDailyProgress(DailyProgress progress) async {
    try {
      await _progressHistoryBox.put(progress.id, progress.toJson());
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
    return _progressHistoryBox.watch(key: key).map((event) {
      if (event.value == null) return null;
      final json = event.value as Map<dynamic, dynamic>;
      return DailyProgress.fromJson(Map<String, dynamic>.from(json));
    });
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
      final json = _notificationSettingsBox.get('current') as Map<dynamic, dynamic>?;
      if (json == null) return NotificationSettings.createDefault();
      return NotificationSettings.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      _logger.e('Error getting notification settings: $e');
      return NotificationSettings.createDefault();
    }
  }

  /// Sauvegarde les paramètres de notification
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    try {
      await _notificationSettingsBox.put('current', settings.toJson());
      _logger.d('Notification settings saved');
    } catch (e) {
      _logger.e('Error saving notification settings: $e');
      rethrow;
    }
  }

  /// Stream des paramètres de notification
  Stream<NotificationSettings?> watchNotificationSettings() {
    return _notificationSettingsBox.watch(key: 'current').map((event) {
      if (event.value == null) return null;
      final json = event.value as Map<dynamic, dynamic>;
      return NotificationSettings.fromJson(Map<String, dynamic>.from(json));
    });
  }

  // ==================== APP SETTINGS ====================

  /// Récupère les paramètres de l'application
  AppSettings getAppSettings() {
    try {
      final json = _appSettingsBox.get('current') as Map<dynamic, dynamic>?;
      if (json == null) return AppSettings.createDefault();
      return AppSettings.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      _logger.e('Error getting app settings: $e');
      return AppSettings.createDefault();
    }
  }

  /// Sauvegarde les paramètres de l'application
  Future<void> saveAppSettings(AppSettings settings) async {
    try {
      await _appSettingsBox.put('current', settings.toJson());
      _logger.d('App settings saved');
    } catch (e) {
      _logger.e('Error saving app settings: $e');
      rethrow;
    }
  }

  /// Stream des paramètres de l'application
  Stream<AppSettings?> watchAppSettings() {
    return _appSettingsBox.watch(key: 'current').map((event) {
      if (event.value == null) return null;
      final json = event.value as Map<dynamic, dynamic>;
      return AppSettings.fromJson(Map<String, dynamic>.from(json));
    });
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
      final progressHistory = <Map<String, dynamic>>[];
      for (var key in _progressHistoryBox.keys) {
        final json = _progressHistoryBox.get(key) as Map<dynamic, dynamic>?;
        if (json != null) {
          progressHistory.add(Map<String, dynamic>.from(json));
        }
      }

      return {
        'user_profile': getUserProfile()?.toJson(),
        'progress_history': progressHistory,
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
