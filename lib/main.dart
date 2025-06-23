import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/auth_wrapper.dart';
import 'package:project_jambam/src/core/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb; // Added Supabase import
import 'package:project_jambam/src/core/environment.dart'; // For environment variables

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final logger = Logger('JambaM.main');
  final environment = Environment(); // Create an instance
  
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
  } catch (e) {
    logger.error('Failed to initialize app: $e');
    // Run app with minimal setup if initialization fails (e.g. show error screen)
    // For now, we'll still try to run the app, but it might not function correctly.
    runApp(
      const ProviderScope(
        child: JambaMApp(),
      ),
    );
  }
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
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}
