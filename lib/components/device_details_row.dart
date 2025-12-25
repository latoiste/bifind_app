import 'package:bifind_app/models/device_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color getStatusColor(DeviceStatus? status) {
  if (status == null) return Colors.grey.withAlpha(127);

  return status == DeviceStatus.connected ? Colors.green : Colors.red;
}

class DeviceDetailsRow extends StatelessWidget {
  const DeviceDetailsRow({
    super.key,
    required this.rowPartition,
    required this.device,
  });

  final List<double> rowPartition;
  final DeviceInfo device;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider.value(
      value: device,
      child: Consumer<DeviceInfo>(
        builder: (context, deviceInfo, child) {
          print("${deviceInfo.name} is rebuilt");
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: screenWidth * rowPartition[0],
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  child: Text(device.name),
                ),
              ), // name
              SizedBox(
                width: screenWidth * rowPartition[1],
                child: Center(
                  child: Text(
                    device.distance == null ? "No data" : "${device.distance?.toStringAsFixed(1)}m",
                  ),
                ),
              ), // distance
              SizedBox(
                width: screenWidth * rowPartition[2],
                child: Center(
                  child: Container(
                    height: screenWidth * rowPartition[2] * 0.25,
                    width: screenWidth * rowPartition[2] * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: getStatusColor(device.status),
                    ),
                  ),
                ),
              ), // status
            ],
          );
        },
      ),
    );
  }
}
