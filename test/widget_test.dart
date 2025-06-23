// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Required for JambaMApp due to ProviderScope
import 'package:flutter_test/flutter_test.dart';
import 'package:project_jambam/main.dart';
import 'package:project_jambam/src/core/logger.dart'; // Ensure logger is available if main initializes it.

void main() {
  // Initialize logger for tests if it's initialized in main() and tests run JambaMApp directly
  // This might be better handled in a test_setup.dart file if used across many tests.
  setUpAll(() {
    Logger.initialize(); // Assuming this is safe to call multiple times or handled internally.
  });

  testWidgets('JambaM app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const JambaMApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App uses Roboto font from Theme for default text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope( // JambaMApp is likely wrapped in ProviderScope in main
        child: JambaMApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Find a common Text widget. The loading text from AuthWrapper is a good candidate.
    // This assumes AuthWrapper will initially show its loading screen.
    // If AuthWrapper immediately resolves to LoginScreen or MainScreen due to mocks,
    // then find a text widget from one of those screens.

    // Let's find the "Loading..." text from AuthWrapper's _buildLoadingScreen
    // This requires AuthWrapper to be in a loading state.
    // For a more robust test, we might need to mock `currentUserProvider` to ensure loading state.
    // However, for a simple font check, finding any text rendered by the app is often sufficient.

    // As JambaMApp directly uses AuthWrapper as home:
    // And AuthWrapper uses currentUserProvider which is a StreamProvider.
    // It will initially be in a loading state.

    final loadingTextFinder = find.text('Loading...');

    // It's possible that by the time pumpAndSettle completes, the stream has resolved.
    // A more reliable way is to find a text that is always there, e.g. in LoginScreen
    // if we can force that state.
    // For now, let's try to find ANY Text widget and check its default style.

    final anyTextFinder = find.byElementType(Text);
    expect(anyTextFinder, findsWidgets, reason: "Expected to find at least one Text widget");

    // Get the BuildContext of the MaterialApp to access the theme.
    final BuildContext context = tester.element(find.byType(MaterialApp));
    final ThemeData theme = Theme.of(context);

    expect(theme.textTheme.bodyLarge?.fontFamily, equals('Roboto'));
    expect(theme.textTheme.headlineSmall?.fontFamily, equals('Roboto'));
    expect(theme.primaryTextTheme.bodyLarge?.fontFamily, equals('Roboto'));

    // More specific check on an actual rendered Text widget if possible
    // This part is tricky because the first Text widget found might have its own style.
    // A better way is to check the theme directly as done above.
    // If we want to check a specific widget:
    // await tester.pumpWidget(MaterialApp(home: Scaffold(body: Text("Test"))));
    // Text textWidget = tester.widget<Text>(find.text("Test"));
    // expect(textWidget.style?.fontFamily ?? DefaultTextStyle.of(tester.element(find.text("Test"))).style.fontFamily, equals('Roboto'));
  });
}
