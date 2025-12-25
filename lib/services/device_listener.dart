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
  Timer? _scanTimer;

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
          status == StepStatus.walking ? _startScanning() : _stopScanning(),
    );
  }

  void _startBleListener() {
    print("FlutterBluePlus listening");
    _bleSub = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        // ga ush filter id, udh di filter dalam startScan
        String id = r.device.remoteId.toString();
        int index = registeredId.indexOf(id);
        DeviceInfo device = registeredDevice[index];
        
        seenIdLastScan.add(id); //tandain device ga disconnect

        device.addRssi(r.rssi);

        // TODO: notify kalo distance > 10, write command ke device
      }
    });
  }

  void _startScanning() async {
    _performScan();

    _scanTimer = Timer.periodic(
      Duration(seconds: 20),
      (_scanTimer) => _performScan(),
    );
  }

  void _stopScanning() {
    if (FlutterBluePlus.isScanningNow) FlutterBluePlus.stopScan();

    _scanTimer?.cancel();
  }

  void _performScan() async {
    final Guid serviceUuid = Guid("d9380fdc-3c8f-4c49-874d-031ef136716c");
    seenIdLastScan.clear();

    await FlutterBluePlus.startScan(
      withServices: [serviceUuid],
      withRemoteIds: registeredId,
      timeout: Duration(seconds: 5),
    );

    for (String id in registeredId) {
      // kalo id ga ke scan dalam 5 detik itu, anggap missing
      if (!seenIdLastScan.contains(id)) {
        // TODO: Handle disconnected device (change status color) sama (write ke notif page kalo cukup waktu)
        print("device $id is missing");
      }
    }
  }

  @override
  void dispose() {
    if (FlutterBluePlus.isScanningNow) {
      FlutterBluePlus.stopScan();
    }
    _scanTimer?.cancel();
    _bleSub?.cancel();
    _pedometerSub?.cancel();
    super.dispose();
  }
}
