import 'dart:async';
import 'package:project_jambam/src/features/b_authentication/domain/auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/user.dart';
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User; // Import for OAuthProvider, hide User to avoid conflict

/// Mock implementation of [AuthRepository] for testing and development.
class MockAuthRepository implements AuthRepository {
  User? _currentUser;
  final _authStateController = StreamController<User?>.broadcast();

  MockAuthRepository() {
    _currentUser = null; // No user initially
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  User? getCurrentUser() => _currentUser;

  @override
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (email == 'test@example.com' && password == 'password') {
      _currentUser = User(
        id: 'mock-user-123',
        email: email,
        displayName: 'Test User',
        isAnonymous: false,
      );
      _authStateController.add(_currentUser);
      return const AuthResult(success: true);
    } else {
      return const AuthResult(success: false, error: 'Invalid credentials');
    }
  }

  @override
  Future<AuthResult> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (email.contains('@') && password.length >= 6 && displayName.isNotEmpty) {
      _currentUser = User(
        id: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: displayName,
        isAnonymous: false,
      );
      _authStateController.add(_currentUser);
      return const AuthResult(success: true);
    } else {
      return const AuthResult(success: false, error: 'Invalid signup data');
    }
  }

  @override
  Future<AuthResult> signInAnonymously() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    _currentUser = User(
      id: 'mock-anonymous-${DateTime.now().millisecondsSinceEpoch}',
      email: 'anonymous@mock.com',
      displayName: 'Anonymous User',
      isAnonymous: true,
    );
    _authStateController.add(_currentUser);
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> signInAsGuest() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    _currentUser = User(
      id: 'mock-guest-${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@mock.com',
      displayName: 'Guest User',
      isAnonymous: true,
    );
    _authStateController.add(_currentUser);
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> signInWithOAuth(OAuthProvider provider) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate OAuth flow delay
    _currentUser = User(
      id: 'mock-${provider.name}-user-${DateTime.now().millisecondsSinceEpoch}',
      email: '${provider.name}@mock.com',
      displayName: '${provider.name} User',
      isAnonymous: false,
    );
    _authStateController.add(_currentUser);
    return const AuthResult(success: true);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<AuthResult> updateProfile({
    String? displayName,
    String? avatar,
    String? bio,
    List<String>? interests,
    SkillLevel? skillLevel,
    LearningStyle? learningStyle,
    List<AccessibilityNeed>? accessibilityNeeds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_currentUser == null) {
      return const AuthResult(success: false, error: 'No user logged in');
    }
    _currentUser = _currentUser!.copyWith(
      displayName: displayName,
      avatar: avatar,
      bio: bio,
      interests: interests,
      skillLevel: skillLevel,
      learningStyle: learningStyle,
      accessibilityNeeds: accessibilityNeeds,
    );
    _authStateController.add(_currentUser);
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
    _authStateController.add(null);
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty) {
      return const AuthResult(success: true);
    }
    return const AuthResult(success: false, error: 'Email not found');
  }

  @override
  Future<AuthResult> verifyEmail() async {
    return const AuthResult(success: false, error: 'Not implemented in mock');
  }

  @override
  Future<AuthResult> sendEmailVerification() async {
    return const AuthResult(success: false, error: 'Not implemented in mock');
  }

  @override
  Future<AuthResult> updatePassword(String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    if (newPassword.length >= 6) {
      return const AuthResult(success: true);
    }
    return const AuthResult(success: false, error: 'Password too short');
  }

  @override
  Future<AuthResult> linkWithEmail(String email, String password) async {
    return const AuthResult(success: false, error: 'Not implemented in mock');
  }

  @override
  Future<User?> getUserById(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (userId == _currentUser?.id) {
      return _currentUser;
    }
    return null;
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_currentUser != null && _currentUser!.displayName.contains(query)) {
      return [_currentUser!];
    }
    return [];
  }

  @override
  Future<AuthResult> followUser(String userIdToFollow) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const AuthResult(success: true);
  }

  @override
  Future<AuthResult> unfollowUser(String userIdToUnfollow) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const AuthResult(success: true);
  }

  @override
  Future<List<User>> getUserFollowers(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [];
  }

  @override
  Future<List<User>> getUserFollowing(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [];
  }

  @override
  Future<AuthResult> updateUserReputation(String userId, int reputationChange) async {
    return const AuthResult(success: false, error: "Not implemented in mock");
  }

  @override
  Future<AuthResult> addUserBadge(String userId, String badge) async {
    return const AuthResult(success: false, error: "Not implemented in mock");
  }

  @override
  Future<AuthResult> removeUserBadge(String userId, String badge) async {
    return const AuthResult(success: false, error: "Not implemented in mock");
  }

  @override
  Future<List<UserActivity>> getUserActivity(String userId) async {
    return [];
  }

  @override
  Future<AuthResult> updateUserPreferences(UserPreferences preferences) async {
    return const AuthResult(success: true);
  }

  @override
  Future<UserStatistics> getUserStatistics(String userId) async {
    return const UserStatistics(jamSeedsCreated: 0, jamKitsGenerated: 0, communityContributions: 0);
  }

  @override
  void dispose() {
    _authStateController.close();
  }
}