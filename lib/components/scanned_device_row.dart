import 'package:bifind_app/components/register_button.dart';
import 'package:flutter/material.dart';

class ScannedDeviceRow extends StatelessWidget {
  const ScannedDeviceRow({
    super.key,
    required this.title,
    required this.index,
    required this.controllerList,
  });

  final String title;
  final int index;
  final List<ExpansibleController> controllerList;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
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
        RegisterButton(),
      ],
    ); // TODO: ganti ke _scanResult nanti
  }
}
