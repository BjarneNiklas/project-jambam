import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details: $projectId'),
      ),
      body: Center(
        child: Text('Project Details Screen for $projectId - Placeholder'),
      ),
    );
  }
}
