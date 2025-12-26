import 'dart:async';

import 'package:bifind_app/constants/device_uuid.dart';
import 'package:bifind_app/models/device_info.dart';
import 'package:bifind_app/services/device_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pedometer_plus/pedometer_plus.dart';

class DeviceListener extends ChangeNotifier {
  final Map<String, DeviceInfo> registeredDevices = {};
  final Set<String> seenIdLastScan = {};

  StreamSubscription<StepStatus>? _pedometerSub;
  StreamSubscription<List<ScanResult>>? _bleSub;
  Timer? _scanTimer;

  DeviceListener() {
    _startMovementListener();
    _startBleListener();
  }

  void registerDevice(DeviceInfo device) {
    if (registeredDevices.containsKey(device.id.toString())) return;

    registeredDevices[device.id.toString()] = device;
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
        DeviceInfo? deviceInfo = registeredDevices[id]; // deviceInfo pasti ga null
        BluetoothDevice device = r.device;

        seenIdLastScan.add(id); //tandain deviceInfo ga disconnect
        if ((deviceInfo?.status ?? DeviceStatus.disconnected) != DeviceStatus.connected) {
          deviceInfo?.changeStatus(DeviceStatus.connected);
        }

        // ini ngeupdate distance
        deviceInfo?.addRssi(r.rssi);

        if ((deviceInfo?.distance ?? 0) > 10.0) {
          notifyDevice(device, deviceInfo!);
        }
      }
    });
  }

  void _startScanning() {
    _performScan();

    // cooldown 1 menit, terus mulai scan 5 detik, diulang sampe stop scanning
    _scanTimer = Timer.periodic(
      Duration(minutes: 1),
      (_scanTimer) => _performScan(),
    );
  }

  void _stopScanning() {
    if (FlutterBluePlus.isScanningNow) FlutterBluePlus.stopScan();

    _scanTimer?.cancel();
  }

  void _performScan() async {
    final List<String> registeredId = List.from(
      registeredDevices.keys,
    ); // keysnya itu remoteid
    seenIdLastScan.clear();

    await FlutterBluePlus.startScan(
      withServices: [serviceUuid],
      withRemoteIds: registeredId,
      timeout: Duration(seconds: 5),
    );

    for (String id in registeredId) {
      // kalo id ga ke scan dalam 5 detik itu, anggap missing
      if (!seenIdLastScan.contains(id)) {
        // TODO: write ke notif page kalo cukup waktu
        DeviceInfo? device = registeredDevices[id];
        device?.changeStatus(DeviceStatus.disconnected);
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
