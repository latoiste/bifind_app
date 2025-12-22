import 'package:flutter/material.dart';

class TableHeaderCell extends StatelessWidget {
  const TableHeaderCell({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(child: Text(title)),
    );
  }
}
