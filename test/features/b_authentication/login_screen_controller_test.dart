import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/login_screen_controller.dart';

void main() {
  group('LoginScreenController', () {
    testWidgets('should initialize with default state', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(loginScreenControllerProvider);
                  return Text('Email: ${state.email}');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Email: '), findsOneWidget);
    });

    testWidgets('should update email field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Email: ${state.email}'),
                      ElevatedButton(
                        onPressed: () => controller.updateEmail('test@example.com'),
                        child: const Text('Update Email'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Email: '), findsOneWidget);

      await tester.tap(find.text('Update Email'));
      await tester.pump();

      expect(find.text('Email: test@example.com'), findsOneWidget);
    });

    testWidgets('should update password field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Password: ${state.password}'),
                      ElevatedButton(
                        onPressed: () => controller.updatePassword('password123'),
                        child: const Text('Update Password'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Password: '), findsOneWidget);

      await tester.tap(find.text('Update Password'));
      await tester.pump();

      expect(find.text('Password: password123'), findsOneWidget);
    });

    testWidgets('should update display name field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Display Name: ${state.displayName}'),
                      ElevatedButton(
                        onPressed: () => controller.updateDisplayName('Test User'),
                        child: const Text('Update Display Name'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Display Name: '), findsOneWidget);

      await tester.tap(find.text('Update Display Name'));
      await tester.pump();

      expect(find.text('Display Name: Test User'), findsOneWidget);
    });

    testWidgets('should toggle between login and signup mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Mode: ${state.isSignUp ? "Sign Up" : "Login"}'),
                      ElevatedButton(
                        onPressed: () => controller.toggleMode(),
                        child: const Text('Toggle Mode'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Mode: Login'), findsOneWidget);

      await tester.tap(find.text('Toggle Mode'));
      await tester.pump();

      expect(find.text('Mode: Sign Up'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Password Visible: ${state.isPasswordVisible}'),
                      ElevatedButton(
                        onPressed: () => controller.togglePasswordVisibility(),
                        child: const Text('Toggle Password Visibility'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Password Visible: false'), findsOneWidget);

      await tester.tap(find.text('Toggle Password Visibility'));
      await tester.pump();

      expect(find.text('Password Visible: true'), findsOneWidget);
    });

    testWidgets('should validate email correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Email Valid: ${state.isEmailValid}'),
                      ElevatedButton(
                        onPressed: () => controller.updateEmail('invalid-email'),
                        child: const Text('Invalid Email'),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.updateEmail('valid@email.com'),
                        child: const Text('Valid Email'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Email Valid: false'), findsOneWidget);

      await tester.tap(find.text('Invalid Email'));
      await tester.pump();

      expect(find.text('Email Valid: false'), findsOneWidget);

      await tester.tap(find.text('Valid Email'));
      await tester.pump();

      expect(find.text('Email Valid: true'), findsOneWidget);
    });

    testWidgets('should validate password correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Password Valid: ${state.isPasswordValid}'),
                      ElevatedButton(
                        onPressed: () => controller.updatePassword('123'),
                        child: const Text('Short Password'),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.updatePassword('password123'),
                        child: const Text('Valid Password'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Password Valid: false'), findsOneWidget);

      await tester.tap(find.text('Short Password'));
      await tester.pump();

      expect(find.text('Password Valid: false'), findsOneWidget);

      await tester.tap(find.text('Valid Password'));
      await tester.pump();

      expect(find.text('Password Valid: true'), findsOneWidget);
    });

    testWidgets('should validate display name correctly in signup mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Display Name Valid: ${state.isDisplayNameValid}'),
                      ElevatedButton(
                        onPressed: () => controller.toggleMode(),
                        child: const Text('Toggle to Sign Up'),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.updateDisplayName('A'),
                        child: const Text('Short Name'),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.updateDisplayName('Valid Name'),
                        child: const Text('Valid Name'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Display Name Valid: true'), findsOneWidget);

      await tester.tap(find.text('Toggle to Sign Up'));
      await tester.pump();

      expect(find.text('Display Name Valid: false'), findsOneWidget);

      await tester.tap(find.text('Short Name'));
      await tester.pump();

      expect(find.text('Display Name Valid: false'), findsOneWidget);

      await tester.tap(find.text('Valid Name'));
      await tester.pump();

      expect(find.text('Display Name Valid: true'), findsOneWidget);
    });

    testWidgets('should get email error message', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  
                  return Column(
                    children: [
                      Text('Error: ${controller.getEmailError() ?? "No Error"}'),
                      ElevatedButton(
                        onPressed: () => controller.updateEmail('invalid-email'),
                        child: const Text('Set Invalid Email'),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.updateEmail('valid@email.com'),
                        child: const Text('Set Valid Email'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error: No Error'), findsOneWidget);

      await tester.tap(find.text('Set Invalid Email'));
      await tester.pump();

      expect(find.text('Error: Please enter a valid email address'), findsOneWidget);

      await tester.tap(find.text('Set Valid Email'));
      await tester.pump();

      expect(find.text('Error: No Error'), findsOneWidget);
    });

    testWidgets('should get password error message', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  
                  return Column(
                    children: [
                      Text('Error: ${controller.getPasswordError() ?? "No Error"}'),
                      ElevatedButton(
                        onPressed: () => controller.updatePassword('123'),
                        child: const Text('Set Short Password'),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.updatePassword('password123'),
                        child: const Text('Set Valid Password'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error: No Error'), findsOneWidget);

      await tester.tap(find.text('Set Short Password'));
      await tester.pump();

      expect(find.text('Error: Password must be at least 6 characters'), findsOneWidget);

      await tester.tap(find.text('Set Valid Password'));
      await tester.pump();

      expect(find.text('Error: No Error'), findsOneWidget);
    });

    testWidgets('should get display name error message in signup mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Mode: ${state.isSignUp ? "Sign Up" : "Login"}'),
                      Text('Error: ${controller.getDisplayNameError() ?? "No Error"}'),
                      ElevatedButton(
                        onPressed: () => controller.toggleMode(),
                        child: const Text('Toggle Mode'),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.updateDisplayName('A'),
                        child: const Text('Set Short Name'),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.updateDisplayName('Valid Name'),
                        child: const Text('Set Valid Name'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error: No Error'), findsOneWidget);

      await tester.tap(find.text('Toggle Mode'));
      await tester.pump();

      expect(find.text('Error: No Error'), findsOneWidget);

      await tester.tap(find.text('Set Short Name'));
      await tester.pump();

      expect(find.text('Error: Display name must be at least 2 characters'), findsOneWidget);

      await tester.tap(find.text('Set Valid Name'));
      await tester.pump();

      expect(find.text('Error: No Error'), findsOneWidget);
    });

    testWidgets('should clear error message', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Error: ${state.error ?? "No Error"}'),
                      ElevatedButton(
                        onPressed: () => controller.clearError(),
                        child: const Text('Clear Error'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error: No Error'), findsOneWidget);

      await tester.tap(find.text('Clear Error'));
      await tester.pump();

      expect(find.text('Error: No Error'), findsOneWidget);
    });

    testWidgets('should clear reset password success message', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final controller = ref.watch(loginScreenControllerProvider.notifier);
                  final state = ref.watch(loginScreenControllerProvider);
                  
                  return Column(
                    children: [
                      Text('Success: ${state.showResetPasswordSuccess}'),
                      ElevatedButton(
                        onPressed: () => controller.clearResetPasswordSuccess(),
                        child: const Text('Clear Success'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Success: false'), findsOneWidget);

      await tester.tap(find.text('Clear Success'));
      await tester.pump();

      expect(find.text('Success: false'), findsOneWidget);
    });
  });
} 