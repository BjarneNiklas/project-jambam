import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_jambam/src/features/b_authentication/data/auth_repository_provider.dart';
import 'package:project_jambam/src/features/b_authentication/data/mock_auth_repository.dart';

/// Test configuration and utilities for consistent test setup
class TestConfig {
  /// Creates a test app with ProviderScope
  static Widget createTestApp({
    required Widget child,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: child,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }

  /// Creates a test app with authentication overrides
  static Widget createAuthTestApp({
    required Widget child,
    MockAuthRepository? mockRepository,
  }) {
    final repository = mockRepository ?? MockAuthRepository();
    
    return createTestApp(
      child: child,
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );
  }

  /// Standard test pump duration
  static const Duration pumpDuration = Duration(milliseconds: 100);

  /// Extended test pump duration for animations
  static const Duration extendedPumpDuration = Duration(milliseconds: 500);

  /// Test timeout duration
  static const Duration testTimeout = Duration(seconds: 30);

  /// Standard test data
  static const Map<String, dynamic> testUserData = {
    'id': 'test_user_1',
    'email': 'test@jambam.com',
    'displayName': 'Test User',
    'bio': 'Test bio',
    'reputation': 100,
    'badges': ['inspirator', 'contributor'],
    'isEmailVerified': true,
    'isAnonymous': false,
    'createdAt': '2024-01-01T00:00:00Z',
    'lastActiveAt': '2024-01-01T12:00:00Z',
  };

  /// Test credentials
  static const Map<String, String> testCredentials = {
    'validEmail': 'test@jambam.com',
    'validPassword': 'password123',
    'invalidEmail': 'invalid@email.com',
    'invalidPassword': 'wrongpassword',
    'shortPassword': '123',
    'newUserEmail': 'newuser@jambam.com',
    'newUserPassword': 'newpassword123',
  };

  /// Test error messages
  static const Map<String, String> testErrorMessages = {
    'invalidCredentials': 'Invalid email or password',
    'emailAlreadyInUse': 'User with this email already exists',
    'weakPassword': 'Password is too weak',
    'invalidEmail': 'Please enter a valid email address',
    'shortPassword': 'Password must be at least 6 characters',
    'shortDisplayName': 'Display name must be at least 2 characters',
    'passwordMismatch': 'Passwords do not match',
    'emptyEmail': 'Please enter your email',
    'emptyPassword': 'Please enter your password',
    'emptyDisplayName': 'Please enter your display name',
  };

  /// Performance test thresholds
  static const Map<String, int> performanceThresholds = {
    'concurrentOperations': 500, // ms
    'rapidStateChanges': 2000, // ms
    'userSearch': 1000, // ms
    'profileUpdate': 1000, // ms
    'reputationUpdate': 1000, // ms
    'emailUpdate': 100, // ms
    'passwordUpdate': 100, // ms
    'modeToggle': 100, // ms
    'validation': 200, // ms
    'memoryIncrease': 10 * 1024 * 1024, // 10MB
  };
}

/// Test utilities
class TestUtils {
  /// Waits for a widget to appear
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = TestConfig.testTimeout,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < timeout) {
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await tester.pump(TestConfig.pumpDuration);
    }
    
    throw TimeoutException(
      'Widget not found within ${timeout.inMilliseconds}ms',
      timeout,
    );
  }

  /// Waits for a widget to disappear
  static Future<void> waitForWidgetToDisappear(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = TestConfig.testTimeout,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < timeout) {
      if (finder.evaluate().isEmpty) {
        return;
      }
      await tester.pump(TestConfig.pumpDuration);
    }
    
    throw TimeoutException(
      'Widget did not disappear within ${timeout.inMilliseconds}ms',
      timeout,
    );
  }

  /// Taps a widget and waits for animation
  static Future<void> tapAndWait(
    WidgetTester tester,
    Finder finder, {
    Duration waitDuration = TestConfig.extendedPumpDuration,
  }) async {
    await tester.tap(finder);
    await tester.pumpAndSettle(waitDuration);
  }

  /// Enters text and waits for validation
  static Future<void> enterTextAndWait(
    WidgetTester tester,
    Finder finder,
    String text, {
    Duration waitDuration = TestConfig.pumpDuration,
  }) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle(waitDuration);
  }

  /// Scrolls to a widget
  static Future<void> scrollToWidget(
    WidgetTester tester,
    Finder finder, {
    Duration scrollDuration = const Duration(milliseconds: 300),
  }) async {
    await tester.scrollUntilVisible(
      finder,
      500.0,
      scrollable: find.byType(Scrollable),
    );
    await tester.pumpAndSettle(scrollDuration);
  }

  /// Takes a screenshot for golden tests
  static Future<void> takeScreenshot(
    WidgetTester tester,
    String name,
  ) async {
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  /// Simulates network delay
  static Future<void> simulateNetworkDelay({
    Duration delay = const Duration(milliseconds: 100),
  }) async {
    await Future.delayed(delay);
  }

  /// Simulates slow network
  static Future<void> simulateSlowNetwork({
    Duration delay = const Duration(milliseconds: 1000),
  }) async {
    await Future.delayed(delay);
  }

  /// Simulates network error
  static Future<void> simulateNetworkError() async {
    throw Exception('Network error');
  }

  /// Measures performance of an operation
  static Future<Duration> measurePerformance(
    Future<void> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    await operation();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Asserts performance is within threshold
  static void assertPerformance(
    Duration actual,
    String operation,
  ) {
    final threshold = Duration(
      milliseconds: TestConfig.performanceThresholds[operation] ?? 1000,
    );
    
    expect(
      actual.inMilliseconds,
      lessThan(threshold.inMilliseconds),
      reason: '$operation took ${actual.inMilliseconds}ms, '
          'expected less than ${threshold.inMilliseconds}ms',
    );
  }
}

/// Test matchers
class TestMatchers {
  /// Matches a valid email
  static Matcher get isValidEmail => predicate<String>(
    (email) => RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email),
    'is a valid email address',
  );

  /// Matches a strong password
  static Matcher get isStrongPassword => predicate<String>(
    (password) => password.length >= 6,
    'is a strong password (at least 6 characters)',
  );

  /// Matches a valid display name
  static Matcher get isValidDisplayName => predicate<String>(
    (name) => name.length >= 2,
    'is a valid display name (at least 2 characters)',
  );

  /// Matches a loading state
  static Matcher get isLoading => predicate<Widget>(
    (widget) => widget is CircularProgressIndicator,
    'is a loading indicator',
  );

  /// Matches an error state
  static Matcher get hasError => predicate<Widget>(
    (widget) => widget is Text && widget.data?.contains('error') == true,
    'contains an error message',
  );

  /// Matches a success state
  static Matcher get hasSuccess => predicate<Widget>(
    (widget) => widget is Text && widget.data?.contains('success') == true,
    'contains a success message',
  );
}

/// Test data generators
class TestDataGenerators {
  /// Generates a random email
  static String randomEmail() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'test$timestamp@jambam.com';
  }

  /// Generates a random password
  static String randomPassword() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'password$timestamp';
  }

  /// Generates a random display name
  static String randomDisplayName() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'Test User $timestamp';
  }

  /// Generates test users
  static List<Map<String, dynamic>> generateTestUsers(int count) {
    return List.generate(count, (index) => {
      'id': 'test_user_$index',
      'email': 'test$index@jambam.com',
      'displayName': 'Test User $index',
      'bio': 'Test bio $index',
      'reputation': 100 + (index * 10),
      'badges': ['inspirator', 'contributor'],
      'isEmailVerified': true,
      'isAnonymous': false,
      'createdAt': '2024-01-01T00:00:00Z',
      'lastActiveAt': '2024-01-01T12:00:00Z',
    });
  }
}

/// Custom test exceptions
class TestException implements Exception {
  final String message;
  final dynamic cause;

  TestException(this.message, [this.cause]);

  @override
  String toString() => 'TestException: $message${cause != null ? ' (caused by: $cause)' : ''}';
}

/// Test timeout exception
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.message, this.timeout);

  @override
  String toString() => 'TimeoutException: $message (timeout: ${timeout.inMilliseconds}ms)';
} 