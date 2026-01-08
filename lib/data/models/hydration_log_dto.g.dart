// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hydration_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HydrationLogDto _$HydrationLogDtoFromJson(Map<String, dynamic> json) =>
    HydrationLogDto(
      id: json['id'] as String,
      timestamp: json['timestamp'] as String,
      photoPath: json['photoPath'] as String?,
      glassSizeString: json['glassSize'] as String,
      volumeLiters: (json['volumeLiters'] as num).toDouble(),
      validated: json['validated'] as bool? ?? true,
      syncedToCloud: json['syncedToCloud'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$HydrationLogDtoToJson(HydrationLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'photoPath': instance.photoPath,
      'glassSize': instance.glassSizeString,
      'volumeLiters': instance.volumeLiters,
      'validated': instance.validated,
      'syncedToCloud': instance.syncedToCloud,
      'createdAt': instance.createdAt,
    };
