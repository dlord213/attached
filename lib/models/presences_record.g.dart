// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presences_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresencesRecord _$PresencesRecordFromJson(Map<String, dynamic> json) =>
    PresencesRecord(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      user: json['user'] as String?,
      connection: json['connection'] as String?,
      status: json['status'] as String?,
      isDnd: json['is_dnd'] as bool,
      isLowBattery: json['is_low_battery'] as bool,
      battery: json['battery'],
      location: json['location'] == null
          ? null
          : GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$PresencesRecordToJson(PresencesRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'user': instance.user,
      'connection': instance.connection,
      'status': instance.status,
      'is_dnd': instance.isDnd,
      'is_low_battery': instance.isLowBattery,
      'battery': instance.battery,
      'location': instance.location,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
