import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:do_not_disturb/do_not_disturb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:attached/services/api.service.dart';

final presenceProvider = Provider<PresenceService>((ref) {
  return PresenceService();
});

class PresenceService {
  final Battery _battery = Battery();
  final DoNotDisturbPlugin _dndPlugin = DoNotDisturbPlugin();
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  Timer? _statusTimer;
  int? _lastBatteryLevel;
  bool? _lastDndStatus;

  void startListening(String userId, String connectionId) {
    _listenToBattery(userId, connectionId);
    _startStatusPolling(userId, connectionId);
  }

  void stopListening() {
    _batteryStateSubscription?.cancel();
    _statusTimer?.cancel();
  }

  void _listenToBattery(String userId, String connectionId) {
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((
      _,
    ) async {
      await _updateBattery(userId, connectionId);
    });
    // Initial fetch
    _updateBattery(userId, connectionId);
  }

  Future<void> _updateBattery(String userId, String connectionId) async {
    try {
      final level = await _battery.batteryLevel;
      final isLow = level <= 20;

      await _updatePresence(userId, connectionId, {
        'battery': {'level': level},
        'is_low_battery': isLow,
      });
      _lastBatteryLevel = level;
    } catch (e) {
      print('Error fetching battery: $e');
    }
  }

  void _startStatusPolling(String userId, String connectionId) {
    // Update DND and battery status periodically
    _statusTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      // 1. Battery check
      try {
        final level = await _battery.batteryLevel;
        if (_lastBatteryLevel == null || level < _lastBatteryLevel!) {
          await _updateBattery(userId, connectionId);
        } else if (level > _lastBatteryLevel!) {
          _lastBatteryLevel = level;
        }
      } catch (e) {
        print('Error polling battery: $e');
      }

      // 2. Fetch DND Status
      bool isDnd = false;
      try {
        isDnd = await _dndPlugin.isDndEnabled();
      } catch (e) {
        print('Error fetching DND: $e');
      }

      if (_lastDndStatus != isDnd) {
        _lastDndStatus = isDnd;
        await _updatePresence(userId, connectionId, {'is_dnd': isDnd});
      }
    });

    // Initial DND fetch
    _dndPlugin.isDndEnabled().then((isDnd) {
      _lastDndStatus = isDnd;
      _updatePresence(userId, connectionId, {'is_dnd': isDnd});
    }).catchError((_) {});
  }

  Future<void> updateLocation(
    String userId,
    String connectionId,
    BuildContext context,
  ) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enable location to share with your partner.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        );
        await _updatePresence(userId, connectionId, {
          'location': '${position.latitude},${position.longitude}',
        });
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<void> updateStatus(
    String userId,
    String connectionId,
    String emoji,
    String status,
  ) async {
    await _updatePresence(userId, connectionId, {
      'emoji': emoji,
      'status': status,
    });

    try {
      await apiService.pb
          .collection('mood_log')
          .create(
            body: {
              'user': userId,
              'connection': connectionId,
              'emoji': emoji,
              'body': status,
            },
          );
    } catch (e) {
      print('Error adding mood log: \$e');
    }
  }

  Future<void> _updatePresence(
    String userId,
    String connectionId,
    Map<String, dynamic> data,
  ) async {
    try {
      final records = await apiService.pb
          .collection('presences')
          .getList(filter: 'user = "$userId" && connection = "$connectionId"');

      if (records.items.isNotEmpty) {
        final recordId = records.items.first.id;
        await apiService.pb
            .collection('presences')
            .update(recordId, body: data);
      }
    } catch (e) {
      print('Error updating presence: $e');
    }
  }
}
