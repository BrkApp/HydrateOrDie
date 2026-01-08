// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreakDto _$StreakDtoFromJson(Map<String, dynamic> json) => StreakDto(
  id: json['id'] as String,
  currentStreak: (json['currentStreak'] as num).toInt(),
  longestStreak: (json['longestStreak'] as num).toInt(),
  lastStreakDate: json['lastStreakDate'] as String,
  streakActive: json['streakActive'] as bool,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$StreakDtoToJson(StreakDto instance) => <String, dynamic>{
  'id': instance.id,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'lastStreakDate': instance.lastStreakDate,
  'streakActive': instance.streakActive,
  'updatedAt': instance.updatedAt,
};
