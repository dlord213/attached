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

part 'connections_record.g.dart';

enum ConnectionsRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  user1('user_1'),
  user2('user_2'),
  status('status'),
  startedRelationshipAt('started_relationship_at'),
  created('created'),
  updated('updated');

  const ConnectionsRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

enum ConnectionsRecordStatusEnum {
  @_i1.JsonValue('pending')
  pending('pending'),
  @_i1.JsonValue('accepted')
  accepted('accepted'),
  @_i1.JsonValue('rejected')
  rejected('rejected');

  const ConnectionsRecordStatusEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class ConnectionsRecord extends _i2.BaseRecord {
  ConnectionsRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    this.user1,
    this.user2,
    this.status,
    this.startedRelationshipAt,
    this.created,
    this.updated,
  }) : super();

  factory ConnectionsRecord.fromJson(Map<String, dynamic> json) =>
      _$ConnectionsRecordFromJson(json);

  factory ConnectionsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      ConnectionsRecordFieldsEnum.id.nameInSchema: recordModel.id,
      ConnectionsRecordFieldsEnum.collectionId.nameInSchema:
          recordModel.collectionId,
      ConnectionsRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return ConnectionsRecord.fromJson(extendedJsonMap);
  }

  @_i1.JsonKey(name: 'user_1')
  final String? user1;

  @_i1.JsonKey(name: 'user_2')
  final String? user2;

  @_i1.JsonKey(unknownEnumValue: _i1.JsonKey.nullForUndefinedEnumValue)
  final ConnectionsRecordStatusEnum? status;

  @_i1.JsonKey(
    toJson: pocketBaseNullableDateTimeToJson,
    fromJson: pocketBaseNullableDateTimeFromJson,
    name: 'started_relationship_at',
  )
  final DateTime? startedRelationshipAt;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = 'pbc_1325916001';

  static const $collectionName = 'connections';

  Map<String, dynamic> toJson() => _$ConnectionsRecordToJson(this);

  ConnectionsRecord copyWith({
    String? user1,
    String? user2,
    ConnectionsRecordStatusEnum? status,
    DateTime? startedRelationshipAt,
    DateTime? created,
    DateTime? updated,
  }) {
    return ConnectionsRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
      status: status ?? this.status,
      startedRelationshipAt:
          startedRelationshipAt ?? this.startedRelationshipAt,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(ConnectionsRecord other) {
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
        user1,
        user2,
        status,
        startedRelationshipAt,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? user1,
    String? user2,
    ConnectionsRecordStatusEnum? status,
    DateTime? startedRelationshipAt,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = ConnectionsRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      user1: user1,
      user2: user2,
      status: status,
      startedRelationshipAt: startedRelationshipAt,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (user1 != null) {
      result.addAll({
        ConnectionsRecordFieldsEnum.user1.nameInSchema:
            jsonMap[ConnectionsRecordFieldsEnum.user1.nameInSchema]
      });
    }
    if (user2 != null) {
      result.addAll({
        ConnectionsRecordFieldsEnum.user2.nameInSchema:
            jsonMap[ConnectionsRecordFieldsEnum.user2.nameInSchema]
      });
    }
    if (status != null) {
      result.addAll({
        ConnectionsRecordFieldsEnum.status.nameInSchema:
            jsonMap[ConnectionsRecordFieldsEnum.status.nameInSchema]
      });
    }
    if (startedRelationshipAt != null) {
      result.addAll({
        ConnectionsRecordFieldsEnum.startedRelationshipAt.nameInSchema: jsonMap[
            ConnectionsRecordFieldsEnum.startedRelationshipAt.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        ConnectionsRecordFieldsEnum.created.nameInSchema:
            jsonMap[ConnectionsRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        ConnectionsRecordFieldsEnum.updated.nameInSchema:
            jsonMap[ConnectionsRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
