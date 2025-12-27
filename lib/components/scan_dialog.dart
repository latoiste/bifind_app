import 'dart:async';

import 'package:bifind_app/components/scanned_device_row.dart';
import 'package:bifind_app/constants/device_uuid.dart';
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
  final List<DeviceInfo> _scanResults = [];
  final List<ExpansibleController> _expansibleController = [];
  int _deviceCount = 1;
  StreamSubscription? _subscription;

  void startBleScan() async {
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

          DeviceInfo newDevice = DeviceInfo(id: id, name: name, rssi: [r.rssi]);
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
  }

  @override
  void initState() {
    startBleScan();
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
                child: ListView.builder(
                  itemCount: _scanResults.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return ScannedDeviceRow(
                      device: _scanResults[index],
                      index: index,
                      controllerList: _expansibleController,
                    );
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
