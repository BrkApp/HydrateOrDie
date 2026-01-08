import 'package:equatable/equatable.dart';

import 'glass_size.dart';

/// Hydration log entry entity
///
/// Represents a single drink validation event.
/// Pure domain entity for hydration tracking.
class HydrationLog extends Equatable {
  /// Unique identifier (UUID)
  final String id;

  /// Timestamp of the drink validation
  final DateTime timestamp;

  /// Path to the photo file (local storage)
  final String? photoPath;

  /// Selected glass size
  final GlassSize glassSize;

  /// Whether this entry was validated (always true for created entries)
  final bool validated;

  /// Creates a hydration log entry
  ///
  /// [id] Unique identifier
  /// [timestamp] When the drink was validated
  /// [photoPath] Optional photo path (can be null if photo capture failed)
  /// [glassSize] Size of glass consumed
  /// [validated] Validation status (default true)
  const HydrationLog({
    required this.id,
    required this.timestamp,
    this.photoPath,
    required this.glassSize,
    this.validated = true,
  });

  /// Get volume in liters based on glass size
  double get volumeLiters => glassSize.volumeLiters;

  /// Check if this log is from today
  ///
  /// Compares log date with current date (ignoring time)
  bool isToday() {
    final now = DateTime.now();
    final logDate = timestamp;

    return now.year == logDate.year &&
        now.month == logDate.month &&
        now.day == logDate.day;
  }

  /// Create a copy with updated fields
  HydrationLog copyWith({
    String? id,
    DateTime? timestamp,
    String? photoPath,
    GlassSize? glassSize,
    bool? validated,
  }) {
    return HydrationLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      photoPath: photoPath ?? this.photoPath,
      glassSize: glassSize ?? this.glassSize,
      validated: validated ?? this.validated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        timestamp,
        photoPath,
        glassSize,
        validated,
      ];

  @override
  String toString() {
    return 'HydrationLog(id: $id, timestamp: $timestamp, '
        'photoPath: $photoPath, glassSize: $glassSize, '
        'validated: $validated)';
  }
}
