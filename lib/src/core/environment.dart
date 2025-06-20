import 'dart:io';
import 'package:flutter/foundation.dart';

class Environment {
  static final Environment _instance = Environment._internal();
  factory Environment() => _instance;
  Environment._internal();

  Map<String, String> _envVars = {};

  Future<void> load() async {
    if (kIsWeb) {
      // Web: Load from window.location.search or use defaults
      _envVars = {
        'API_BASE_URL': 'http://localhost:8000',
        'OPENAI_API_KEY': '',
        'GEMINI_API_KEY': '',
        'ENVIRONMENT': 'development',
      };
    } else {
      // Mobile: Try to load from .env file
      try {
        final envFile = File('.env');
        if (await envFile.exists()) {
          final contents = await envFile.readAsString();
          for (final line in contents.split('\n')) {
            final trimmedLine = line.trim();
            if (trimmedLine.isNotEmpty && !trimmedLine.startsWith('#')) {
              final parts = trimmedLine.split('=');
              if (parts.length >= 2) {
                final key = parts[0].trim();
                final value = parts.sublist(1).join('=').trim();
                _envVars[key] = value;
              }
            }
          }
        }
      } catch (e) {
        // Use defaults if .env file cannot be read
        _envVars = {
          'API_BASE_URL': 'http://localhost:8000',
          'OPENAI_API_KEY': '',
          'GEMINI_API_KEY': '',
          'ENVIRONMENT': 'development',
        };
      }
    }
  }

  String? get(String key) {
    return _envVars[key];
  }

  String getOrElse(String key, String defaultValue) {
    return _envVars[key] ?? defaultValue;
  }

  bool get isDevelopment => _envVars['ENVIRONMENT'] == 'development';
  bool get isProduction => _envVars['ENVIRONMENT'] == 'production';
} 