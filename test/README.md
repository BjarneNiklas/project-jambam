# JambaM Test Suite

This directory contains comprehensive tests for the JambaM application, covering authentication, ideation features, and performance benchmarks.

## 📁 Test Structure

```
test/
├── features/
│   ├── a_ideation/           # Ideation feature tests
│   └── b_authentication/     # Authentication tests
│       ├── auth_repository_test.dart
│       ├── login_screen_controller_test.dart
│       ├── login_screen_widget_test.dart
│       ├── auth_performance_test.dart
│       └── run_auth_tests.dart
├── integration_test/         # Integration tests
│   └── auth_flow_test.dart
├── test_config.dart          # Test configuration and utilities
└── README.md                 # This file
```

## 🧪 Test Categories

### 1. Unit Tests
- **Repository Tests**: Core business logic and data operations
- **Controller Tests**: State management and business logic
- **Widget Tests**: UI components and user interactions

### 2. Integration Tests
- **Flow Tests**: End-to-end user workflows
- **Cross-feature Tests**: Interactions between different features

### 3. Performance Tests
- **Benchmark Tests**: Performance measurements
- **Memory Tests**: Memory usage and leak detection
- **Concurrency Tests**: Concurrent operation handling

## 🚀 Running Tests

### All Tests
```bash
flutter test
```

### Specific Test Categories
```bash
# Authentication tests only
flutter test test/features/b_authentication/

# Ideation tests only
flutter test test/features/a_ideation/

# Integration tests only
flutter test integration_test/
```

### Performance Tests
```bash
# Run performance benchmarks
flutter test test/features/b_authentication/auth_performance_test.dart

# Run with detailed output
flutter test --verbose test/features/b_authentication/auth_performance_test.dart
```

### With Coverage
```bash
# Generate coverage report
flutter test --coverage

# View coverage in browser
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Golden Tests (Visual Regression)
```bash
# Update golden files
flutter test --update-goldens

# Run golden tests
flutter test test/golden/
```

## 📊 Test Coverage

### Authentication System
- ✅ User registration and login
- ✅ Password reset functionality
- ✅ Anonymous authentication
- ✅ Profile management
- ✅ User search and following
- ✅ Reputation and badge system
- ✅ Form validation
- ✅ Error handling
- ✅ Loading states
- ✅ Accessibility features

### Performance Benchmarks
- ✅ Concurrent operations (target: <500ms)
- ✅ Memory usage (target: <10MB increase)
- ✅ Response times (target: <1000ms)
- ✅ Network simulation
- ✅ State management efficiency

## 🛠️ Test Utilities

### TestConfig
The `test_config.dart` file provides utilities for consistent test setup:

```dart
// Create test app with authentication
final app = TestConfig.createAuthTestApp(
  child: LoginScreen(),
  mockRepository: MockAuthRepository(),
);

// Wait for widgets
await TestConfig.Utils.waitForWidget(tester, find.text('Login'));

// Measure performance
final duration = await TestConfig.Utils.measurePerformance(() async {
  // Your operation here
});
TestConfig.Utils.assertPerformance(duration, 'operationName');
```

### Mock Data
```dart
// Use predefined test data
final userData = TestConfig.testUserData;
final credentials = TestConfig.testCredentials;

// Generate random test data
final email = TestConfig.DataGenerators.randomEmail();
final users = TestConfig.DataGenerators.generateTestUsers(10);
```

## 📋 Test Writing Guidelines

### 1. Test Structure
```dart
group('Feature Name', () {
  setUp(() {
    // Setup code
  });

  tearDown(() {
    // Cleanup code
  });

  testWidgets('should do something', (tester) async {
    // Arrange
    await tester.pumpWidget(TestConfig.createTestApp(child: MyWidget()));
    
    // Act
    await tester.tap(find.text('Button'));
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.text('Expected Result'), findsOneWidget);
  });
});
```

### 2. Performance Testing
```dart
test('should complete within performance threshold', () async {
  final duration = await TestConfig.Utils.measurePerformance(() async {
    // Your operation here
  });
  
  TestConfig.Utils.assertPerformance(duration, 'operationName');
});
```

### 3. Error Testing
```dart
test('should handle errors gracefully', () async {
  expect(
    () => repository.signInWithEmailAndPassword('invalid', 'invalid'),
    throwsA(isA<AuthException>()),
  );
});
```

## 🔧 Test Configuration

### Performance Thresholds
```dart
static const Map<String, int> performanceThresholds = {
  'concurrentOperations': 500,    // ms
  'rapidStateChanges': 2000,      // ms
  'userSearch': 1000,             // ms
  'profileUpdate': 1000,          // ms
  'memoryIncrease': 10 * 1024 * 1024, // 10MB
};
```

### Test Data
```dart
static const Map<String, String> testCredentials = {
  'validEmail': 'test@jambam.com',
  'validPassword': 'password123',
  'invalidEmail': 'invalid@email.com',
  'invalidPassword': 'wrongpassword',
};
```

## 📈 Continuous Integration

### GitHub Actions
Tests are automatically run on:
- Pull requests
- Push to main branch
- Scheduled runs (daily)

### Test Reports
- Coverage reports are generated and uploaded
- Performance benchmarks are tracked over time
- Test results are published as artifacts

## 🐛 Debugging Tests

### Verbose Output
```bash
flutter test --verbose
```

### Debug Mode
```bash
flutter test --debug
```

### Single Test
```bash
flutter test test/features/b_authentication/auth_repository_test.dart
```

### Hot Reload for Tests
```bash
flutter test --hot
```

## 📚 Best Practices

### 1. Test Isolation
- Each test should be independent
- Use `setUp()` and `tearDown()` for cleanup
- Avoid shared state between tests

### 2. Descriptive Names
```dart
// Good
testWidgets('should show error message for invalid email', (tester) async {

// Bad
testWidgets('test1', (tester) async {
```

### 3. Arrange-Act-Assert Pattern
```dart
testWidgets('should login successfully', (tester) async {
  // Arrange
  await tester.pumpWidget(TestConfig.createAuthTestApp(child: LoginScreen()));
  
  // Act
  await tester.enterText(find.byKey(Key('email_field')), 'test@jambam.com');
  await tester.enterText(find.byKey(Key('password_field')), 'password123');
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
  
  // Assert
  expect(find.text('Welcome'), findsOneWidget);
});
```

### 4. Performance Testing
- Always measure performance for critical operations
- Set realistic thresholds
- Monitor for regressions

### 5. Error Testing
- Test both happy path and error scenarios
- Verify error messages are user-friendly
- Test edge cases and boundary conditions

## 🔍 Test Maintenance

### Regular Tasks
- [ ] Update test data when models change
- [ ] Review and update performance thresholds
- [ ] Add tests for new features
- [ ] Remove obsolete tests
- [ ] Update golden files when UI changes

### Monitoring
- [ ] Track test execution time
- [ ] Monitor coverage trends
- [ ] Review performance benchmarks
- [ ] Check for flaky tests

## 📞 Support

For questions about testing:
1. Check this README
2. Review existing test examples
3. Consult the Flutter testing documentation
4. Ask in the development team

## 🎯 Future Improvements

- [ ] Add more integration tests
- [ ] Implement visual regression testing
- [ ] Add load testing for backend APIs
- [ ] Create automated test data generation
- [ ] Implement test parallelization
- [ ] Add accessibility testing automation 