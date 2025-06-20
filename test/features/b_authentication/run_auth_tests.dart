import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

// Import all authentication tests
import 'auth_repository_test.dart' as auth_repo_test;
import 'login_screen_controller_test.dart' as controller_test;
import 'login_screen_widget_test.dart' as widget_test;
import 'auth_performance_test.dart' as performance_test;

final _logger = Logger('AuthTest');

// Test runner configuration
class AuthTestRunner {
  static Future<void> runAllTests() async {
    _logger.info('Starting Authentication Test Suite...\n');

    final stopwatch = Stopwatch()..start();

    try {
      // Run repository tests
      _logger.info('Running Repository Tests...');
      await _runTestGroup('Repository Tests', () {
        auth_repo_test.main();
      });

      // Run controller tests
      _logger.info('Running Controller Tests...');
      await _runTestGroup('Controller Tests', () {
        controller_test.main();
      });

      // Run widget tests
      _logger.info('Running Widget Tests...');
      await _runTestGroup('Widget Tests', () {
        widget_test.main();
      });

      // Run performance tests
      _logger.info('Running Performance Tests...');
      await _runTestGroup('Performance Tests', () {
        performance_test.main();
      });

      stopwatch.stop();

      _logger.info('\nAll Authentication Tests Completed Successfully!');
      _logger.info('Total execution time: ${stopwatch.elapsedMilliseconds}ms');
      _logger.info('Test coverage: Repository, Controller, Widget, Performance');

    } catch (e) {
      _logger.severe('Test Suite Failed: $e');
      rethrow;
    }
  }

  static Future<void> _runTestGroup(String groupName, Function testFunction) async {
    final groupStopwatch = Stopwatch()..start();
    
    try {
      testFunction();
      groupStopwatch.stop();
      
      _logger.info('  [32m[1m$groupName completed in ${groupStopwatch.elapsedMilliseconds}ms');
    } catch (e) {
      groupStopwatch.stop();
      _logger.severe('  [31m[1m$groupName failed after ${groupStopwatch.elapsedMilliseconds}ms: $e');
      rethrow;
    }
  }

  static Future<void> runSpecificTest(String testType) async {
    _logger.info('Running specific test: $testType\n');

    switch (testType.toLowerCase()) {
      case 'repository':
        await _runTestGroup('Repository Tests', () {
          auth_repo_test.main();
        });
        break;
      case 'controller':
        await _runTestGroup('Controller Tests', () {
          controller_test.main();
        });
        break;
      case 'widget':
        await _runTestGroup('Widget Tests', () {
          widget_test.main();
        });
        break;
      case 'performance':
        await _runTestGroup('Performance Tests', () {
          performance_test.main();
        });
        break;
      default:
        _logger.severe('Please specify a test type: repository, controller, widget, performance');
        _logger.severe('Available test types: repository, controller, widget, performance');
    }
  }

  static void printTestSummary() {
    _logger.info('''
📋 Authentication Test Summary
==============================

🧪 Test Categories:
  • Repository Tests - Core authentication logic
  • Controller Tests - State management
  • Widget Tests - UI components
  • Performance Tests - Performance benchmarks

🎯 Test Coverage:
  ✅ User authentication (login/signup/logout)
  ✅ Profile management
  ✅ Password reset
  ✅ Anonymous login
  ✅ User search and following
  ✅ Reputation and badges
  ✅ Form validation
  ✅ Error handling
  ✅ Loading states
  ✅ Accessibility features

⚡ Performance Benchmarks:
  ✅ Concurrent operations
  ✅ Memory usage
  ✅ Response times
  ✅ Network simulation

🔧 How to run:
  • All tests: flutter test test/features/b_authentication/
  • Specific test: flutter test test/features/b_authentication/run_auth_tests.dart
  • With coverage: flutter test --coverage test/features/b_authentication/

📊 Expected Results:
  • All tests should pass
  • Performance benchmarks within acceptable limits
  • No memory leaks detected
  • Proper error handling verified
''');
  }
}

// Command line interface for test runner
void main(List<String> args) {
  if (args.isEmpty) {
    // Run all tests by default
    AuthTestRunner.runAllTests();
  } else if (args.contains('--help') || args.contains('-h')) {
    AuthTestRunner.printTestSummary();
  } else if (args.contains('--specific') || args.contains('-s')) {
    final testTypeIndex = args.contains('--specific') ? args.indexOf('--specific') : args.indexOf('-s');
    
    if (testTypeIndex + 1 < args.length) {
      final testType = args[testTypeIndex + 1];
      AuthTestRunner.runSpecificTest(testType);
    } else {
      _logger.severe('Please specify a test type: repository, controller, widget, performance');
    }
  } else {
    _logger.severe('Unknown arguments: ${args.join(' ')}');
    _logger.severe('Use --help for usage information');
  }
} 