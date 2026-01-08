import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/streak.dart';

part 'streak_dto.g.dart';

/// Data Transfer Object for Streak entity
///
/// Provides JSON serialization for Firebase and SQLite persistence.
/// Singleton pattern - only one streak record per user.
@JsonSerializable()
class StreakDto {
  /// Fixed ID for singleton pattern
  final String id;

  /// Current consecutive days count
  final int currentStreak;

  /// Personal best - longest streak ever achieved
  final int longestStreak;

  /// Last date where goal was achieved (ISO 8601 date format YYYY-MM-DD)
  final String lastStreakDate;

  /// Whether goal was achieved today
  final bool streakActive;

  /// Last update timestamp (ISO 8601 UTC)
  final String updatedAt;

  /// Creates a streak DTO
  ///
  /// [id] should always be 'streak_singleton' for singleton pattern.
  /// [lastStreakDate] must be in ISO 8601 date format (YYYY-MM-DD).
  /// [updatedAt] must be in ISO 8601 UTC format.
  const StreakDto({
    required this.id,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastStreakDate,
    required this.streakActive,
    required this.updatedAt,
  });

  /// Creates DTO from JSON map
  ///
  /// Used for deserializing from Firestore and SQLite.
  factory StreakDto.fromJson(Map<String, dynamic> json) =>
      _$StreakDtoFromJson(json);

  /// Converts DTO to JSON map
  ///
  /// Used for serializing to Firestore and SQLite.
  Map<String, dynamic> toJson() => _$StreakDtoToJson(this);

  /// Creates DTO from domain entity
  ///
  /// Converts [Streak] entity to serializable DTO.
  /// Date is stored as ISO 8601 date string (YYYY-MM-DD only).
  factory StreakDto.fromEntity(Streak streak) {
    return StreakDto(
      id: 'streak_singleton',
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      lastStreakDate: _formatDateOnly(streak.lastStreakDate),
      streakActive: streak.streakActive,
      updatedAt: DateTime.now().toUtc().toIso8601String(),
    );
  }

  /// Converts DTO to domain entity
  ///
  /// Parses ISO 8601 date string back to DateTime.
  Streak toEntity() {
    return Streak(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastStreakDate: DateTime.parse(lastStreakDate),
      streakActive: streakActive,
    );
  }

  /// Format DateTime to ISO 8601 date only (YYYY-MM-DD)
  ///
  /// Removes time component for date-only storage.
  static String _formatDateOnly(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Creates a copy with updated fields
  StreakDto copyWith({
    String? id,
    int? currentStreak,
    int? longestStreak,
    String? lastStreakDate,
    bool? streakActive,
    String? updatedAt,
  }) {
    return StreakDto(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastStreakDate: lastStreakDate ?? this.lastStreakDate,
      streakActive: streakActive ?? this.streakActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
