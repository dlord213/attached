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

import 'auth_record.dart' as _i2;
import 'date_time_json_methods.dart';
import 'geo_point_class.dart';

part 'users_record.g.dart';

enum UsersRecordFieldsEnum {
  id('id'),
  collectionId('collectionId'),
  collectionName('collectionName'),
  email('email'),
  emailVisibility('emailVisibility'),
  verified('verified'),
  name('name'),
  avatar('avatar'),
  hasPartner('has_partner'),
  currentMood('current_mood'),
  currentEmoji('current_emoji'),
  created('created'),
  updated('updated'),
  hidden$tokenKey('tokenKey'),
  hidden$password('password'),
  hidden$passwordConfirm('passwordConfirm');

  const UsersRecordFieldsEnum(this.nameInSchema);

  final String nameInSchema;
}

@_i1.JsonSerializable()
final class UsersRecord extends _i2.AuthRecord {
  UsersRecord({
    required super.id,
    required super.collectionId,
    required super.collectionName,
    super.email,
    required super.emailVisibility,
    required super.verified,
    this.name,
    this.avatar,
    required this.hasPartner,
    this.currentMood,
    this.currentEmoji,
    this.created,
    this.updated,
  }) : super();

  factory UsersRecord.fromJson(Map<String, dynamic> json) =>
      _$UsersRecordFromJson(json);

  factory UsersRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      UsersRecordFieldsEnum.id.nameInSchema: recordModel.id,
      UsersRecordFieldsEnum.collectionId.nameInSchema: recordModel.collectionId,
      UsersRecordFieldsEnum.collectionName.nameInSchema:
          recordModel.collectionName,
    };
    return UsersRecord.fromJson(extendedJsonMap);
  }

  final String? name;

  static const nameMinValue = 0;

  static const nameMaxValue = 255;

  final String? avatar;

  @_i1.JsonKey(name: 'has_partner')
  final bool hasPartner;

  @_i1.JsonKey(name: 'current_mood')
  final String? currentMood;

  static const current_moodMinValue = 0;

  static const current_moodMaxValue = 0;

  @_i1.JsonKey(name: 'current_emoji')
  final String? currentEmoji;

  static const current_emojiMinValue = 0;

  static const current_emojiMaxValue = 0;

  final DateTime? created;

  final DateTime? updated;

  static const $collectionId = '_pb_users_auth_';

  static const $collectionName = 'users';

  Map<String, dynamic> toJson() => _$UsersRecordToJson(this);

  UsersRecord copyWith({
    String? email,
    bool? emailVisibility,
    bool? verified,
    String? name,
    String? avatar,
    bool? hasPartner,
    String? currentMood,
    String? currentEmoji,
    DateTime? created,
    DateTime? updated,
  }) {
    return UsersRecord(
      id: id,
      collectionId: collectionId,
      collectionName: collectionName,
      email: email ?? this.email,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      hasPartner: hasPartner ?? this.hasPartner,
      currentMood: currentMood ?? this.currentMood,
      currentEmoji: currentEmoji ?? this.currentEmoji,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> takeDiff(UsersRecord other) {
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
        name,
        avatar,
        hasPartner,
        currentMood,
        currentEmoji,
        created,
        updated,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? email,
    required bool emailVisibility,
    required bool verified,
    String? name,
    String? avatar,
    required bool hasPartner,
    String? currentMood,
    String? currentEmoji,
    DateTime? created,
    DateTime? updated,
  }) {
    final jsonMap = UsersRecord(
      id: '',
      collectionId: $collectionId,
      collectionName: $collectionName,
      email: email,
      emailVisibility: emailVisibility,
      verified: verified,
      name: name,
      avatar: avatar,
      hasPartner: hasPartner,
      currentMood: currentMood,
      currentEmoji: currentEmoji,
      created: created,
      updated: updated,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (email != null) {
      result.addAll({
        UsersRecordFieldsEnum.email.nameInSchema:
            jsonMap[UsersRecordFieldsEnum.email.nameInSchema]
      });
    }
    result.addAll({
      UsersRecordFieldsEnum.emailVisibility.nameInSchema:
          jsonMap[UsersRecordFieldsEnum.emailVisibility.nameInSchema]
    });
    result.addAll({
      UsersRecordFieldsEnum.verified.nameInSchema:
          jsonMap[UsersRecordFieldsEnum.verified.nameInSchema]
    });
    if (name != null) {
      result.addAll({
        UsersRecordFieldsEnum.name.nameInSchema:
            jsonMap[UsersRecordFieldsEnum.name.nameInSchema]
      });
    }
    if (avatar != null) {
      result.addAll({
        UsersRecordFieldsEnum.avatar.nameInSchema:
            jsonMap[UsersRecordFieldsEnum.avatar.nameInSchema]
      });
    }
    result.addAll({
      UsersRecordFieldsEnum.hasPartner.nameInSchema:
          jsonMap[UsersRecordFieldsEnum.hasPartner.nameInSchema]
    });
    if (currentMood != null) {
      result.addAll({
        UsersRecordFieldsEnum.currentMood.nameInSchema:
            jsonMap[UsersRecordFieldsEnum.currentMood.nameInSchema]
      });
    }
    if (currentEmoji != null) {
      result.addAll({
        UsersRecordFieldsEnum.currentEmoji.nameInSchema:
            jsonMap[UsersRecordFieldsEnum.currentEmoji.nameInSchema]
      });
    }
    if (created != null) {
      result.addAll({
        UsersRecordFieldsEnum.created.nameInSchema:
            jsonMap[UsersRecordFieldsEnum.created.nameInSchema]
      });
    }
    if (updated != null) {
      result.addAll({
        UsersRecordFieldsEnum.updated.nameInSchema:
            jsonMap[UsersRecordFieldsEnum.updated.nameInSchema]
      });
    }
    return result;
  }
}
