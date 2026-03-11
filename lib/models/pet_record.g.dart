// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetRecord _$PetRecordFromJson(Map<String, dynamic> json) => PetRecord(
  id: json['id'] as String,
  collectionId: json['collectionId'] as String,
  collectionName: json['collectionName'] as String,
  connection: json['connection'] as String?,
  type: json['type'] as String?,
  name: json['name'] as String?,
  health: (json['health'] as num?)?.toDouble(),
  level: (json['level'] as num?)?.toDouble(),
  lastInteractedAt: pocketBaseNullableDateTimeFromJson(
    json['last_interacted_at'] as String,
  ),
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
  updated: json['updated'] == null
      ? null
      : DateTime.parse(json['updated'] as String),
);

Map<String, dynamic> _$PetRecordToJson(PetRecord instance) => <String, dynamic>{
  'id': instance.id,
  'collectionId': instance.collectionId,
  'collectionName': instance.collectionName,
  'connection': instance.connection,
  'type': instance.type,
  'name': instance.name,
  'health': instance.health,
  'level': instance.level,
  'last_interacted_at': pocketBaseNullableDateTimeToJson(
    instance.lastInteractedAt,
  ),
  'created': instance.created?.toIso8601String(),
  'updated': instance.updated?.toIso8601String(),
};
