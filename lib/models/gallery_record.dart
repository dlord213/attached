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

part 'gallery_record.g.dart';

enum GalleryRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  connection('connection'),
  createdBy('created_by'),
  image('image'),
  isEncrypted('is_encrypted'),
  customTag('custom_tag'),
  created('created'),
  updated('updated');

  const GalleryRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class GalleryRecord extends _i2.BaseRecord {
  GalleryRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    this.connection,
    this.createdBy,
    this.image,
    required this.isEncrypted,
    this.customTag,
    this.created,
    this.updated,
  }) : super();

  factory GalleryRecord.fromJson(Map<String, dynamic> json) =>
      _$GalleryRecordFromJson(json);

  factory GalleryRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      GalleryRecordFieldsEnum.id.nameInSchema: recordModel.id,
      GalleryRecordFieldsEnum.collectionId.nameInSchema:
          recordModel.collectionId,
      GalleryRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return GalleryRecord.fromJson(extendedJsonMap);
  }

  final String? connection;

  @_i1.JsonKey(name: 'created_by')
  final String? createdBy;

  final String? image;

  @_i1.JsonKey(name: 'is_encrypted')
  final bool isEncrypted;

  @_i1.JsonKey(name: 'custom_tag')
  final String? customTag;

  static const custom_tagMinValue = 0;

  static const custom_tagMaxValue = 0;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = 'pbc_3598190544';

  static const $collectionName = 'gallery';

  Map<String, dynamic> toJson() => _$GalleryRecordToJson(this);

  GalleryRecord copyWith({
    String? connection,
    String? createdBy,
    String? image,
    bool? isEncrypted,
    String? customTag,
    DateTime? created,
    DateTime? updated,
  }) {
    return GalleryRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      connection: connection ?? this.connection,
      createdBy: createdBy ?? this.createdBy,
      image: image ?? this.image,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      customTag: customTag ?? this.customTag,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(GalleryRecord other) {
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
        image,
        isEncrypted,
        customTag,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? connection,
    String? createdBy,
    String? image,
    required bool isEncrypted,
    String? customTag,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = GalleryRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      connection: connection,
      createdBy: createdBy,
      image: image,
      isEncrypted: isEncrypted,
      customTag: customTag,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (connection != null) {
      result.addAll({
        GalleryRecordFieldsEnum.connection.nameInSchema:
            jsonMap[GalleryRecordFieldsEnum.connection.nameInSchema]
      });
    }
    if (createdBy != null) {
      result.addAll({
        GalleryRecordFieldsEnum.createdBy.nameInSchema:
            jsonMap[GalleryRecordFieldsEnum.createdBy.nameInSchema]
      });
    }
    if (image != null) {
      result.addAll({
        GalleryRecordFieldsEnum.image.nameInSchema:
            jsonMap[GalleryRecordFieldsEnum.image.nameInSchema]
      });
    }
    result.addAll({
      GalleryRecordFieldsEnum.isEncrypted.nameInSchema:
          jsonMap[GalleryRecordFieldsEnum.isEncrypted.nameInSchema]
    });
    if (customTag != null) {
      result.addAll({
        GalleryRecordFieldsEnum.customTag.nameInSchema:
            jsonMap[GalleryRecordFieldsEnum.customTag.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        GalleryRecordFieldsEnum.created.nameInSchema:
            jsonMap[GalleryRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        GalleryRecordFieldsEnum.updated.nameInSchema:
            jsonMap[GalleryRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
