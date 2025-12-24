import 'package:bifind_app/components/register_button.dart';
import 'package:bifind_app/models/device_info.dart';
import 'package:bifind_app/services/device_listener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScannedDeviceRow extends StatelessWidget {
  const ScannedDeviceRow({
    super.key,
    required this.device,
    required this.index,
    required this.controllerList,
  });

  final DeviceInfo device;
  final int index;
  final List<ExpansibleController> controllerList;

  @override
  Widget build(BuildContext context) {
    String name = device.name;

    return ExpansionTile(
      title: Text(name),
      expandedAlignment: Alignment.topLeft,
      showTrailingIcon: false,
      controller: controllerList[index],
      onExpansionChanged: (expanded) {
        if (!expanded) return;
        for (int i = 0; i < controllerList.length; i++) {
          if (i != index) controllerList[i].collapse();
        }
      },
      children: [
        RegisterButton(
          onPressed: () {
            final listener = context.read<DeviceListener>();
            listener.registerDevice(device);
          },
        ),
      ],
    );
  }
}
