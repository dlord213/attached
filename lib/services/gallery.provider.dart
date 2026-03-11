import 'dart:async';
import 'package:attached/models/gallery_record.dart';
import 'package:attached/services/api.service.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

final galleryProvider =
    AsyncNotifierProvider<GalleryNotifier, List<GalleryRecord>>(() {
      return GalleryNotifier();
    });

class GalleryNotifier extends AsyncNotifier<List<GalleryRecord>> {
  UnsubscribeFunc? _unsubscribe;

  @override
  Future<List<GalleryRecord>> build() async {
    final connection = ref.watch(connectionProvider);
    if (connection == null) return [];

    if (_unsubscribe != null) {
      _unsubscribe!();
    }

    _unsubscribe = await apiService.pb.collection('gallery').subscribe('*', (
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
          .collection('gallery')
          .getList(
            filter: 'connection = "${connection.id}"',
            sort: '-created',
            expand: 'created_by',
          );

      return records.items
          .map((item) => GalleryRecord.fromRecordModel(item))
          .toList();
    } catch (e) {
      print('Error fetching gallery: \$e');
      return [];
    }
  }

  Future<void> addGalleryItem({
    required String customTag,
    required bool isEncrypted,
  }) async {
    final connection = ref.read(connectionProvider);
    final user = apiService.pb.authStore.record;

    if (connection == null || user == null) return;

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return; // User canceled picking

    try {
      final bytes = await image.readAsBytes();

      await apiService.pb
          .collection('gallery')
          .create(
            body: {
              'connection': connection.id,
              'created_by': user.id,
              'is_encrypted': isEncrypted.toString(),
              'custom_tag': customTag,
            },
            files: [
              http.MultipartFile.fromBytes(
                'image',
                bytes,
                filename: image.name,
              ),
            ],
          );
    } catch (e) {
      print('Error uploading gallery image: \$e');
    }
  }

  Future<void> deleteGalleryItem(String id) async {
    try {
      await apiService.pb.collection('gallery').delete(id);
    } catch (e) {
      print('Error deleting gallery item: \$e');
    }
  }
}
