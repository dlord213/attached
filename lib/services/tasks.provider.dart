import 'dart:async';
import 'package:attached/models/shared_item_record.dart';
import 'package:attached/services/api.service.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final tasksProvider =
    AsyncNotifierProvider<TasksNotifier, List<SharedItemRecord>>(() {
      return TasksNotifier();
    });

class TasksNotifier extends AsyncNotifier<List<SharedItemRecord>> {
  UnsubscribeFunc? _unsubscribe;

  @override
  Future<List<SharedItemRecord>> build() async {
    final connection = ref.watch(connectionProvider);
    if (connection == null) return [];

    // Subscribe to realtime changes only once per connection
    if (_unsubscribe != null) {
      _unsubscribe!();
    }
    _unsubscribe = await apiService.pb.collection('shared_item').subscribe('*', (
      e,
    ) {
      if (e.record != null) {
        // If there's an event on a shared_item, we just invalidate to refetch.
        // Or optimally modify the list, but invalidate is safer to start.
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
          .collection('shared_item')
          .getList(
            filter:
                'connection = "${connection.id}" && field = "task" && status != "archived"',
            sort: '-created',
            expand: 'created_by',
          );

      return records.items
          .map((item) => SharedItemRecord.fromRecordModel(item))
          .toList();
    } catch (e) {
      print('Error fetching tasks: \$e');
      return [];
    }
  }

  Future<void> addTask(String title, {String customTag = 'Together'}) async {
    final connection = ref.read(connectionProvider);
    final user = apiService.pb.authStore.record;

    if (connection == null || user == null) return;

    try {
      await apiService.pb
          .collection('shared_item')
          .create(
            body: {
              'connection': connection.id,
              'created_by': user.id,
              'title': title,
              'field': 'task',
              'status': 'pending',
              'custom_tag': customTag,
            },
          );
    } catch (e) {
      print('Error adding task: \$e');
    }
  }

  Future<void> toggleTask(String id, bool currentlyDone) async {
    try {
      await apiService.pb
          .collection('shared_item')
          .update(
            id,
            body: {'status': currentlyDone ? 'pending' : 'completed'},
          );
    } catch (e) {
      print('Error toggling task: \$e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await apiService.pb.collection('shared_item').delete(id);
    } catch (e) {
      print('Error deleting task: \$e');
    }
  }
}
