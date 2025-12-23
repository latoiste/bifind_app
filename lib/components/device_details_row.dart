import 'package:flutter/material.dart';

class DeviceDetailsRow extends StatelessWidget {
  const DeviceDetailsRow({
    super.key,
    required this.index,
    required this.screenWidth,
  });

  final double screenWidth;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // placeholder
        SizedBox(width: screenWidth * 0.25, child: Center(child: Text("AAAAA"))),
        SizedBox(width: screenWidth * 0.25, child: Center(child: Text("BBBB"))),
        SizedBox(width: screenWidth * 0.25, child: Center(child: Text("DDDD"))),
      ],
    );
  }
}
