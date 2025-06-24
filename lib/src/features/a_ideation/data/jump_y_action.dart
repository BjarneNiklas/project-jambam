import 'package:flutter/material.dart';

class JumpYAction {
  final IconData icon;
  final String label;
  final String description;
  final String prompt;
  final String category;

  const JumpYAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.prompt,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'icon': icon.codePoint,
      'label': label,
      'description': description,
      'prompt': prompt,
      'category': category,
    };
  }

  factory JumpYAction.fromJson(Map<String, dynamic> json) {
    return JumpYAction(
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      label: json['label'] as String,
      description: json['description'] as String,
      prompt: json['prompt'] as String,
      category: json['category'] as String,
    );
  }
} 