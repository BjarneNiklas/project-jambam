import 'package:flutter/foundation.dart';

/// Centralized logging service for the JambaM application
class Logger {
  final String _name;
  
  Logger(this._name);

  void info(String message) {
    if (kDebugMode) {
      print('INFO [$this]: $message');
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      print('WARNING [$this]: $message');
    }
  }

  void error(String message) {
    if (kDebugMode) {
      print('ERROR [$this]: $message');
    }
  }

  void debug(String message) {
    if (kDebugMode) {
      print('DEBUG [$this]: $message');
    }
  }

  @override
  String toString() => _name;
} 