import 'package:bifind_app/models/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceListener extends ChangeNotifier {
  final List<DeviceInfo> registeredDevice = [];
  final List<DeviceIdentifier> registeredId = [];

  void registerDevice(DeviceInfo device) {
    if (registeredId.contains(device.id)) return;

    registeredDevice.add(device);
    registeredId.add(device.id);
    notifyListeners();
  }
}
