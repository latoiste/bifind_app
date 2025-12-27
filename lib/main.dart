import 'package:bifind_app/services/device_listener.dart';
import 'package:bifind_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import "package:bifind_app/pages/main_page.dart";
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => DeviceListener(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF67C090)
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF67C090),
          foregroundColor: Color(0xFF3D7155),
        ),
        textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            )
        ),
      ));
  }
}
