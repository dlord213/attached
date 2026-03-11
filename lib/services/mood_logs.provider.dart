import 'dart:async';
import 'package:attached/models/mood_log_record.dart';
import 'package:attached/services/api.service.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final moodLogsProvider =
    AsyncNotifierProvider<MoodLogsNotifier, List<MoodLogRecord>>(() {
      return MoodLogsNotifier();
    });

class MoodLogsNotifier extends AsyncNotifier<List<MoodLogRecord>> {
  UnsubscribeFunc? _unsubscribe;

  @override
  Future<List<MoodLogRecord>> build() async {
    final connection = ref.watch(connectionProvider);
    if (connection == null) return [];

    if (_unsubscribe != null) {
      _unsubscribe!();
    }

    _unsubscribe = await apiService.pb.collection('mood_log').subscribe('*', (
      e,
    ) {
      if (e.record != null) {
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
          .collection('mood_log')
          .getList(
            filter: 'connection = "${connection.id}"',
            sort: '-created',
            expand: 'user',
          );

      return records.items
          .map((item) => MoodLogRecord.fromRecordModel(item))
          .toList();
    } catch (e) {
      print('Error fetching mood logs: \$e');
      return [];
    }
  }

  Future<void> addMoodLog(String emoji, String body) async {
    final connection = ref.read(connectionProvider);
    final user = apiService.pb.authStore.record;

    if (connection == null || user == null) return;

    try {
      await apiService.pb
          .collection('mood_log')
          .create(
            body: {
              'user': user.id,
              'connection': connection.id,
              'emoji': emoji,
              'body': body,
            },
          );
    } catch (e) {
      print('Error adding mood log: \$e');
    }
  }
}
