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

part 'pet_record.g.dart';

enum PetRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  connection('connection'),
  type('type'),
  name('name'),
  health('health'),
  level('level'),
  lastInteractedAt('last_interacted_at'),
  created('created'),
  updated('updated');

  const PetRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class PetRecord extends _i2.BaseRecord {
  PetRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    this.connection,
    this.type,
    this.name,
    this.health,
    this.level,
    this.lastInteractedAt,
    this.created,
    this.updated,
  }) : super();

  factory PetRecord.fromJson(Map<String, dynamic> json) =>
      _$PetRecordFromJson(json);

  factory PetRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      PetRecordFieldsEnum.id.nameInSchema: recordModel.id,
      PetRecordFieldsEnum.collectionId.nameInSchema: recordModel.collectionId,
      PetRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return PetRecord.fromJson(extendedJsonMap);
  }

  final String? connection;

  final String? type;

  static const typeMinValue = 0;

  static const typeMaxValue = 0;

  final String? name;

  static const nameMinValue = 0;

  static const nameMaxValue = 0;

  final double? health;

  final double? level;

  @_i1.JsonKey(
    toJson: pocketBaseNullableDateTimeToJson,
    fromJson: pocketBaseNullableDateTimeFromJson,
    name: 'last_interacted_at',
  )
  final DateTime? lastInteractedAt;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = 'pbc_3950281204';

  static const $collectionName = 'pet';

  Map<String, dynamic> toJson() => _$PetRecordToJson(this);

  PetRecord copyWith({
    String? connection,
    String? type,
    String? name,
    double? health,
    double? level,
    DateTime? lastInteractedAt,
    DateTime? created,
    DateTime? updated,
  }) {
    return PetRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      connection: connection ?? this.connection,
      type: type ?? this.type,
      name: name ?? this.name,
      health: health ?? this.health,
      level: level ?? this.level,
      lastInteractedAt: lastInteractedAt ?? this.lastInteractedAt,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(PetRecord other) {
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
        type,
        name,
        health,
        level,
        lastInteractedAt,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? connection,
    String? type,
    String? name,
    double? health,
    double? level,
    DateTime? lastInteractedAt,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = PetRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      connection: connection,
      type: type,
      name: name,
      health: health,
      level: level,
      lastInteractedAt: lastInteractedAt,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (connection != null) {
      result.addAll({
        PetRecordFieldsEnum.connection.nameInSchema:
            jsonMap[PetRecordFieldsEnum.connection.nameInSchema]
      });
    }
    if (type != null) {
      result.addAll({
        PetRecordFieldsEnum.type.nameInSchema:
            jsonMap[PetRecordFieldsEnum.type.nameInSchema]
      });
    }
    if (name != null) {
      result.addAll({
        PetRecordFieldsEnum.name.nameInSchema:
            jsonMap[PetRecordFieldsEnum.name.nameInSchema]
      });
    }
    if (health != null) {
      result.addAll({
        PetRecordFieldsEnum.health.nameInSchema:
            jsonMap[PetRecordFieldsEnum.health.nameInSchema]
      });
    }
    if (level != null) {
      result.addAll({
        PetRecordFieldsEnum.level.nameInSchema:
            jsonMap[PetRecordFieldsEnum.level.nameInSchema]
      });
    }
    if (lastInteractedAt != null) {
      result.addAll({
        PetRecordFieldsEnum.lastInteractedAt.nameInSchema:
            jsonMap[PetRecordFieldsEnum.lastInteractedAt.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        PetRecordFieldsEnum.created.nameInSchema:
            jsonMap[PetRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        PetRecordFieldsEnum.updated.nameInSchema:
            jsonMap[PetRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
