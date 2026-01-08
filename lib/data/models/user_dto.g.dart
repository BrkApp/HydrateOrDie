// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  userId: json['userId'] as String,
  weight: (json['weight'] as num).toDouble(),
  age: (json['age'] as num).toInt(),
  genderString: json['gender'] as String,
  activityLevelString: json['activityLevel'] as String,
  locationPermissionGranted: json['locationPermissionGranted'] as bool,
  dailyGoalLiters: (json['dailyGoalLiters'] as num).toDouble(),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'userId': instance.userId,
  'weight': instance.weight,
  'age': instance.age,
  'gender': instance.genderString,
  'activityLevel': instance.activityLevelString,
  'locationPermissionGranted': instance.locationPermissionGranted,
  'dailyGoalLiters': instance.dailyGoalLiters,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
