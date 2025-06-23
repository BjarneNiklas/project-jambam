import 'package:logging/logging.dart' as logging;
import 'package:flutter/foundation.dart';

/// Centralized logging service for the JambaM application
/// using the `logging` package.
class Logger {
  final logging.Logger _logger;

  /// Creates a new Logger with the given name.
  Logger(String name) : _logger = logging.Logger(name);

  /// Logs a message at level [Level.INFO].
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /// Logs a message at level [Level.WARNING].
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  /// Logs a message at level [Level.SEVERE] (for errors).
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /// Logs a message at level [Level.CONFIG] (can be used for debug-like messages).
  /// For more verbose debugging, consider using [Level.FINE], [Level.FINER], or [Level.FINEST].
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    // Using Level.CONFIG as a general debug level.
    // For more fine-grained control, specific `fine`, `finer`, `finest` methods could be added.
    _logger.config(message, error, stackTrace);
  }

  /// Returns the name of the logger.
  @override
  String toString() => _logger.name;

  /// Initializes the logging system.
  ///
  /// This should be called once at application startup (e.g., in `main.dart`).
  /// It sets up a listener to print log messages to the console.
  ///
  /// In debug mode, it logs all messages.
  /// In release mode, it logs messages of level [Level.WARNING] or higher.
  static void initialize() {
    if (kDebugMode) {
      logging.Logger.root.level = logging.Level.ALL; // Includes FINE, FINER, FINEST for verbose debugging
    } else {
      logging.Logger.root.level = logging.Level.WARNING; // Only WARNING and SEVERE in release
    }

    logging.Logger.root.onRecord.listen((record) {
      // In debug mode, print all details.
      // In release mode, you might want a more structured logging service (e.g., Sentry, Firebase Crashlytics).
      if (kDebugMode) {
        debugPrint(
            '${record.level.name} [${record.loggerName}] ${record.time}: ${record.message}');
        if (record.error != null) {
          debugPrint('Error: ${record.error}');
        }
        if (record.stackTrace != null) {
          debugPrint('StackTrace: ${record.stackTrace}');
        }
      } else {
        // For release, only print the message for WARNING and SEVERE, or send to a logging service.
        if (record.level >= logging.Level.WARNING) {
          print(
              '${record.level.name} [${record.loggerName}]: ${record.message}');
          if (record.error != null) {
            print('Error: ${record.error}');
          }
        }
      }
    });
  }
}