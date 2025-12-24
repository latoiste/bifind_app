import 'dart:async';

import 'package:bifind_app/models/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pedometer_plus/pedometer_plus.dart';

class DeviceListener extends ChangeNotifier {
  final List<DeviceInfo> registeredDevice = [];
  final List<DeviceIdentifier> registeredId = [];

  StreamSubscription<StepStatus>? _pedometerSub;
  StreamSubscription<List<ScanResult>>? _bleSub;

  DeviceListener() {
    _startMovementDetection();
  }

  void registerDevice(DeviceInfo device) {
    if (registeredId.contains(device.id)) return;

    registeredDevice.add(device);
    registeredId.add(device.id);
    notifyListeners();
  }

  void _startMovementDetection() {
    _pedometerSub = Pedometer().stepStatusStream().listen(
      (status) => status == StepStatus.walking ? _startListening() : _stopListening()
    );
  }

  void _startListening() {}

  void _stopListening() {
    _bleSub?.cancel();
  }

  @override
  void dispose() {
    _bleSub?.cancel();
    _pedometerSub?.cancel();
    super.dispose();
  }
}
