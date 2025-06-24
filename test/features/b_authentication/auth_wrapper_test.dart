import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_jambam/src/features/b_authentication/data/auth_repository_provider.dart'; // Import provider
import 'package:project_jambam/src/features/b_authentication/domain/user.dart' as domain_user; // Import domain user
import 'package:project_jambam/src/features/b_authentication/presentation/auth_wrapper.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/login_screen.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/main_navigation_screen.dart';


void main() {
  testWidgets('AuthWrapper shows LoginScreen or MainNavigationScreen initially', (WidgetTester tester) async {
    // This test assumes a default behavior (e.g., mock anonymous user signed in)
    // For a more controlled test, override currentUserProvider to return a specific user or null.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Example: Override to simulate no user logged in initially for this specific test run
          // currentUserProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(
          home: AuthWrapper(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final loginScreenFinder = find.byType(LoginScreen);
    final mainNavigationScreenFinder = find.byType(MainNavigationScreen);

    // Depending on the default mock behavior (or override), one of these should be true.
    // The original comment suggested mock signs in anon user.
    // If currentUserProvider is overridden to Stream.value(null), LoginScreen should be found.
    // If default mock is anon user, MainNavigationScreen should be found.
    // For this example, let's stick to the original idea of a default mock behavior.
    expect(
        (loginScreenFinder.evaluate().isNotEmpty || mainNavigationScreenFinder.evaluate().isNotEmpty),
        isTrue,
        reason: 'Expected to find LoginScreen or MainNavigationScreen, but found neither.');
    expect(find.byType(CircularProgressIndicator), findsNothing,
        reason: 'Expected not to find loading indicator, but it was present.');
  });

  testWidgets('AuthWrapper shows error screen and handles try again', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) => Stream<domain_user.User?>.error(Exception('Test Auth Error'))),
        ],
        child: const MaterialApp(
          home: AuthWrapper(),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Settle to show error screen

    expect(find.text('Authentication Error'), findsOneWidget);
    expect(find.text('There was an error loading your authentication state.'), findsOneWidget);
    final tryAgainButtonFinder = find.widgetWithText(ElevatedButton, 'Try Again');
    expect(tryAgainButtonFinder, findsOneWidget);

    await tester.tap(tryAgainButtonFinder);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) {
            return Stream<domain_user.User?>.value(null).asyncExpand((_) async* {
              await Future.delayed(const Duration(milliseconds: 50));
              throw Exception('Auth Error After Retry');
            });
          }),
        ],
        child: const MaterialApp(
          home: AuthWrapper(),
        ),
      ),
    );
    await tester.pumpAndSettle(); // Initial error

    expect(find.text('Authentication Error'), findsOneWidget, reason: "Should show initial error message");
    expect(find.widgetWithText(ElevatedButton, 'Try Again'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Try Again'));
    await tester.pump(); // Start the "loading" phase after tap

    expect(find.byType(CircularProgressIndicator), findsOneWidget, reason: "Should show loading indicator after tap");

    await tester.pumpAndSettle(); // Settle to show the error again

    expect(find.text('Authentication Error'), findsOneWidget, reason: "Should show error message again after retry");
    // The specific error message from the provider might be different, check for generic error UI
    expect(find.text('There was an error loading your authentication state.'), findsOneWidget);

  });
}
