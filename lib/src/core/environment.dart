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
        'SUPABASE_URL': 'https://nnneohqytsemmwpufwtv.supabase.co',
        'SUPABASE_ANON_KEY': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ubmVvaHF5dHNlbW13cHVmd3R2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1OTU3NzEsImV4cCI6MjA2NjE3MTc3MX0.PnojgXWf9n34CNTRy2tWTQFjeUqUfH-WGjvh8ygS82A',
      };
    } else {
      // Mobile: Try to load from .env file first, then fallback to defaults
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
        
        // Always load defaults as fallback for missing values
        _loadDefaults();
        
        // Override with .env values if they exist
        if (await envFile.exists()) {
          final contents = await envFile.readAsString();
          for (final line in contents.split('\n')) {
            final trimmedLine = line.trim();
            if (trimmedLine.isNotEmpty && !trimmedLine.startsWith('#')) {
              final parts = trimmedLine.split('=');
              if (parts.length >= 2) {
                final key = parts[0].trim();
                final value = parts.sublist(1).join('=').trim();
                if (value.isNotEmpty) {
                  _envVars[key] = value;
                }
              }
            }
          }
        }
      } catch (e) {
        // Use defaults if .env file cannot be read or on any error
        _loadDefaults();
      }
    }
  }

  void _loadDefaults() {
    _envVars = {
      'API_BASE_URL': 'http://localhost:8000',
      'OPENAI_API_KEY': '',
      'GEMINI_API_KEY': '',
      'ENVIRONMENT': 'development',
      'SUPABASE_URL': 'https://nnneohqytsemmwpufwtv.supabase.co',
      'SUPABASE_ANON_KEY': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ubmVvaHF5dHNlbW13cHVmd3R2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1OTU3NzEsImV4cCI6MjA2NjE3MTc3MX0.PnojgXWf9n34CNTRy2tWTQFjeUqUfH-WGjvh8ygS82A',
    };
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