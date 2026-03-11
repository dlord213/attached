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

part 'shared_item_record.g.dart';

enum SharedItemRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  connection('connection'),
  createdBy('created_by'),
  title('title'),
  content('content'),
  field('field'),
  status('status'),
  customTag('custom_tag'),
  dueDate('due_date'),
  created('created'),
  updated('updated');

  const SharedItemRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

enum SharedItemRecordFieldEnum {
  @_i1.JsonValue('note')
  note('note'),
  @_i1.JsonValue('task')
  task('task'),
  @_i1.JsonValue('clipboard')
  clipboard('clipboard');

  const SharedItemRecordFieldEnum(this.nameInSchema);

  final String nameInSchema;
}

enum SharedItemRecordStatusEnum {
  @_i1.JsonValue('pending')
  pending('pending'),
  @_i1.JsonValue('completed')
  completed('completed'),
  @_i1.JsonValue('archived')
  archived('archived'),
  @_i1.JsonValue('backlog')
  backlog('backlog');

  const SharedItemRecordStatusEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class SharedItemRecord extends _i2.BaseRecord {
  SharedItemRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    this.connection,
    this.createdBy,
    this.title,
    this.content,
    this.field,
    this.status,
    this.customTag,
    this.dueDate,
    this.created,
    this.updated,
  }) : super();

  factory SharedItemRecord.fromJson(Map<String, dynamic> json) =>
      _$SharedItemRecordFromJson(json);

  factory SharedItemRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      SharedItemRecordFieldsEnum.id.nameInSchema: recordModel.id,
      SharedItemRecordFieldsEnum.collectionId.nameInSchema:
          recordModel.collectionId,
      SharedItemRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return SharedItemRecord.fromJson(extendedJsonMap);
  }

  final String? connection;

  @_i1.JsonKey(name: 'created_by')
  final String? createdBy;

  final String? title;

  static const titleMinValue = 0;

  static const titleMaxValue = 0;

  final String? content;

  static const contentMinValue = 0;

  static const contentMaxValue = 0;

  @_i1.JsonKey(unknownEnumValue: _i1.JsonKey.nullForUndefinedEnumValue)
  final SharedItemRecordFieldEnum? field;

  @_i1.JsonKey(unknownEnumValue: _i1.JsonKey.nullForUndefinedEnumValue)
  final SharedItemRecordStatusEnum? status;

  @_i1.JsonKey(name: 'custom_tag')
  final String? customTag;

  static const custom_tagMinValue = 0;

  static const custom_tagMaxValue = 0;

  @_i1.JsonKey(name: 'due_date')
  final DateTime? dueDate;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = 'pbc_1427926514';

  static const $collectionName = 'shared_item';

  Map<String, dynamic> toJson() => _$SharedItemRecordToJson(this);

  SharedItemRecord copyWith({
    String? connection,
    String? createdBy,
    String? title,
    String? content,
    SharedItemRecordFieldEnum? field,
    SharedItemRecordStatusEnum? status,
    String? customTag,
    DateTime? dueDate,
    DateTime? created,
    DateTime? updated,
  }) {
    return SharedItemRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      connection: connection ?? this.connection,
      createdBy: createdBy ?? this.createdBy,
      title: title ?? this.title,
      content: content ?? this.content,
      field: field ?? this.field,
      status: status ?? this.status,
      customTag: customTag ?? this.customTag,
      dueDate: dueDate ?? this.dueDate,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(SharedItemRecord other) {
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
        title,
        content,
        field,
        status,
        customTag,
        dueDate,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? connection,
    String? createdBy,
    String? title,
    String? content,
    SharedItemRecordFieldEnum? field,
    SharedItemRecordStatusEnum? status,
    String? customTag,
    DateTime? dueDate,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = SharedItemRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      connection: connection,
      createdBy: createdBy,
      title: title,
      content: content,
      field: field,
      status: status,
      customTag: customTag,
      dueDate: dueDate,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (connection != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.connection.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.connection.nameInSchema]
      });
    }
    if (createdBy != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.createdBy.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.createdBy.nameInSchema]
      });
    }
    if (title != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.title.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.title.nameInSchema]
      });
    }
    if (content != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.content.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.content.nameInSchema]
      });
    }
    if (field != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.field.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.field.nameInSchema]
      });
    }
    if (status != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.status.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.status.nameInSchema]
      });
    }
    if (customTag != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.customTag.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.customTag.nameInSchema]
      });
    }
    if (dueDate != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.dueDate.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.dueDate.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.created.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        SharedItemRecordFieldsEnum.updated.nameInSchema:
            jsonMap[SharedItemRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
