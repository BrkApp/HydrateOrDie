import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'daily_progress.freezed.dart';
part 'daily_progress.g.dart';

/// Progression quotidienne d'hydratation
@freezed
@HiveType(typeId: 1)
class DailyProgress with _$DailyProgress {
  const factory DailyProgress({
    @HiveField(0) required String id,
    @HiveField(1) required DateTime date,
    @HiveField(2) @Default(0.0) double totalMl,
    @HiveField(3) @Default([]) List<WaterEntry> entries,
    @HiveField(4) @Default(0) int streakCount,
    @HiveField(5) @Default(false) bool goalReached,
    @HiveField(6) DateTime? lastDrinkTime,
  }) = _DailyProgress;

  factory DailyProgress.fromJson(Map<String, dynamic> json) =>
      _$DailyProgressFromJson(json);

  /// Crée une nouvelle progression pour aujourd'hui
  static DailyProgress createToday(int currentStreak) {
    final now = DateTime.now();
    return DailyProgress(
      id: '${now.year}-${now.month}-${now.day}',
      date: DateTime(now.year, now.month, now.day),
      streakCount: currentStreak,
    );
  }
}

const DailyProgress _$DailyProgressConst = DailyProgress;

extension DailyProgressX on DailyProgress {
  /// Ajoute une nouvelle entrée d'eau
  DailyProgress addEntry(WaterEntry entry) {
    final newEntries = [...entries, entry];
    final newTotal = totalMl + entry.amount;
    return copyWith(
      entries: newEntries,
      totalMl: newTotal,
      lastDrinkTime: entry.timestamp,
    );
  }

  /// Calcule le pourcentage de progression
  double getProgress(double dailyGoal) {
    if (dailyGoal == 0) return 0;
    return (totalMl / dailyGoal).clamp(0.0, 1.0);
  }

  /// Vérifie si l'objectif est atteint
  DailyProgress checkGoalReached(double dailyGoal) {
    return copyWith(goalReached: totalMl >= dailyGoal);
  }
}

/// Entrée individuelle d'eau
@freezed
@HiveType(typeId: 2)
class WaterEntry with _$WaterEntry {
  const factory WaterEntry({
    @HiveField(0) required String id,
    @HiveField(1) required DateTime timestamp,
    @HiveField(2) required double amount, // en ml
    @HiveField(3) @Default(WaterSource.photo) WaterSource source,
    @HiveField(4) String? photoPath,
    @HiveField(5) @Default(1.0) double confidence, // Confidence ML (0-1)
  }) = _WaterEntry;

  factory WaterEntry.fromJson(Map<String, dynamic> json) =>
      _$WaterEntryFromJson(json);

  /// Crée une nouvelle entrée
  static WaterEntry create({
    required double amount,
    WaterSource source = WaterSource.photo,
    String? photoPath,
    double confidence = 1.0,
  }) {
    return WaterEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      amount: amount,
      source: source,
      photoPath: photoPath,
      confidence: confidence,
    );
  }
}

/// Source de l'entrée d'eau
@HiveType(typeId: 3)
enum WaterSource {
  @HiveField(0)
  photo, // Validé par photo

  @HiveField(1)
  manual, // Entrée manuelle (premium)

  @HiveField(2)
  quick, // Ajout rapide depuis notification
}
