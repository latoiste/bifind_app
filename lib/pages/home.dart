import 'package:bifind_app/models/device_info.dart';
import 'package:bifind_app/services/device_listener.dart';
import 'package:flutter/material.dart';
import 'package:bifind_app/components/device_details_row.dart';
import 'package:bifind_app/components/table_header_cell.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<double> rowPartition = [0.4, 0.3, 0.3];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final List<DeviceInfo> registeredDevices = context.watch<DeviceListener>().registeredDevice;

    return ListView.builder(
      itemCount: registeredDevices.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: screenWidth * rowPartition[0],
                child: TableHeaderCell(title: "Device"),
              ),
              SizedBox(
                width: screenWidth * rowPartition[1],
                child: TableHeaderCell(title: "Distance"),
              ),
              SizedBox(
                width: screenWidth * rowPartition[2],
                child: TableHeaderCell(title: "Status"),
              ),
            ],
          );
        }
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withAlpha(127), 
                width: 2.0, 
                style: BorderStyle.solid,
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 5.0),
          child: DeviceDetailsRow(
            rowPartition: rowPartition,
            device: registeredDevices[index - 1],
          )
        );
      },
    );
  }
}
