import "package:bifind_app/pages/home.dart";
import "package:bifind_app/pages/notifications.dart";
import "package:bifind_app/pages/settings.dart";
import "package:bifind_app/components/navbar.dart";
import "package:flutter/material.dart";

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("AAAAAAAAAA"),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Navbar(
        selectedIndex: _currentIndex,
        onSelected: _onTap,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add device"),
        onPressed: () {
          print("AAAAAAAA");
        },
      ),
    );
  }
}
