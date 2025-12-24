import 'package:bifind_app/models/device_info.dart';
import 'package:flutter/material.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        // placeholder
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
            child: Text(device.rssi == null ? "No data" : "${4.toString()}m"),
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
                // color: device.status == DeviceStatus.connected
                //     ? Colors.green
                //     : Colors.red,
              ),
            ),
          ),
        ), // status
      ],
    );
  }
}
