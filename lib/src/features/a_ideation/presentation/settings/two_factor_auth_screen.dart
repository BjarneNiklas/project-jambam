import 'package:flutter/material.dart';

class TwoFactorAuthScreen extends StatelessWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Two-Factor Authentication Settings - Placeholder'),
      ),
    );
  }
}
