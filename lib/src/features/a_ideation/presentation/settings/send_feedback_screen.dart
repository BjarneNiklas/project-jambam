import 'package:flutter/material.dart';

class SendFeedbackScreen extends StatelessWidget {
  const SendFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Send Feedback - Placeholder'),
      ),
    );
  }
}
