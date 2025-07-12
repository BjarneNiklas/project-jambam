import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project_jambam/src/features/b_authentication/data/auth_repository_provider.dart';
import 'package:project_jambam/src/features/b_authentication_invite/invite_code_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb; // Import for OAuthProvider

part 'login_screen_controller.g.dart';

/// Controller for the login screen
@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  LoginScreenState build() {
    return const LoginScreenState();
  }

  /// Update email field
  void updateEmail(String email) {
    state = state.copyWith(email: email);
    _validateForm();
  }

  /// Update password field
  void updatePassword(String password) {
    state = state.copyWith(password: password);
    _validateForm();
  }

  /// Update display name field (for sign up)
  void updateDisplayName(String displayName) {
    state = state.copyWith(displayName: displayName);
    _validateForm();
  }

  /// Update invite code field
  void updateInviteCode(String value) {
    state = state.copyWith(inviteCode: value);
  }

  /// Toggle between login and signup mode
  void toggleMode() {
    state = state.copyWith(
      isSignUp: !state.isSignUp,
      error: null,
    );
    _validateForm();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// Sign in with email and password
  Future<void> signIn() async {
    if (!state.isFormValid) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = ref.read(authStateProvider.notifier);
      await authState.signInWithEmailAndPassword(state.email, state.password);
      
      // Check if there was an error
      final currentState = ref.read(authStateProvider);
      if (currentState.error != null) {
        state = state.copyWith(
          isLoading: false,
          error: currentState.error,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign up with email and password
  Future<void> signUp() async {
    if (!state.isFormValid) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = ref.read(authStateProvider.notifier);
      await authState.signUpWithEmailAndPassword(
        state.email,
        state.password,
        state.displayName,
      );
      final authData = ref.read(authStateProvider);
      if (authData.user != null && state.inviteCode.isNotEmpty) {
        final inviteController = ref.read(inviteCodeControllerProvider.notifier);
        await inviteController.activate(state.inviteCode, authData.user!.id);
      }
      if (authData.error == null) {
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: authData.error,
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
      final authState = ref.read(authStateProvider.notifier);
      await authState.signInAnonymously();
      
      // Check if there was an error
      final currentState = ref.read(authStateProvider);
      if (currentState.error != null) {
        state = state.copyWith(
          isLoading: false,
          error: currentState.error,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign in as a guest
  Future<void> signInAsGuest() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = ref.read(authStateProvider.notifier);
      await authState.signInAsGuest();
      
      // Check if there was an error
      final currentState = ref.read(authStateProvider);
      if (currentState.error != null) {
        state = state.copyWith(
          isLoading: false,
          error: currentState.error,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authState = ref.read(authStateProvider.notifier);
      await authState.signInWithOAuth(sb.OAuthProvider.google);
      final currentState = ref.read(authStateProvider);
      if (currentState.error != null) {
        state = state.copyWith(
          isLoading: false,
          error: currentState.error,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign in with Discord
  Future<void> signInWithDiscord() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authState = ref.read(authStateProvider.notifier);
      await authState.signInWithOAuth(sb.OAuthProvider.discord);
      final currentState = ref.read(authStateProvider);
      if (currentState.error != null) {
        state = state.copyWith(
          isLoading: false,
          error: currentState.error,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Sign in with GitHub
  Future<void> signInWithGitHub() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authState = ref.read(authStateProvider.notifier);
      await authState.signInWithOAuth(sb.OAuthProvider.github);
      final currentState = ref.read(authStateProvider);
      if (currentState.error != null) {
        state = state.copyWith(
          isLoading: false,
          error: currentState.error,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Reset password
  Future<void> resetPassword() async {
    if (state.email.isEmpty) {
      state = state.copyWith(error: 'Please enter your email address');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = ref.read(authStateProvider.notifier);
      await authState.resetPassword(state.email);
      
      state = state.copyWith(
        isLoading: false,
        showResetPasswordSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear reset password success message
  void clearResetPasswordSuccess() {
    state = state.copyWith(showResetPasswordSuccess: false);
  }

  /// Validate form fields
  void _validateForm() {
    final emailValid = _isValidEmail(state.email);
    final passwordValid = state.password.length >= 6;
    final displayNameValid = state.isSignUp ? state.displayName.length >= 2 : true;

    state = state.copyWith(
      isEmailValid: emailValid,
      isPasswordValid: passwordValid,
      isDisplayNameValid: displayNameValid,
      isFormValid: emailValid && passwordValid && displayNameValid,
    );
  }

  /// Check if email is valid
  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Get email error message
  String? getEmailError() {
    if (state.email.isEmpty) return null;
    if (!state.isEmailValid) return 'Please enter a valid email address';
    return null;
  }

  /// Get password error message
  String? getPasswordError() {
    if (state.password.isEmpty) return null;
    if (!state.isPasswordValid) return 'Password must be at least 6 characters';
    return null;
  }

  /// Get display name error message
  String? getDisplayNameError() {
    if (!state.isSignUp) return null;
    if (state.displayName.isEmpty) return null;
    if (!state.isDisplayNameValid) return 'Display name must be at least 2 characters';
    return null;
  }

  /// Get invite code error message
  String? getInviteCodeError() {
    if (!state.isSignUp) return null;
    if (state.inviteCode.isEmpty) return null;
    if (state.inviteCode.length < 4) return 'Invite-Code zu kurz';
    return null;
  }
}

/// State for the login screen
class LoginScreenState {
  const LoginScreenState({
    this.email = '',
    this.password = '',
    this.displayName = '',
    this.inviteCode = '',
    this.isSignUp = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isDisplayNameValid = false,
    this.isFormValid = false,
    this.error,
    this.showResetPasswordSuccess = false,
  });

  final String email;
  final String password;
  final String displayName;
  final String inviteCode;
  final bool isSignUp;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isDisplayNameValid;
  final bool isFormValid;
  final String? error;
  final bool showResetPasswordSuccess;

  LoginScreenState copyWith({
    String? email,
    String? password,
    String? displayName,
    String? inviteCode,
    bool? isSignUp,
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isDisplayNameValid,
    bool? isFormValid,
    String? error,
    bool? showResetPasswordSuccess,
  }) {
    return LoginScreenState(
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      inviteCode: inviteCode ?? this.inviteCode,
      isSignUp: isSignUp ?? this.isSignUp,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isDisplayNameValid: isDisplayNameValid ?? this.isDisplayNameValid,
      isFormValid: isFormValid ?? this.isFormValid,
      error: error ?? this.error,
      showResetPasswordSuccess: showResetPasswordSuccess ?? this.showResetPasswordSuccess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginScreenState &&
        other.email == email &&
        other.password == password &&
        other.displayName == displayName &&
        other.isSignUp == isSignUp &&
        other.isPasswordVisible == isPasswordVisible &&
        other.isLoading == isLoading &&
        other.isEmailValid == isEmailValid &&
        other.isPasswordValid == isPasswordValid &&
        other.isDisplayNameValid == isDisplayNameValid &&
        other.isFormValid == isFormValid &&
        other.error == error &&
        other.showResetPasswordSuccess == showResetPasswordSuccess;
  }

  @override
  int get hashCode {
    return Object.hash(
      email,
      password,
      displayName,
      isSignUp,
      isPasswordVisible,
      isLoading,
      isEmailValid,
      isPasswordValid,
      isDisplayNameValid,
      isFormValid,
      error,
      showResetPasswordSuccess,
    );
  }
}