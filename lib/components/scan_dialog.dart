import 'package:bifind_app/components/scanned_device_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bifind_app/models/discovered_device.dart';

class ScanDialog extends StatefulWidget {
  const ScanDialog({super.key});

  @override
  State<ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<ScanDialog> {
  final ScrollController scrollController = ScrollController();
  final List<DiscoveredDevice> fakeResult = [
    DiscoveredDevice(
      id: DeviceIdentifier("00:11:22:33:44:55"),
      name: "Smart Heart Rate Monitor",
    ),
    DiscoveredDevice(
      id: DeviceIdentifier("AA:BB:CC:DD:EE:FF"),
      name: "Sony WH-1000XM4",
    ),
    DiscoveredDevice(
      id: DeviceIdentifier("12:34:56:78:90:AB"),
      name: "Bi-Find 1",
    ),
    DiscoveredDevice(
      id: DeviceIdentifier("FE:ED:BE:EF:01:02"),
      name: "ESP32_Sensor_Node",
    ),
    DiscoveredDevice(
      id: DeviceIdentifier("66:55:44:33:22:11"),
      name: "Kitchen Thermometer",
    ),
  ];
  final List<DiscoveredDevice> _scanResults = [];
  int deviceCount = 1;
  final List<ExpansibleController> expansibleController = List.generate(
    5,
    (index) => ExpansibleController(),
  ); // TODO: change to empty list later

  void startBleScan() async {
    final Guid serviceUuid = Guid("d9380fdc-3c8f-4c49-874d-031ef136716c");

    var subscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        final Iterable<DeviceIdentifier> discoveredId = _scanResults.map(
          (device) => device.id,
        );
        for (ScanResult r in results) {
          DeviceIdentifier id = r.device.remoteId;
          String name = r.advertisementData.advName;

          if (discoveredId.contains(id)) continue;

          if (name == "") {
            name = "Bi-Find Device $deviceCount";
            deviceCount++;
          }

          DiscoveredDevice newDevice = DiscoveredDevice(id: id, name: name);
          _scanResults.add(newDevice);
          expansibleController.add(ExpansibleController());
        }
      });
    });

    await FlutterBluePlus.startScan(
      withServices: [serviceUuid],
      timeout: Duration(seconds: 15),
    );

    FlutterBluePlus.stopScan();
    subscription.cancel();
    print("scanning finished??");
  }

  // TODO: Delete later
  Future<void> addDeviceDummy() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    setState(() {
      fakeResult.add(
        DiscoveredDevice(
          id: DeviceIdentifier("66:77:67:67:67:67"),
          name: "six",
        ),
      );
      expansibleController.add(ExpansibleController());
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

    for (ExpansibleController controller in expansibleController) {
      controller.dispose();
    }
    _scanResults.clear();
    scrollController.dispose();
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
                controller: scrollController,
                thumbVisibility: true,
                // TODO: add condition if no devices being scanned
                child: ListView.builder(
                  itemCount: fakeResult.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return ScannedDeviceRow(
                      title: fakeResult[index].name,
                      index: index,
                      controllerList: expansibleController,
                    );
                  },
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade600,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
