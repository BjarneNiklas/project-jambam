import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/auth_wrapper.dart';
import 'package:project_jambam/src/core/logger.dart'; // Updated Logger import
import 'package:supabase_flutter/supabase_flutter.dart' as sb; // Added Supabase import
import 'package:project_jambam/src/core/environment.dart'; // For environment variables
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:async';
// import 'package:project_jambam/src/features/b_admin_panel/admin_panel_screen.dart'; // Entfernt
import 'src/features/b_authentication/data/auth_repository_provider.dart';

final environment = Environment();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the new logging system
  Logger.initialize();

  final logger = Logger('JambaM.main'); // Logger instance can now be created after initialization
  
  // Global error handler for Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.presentError(details);
    await Sentry.captureException(details.exception, stackTrace: details.stack);
    // Show user feedback dialog if in release mode
    if (!logger.toString().contains('debug')) {
      await showSentryUserFeedback(details.exception, details.stack);
    }
  };

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://db974f6de599037c8fb6a1c00a7393c6@o4509548275236864.ingest.de.sentry.io/4509548279234640'; // Sentry DSN for JambaM
      options.sendDefaultPii = false; // DSGVO: Keine personenbezogenen Daten senden
      options.tracesSampleRate = 1.0; // 100% aller Performance-Traces (für Produktion ggf. 0.2)
      options.release = 'jambam@1.0.0+1'; // Passe ggf. dynamisch an
      options.environment = environment.get('ENVIRONMENT') ?? 'development';
      options.beforeSend = (event, {hint}) {
        // Beispiel: User-E-Mail entfernen
        if (event.user != null) {
          event = event.copyWith(user: event.user!.copyWith(email: null));
        }
        // Weitere Privacy-Filter können hier ergänzt werden (z.B. event.tags, event.breadcrumbs, etc.)
        return event;
      };
      // options.attachStacktrace = true;
      // options.debug = kDebugMode;
      // options.serverName = 'jambam-eu';
    },
    appRunner: () async {
      runZonedGuarded(() async {
        try {
          logger.info('Loading environment variables...');
          await environment.load(); // Load variables
          logger.info('Environment variables loaded.');

          final supabaseUrl = environment.get('SUPABASE_URL');
          final supabaseAnonKey = environment.get('SUPABASE_ANON_KEY');

          if (supabaseUrl == null || supabaseAnonKey == null) {
            throw Exception('Supabase URL or Anon Key is not configured in environment.');
          }

          logger.info('Initializing Supabase...');
          await sb.Supabase.initialize(
            url: supabaseUrl,
            anonKey: supabaseAnonKey,
            // Optional: custom auth store, debug settings, etc.
          );
          logger.info('Supabase initialized successfully.');

          logger.info('Starting JambaM application');
          
          runApp(
            const ProviderScope(
              child: JambaMApp(),
            ),
          );
        } catch (e, stackTrace) {
          logger.error('Failed to initialize app: $e');
          final sentryId = await Sentry.captureException(e, stackTrace: stackTrace);
          await showSentryUserFeedback(e, stackTrace, eventId: sentryId);
          runApp(
            const ProviderScope(
              child: JambaMApp(),
            ),
          );
        }
      }, (error, stackTrace) async {
        logger.error('Uncaught error: $error');
        final sentryId = await Sentry.captureException(error, stackTrace: stackTrace);
        await showSentryUserFeedback(error, stackTrace, eventId: sentryId);
      });
    },
  );
}

Future<void> showSentryUserFeedback(Object error, StackTrace? stack, {SentryId? eventId}) async {
  // Only show dialog if context is available (i.e. app is running)
  final navigatorKey = GlobalKey<NavigatorState>();
  final context = navigatorKey.currentContext;
  if (context == null) return;
  String? feedback;
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Fehler aufgetreten'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Etwas ist schiefgelaufen. Möchtest du uns Feedback geben?'),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Dein Feedback (optional)'),
            onChanged: (value) => feedback = value,
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (eventId != null && feedback != null && feedback!.trim().isNotEmpty) {
              await Sentry.captureUserFeedback(
                SentryUserFeedback(
                  eventId: eventId,
                  comments: feedback,
                ),
              );
            }
            Navigator.of(ctx).pop();
          },
          child: const Text('Feedback senden'),
        ),
      ],
    ),
  );
}

class JambaMApp extends StatelessWidget {
  const JambaMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JambaM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Changed to Roboto as per STYLE_GUIDE.md
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: const RoundedRectangleBorder( // shape kann const sein
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          filled: true,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Changed to Roboto as per STYLE_GUIDE.md
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: const RoundedRectangleBorder( // shape kann const sein
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          filled: true,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}

class AdminGuard extends ConsumerWidget {
  final Widget child;
  const AdminGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (user) {
        if (user != null && (user.badges.contains('admin') || user.badges.contains('superadmin'))) {
          return child;
        }
        return const Scaffold(
          body: Center(child: Text('Kein Zugriff – Adminrechte erforderlich.')),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Fehler: $e'))),
    );
  }
}
