import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('should display login form correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify main elements are present
      expect(find.text('Welcome to JambaM'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Verify form fields
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should switch between login and signup modes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Initially in login mode
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byKey(const Key('display_name_field')), findsNothing);

      // Switch to signup mode
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Verify signup mode
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.byKey(const Key('display_name_field')), findsOneWidget);
      expect(find.byKey(const Key('confirm_password_field')), findsOneWidget);

      // Switch back to login mode
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify login mode
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byKey(const Key('display_name_field')), findsNothing);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Initially password should be hidden
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Password should now be visible
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Password should be hidden again
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should show validation errors for invalid input', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'invalid-email',
      );
      await tester.pumpAndSettle();

      // Verify email validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);

      // Enter short password
      await tester.enterText(
        find.byKey(const Key('password_field')),
        '123',
      );
      await tester.pumpAndSettle();

      // Verify password validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should show validation errors in signup mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Switch to signup mode
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Enter short display name
      await tester.enterText(
        find.byKey(const Key('display_name_field')),
        'A',
      );
      await tester.pumpAndSettle();

      // Verify display name validation error
      expect(find.text('Display name must be at least 2 characters'), findsOneWidget);

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

      // Verify password mismatch error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should handle successful login', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

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

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle successful signup', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Switch to signup mode
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Enter valid signup information
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

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle anonymous login', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Tap continue as guest
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show password reset dialog', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Tap forgot password
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Verify reset dialog
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('Enter your email address to receive a password reset link.'), findsOneWidget);
      expect(find.byKey(const Key('reset_email_field')), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should handle password reset', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Open reset dialog
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Enter email
      await tester.enterText(
        find.byKey(const Key('reset_email_field')),
        'test@jambam.com',
      );
      await tester.pumpAndSettle();

      // Send reset link
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Password reset email sent!'), findsOneWidget);
    });

    testWidgets('should show error messages', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter invalid credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'invalid@email.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'wrongpassword',
      );
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Invalid email or password'), findsOneWidget);
    });

    testWidgets('should clear error when user starts typing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // First, trigger an error
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your email'), findsOneWidget);

      // Start typing in email field
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@email.com',
      );
      await tester.pumpAndSettle();

      // Error should be cleared
      expect(find.text('Please enter your email'), findsNothing);
    });

    testWidgets('should show loading state during authentication', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

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

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Signing in...'), findsOneWidget);

      // Button should be disabled
      expect(tester.widget<ElevatedButton>(find.text('Sign In')).enabled, isFalse);
    });

    testWidgets('should handle form submission with keyboard', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@jambam.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.pumpAndSettle();

      // Submit with keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show accessibility features', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify accessibility labels
      expect(find.bySemanticsLabel('Email address input field'), findsOneWidget);
      expect(find.bySemanticsLabel('Password input field'), findsOneWidget);
      expect(find.bySemanticsLabel('Sign in button'), findsOneWidget);
      expect(find.bySemanticsLabel('Create account button'), findsOneWidget);
      expect(find.bySemanticsLabel('Continue as guest button'), findsOneWidget);
      expect(find.bySemanticsLabel('Forgot password link'), findsOneWidget);
    });

    testWidgets('should handle theme changes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: LoginScreen(),
          ),
        ),
      );

      // Verify light theme is applied
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);

      // Test dark theme
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: LoginScreen(),
          ),
        ),
      );
    });
  });
} 