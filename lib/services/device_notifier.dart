import 'package:bifind_app/constants/device_uuid.dart';
import 'package:bifind_app/models/device_info.dart';
import 'package:collection/collection.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<void> notifyDevice(BluetoothDevice device, DeviceInfo deviceInfo) async {
  if (deviceInfo.writeCooldownActive) return;
  deviceInfo.activateWriteCooldown();

  await writeToDevice(device, [0x01]); // 0x01 = buzzer nyala
  await device.disconnect();

  await Future.delayed(Duration(seconds: 10)); // buzzer bakal auto mati dalam 10 detik
  await writeToDevice(device, [0x0]); // 0x0 = buzzer mati
  await device.disconnect();
}

Future<void> connectToDevice(BluetoothDevice device) async {
  if (device.isConnected) return;
  await device.connect(license: License.free, timeout: Duration(seconds: 5));
}

Future<void> writeToDevice(BluetoothDevice device, List<int> values) async {
  try {
    await connectToDevice(device);
  } catch (e) {
    return;
  }
  
  List<BluetoothService> services = await device.discoverServices();
  BluetoothService? service = services.firstWhereOrNull(
    (s) => s.uuid.toString() == serviceUuid.toString(),
  );
  BluetoothCharacteristic? buzzerCharacteristic = service?.characteristics.firstWhereOrNull(
    (c) => c.uuid.toString() == buzzerCharacteristicUuid.toString(),
  );
  await buzzerCharacteristic?.write(values);
}
