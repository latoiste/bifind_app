import 'package:flutter/material.dart';
import 'package:bifind_app/components/device_details_row.dart';
import 'package:bifind_app/components/table_header_cell.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const registeredDevices = [1, 2, 3, 4]; //placeholder

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: registeredDevices.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: screenWidth * 0.25, child: TableHeaderCell(title: "Device")),
              SizedBox(width: screenWidth * 0.25, child: TableHeaderCell(title: "Distance")),
              SizedBox(width: screenWidth * 0.25, child: TableHeaderCell(title: "Status")),
            ],
          );
        }
        return DeviceDetailsRow(index: index - 1, screenWidth: screenWidth,);
      },
    );
  }
}
