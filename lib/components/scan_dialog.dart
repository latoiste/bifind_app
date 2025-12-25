import 'dart:async';

import 'package:bifind_app/components/scanned_device_row.dart';
import 'package:bifind_app/models/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanDialog extends StatefulWidget {
  const ScanDialog({super.key});

  @override
  State<ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<ScanDialog> {
  final ScrollController _scrollController = ScrollController();
  final List<DeviceInfo> fakeResult = [
    DeviceInfo(
      id: DeviceIdentifier("00:11:22:33:44:55"),
      name: "Smart Heart Rate Monitor",
      rssi: [5],
    ),
    DeviceInfo(
      id: DeviceIdentifier("AA:BB:CC:DD:EE:FF"),
      name: "Sony WH-1000XM4",
      rssi: [5],
    ),
    DeviceInfo(
      id: DeviceIdentifier("12:34:56:78:90:AB"),
      name: "Bi-Find 1",
      rssi: [5],
    ),
    DeviceInfo(
      id: DeviceIdentifier("FE:ED:BE:EF:01:02"),
      name: "ESP32_Sensor_Node",
      rssi: [5],
    ),
    DeviceInfo(
      id: DeviceIdentifier("66:55:44:33:22:11"),
      name: "Kitchen Thermometer",
      rssi: [5],
    ),
  ];
  final List<DeviceInfo> _scanResults = [];
  int _deviceCount = 1;
  // TODO: change to empty list later
  final List<ExpansibleController> _expansibleController = List.generate(
    5,
    (index) => ExpansibleController(),
  );
  StreamSubscription? _subscription;

  void startBleScan() async {
    final Guid serviceUuid = Guid("d9380fdc-3c8f-4c49-874d-031ef136716c");

    _subscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        final Iterable<DeviceIdentifier> discoveredId = _scanResults.map(
          (device) => device.id,
        );
        for (ScanResult r in results) {
          DeviceIdentifier id = r.device.remoteId;
          String name = r.advertisementData.advName;

          if (discoveredId.contains(id)) continue;

          if (name == "") {
            name = "Bi-Find Device $_deviceCount";
            _deviceCount++;
          }

          DeviceInfo newDevice = DeviceInfo(
            id: id,
            name: name,
            rssi: [r.rssi],
          );
          _scanResults.add(newDevice);
          _expansibleController.add(ExpansibleController());
        }
      });
    });

    await FlutterBluePlus.startScan(
      withServices: [serviceUuid],
      timeout: Duration(seconds: 15),
    );

    FlutterBluePlus.stopScan();
    _subscription?.cancel();
    print("scanning finished??");
  }

  // TODO: Delete later
  Future<void> addDeviceDummy() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    setState(() {
      fakeResult.add(
        DeviceInfo(
          id: DeviceIdentifier("66:77:67:67:67:67"),
          name: "six",
          rssi: [-45],
        ),
      );
      _expansibleController.add(ExpansibleController());
    });
  }

  @override
  void initState() {
    addDeviceDummy();
    super.initState();
  }

  @override
  void dispose() {
    if (FlutterBluePlus.isScanningNow) {
      FlutterBluePlus.stopScan();
    }

    for (ExpansibleController controller in _expansibleController) {
      controller.dispose();
    }
    _scanResults.clear();
    _scrollController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  // TODO: ganti semua fakeResult ke _scanResult
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Available Devices"),
            Container(
              padding: EdgeInsets.only(bottom: 15.0),
              height: screenHeight * 0.3,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                // TODO: add condition if no devices being scanned
                child: ListView.builder(
                  itemCount: fakeResult.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return ScannedDeviceRow(
                      device: fakeResult[index],
                      index: index,
                      controllerList: _expansibleController,
                    );
                  },
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade600,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
