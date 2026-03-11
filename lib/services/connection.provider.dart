import 'package:attached/services/api.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:attached/models/connections_record.dart';
import 'package:attached/models/users_record.dart';

final connectionProvider =
    NotifierProvider<ConnectionNotifier, ConnectionsRecord?>(() {
      return ConnectionNotifier();
    });

class ConnectionNotifier extends Notifier<ConnectionsRecord?> {
  UsersRecord? partnerData;

  @override
  ConnectionsRecord? build() {
    // Initial fetch if we have a logged-in user
    if (apiService.pb.authStore.record != null) {
      _fetchAndSetPartnerData();
    }

    apiService.pb.authStore.onChange.listen((event) {
      if (event.record is RecordModel) {
        _fetchAndSetPartnerData();
      } else if (event.record == null) {
        state = null;
        partnerData = null;
        ref.notifyListeners();
      }
    });

    return null;
  }

  Future<void> _fetchAndSetPartnerData() async {
    final data = await getPartnerData();
    if (data != null) {
      partnerData = data;
      ref.notifyListeners();
    }
  }

  Future<int> connectPartner(String partnerId) async {
    final alreadyExists = await apiService.pb
        .collection('connections')
        .getList(
          filter:
              'user_1 = "${apiService.pb.authStore.record?.id}" && user_2 = "$partnerId"',
        );

    if (alreadyExists.items.isNotEmpty) {
      return 302;
    }

    await apiService.pb
        .collection('connections')
        .create(
          body: {
            'user_1': apiService.pb.authStore.record?.id,
            'user_2': partnerId,
            'status': 'pending',
          },
        );
    return 200;
  }

  Future<Map<String, dynamic>?> getPendingInvitation() async {
    try {
      final myId = apiService.pb.authStore.record?.id;
      final connections = await apiService.pb
          .collection('connections')
          .getList(
            filter: 'user_2 = "$myId" && status = "pending"',
            expand: 'user_1',
          );
      if (connections.items.isNotEmpty) {
        print(connections.items);
        return connections.items.first.toJson();
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> acceptConnection(String connectionId) async {
    try {
      final connection = await apiService.pb
          .collection('connections')
          .getOne(connectionId);

      print(connection.data);

      await apiService.pb
          .collection('connections')
          .update(
            connectionId,
            body: {
              'status': 'accepted',
              'started_relationship_at': DateTime.now(),
            },
          );

      final user1Id = connection.data['user_1'];
      final user2Id = connection.data['user_2'];

      if (user1Id != null) {
        await apiService.pb
            .collection('users')
            .update(user1Id, body: {'has_partner': true});
      }
      if (user2Id != null) {
        await apiService.pb
            .collection('users')
            .update(user2Id, body: {'has_partner': true});
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> declineConnection(String connectionId) async {
    try {
      await apiService.pb.collection('connections').delete(connectionId);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> checkConnection() async {
    try {
      final myId = apiService.pb.authStore.record?.id;
      final connections = await apiService.pb
          .collection('connections')
          .getFirstListItem(
            '(user_1 = "$myId" || user_2 = "$myId") && status = "accepted"',
            expand: "user_1,user_2",
          );

      if (connections.data['user_1'] == myId) {
        partnerData = UsersRecord.fromJson(
          connections.data['expand']['user_2'],
        );
      } else {
        partnerData = UsersRecord.fromJson(
          connections.data['expand']['user_1'],
        );
      }

      state = ConnectionsRecord.fromRecordModel(connections);

      return connections.data.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateAnniversary(DateTime date) async {
    final connId = state?.id;
    if (connId == null) return;
    try {
      await apiService.pb
          .collection('connections')
          .update(
            connId,
            body: {'started_relationship_at': date.toIso8601String()},
          );
      await checkConnection();
    } catch (e) {
      print(e);
    }
  }

  Future<UsersRecord?> getPartnerData() async {
    try {
      final myId = apiService.pb.authStore.record?.id;
      final connections = await apiService.pb
          .collection('connections')
          .getFirstListItem(
            '(user_1 = "$myId" || user_2 = "$myId") && status = "accepted"',
            expand: "user_1,user_2",
          );

      if (connections.data['user_1'] == myId) {
        partnerData = UsersRecord.fromJson(
          connections.data['expand']['user_2'],
        );
      } else {
        partnerData = UsersRecord.fromJson(
          connections.data['expand']['user_1'],
        );
      }

      state = ConnectionsRecord.fromRecordModel(connections);

      final currentUserPresence = await apiService.pb
          .collection('presences')
          .getList(
            filter:
                '(user = "$myId") && connection = "${connections.data['id']}"',
          );

      final partnerPresence = await apiService.pb
          .collection('presences')
          .getList(
            filter:
                'user = "${partnerData?.id}" && connection = "${connections.data['id']}"',
          );

      if (currentUserPresence.items.isEmpty) {
        await apiService.pb
            .collection('presences')
            .create(body: {'user': myId, 'connection': connections.data['id']});
      }

      if (partnerPresence.items.isEmpty) {
        await apiService.pb
            .collection('presences')
            .create(
              body: {
                'user': partnerData?.id,
                'connection': connections.data['id'],
              },
            );
      }

      return partnerData;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
