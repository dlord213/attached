// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_item_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedItemRecord _$SharedItemRecordFromJson(Map<String, dynamic> json) =>
    SharedItemRecord(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      connection: json['connection'] as String?,
      createdBy: json['created_by'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      field: $enumDecodeNullable(
        _$SharedItemRecordFieldEnumEnumMap,
        json['field'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      status: $enumDecodeNullable(
        _$SharedItemRecordStatusEnumEnumMap,
        json['status'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      customTag: json['custom_tag'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$SharedItemRecordToJson(SharedItemRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'connection': instance.connection,
      'created_by': instance.createdBy,
      'title': instance.title,
      'content': instance.content,
      'field': _$SharedItemRecordFieldEnumEnumMap[instance.field],
      'status': _$SharedItemRecordStatusEnumEnumMap[instance.status],
      'custom_tag': instance.customTag,
      'due_date': instance.dueDate?.toIso8601String(),
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };

const _$SharedItemRecordFieldEnumEnumMap = {
  SharedItemRecordFieldEnum.note: 'note',
  SharedItemRecordFieldEnum.task: 'task',
  SharedItemRecordFieldEnum.clipboard: 'clipboard',
};

const _$SharedItemRecordStatusEnumEnumMap = {
  SharedItemRecordStatusEnum.pending: 'pending',
  SharedItemRecordStatusEnum.completed: 'completed',
  SharedItemRecordStatusEnum.archived: 'archived',
  SharedItemRecordStatusEnum.backlog: 'backlog',
};
