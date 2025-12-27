import 'package:bifind_app/components/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:bifind_app/pages/home.dart';
import 'package:bifind_app/pages/notifications.dart';
import 'package:bifind_app/pages/settings.dart';
import 'package:bifind_app/components/navbar.dart';
import 'package:bifind_app/components/scan_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const NotificationPage(),
    const SettingsPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppbar(currentIndex: _currentIndex, height: screenHeight * 0.12),
      body: _pages[_currentIndex],
      bottomNavigationBar: Navbar(
        selectedIndex: _currentIndex,
        onSelected: _onTap,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add device"),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ScanDialog();
            },
          );
        },
      ),
    );
  }
}
