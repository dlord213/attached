import 'dart:async';
import 'package:attached/models/curated_lists_record.dart';
import 'package:attached/services/api.service.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final curatedListsProvider =
    AsyncNotifierProvider<CuratedListsNotifier, List<CuratedListsRecord>>(() {
      return CuratedListsNotifier();
    });

class CuratedListsNotifier extends AsyncNotifier<List<CuratedListsRecord>> {
  UnsubscribeFunc? _unsubscribe;

  @override
  Future<List<CuratedListsRecord>> build() async {
    final connection = ref.watch(connectionProvider);
    if (connection == null) return [];

    if (_unsubscribe != null) {
      _unsubscribe!();
    }

    _unsubscribe = await apiService.pb.collection('curated_lists').subscribe(
      '*',
      (e) {
        if (e.record != null) {
          ref.invalidateSelf();
        }
      },
    );

    ref.onDispose(() {
      if (_unsubscribe != null) {
        _unsubscribe!();
      }
    });

    try {
      final records = await apiService.pb
          .collection('curated_lists')
          .getList(
            filter: 'connection = "${connection.id}"',
            sort: '-created',
            expand: 'created_by',
          );

      return records.items
          .map((item) => CuratedListsRecord.fromRecordModel(item))
          .toList();
    } catch (e) {
      print('Error fetching curated lists: \$e');
      return [];
    }
  }

  Future<void> addListItem({
    required String title,
    required String category,
    String? body,
    String? author,
    String? coverImage,
  }) async {
    final connection = ref.read(connectionProvider);
    final user = apiService.pb.authStore.record;

    if (connection == null || user == null) return;

    try {
      await apiService.pb
          .collection('curated_lists')
          .create(
            body: {
              'connection': connection.id,
              'created_by': user.id,
              'title': title,
              'category': category,
              'status': 'to-do',
              if (body != null) 'body': body,
              if (author != null) 'author': author,
              if (coverImage != null) 'cover_image': coverImage,
            },
          );
    } catch (e) {
      print('Error adding curated list item: \$e');
    }
  }

  Future<void> updateItemStatus(String id, String newStatus) async {
    try {
      await apiService.pb
          .collection('curated_lists')
          .update(id, body: {'status': newStatus});
    } catch (e) {
      print('Error updating item status: \$e');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await apiService.pb.collection('curated_lists').delete(id);
    } catch (e) {
      print('Error deleting item: \$e');
    }
  }
}
