// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curated_lists_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CuratedListsRecord _$CuratedListsRecordFromJson(Map<String, dynamic> json) =>
    CuratedListsRecord(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      connection: json['connection'] as String?,
      createdBy: json['created_by'] as String?,
      category: $enumDecodeNullable(
        _$CuratedListsRecordCategoryEnumEnumMap,
        json['category'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      status: $enumDecodeNullable(
        _$CuratedListsRecordStatusEnumEnumMap,
        json['status'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      externalId: json['external_id'] as String?,
      customTag: json['custom_tag'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      author: json['author'] as String?,
      coverImage: json['cover_image'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$CuratedListsRecordToJson(CuratedListsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'connection': instance.connection,
      'created_by': instance.createdBy,
      'category': _$CuratedListsRecordCategoryEnumEnumMap[instance.category],
      'status': _$CuratedListsRecordStatusEnumEnumMap[instance.status],
      'external_id': instance.externalId,
      'custom_tag': instance.customTag,
      'title': instance.title,
      'body': instance.body,
      'author': instance.author,
      'cover_image': instance.coverImage,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };

const _$CuratedListsRecordCategoryEnumEnumMap = {
  CuratedListsRecordCategoryEnum.movie: 'movie',
  CuratedListsRecordCategoryEnum.anime: 'anime',
  CuratedListsRecordCategoryEnum.tv: 'tv',
  CuratedListsRecordCategoryEnum.book: 'book',
  CuratedListsRecordCategoryEnum.game: 'game',
  CuratedListsRecordCategoryEnum.album: 'album',
};

const _$CuratedListsRecordStatusEnumEnumMap = {
  CuratedListsRecordStatusEnum.toDo: 'to-do',
  CuratedListsRecordStatusEnum.inProgress: 'in-progress',
  CuratedListsRecordStatusEnum.completed: 'completed',
};
