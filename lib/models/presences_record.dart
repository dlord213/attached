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

part 'presences_record.g.dart';

enum PresencesRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  user('user'),
  connection('connection'),
  status('status'),
  isDnd('is_dnd'),
  isLowBattery('is_low_battery'),
  battery('battery'),
  location('location'),
  created('created'),
  updated('updated');

  const PresencesRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class PresencesRecord extends _i2.BaseRecord {
  PresencesRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    this.user,
    this.connection,
    this.status,
    required this.isDnd,
    required this.isLowBattery,
    this.battery,
    this.location,
    this.created,
    this.updated,
  }) : super();

  factory PresencesRecord.fromJson(Map<String, dynamic> json) =>
      _$PresencesRecordFromJson(json);

  factory PresencesRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      PresencesRecordFieldsEnum.id.nameInSchema: recordModel.id,
      PresencesRecordFieldsEnum.collectionId.nameInSchema:
          recordModel.collectionId,
      PresencesRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return PresencesRecord.fromJson(extendedJsonMap);
  }

  final String? user;

  final String? connection;

  final String? status;

  static const statusMinValue = 0;

  static const statusMaxValue = 0;

  @_i1.JsonKey(name: 'is_dnd')
  final bool isDnd;

  @_i1.JsonKey(name: 'is_low_battery')
  final bool isLowBattery;

  final dynamic battery;

  final GeoPoint? location;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = 'pbc_3656386867';

  static const $collectionName = 'presences';

  Map<String, dynamic> toJson() => _$PresencesRecordToJson(this);

  PresencesRecord copyWith({
    String? user,
    String? connection,
    String? status,
    bool? isDnd,
    bool? isLowBattery,
    dynamic battery,
    GeoPoint? location,
    DateTime? created,
    DateTime? updated,
  }) {
    return PresencesRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      user: user ?? this.user,
      connection: connection ?? this.connection,
      status: status ?? this.status,
      isDnd: isDnd ?? this.isDnd,
      isLowBattery: isLowBattery ?? this.isLowBattery,
      battery: battery ?? this.battery,
      location: location ?? this.location,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(PresencesRecord other) {
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
        status,
        isDnd,
        isLowBattery,
        battery,
        location,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? user,
    String? connection,
    String? status,
    required bool isDnd,
    required bool isLowBattery,
    dynamic battery,
    GeoPoint? location,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = PresencesRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      user: user,
      connection: connection,
      status: status,
      isDnd: isDnd,
      isLowBattery: isLowBattery,
      battery: battery,
      location: location,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (user != null) {
      result.addAll({
        PresencesRecordFieldsEnum.user.nameInSchema:
            jsonMap[PresencesRecordFieldsEnum.user.nameInSchema]
      });
    }
    if (connection != null) {
      result.addAll({
        PresencesRecordFieldsEnum.connection.nameInSchema:
            jsonMap[PresencesRecordFieldsEnum.connection.nameInSchema]
      });
    }
    if (status != null) {
      result.addAll({
        PresencesRecordFieldsEnum.status.nameInSchema:
            jsonMap[PresencesRecordFieldsEnum.status.nameInSchema]
      });
    }
    result.addAll({
      PresencesRecordFieldsEnum.isDnd.nameInSchema:
          jsonMap[PresencesRecordFieldsEnum.isDnd.nameInSchema]
    });
    result.addAll({
      PresencesRecordFieldsEnum.isLowBattery.nameInSchema:
          jsonMap[PresencesRecordFieldsEnum.isLowBattery.nameInSchema]
    });
    if (battery != null) {
      result.addAll({
        PresencesRecordFieldsEnum.battery.nameInSchema:
            jsonMap[PresencesRecordFieldsEnum.battery.nameInSchema]
      });
    }
    if (location != null) {
      result.addAll({
        PresencesRecordFieldsEnum.location.nameInSchema:
            jsonMap[PresencesRecordFieldsEnum.location.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        PresencesRecordFieldsEnum.created.nameInSchema:
            jsonMap[PresencesRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        PresencesRecordFieldsEnum.updated.nameInSchema:
            jsonMap[PresencesRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
