import 'dart:async';

import 'package:bifind_app/models/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pedometer_plus/pedometer_plus.dart';

class DeviceListener extends ChangeNotifier {
  final List<DeviceInfo> registeredDevice = [];
  final List<String> registeredId = [];
  final Set<String> seenIdLastScan = {};

  StreamSubscription<StepStatus>? _pedometerSub;
  StreamSubscription<List<ScanResult>>? _bleSub;

  DeviceListener() {
    _startMovementListener();
    _startBleListener();
  }

  void registerDevice(DeviceInfo device) {
    if (registeredId.contains(device.id.toString())) return;

    registeredDevice.add(device);
    registeredId.add(device.id.toString());
    notifyListeners();
  }

  void _startMovementListener() {
    print("Pedometer listening");
    // pedometer cuma bisa di native mobile, ini biar ga ngecrash waktu debug aja
    if (kIsWeb) return;

    _pedometerSub = Pedometer().stepStatusStream().listen(
      (status) =>
          status == StepStatus.walking ? _startScanning() : FlutterBluePlus.stopScan(),
    );
  }

  void _startBleListener() {
    print("FlutterBluePlus listening");
    _bleSub = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        // ga ush filter id, udh di filter dalam startScan
        seenIdLastScan.add(r.device.remoteId.toString());
        // change device info nanti kalo perlu
        // notify kalo distance > 10, write command ke device
      }
    });
  }

  void _startScanning() async {
    final Guid serviceUuid = Guid("d9380fdc-3c8f-4c49-874d-031ef136716c");
    seenIdLastScan.clear();

    // mulai scan selama 5 detik, setiap result yang diterima, callback ble listener bakal jalan
    await FlutterBluePlus.startScan(
      withServices: [serviceUuid],
      withRemoteIds: registeredId,
      timeout: Duration(seconds: 5),
    );

    for (String id in registeredId) {
      // kalo id ga ke scan dalam 5 detik itu, anggap missing
      if (!seenIdLastScan.contains(id)) {
        // TODO: Handle disconnected device (change status color)
        print("device $id is missing");
      }
    }
    // cooldown?? then start scanning again
  }

  @override
  void dispose() {
    if (FlutterBluePlus.isScanningNow) {
      FlutterBluePlus.stopScan();
    }
    _bleSub?.cancel();
    _pedometerSub?.cancel();
    super.dispose();
  }
}
