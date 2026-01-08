// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarDto _$AvatarDtoFromJson(Map<String, dynamic> json) => AvatarDto(
  id: json['id'] as String,
  name: json['name'] as String,
  personalityString: json['personality'] as String,
  currentStateString: json['currentState'] as String,
  lastDrinkTime: json['lastDrinkTime'] as String,
  lastUpdated: json['lastUpdated'] as String,
);

Map<String, dynamic> _$AvatarDtoToJson(AvatarDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'personality': instance.personalityString,
  'currentState': instance.currentStateString,
  'lastDrinkTime': instance.lastDrinkTime,
  'lastUpdated': instance.lastUpdated,
};
