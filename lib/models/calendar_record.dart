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

part 'calendar_record.g.dart';

enum CalendarRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  user('user'),
  connection('connection'),
  title('title'),
  body('body'),
  customTag('custom_tag'),
  datetime('datetime'),
  location('location'),
  subtasks('subtasks'),
  created('created'),
  updated('updated');

  const CalendarRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class CalendarRecord extends _i2.BaseRecord {
  CalendarRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    this.user,
    this.connection,
    this.title,
    this.body,
    this.customTag,
    this.datetime,
    this.location,
    this.subtasks,
    this.created,
    this.updated,
  }) : super();

  factory CalendarRecord.fromJson(Map<String, dynamic> json) =>
      _$CalendarRecordFromJson(json);

  factory CalendarRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      CalendarRecordFieldsEnum.id.nameInSchema: recordModel.id,
      CalendarRecordFieldsEnum.collectionId.nameInSchema:
          recordModel.collectionId,
      CalendarRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return CalendarRecord.fromJson(extendedJsonMap);
  }

  final String? user;

  final String? connection;

  final String? title;

  static const titleMinValue = 0;

  static const titleMaxValue = 0;

  final String? body;

  static const bodyMinValue = 0;

  static const bodyMaxValue = 0;

  @_i1.JsonKey(name: 'custom_tag')
  final String? customTag;

  static const custom_tagMinValue = 0;

  static const custom_tagMaxValue = 0;

  @_i1.JsonKey(
    toJson: pocketBaseNullableDateTimeToJson,
    fromJson: pocketBaseNullableDateTimeFromJson,
  )
  final DateTime? datetime;

  final GeoPoint? location;

  final dynamic subtasks;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = 'pbc_786954591';

  static const $collectionName = 'calendar';

  Map<String, dynamic> toJson() => _$CalendarRecordToJson(this);

  CalendarRecord copyWith({
    String? user,
    String? connection,
    String? title,
    String? body,
    String? customTag,
    DateTime? datetime,
    GeoPoint? location,
    dynamic subtasks,
    DateTime? created,
    DateTime? updated,
  }) {
    return CalendarRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      user: user ?? this.user,
      connection: connection ?? this.connection,
      title: title ?? this.title,
      body: body ?? this.body,
      customTag: customTag ?? this.customTag,
      datetime: datetime ?? this.datetime,
      location: location ?? this.location,
      subtasks: subtasks ?? this.subtasks,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(CalendarRecord other) {
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
        user,
        connection,
        title,
        body,
        customTag,
        datetime,
        location,
        subtasks,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? user,
    String? connection,
    String? title,
    String? body,
    String? customTag,
    DateTime? datetime,
    GeoPoint? location,
    dynamic subtasks,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = CalendarRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      user: user,
      connection: connection,
      title: title,
      body: body,
      customTag: customTag,
      datetime: datetime,
      location: location,
      subtasks: subtasks,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (user != null) {
      result.addAll({
        CalendarRecordFieldsEnum.user.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.user.nameInSchema]
      });
    }
    if (connection != null) {
      result.addAll({
        CalendarRecordFieldsEnum.connection.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.connection.nameInSchema]
      });
    }
    if (title != null) {
      result.addAll({
        CalendarRecordFieldsEnum.title.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.title.nameInSchema]
      });
    }
    if (body != null) {
      result.addAll({
        CalendarRecordFieldsEnum.body.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.body.nameInSchema]
      });
    }
    if (customTag != null) {
      result.addAll({
        CalendarRecordFieldsEnum.customTag.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.customTag.nameInSchema]
      });
    }
    if (datetime != null) {
      result.addAll({
        CalendarRecordFieldsEnum.datetime.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.datetime.nameInSchema]
      });
    }
    if (location != null) {
      result.addAll({
        CalendarRecordFieldsEnum.location.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.location.nameInSchema]
      });
    }
    if (subtasks != null) {
      result.addAll({
        CalendarRecordFieldsEnum.subtasks.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.subtasks.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        CalendarRecordFieldsEnum.created.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        CalendarRecordFieldsEnum.updated.nameInSchema:
            jsonMap[CalendarRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
