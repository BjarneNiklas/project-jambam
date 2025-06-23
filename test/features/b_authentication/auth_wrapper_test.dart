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
    final mockErrorCurrentUserProvider = StreamProvider<domain_user.User?>((ref) async* {
      // Ensure it's treated as async and throws after the first frame
      await Future.delayed(Duration.zero);
      throw Exception('Test Auth Error');
    });

    // To track if invalidate was called (simplified mock)
    bool providerInvalidated = false;
    final mockTrackingCurrentUserProvider = StreamProvider<domain_user.User?>((ref) {
      // This is a trick: when invalidated, this will be called again.
      // For a real test, you might use a proper mocking framework or a more complex setup.
      if (providerInvalidated) { // After "Try Again"
        return Stream.value(null); // Or simulate loading then data
      }
      // Initial error state
      return Stream.error(Exception('Test Auth Error'));
    });

    // We will use a more direct way to check invalidation by observing a change in UI state
    // (e.g. going back to loading state) rather than directly tracking invalidate calls here.

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithProvider(mockErrorCurrentUserProvider),
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

    // Re-pump with a provider that can change its state upon invalidation
    // to simulate the effect of "Try Again".
    // When "Try Again" is tapped, it calls ref.invalidate(currentUserProvider).
    // The overridden provider should then re-execute its logic.

    // For simplicity, we'll assume the invalidate causes a brief loading state.
    // We will override again with a provider that shows loading, then an error.
    // This simulates the "Try Again" causing a re-fetch.

    final loadingThenErrorProvider = StreamProvider<domain_user.User?>((ref) async* {
      yield* Stream.value(null).asyncMap((event) async { // Trick to make it emit loading first
          await Future.delayed(const Duration(milliseconds: 10)); // Simulate network delay
          throw Exception('Persistent Error After Retry');
        });
    });

    await tester.tap(tryAgainButtonFinder);
    // Override the provider *before* pumping again to reflect the new state post-invalidation.
    // This is a bit of a workaround for not directly mocking `ref.invalidate`.
    // A more robust way would involve a mock provider that changes its output based on an external signal or count.

    // For this test, let's assume invalidation leads to re-evaluation of the *original* mockErrorCurrentUserProvider.
    // So, tapping "Try Again" should re-trigger the error state from mockErrorCurrentUserProvider.
    // A more realistic test would involve a mock that changes behavior after an invalidate.

    // Let's test that after tap, it goes to loading, then error again.
    // To do this, we need a provider that changes state.
    int callCount = 0;
    final mockRetryProvider = StreamProvider<domain_user.User?>((ref) async* {
      callCount++;
      if (callCount == 1) { // Initial load
        await Future.delayed(Duration.zero);
        throw Exception('Initial Auth Error');
      } else { // After "Try Again" (invalidate)
        // Simulate loading
        yield null; // Represents loading state for AsyncValue.when
        await Future.delayed(const Duration(milliseconds: 50)); // Simulate work
        throw Exception('Auth Error After Retry'); // Simulate error again
      }
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithProvider(mockRetryProvider),
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
