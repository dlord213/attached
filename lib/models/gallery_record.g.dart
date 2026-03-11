// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryRecord _$GalleryRecordFromJson(Map<String, dynamic> json) =>
    GalleryRecord(
      id: json['id'] as String,
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      connection: json['connection'] as String?,
      createdBy: json['created_by'] as String?,
      image: json['image'] as String?,
      isEncrypted: json['is_encrypted'] as bool,
      customTag: json['custom_tag'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$GalleryRecordToJson(GalleryRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'connection': instance.connection,
      'created_by': instance.createdBy,
      'image': instance.image,
      'is_encrypted': instance.isEncrypted,
      'custom_tag': instance.customTag,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };
