import 'package:flutter/material.dart';

class DataUsageSettingsScreen extends StatelessWidget {
  const DataUsageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Usage Settings'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Data Usage Settings - Placeholder'),
      ),
    );
  }
}
