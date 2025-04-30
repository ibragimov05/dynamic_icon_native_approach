import 'dart:developer' show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MainApp());

/// Enumeration for the app icon types.
enum AppIconType {
  main(name: 'main'),
  secondary(name: 'secondary');

  const AppIconType({required this.name});

  final String name;

  bool get isMain => this == main;
  bool get isSecondary => this == secondary;
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) => const MaterialApp(home: HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Method channel for communicating with the native platform.
  static const MethodChannel _channel = MethodChannel('com.example.dynamic_icon_native_approach/AppIconManager');

  /// Switches the app icon based on the provided [iconType].
  Future<void> switchAppIcon(AppIconType iconType) async {
    try {
      if (Platform.isIOS) {
        final iconName = iconType == AppIconType.main ? null : 'Icon-App-Secondary';
        await _channel.invokeMethod<void>('switchAppIcon', {'iconName': iconName});
      } else {
        await _channel.invokeMethod<void>('switchAppIcon', {'iconName': iconType.name});
      }
    } on Object catch (e) {
      log('Error occurred when changing application icon: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dynamic App Icon'), backgroundColor: Colors.lightBlue),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Button to change the app icon to the main icon.
          TextButton(onPressed: () => switchAppIcon(AppIconType.main), child: const Text('Change icon to Main')),

          /// Button to change the app icon to the secondary icon.
          TextButton(
            onPressed: () => switchAppIcon(AppIconType.secondary),
            child: const Text('Change icon to alternative'),
          ),
        ],
      ),
    ),
  );
}
