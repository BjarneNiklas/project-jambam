import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/auth_wrapper.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/login_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/main_navigation_screen.dart';

void main() {
  testWidgets('AuthWrapper shows LoginScreen or MainNavigationScreen initially', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AuthWrapper(),
        ),
      ),
    );

    // Wait for the initial state to settle.
    // The mock auth repository now signs in an anonymous user by default.
    // So, we expect to see the MainNavigationScreen.
    await tester.pumpAndSettle();

    // Verify that either LoginScreen or MainNavigationScreen is present.
    // And that the loading indicator is not present.
    final loginScreenFinder = find.byType(LoginScreen);
    final mainNavigationScreenFinder = find.byType(MainNavigationScreen);
    final loadingIndicatorFinder = find.byType(CircularProgressIndicator);

    expect(
        (loginScreenFinder.evaluate().isNotEmpty || mainNavigationScreenFinder.evaluate().isNotEmpty),
        isTrue,
        reason: 'Expected to find LoginScreen or MainNavigationScreen, but found neither.');
    expect(loadingIndicatorFinder, findsNothing,
        reason: 'Expected not to find loading indicator, but it was present.');
  });
}
