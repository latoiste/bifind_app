import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DiscoveredDevice {
  const DiscoveredDevice({required this.id, required this.name});
  
  final DeviceIdentifier id;
  final String name;
}
