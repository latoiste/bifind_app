import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum DeviceStatus { connected, disconnected }

class DeviceInfo {
  DeviceInfo({
    required this.id,
    required this.name,
    required this.rssi,
    required this.status,
  });

  final DeviceIdentifier id;
  final String name;
  final int? rssi;
  final DeviceStatus? status;
}
