import 'dart:async';
import 'package:attached/models/presences_record.dart';
import 'package:attached/services/api.service.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final partnerPresenceProvider =
    AsyncNotifierProvider<PartnerPresenceNotifier, PresencesRecord?>(() {
      return PartnerPresenceNotifier();
    });

class PartnerPresenceNotifier extends AsyncNotifier<PresencesRecord?> {
  UnsubscribeFunc? _unsubscribe;

  @override
  Future<PresencesRecord?> build() async {
    final connection = ref.watch(connectionProvider);
    final partnerData = ref.read(connectionProvider.notifier).partnerData;

    if (connection == null || partnerData == null) return null;

    if (_unsubscribe != null) {
      _unsubscribe!();
    }

    _unsubscribe = await apiService.pb.collection('presences').subscribe('*', (
      e,
    ) {
      if (e.record != null && e.record!.data['user'] == partnerData.id) {
        ref.invalidateSelf();
      }
    });

    ref.onDispose(() {
      if (_unsubscribe != null) {
        _unsubscribe!();
      }
    });

    try {
      final records = await apiService.pb
          .collection('presences')
          .getList(
            filter:
                'user = "${partnerData.id}" && connection = "${connection.id}"',
          );

      if (records.items.isNotEmpty) {
        return PresencesRecord.fromRecordModel(records.items.first);
      }
    } catch (e) {
      print('Error fetching partner presence: \$e');
    }
    return null;
  }
}
