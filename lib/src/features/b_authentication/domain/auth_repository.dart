import 'package:project_jambam/src/features/b_authentication/domain/user.dart';
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User; // Import for OAuthProvider, hide User to avoid conflict

/// Repository interface for authentication and user management
abstract class AuthRepository {
  /// Sign in with email and password
  Future<AuthResult> signInWithEmailAndPassword(String email, String password);
  
  /// Sign up with email and password
  Future<AuthResult> signUpWithEmailAndPassword(String email, String password, String displayName);
  
  /// Sign in anonymously
  Future<AuthResult> signInAnonymously();
  
  /// Sign in as a guest
  Future<AuthResult> signInAsGuest();

  /// Sign in with OAuth provider
  Future<AuthResult> signInWithOAuth(OAuthProvider provider);
  
  /// Sign out current user
  Future<void> signOut();
  
  /// Get current user
  User? getCurrentUser();
  
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
  
  /// Update user profile
  Future<AuthResult> updateProfile({
    String? displayName,
    String? avatar,
    String? bio,
    List<String>? interests,
    SkillLevel? skillLevel,
    LearningStyle? learningStyle,
    List<AccessibilityNeed>? accessibilityNeeds,
  });
  
  /// Delete user account
  Future<AuthResult> deleteAccount();
  
  /// Reset password
  Future<AuthResult> resetPassword(String email);
  
  /// Verify email
  Future<AuthResult> verifyEmail();
  
  /// Send email verification
  Future<AuthResult> sendEmailVerification();
  
  /// Update password
  Future<AuthResult> updatePassword(String newPassword);
  
  /// Link anonymous account with email
  Future<AuthResult> linkWithEmail(String email, String password);
  
  /// Get user by ID
  Future<User?> getUserById(String userId);
  
  /// Search users
  Future<List<User>> searchUsers(String query);
  
  /// Follow user
  Future<AuthResult> followUser(String userId);
  
  /// Unfollow user
  Future<AuthResult> unfollowUser(String userId);
  
  /// Get user followers
  Future<List<User>> getUserFollowers(String userId);
  
  /// Get user following
  Future<List<User>> getUserFollowing(String userId);
  
  /// Update user reputation
  Future<AuthResult> updateUserReputation(String userId, int reputationChange);
  
  /// Add user badge
  Future<AuthResult> addUserBadge(String userId, String badge);
  
  /// Remove user badge
  Future<AuthResult> removeUserBadge(String userId, String badge);
  
  /// Get user activity
  Future<List<UserActivity>> getUserActivity(String userId);
  
  /// Update user preferences
  Future<AuthResult> updateUserPreferences(UserPreferences preferences);
  
  /// Get user statistics
  Future<UserStatistics> getUserStatistics(String userId);
  
  /// Dispose resources
  void dispose();
}

/// Result of authentication operations
class AuthResult {
  const AuthResult({
    required this.success,
    this.user,
    this.error,
    this.errorCode,
  });

  final bool success;
  final User? user;
  final String? error;
  final String? errorCode;
}

/// User activity tracking
class UserActivity {
  const UserActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    this.data,
  });

  final String id;
  final ActivityType type;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? data;
}

enum ActivityType {
  jamSeedCreated,
  jamKitGenerated,
  communityContribution,
  experimentConducted,
  badgeEarned,
  reputationGained,
  userFollowed,
  contentLiked,
  commentPosted,
  researchPublished,
}