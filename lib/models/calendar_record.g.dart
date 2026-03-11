// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarRecord _$CalendarRecordFromJson(Map<String, dynamic> json) =>
    CalendarRecord(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      user: json['user'] as String?,
      connection: json['connection'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      customTag: json['custom_tag'] as String?,
      datetime: pocketBaseNullableDateTimeFromJson(json['datetime'] as String),
      location: json['location'] == null
          ? null
          : GeoPoint.fromJson(json['location'] as Map<String, dynamic>),
      subtasks: json['subtasks'],
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$CalendarRecordToJson(CalendarRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'user': instance.user,
      'connection': instance.connection,
      'title': instance.title,
      'body': instance.body,
      'custom_tag': instance.customTag,
      'datetime': pocketBaseNullableDateTimeToJson(instance.datetime),
      'location': instance.location,
      'subtasks': instance.subtasks,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
