import 'package:project_jambam/src/features/b_authentication/data/supabase_auth_repository.dart'; // Changed to SupabaseAuthRepository
import 'package:project_jambam/src/features/b_authentication/domain/auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/user.dart';
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb; // Added Supabase import

part 'auth_repository_provider.g.dart';

/// Provider for the authentication repository
@riverpod
AuthRepository authRepository(Ref ref) {
  // Ensure Supabase is initialized before accessing Supabase.instance.client
  // This typically happens in main.dart
  // If Supabase is not initialized, this will throw an error.
  // Consider adding a check or relying on main.dart initialization.
  final supabaseClient = sb.Supabase.instance.client;
  return SupabaseAuthRepository(supabaseClient);
}

/// Provider for the current user stream
@riverpod
Stream<User?> currentUser(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
}

/// Provider for the current user (synchronous)
@riverpod
User? currentUserSync(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getCurrentUser();
}

/// Provider for user authentication state
@riverpod
class AuthState extends _$AuthState {
  @override
  AuthStateData build() {
    return const AuthStateData(
      isLoading: false,
      isAuthenticated: false,
      user: null,
      error: null,
    );
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.signInWithEmailAndPassword(email, password);
      
      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: result.user,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.signUpWithEmailAndPassword(email, password, displayName);
      
      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: result.user,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign in anonymously
  Future<void> signInAnonymously() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.signInAnonymously();
      
      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: result.user,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signOut();
      
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? avatar,
    String? bio,
    List<String>? interests,
    SkillLevel? skillLevel,
    LearningStyle? learningStyle,
    List<AccessibilityNeed>? accessibilityNeeds,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.updateProfile(
        displayName: displayName,
        avatar: avatar,
        bio: bio,
        interests: interests,
        skillLevel: skillLevel,
        learningStyle: learningStyle,
        accessibilityNeeds: accessibilityNeeds,
      );
      
      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          user: result.user,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.deleteAccount();
      
      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.resetPassword(email);
      
      if (result.success) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Data class for authentication state
class AuthStateData {
  const AuthStateData({
    required this.isLoading,
    required this.isAuthenticated,
    this.user,
    this.error,
  });

  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? error;

  AuthStateData copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    String? error,
  }) {
    return AuthStateData(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthStateData &&
        other.isLoading == isLoading &&
        other.isAuthenticated == isAuthenticated &&
        other.user == user &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(isLoading, isAuthenticated, user, error);
  }
} 