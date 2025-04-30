import 'dart:developer' show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../enums/app_icon_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const MethodChannel _channel = MethodChannel('com.example.dynamic_icon_native_approach/AppIconManager');
  Future<void> switchAppIcon(AppIconType iconType) async {
    try {
      if (Platform.isIOS) {
        final iconName = iconType == AppIconType.main ? null : 'Icon-App-Alt';
        await _channel.invokeMethod<void>('switchAppIcon', {'iconName': iconName});
      } else {
        await _channel.invokeMethod<void>('switchAppIcon', {'iconName': iconType.name});
      }
    } on Object catch (e) {
      log('Error occurred when changing application icon: $e');
    }
  }

  Future<void> onMainIconTap() async => await switchAppIcon(AppIconType.main);

  Future<void> onAlternativeIconTap() async => await switchAppIcon(AppIconType.alternative);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dynamic App Icon'), backgroundColor: Colors.lightBlue),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(onPressed: () => switchAppIcon(AppIconType.main), child: const Text('Change icon to Main')),
          TextButton(
            onPressed: () => switchAppIcon(AppIconType.alternative),
            child: const Text('Change icon to Alternative'),
          ),
        ],
      ),
    ),
  );
}
