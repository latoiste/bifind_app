import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum DeviceStatus { connected, disconnected }

class DeviceInfo extends ChangeNotifier {
  DeviceInfo({required this.id, required this.name, required this.rssi});

  final DeviceIdentifier id;
  final String name;
  final List<int> rssi;
  DeviceStatus? status;
  double? distance;

  void addRssi(int value) {
    int windowSize = 10;

    if (rssi.length >= windowSize) rssi.removeAt(0);

    rssi.add(value);
    estimateDistance();
  }

  double getAverageRssi() {
    int sum = 0;
    for (int value in rssi) sum += value;
    return sum / rssi.length;
  }

  void estimateDistance() {
    // ini values temporary dulu, belum ada device benerannya
    int refPower = -60;
    int envFactor = 3;

    distance = pow(10, (refPower - getAverageRssi()) / (10 * envFactor)) as double?;

    notifyListeners(); //bakal ngerebuild DeviceDetailsRow
  }

  void changeStatus(DeviceStatus status) {
    this.status = status;
    notifyListeners();
  }
}
