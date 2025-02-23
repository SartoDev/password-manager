import 'dart:io';

import 'package:flutter/material.dart';
import 'package:password_manager/biometric/biometric_auth_screen.dart';
import 'package:password_manager/home_screen.dart';
import 'package:password_manager/sync/qr_code_screen.dart';
import 'package:password_manager/sync/scanner_screen.dart';
import 'package:password_manager/themes.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    windowManager.setMinimumSize(Size(400, 800));
    windowManager.setMaximumSize(Size(600, 900));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: const ThemeComponent(TextTheme(
                labelSmall: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                headlineSmall: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                bodyMedium: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                bodySmall: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                labelLarge: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                headlineLarge: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                bodyLarge: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                displayLarge: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                displayMedium: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                displaySmall: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                headlineMedium: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                labelMedium: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                titleSmall: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                titleLarge: TextStyle(
                    color: Color(0xff66798f),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                titleMedium: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis)))
            .light(),
        initialRoute: "/biometric-auth",
        routes: {
          '/home': (context) => const HomeScreen(),
          '/biometric-auth': (context) => const BiometricAuthScreen(),
          '/qr-code': (context) => const QrCodeScreen(),
          '/scanner': (context) => const ScannerScreen(),
        });
  }
}
