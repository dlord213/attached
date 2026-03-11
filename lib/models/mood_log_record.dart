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

part 'mood_log_record.g.dart';

enum MoodLogRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  user('user'),
  connection('connection'),
  emoji('emoji'),
  body('body'),
  created('created'),
  updated('updated');

  const MoodLogRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class MoodLogRecord extends _i2.BaseRecord {
  MoodLogRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    this.user,
    this.connection,
    this.emoji,
    this.body,
    this.created,
    this.updated,
  }) : super();

  factory MoodLogRecord.fromJson(Map<String, dynamic> json) =>
      _$MoodLogRecordFromJson(json);

  factory MoodLogRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      MoodLogRecordFieldsEnum.id.nameInSchema: recordModel.id,
      MoodLogRecordFieldsEnum.collectionId.nameInSchema:
          recordModel.collectionId,
      MoodLogRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return MoodLogRecord.fromJson(extendedJsonMap);
  }

  final String? user;

  final String? connection;

  final String? emoji;

  static const emojiMinValue = 0;

  static const emojiMaxValue = 0;

  final String? body;

  static const bodyMinValue = 0;

  static const bodyMaxValue = 0;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = 'pbc_607439174';

  static const $collectionName = 'mood_log';

  Map<String, dynamic> toJson() => _$MoodLogRecordToJson(this);

  MoodLogRecord copyWith({
    String? user,
    String? connection,
    String? emoji,
    String? body,
    DateTime? created,
    DateTime? updated,
  }) {
    return MoodLogRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      user: user ?? this.user,
      connection: connection ?? this.connection,
      emoji: emoji ?? this.emoji,
      body: body ?? this.body,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(MoodLogRecord other) {
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
        emoji,
        body,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? user,
    String? connection,
    String? emoji,
    String? body,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = MoodLogRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      user: user,
      connection: connection,
      emoji: emoji,
      body: body,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (user != null) {
      result.addAll({
        MoodLogRecordFieldsEnum.user.nameInSchema:
            jsonMap[MoodLogRecordFieldsEnum.user.nameInSchema]
      });
    }
    if (connection != null) {
      result.addAll({
        MoodLogRecordFieldsEnum.connection.nameInSchema:
            jsonMap[MoodLogRecordFieldsEnum.connection.nameInSchema]
      });
    }
    if (emoji != null) {
      result.addAll({
        MoodLogRecordFieldsEnum.emoji.nameInSchema:
            jsonMap[MoodLogRecordFieldsEnum.emoji.nameInSchema]
      });
    }
    if (body != null) {
      result.addAll({
        MoodLogRecordFieldsEnum.body.nameInSchema:
            jsonMap[MoodLogRecordFieldsEnum.body.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        MoodLogRecordFieldsEnum.created.nameInSchema:
            jsonMap[MoodLogRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        MoodLogRecordFieldsEnum.updated.nameInSchema:
            jsonMap[MoodLogRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
