import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/auth_wrapper.dart';
import 'package:project_jambam/src/core/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb; // Added Supabase import
import 'package:project_jambam/src/core/environment.dart'; // For environment variables

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final logger = Logger('JambaM.main');
  
  try {
    logger.info('Initializing Supabase...');
    await sb.Supabase.initialize(
      url: Environment.supabaseUrl, // Replace with your Supabase URL
      anonKey: Environment.supabaseAnonKey, // Replace with your Supabase anon key
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
    // Run app with minimal setup if initialization fails
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
