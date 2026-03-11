// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_log_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodLogRecord _$MoodLogRecordFromJson(Map<String, dynamic> json) =>
    MoodLogRecord(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      user: json['user'] as String?,
      connection: json['connection'] as String?,
      emoji: json['emoji'] as String?,
      body: json['body'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$MoodLogRecordToJson(MoodLogRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'user': instance.user,
      'connection': instance.connection,
      'emoji': instance.emoji,
      'body': instance.body,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
