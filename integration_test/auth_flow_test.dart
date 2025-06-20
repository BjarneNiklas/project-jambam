import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_jambam/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Tests', () {
    testWidgets('Complete authentication flow test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we start at login screen
      expect(find.text('Welcome to JambaM'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      // Test login with valid credentials
      await _testValidLogin(tester);
      
      // Test logout
      await _testLogout(tester);
      
      // Test signup flow
      await _testSignupFlow(tester);
      
      // Test password reset
      await _testPasswordReset(tester);
      
      // Test anonymous login
      await _testAnonymousLogin(tester);
    });

    testWidgets('Login validation tests', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test invalid email format
      await _testInvalidEmailValidation(tester);
      
      // Test short password
      await _testShortPasswordValidation(tester);
      
      // Test empty fields
      await _testEmptyFieldsValidation(tester);
    });

    testWidgets('Signup validation tests', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Switch to signup mode
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Test invalid display name
      await _testInvalidDisplayNameValidation(tester);
      
      // Test password mismatch
      await _testPasswordMismatchValidation(tester);
    });

    testWidgets('Profile management tests', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await _testValidLogin(tester);
      
      // Test profile update
      await _testProfileUpdate(tester);
      
      // Test settings access
      await _testSettingsAccess(tester);
    });
  });
}

Future<void> _testValidLogin(WidgetTester tester) async {
  // Enter valid credentials
  await tester.enterText(
    find.byKey(const Key('email_field')),
    'test@jambam.com',
  );
  await tester.enterText(
    find.byKey(const Key('password_field')),
    'password123',
  );
  await tester.pumpAndSettle();

  // Tap login button
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();

  // Verify successful login - should navigate to main screen
  expect(find.text('JambaM'), findsOneWidget);
  expect(find.text('Community Hub'), findsOneWidget);
  expect(find.text('Jam Seeds'), findsOneWidget);
  expect(find.text('Jam Kits'), findsOneWidget);
}

Future<void> _testLogout(WidgetTester tester) async {
  // Navigate to settings
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();

  // Tap logout button
  await tester.tap(find.text('Sign Out'));
  await tester.pumpAndSettle();

  // Verify we're back at login screen
  expect(find.text('Welcome to JambaM'), findsOneWidget);
  expect(find.text('Sign In'), findsOneWidget);
}

Future<void> _testSignupFlow(WidgetTester tester) async {
  // Switch to signup mode
  await tester.tap(find.text('Create Account'));
  await tester.pumpAndSettle();

  // Enter signup information
  await tester.enterText(
    find.byKey(const Key('display_name_field')),
    'New Test User',
  );
  await tester.enterText(
    find.byKey(const Key('email_field')),
    'newuser@jambam.com',
  );
  await tester.enterText(
    find.byKey(const Key('password_field')),
    'newpassword123',
  );
  await tester.enterText(
    find.byKey(const Key('confirm_password_field')),
    'newpassword123',
  );
  await tester.pumpAndSettle();

  // Tap signup button
  await tester.tap(find.text('Create Account'));
  await tester.pumpAndSettle();

  // Verify successful signup
  expect(find.text('JambaM'), findsOneWidget);
  expect(find.text('Community Hub'), findsOneWidget);
}

Future<void> _testPasswordReset(WidgetTester tester) async {
  // Tap forgot password
  await tester.tap(find.text('Forgot Password?'));
  await tester.pumpAndSettle();

  // Enter email
  await tester.enterText(
    find.byKey(const Key('reset_email_field')),
    'test@jambam.com',
  );
  await tester.pumpAndSettle();

  // Tap reset button
  await tester.tap(find.text('Send Reset Link'));
  await tester.pumpAndSettle();

  // Verify success message
  expect(find.text('Password reset email sent!'), findsOneWidget);

  // Go back to login
  await tester.tap(find.text('Back to Login'));
  await tester.pumpAndSettle();
}

Future<void> _testAnonymousLogin(WidgetTester tester) async {
  // Tap continue as guest
  await tester.tap(find.text('Continue as Guest'));
  await tester.pumpAndSettle();

  // Verify anonymous login
  expect(find.text('JambaM'), findsOneWidget);
  expect(find.text('Guest User'), findsOneWidget);

  // Logout
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Sign Out'));
  await tester.pumpAndSettle();
}

Future<void> _testInvalidEmailValidation(WidgetTester tester) async {
  // Enter invalid email
  await tester.enterText(
    find.byKey(const Key('email_field')),
    'invalid-email',
  );
  await tester.pumpAndSettle();

  // Verify error message
  expect(find.text('Please enter a valid email address'), findsOneWidget);
}

Future<void> _testShortPasswordValidation(WidgetTester tester) async {
  // Enter short password
  await tester.enterText(
    find.byKey(const Key('password_field')),
    '123',
  );
  await tester.pumpAndSettle();

  // Verify error message
  expect(find.text('Password must be at least 6 characters'), findsOneWidget);
}

Future<void> _testEmptyFieldsValidation(WidgetTester tester) async {
  // Try to login with empty fields
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();

  // Verify error messages
  expect(find.text('Please enter your email'), findsOneWidget);
  expect(find.text('Please enter your password'), findsOneWidget);
}

Future<void> _testInvalidDisplayNameValidation(WidgetTester tester) async {
  // Enter short display name
  await tester.enterText(
    find.byKey(const Key('display_name_field')),
    'A',
  );
  await tester.pumpAndSettle();

  // Verify error message
  expect(find.text('Display name must be at least 2 characters'), findsOneWidget);
}

Future<void> _testPasswordMismatchValidation(WidgetTester tester) async {
  // Enter different passwords
  await tester.enterText(
    find.byKey(const Key('password_field')),
    'password123',
  );
  await tester.enterText(
    find.byKey(const Key('confirm_password_field')),
    'differentpassword',
  );
  await tester.pumpAndSettle();

  // Verify error message
  expect(find.text('Passwords do not match'), findsOneWidget);
}

Future<void> _testProfileUpdate(WidgetTester tester) async {
  // Navigate to profile
  await tester.tap(find.byIcon(Icons.person));
  await tester.pumpAndSettle();

  // Update display name
  await tester.tap(find.text('Edit Profile'));
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('edit_display_name_field')),
    'Updated User Name',
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('Save Changes'));
  await tester.pumpAndSettle();

  // Verify update
  expect(find.text('Updated User Name'), findsOneWidget);
}

Future<void> _testSettingsAccess(WidgetTester tester) async {
  // Navigate to settings
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();

  // Verify settings options
  expect(find.text('Account Settings'), findsOneWidget);
  expect(find.text('Privacy'), findsOneWidget);
  expect(find.text('Notifications'), findsOneWidget);
  expect(find.text('Accessibility'), findsOneWidget);
} 