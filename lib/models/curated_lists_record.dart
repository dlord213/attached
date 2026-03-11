// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: unused_import

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i4;
import 'package:json_annotation/json_annotation.dart' as _i1;
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart' as _i3;

import 'base_record.dart' as _i2;
import 'date_time_json_methods.dart';
import 'geo_point_class.dart';

part 'curated_lists_record.g.dart';

enum CuratedListsRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  connection('connection'),
  createdBy('created_by'),
  category('category'),
  status('status'),
  externalId('external_id'),
  customTag('custom_tag'),
  title('title'),
  body('body'),
  author('author'),
  coverImage('cover_image'),
  created('created'),
  updated('updated');

  const CuratedListsRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

enum CuratedListsRecordCategoryEnum {
  @_i1.JsonValue('movie')
  movie('movie'),
  @_i1.JsonValue('anime')
  anime('anime'),
  @_i1.JsonValue('tv')
  tv('tv'),
  @_i1.JsonValue('book')
  book('book'),
  @_i1.JsonValue('game')
  game('game'),
  @_i1.JsonValue('album')
  album('album');

  const CuratedListsRecordCategoryEnum(this.nameInSchema);

  final String nameInSchema;
}

enum CuratedListsRecordStatusEnum {
  @_i1.JsonValue('to-do')
  toDo('to-do'),
  @_i1.JsonValue('in-progress')
  inProgress('in-progress'),
  @_i1.JsonValue('completed')
  completed('completed');

  const CuratedListsRecordStatusEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class CuratedListsRecord extends _i2.BaseRecord {
  CuratedListsRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    this.connection,
    this.createdBy,
    this.category,
    this.status,
    this.externalId,
    this.customTag,
    this.title,
    this.body,
    this.author,
    this.coverImage,
    this.created,
    this.updated,
  }) : super();

  factory CuratedListsRecord.fromJson(Map<String, dynamic> json) =>
      _$CuratedListsRecordFromJson(json);

  factory CuratedListsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      CuratedListsRecordFieldsEnum.id.nameInSchema: recordModel.id,
      CuratedListsRecordFieldsEnum.collectionId.nameInSchema:
          recordModel.collectionId,
      CuratedListsRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return CuratedListsRecord.fromJson(extendedJsonMap);
  }

  final String? connection;

  @_i1.JsonKey(name: 'created_by')
  final String? createdBy;

  @_i1.JsonKey(unknownEnumValue: _i1.JsonKey.nullForUndefinedEnumValue)
  final CuratedListsRecordCategoryEnum? category;

  @_i1.JsonKey(unknownEnumValue: _i1.JsonKey.nullForUndefinedEnumValue)
  final CuratedListsRecordStatusEnum? status;

  @_i1.JsonKey(name: 'external_id')
  final String? externalId;

  static const external_idMinValue = 0;

  static const external_idMaxValue = 0;

  @_i1.JsonKey(name: 'custom_tag')
  final String? customTag;

  static const custom_tagMinValue = 0;

  static const custom_tagMaxValue = 0;

  final String? title;

  static const titleMinValue = 0;

  static const titleMaxValue = 0;

  final String? body;

  static const bodyMinValue = 0;

  static const bodyMaxValue = 0;

  final String? author;

  static const authorMinValue = 0;

  static const authorMaxValue = 0;

  @_i1.JsonKey(name: 'cover_image')
  final String? coverImage;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = 'pbc_3277857102';

  static const $collectionName = 'curated_lists';

  Map<String, dynamic> toJson() => _$CuratedListsRecordToJson(this);

  CuratedListsRecord copyWith({
    String? connection,
    String? createdBy,
    CuratedListsRecordCategoryEnum? category,
    CuratedListsRecordStatusEnum? status,
    String? externalId,
    String? customTag,
    String? title,
    String? body,
    String? author,
    String? coverImage,
    DateTime? created,
    DateTime? updated,
  }) {
    return CuratedListsRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      connection: connection ?? this.connection,
      createdBy: createdBy ?? this.createdBy,
      category: category ?? this.category,
      status: status ?? this.status,
      externalId: externalId ?? this.externalId,
      customTag: customTag ?? this.customTag,
      title: title ?? this.title,
      body: body ?? this.body,
      author: author ?? this.author,
      coverImage: coverImage ?? this.coverImage,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(CuratedListsRecord other) {
    final thisInJsonMap = toJson();
    final otherInJsonMap = other.toJson();
    final Map<String, dynamic> result = {};
    final _i4.DeepCollectionEquality deepCollectionEquality =
        _i4.DeepCollectionEquality();
    for (final mapEntry in thisInJsonMap.entries) {
      final thisValue = mapEntry.value;
      final otherValue = otherInJsonMap[mapEntry.key];
      if (!deepCollectionEquality.equals(
        thisValue,
        otherValue,
      )) {
        result.addAll({mapEntry.key: otherValue});
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        connection,
        createdBy,
        category,
        status,
        externalId,
        customTag,
        title,
        body,
        author,
        coverImage,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? connection,
    String? createdBy,
    CuratedListsRecordCategoryEnum? category,
    CuratedListsRecordStatusEnum? status,
    String? externalId,
    String? customTag,
    String? title,
    String? body,
    String? author,
    String? coverImage,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = CuratedListsRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      connection: connection,
      createdBy: createdBy,
      category: category,
      status: status,
      externalId: externalId,
      customTag: customTag,
      title: title,
      body: body,
      author: author,
      coverImage: coverImage,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (connection != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.connection.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.connection.nameInSchema]
      });
    }
    if (createdBy != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.createdBy.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.createdBy.nameInSchema]
      });
    }
    if (category != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.category.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.category.nameInSchema]
      });
    }
    if (status != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.status.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.status.nameInSchema]
      });
    }
    if (externalId != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.externalId.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.externalId.nameInSchema]
      });
    }
    if (customTag != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.customTag.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.customTag.nameInSchema]
      });
    }
    if (title != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.title.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.title.nameInSchema]
      });
    }
    if (body != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.body.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.body.nameInSchema]
      });
    }
    if (author != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.author.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.author.nameInSchema]
      });
    }
    if (coverImage != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.coverImage.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.coverImage.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.created.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        CuratedListsRecordFieldsEnum.updated.nameInSchema:
            jsonMap[CuratedListsRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
