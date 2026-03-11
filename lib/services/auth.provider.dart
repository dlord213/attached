import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'api.service.dart';
import 'package:http/http.dart' as http;

import 'package:attached/models/users_record.dart';

final authProvider = NotifierProvider<AuthNotifier, UsersRecord?>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<UsersRecord?> {
  @override
  UsersRecord? build() {
    apiService.pb.authStore.onChange.listen((event) {
      if (event.record is RecordModel) {
        state = UsersRecord.fromRecordModel(event.record as RecordModel);
        print(state);
      } else if (event.record == null) {
        state = null;
      }
    });

    final record = apiService.pb.authStore.record;
    if (record != null) {
      return UsersRecord.fromRecordModel(record);
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    await apiService.pb.collection('users').authWithPassword(email, password);
  }

  Future<void> register(
    String email,
    String password,
    String passwordConfirm,
    String name,
  ) async {
    await apiService.pb
        .collection('users')
        .create(
          body: {
            'email': email,
            'password': password,
            'passwordConfirm': passwordConfirm,
            'name': name,
          },
        );
    await login(email, password);
  }

  Future<void> requestPasswordReset(String email) async {
    await apiService.pb.collection('users').requestPasswordReset(email);
  }

  Future<void> logout() async {
    apiService.pb.authStore.clear();
  }

  Future<void> updateProfile({required String name, String? avatarPath}) async {
    final record = apiService.pb.authStore.record;
    if (record == null) return;

    final body = {'name': name};
    final files = <http.MultipartFile>[];

    if (avatarPath != null) {
      files.add(await http.MultipartFile.fromPath('avatar', avatarPath));
    }

    try {
      final updatedRecord = await apiService.pb
          .collection('users')
          .update(record.id, body: body, files: files);
      state = UsersRecord.fromRecordModel(updatedRecord);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}
