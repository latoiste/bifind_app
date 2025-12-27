import 'package:bifind_app/components/appbar/appbar_title.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.currentIndex,
    required this.height,
  });

  final int currentIndex;
  final double height;

  @override
  Widget build(BuildContext context) {
    final List<AppbarTitle> titles = [
      const AppbarTitle(title: "Home"),
      const AppbarTitle(title: "Notifications"),
      const AppbarTitle(title: "Settings"),
    ];

    return AppBar(
      title: Center(child: titles[currentIndex]),
      toolbarHeight: height,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(bottom: Radius.elliptical(450, 150)),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
