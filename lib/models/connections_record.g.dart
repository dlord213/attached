// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connections_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionsRecord _$ConnectionsRecordFromJson(Map<String, dynamic> json) =>
    ConnectionsRecord(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      user1: json['user_1'] as String?,
      user2: json['user_2'] as String?,
      status: $enumDecodeNullable(
        _$ConnectionsRecordStatusEnumEnumMap,
        json['status'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      startedRelationshipAt: pocketBaseNullableDateTimeFromJson(
        json['started_relationship_at'] as String,
      ),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$ConnectionsRecordToJson(ConnectionsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'user_1': instance.user1,
      'user_2': instance.user2,
      'status': _$ConnectionsRecordStatusEnumEnumMap[instance.status],
      'started_relationship_at': pocketBaseNullableDateTimeToJson(
        instance.startedRelationshipAt,
      ),
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };

const _$ConnectionsRecordStatusEnumEnumMap = {
  ConnectionsRecordStatusEnum.pending: 'pending',
  ConnectionsRecordStatusEnum.accepted: 'accepted',
  ConnectionsRecordStatusEnum.rejected: 'rejected',
};
