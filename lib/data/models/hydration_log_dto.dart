import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/glass_size.dart';
import '../../domain/entities/hydration_log.dart';

part 'hydration_log_dto.g.dart';

/// Data Transfer Object for HydrationLog entity
///
/// Provides JSON serialization for Firebase and SQLite persistence.
/// Includes sync status for offline-first architecture.
@JsonSerializable()
class HydrationLogDto {
  /// Unique identifier (UUID)
  final String id;

  /// Timestamp of drink validation (ISO 8601 UTC)
  final String timestamp;

  /// Path to photo file (local storage, nullable)
  final String? photoPath;

  /// Selected glass size (serialized as string)
  @JsonKey(name: 'glassSize')
  final String glassSizeString;

  /// Volume in liters (calculated from glass size)
  final double volumeLiters;

  /// Validation status (always true for created entries)
  final bool validated;

  /// Cloud sync status (SQLite only, false by default)
  final bool syncedToCloud;

  /// Entry creation timestamp (ISO 8601 UTC)
  final String createdAt;

  /// Creates a hydration log DTO
  ///
  /// All timestamps must be in ISO 8601 UTC format.
  /// Glass size is stored as string enum.
  const HydrationLogDto({
    required this.id,
    required this.timestamp,
    this.photoPath,
    required this.glassSizeString,
    required this.volumeLiters,
    this.validated = true,
    this.syncedToCloud = false,
    required this.createdAt,
  });

  /// Creates DTO from JSON map
  ///
  /// Used for deserializing from Firestore and SQLite.
  factory HydrationLogDto.fromJson(Map<String, dynamic> json) =>
      _$HydrationLogDtoFromJson(json);

  /// Converts DTO to JSON map
  ///
  /// Used for serializing to Firestore and SQLite.
  Map<String, dynamic> toJson() => _$HydrationLogDtoToJson(this);

  /// Creates DTO from domain entity
  ///
  /// Converts [HydrationLog] entity to serializable DTO.
  /// Timestamps are converted to ISO 8601 UTC strings.
  /// Volume is calculated from glass size.
  factory HydrationLogDto.fromEntity(HydrationLog log) {
    return HydrationLogDto(
      id: log.id,
      timestamp: log.timestamp.toUtc().toIso8601String(),
      photoPath: log.photoPath,
      glassSizeString: log.glassSize.name,
      volumeLiters: log.glassSize.volumeLiters,
      validated: log.validated,
      syncedToCloud: false,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
  }

  /// Converts DTO to domain entity
  ///
  /// Parses string enum back to [GlassSize] and ISO 8601 strings to DateTime.
  ///
  /// Throws [ArgumentError] if glass size string is invalid.
  HydrationLog toEntity() {
    final glassSize = GlassSize.values.firstWhere(
      (e) => e.name == glassSizeString,
      orElse: () =>
          throw ArgumentError('Invalid glass size: $glassSizeString'),
    );

    return HydrationLog(
      id: id,
      timestamp: DateTime.parse(timestamp),
      photoPath: photoPath,
      glassSize: glassSize,
      validated: validated,
    );
  }

  /// Creates a copy with updated fields
  HydrationLogDto copyWith({
    String? id,
    String? timestamp,
    String? photoPath,
    String? glassSizeString,
    double? volumeLiters,
    bool? validated,
    bool? syncedToCloud,
    String? createdAt,
  }) {
    return HydrationLogDto(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      photoPath: photoPath ?? this.photoPath,
      glassSizeString: glassSizeString ?? this.glassSizeString,
      volumeLiters: volumeLiters ?? this.volumeLiters,
      validated: validated ?? this.validated,
      syncedToCloud: syncedToCloud ?? this.syncedToCloud,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
