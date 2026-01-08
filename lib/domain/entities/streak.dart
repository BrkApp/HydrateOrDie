import 'package:equatable/equatable.dart';

/// Streak entity for consecutive days tracking
///
/// Tracks consecutive days where the user achieved their hydration goal.
/// Pure domain entity for streak business logic.
class Streak extends Equatable {
  /// Current number of consecutive days
  final int currentStreak;

  /// Personal best - longest streak ever achieved
  final int longestStreak;

  /// Last date where goal was achieved (YYYY-MM-DD)
  final DateTime lastStreakDate;

  /// Whether goal was achieved today
  final bool streakActive;

  /// Creates a streak entity
  ///
  /// All fields are required and immutable.
  const Streak({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastStreakDate,
    required this.streakActive,
  });

  /// Increment streak for a new day
  ///
  /// [date] The date when goal was achieved
  /// Returns new Streak with incremented current and updated longest if needed
  Streak incrementStreak(DateTime date) {
    final newCurrent = currentStreak + 1;
    final newLongest =
        newCurrent > longestStreak ? newCurrent : longestStreak;

    return Streak(
      currentStreak: newCurrent,
      longestStreak: newLongest,
      lastStreakDate: date,
      streakActive: true,
    );
  }

  /// Break the current streak
  ///
  /// Returns new Streak with current reset to 0 and inactive
  Streak breakStreak() {
    return Streak(
      currentStreak: 0,
      longestStreak: longestStreak,
      lastStreakDate: lastStreakDate,
      streakActive: false,
    );
  }

  /// Check if streak is active for today
  ///
  /// Compares last streak date with today
  bool isStreakActiveToday() {
    final today = DateTime.now();
    final lastDate = lastStreakDate;

    return streakActive &&
        today.year == lastDate.year &&
        today.month == lastDate.month &&
        today.day == lastDate.day;
  }

  /// Check if streak should increment today
  ///
  /// [today] Current date
  /// Returns true if last streak was yesterday (consecutive)
  bool shouldIncrementToday(DateTime today) {
    final yesterday = today.subtract(const Duration(days: 1));
    final lastDate = lastStreakDate;

    return yesterday.year == lastDate.year &&
        yesterday.month == lastDate.month &&
        yesterday.day == lastDate.day;
  }

  /// Create a copy with updated fields
  Streak copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastStreakDate,
    bool? streakActive,
  }) {
    return Streak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastStreakDate: lastStreakDate ?? this.lastStreakDate,
      streakActive: streakActive ?? this.streakActive,
    );
  }

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        lastStreakDate,
        streakActive,
      ];

  @override
  String toString() {
    return 'Streak(currentStreak: $currentStreak, '
        'longestStreak: $longestStreak, '
        'lastStreakDate: $lastStreakDate, '
        'streakActive: $streakActive)';
  }
}
