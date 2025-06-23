import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:project_jambam/src/features/b_authentication/domain/auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/user.dart' as domain_user;
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart'; // For UserPreferences, SkillLevel etc.
import 'package:project_jambam/src/core/logger.dart'; // Import Logger

class SupabaseAuthRepository implements AuthRepository {
  final sb.SupabaseClient _supabaseClient;
  // Add a logger instance
  final Logger _logger = Logger('SupabaseAuthRepository');

  SupabaseAuthRepository(this._supabaseClient);

  domain_user.User? _mapSupabaseUser(sb.User? supabaseUser, Map<String, dynamic>? profileData) {
    if (supabaseUser == null) {
      return null;
    }
    // Combine Supabase auth user data with profile data
    return domain_user.User(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      displayName: profileData?['username'] as String? ?? supabaseUser.userMetadata?['display_name'] as String? ?? supabaseUser.email?.split('@').first ?? 'Anonymous',
      avatar: profileData?['avatar_url'] as String?,
      bio: profileData?['bio'] as String?,
      isAnonymous: supabaseUser.isAnonymous,
      interests: (profileData?['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      skillLevel: _parseSkillLevel(profileData?['skill_level'] as String?),
      learningStyle: _parseLearningStyle(profileData?['learning_style'] as String?),
      accessibilityNeeds: (profileData?['accessibility_needs'] as List<dynamic>?)
          ?.map((e) => _parseAccessibilityNeed(e as String?))
          .where((element) => element != null)
          .cast<AccessibilityNeed>()
          .toList() ?? [],
      reputation: profileData?['reputation'] as int? ?? 0,
      badges: (profileData?['badges'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      preferences: domain_user.UserPreferences(
        theme: _parseThemePreference(profileData?['preferences']?['theme'] as String?),
        notifications: domain_user.NotificationPreferences(
          emailNotifications: profileData?['preferences']?['notifications']?['emailNotifications'] as bool? ?? true,
          pushNotifications: profileData?['preferences']?['notifications']?['pushNotifications'] as bool? ?? true,
          communityUpdates: profileData?['preferences']?['notifications']?['communityUpdates'] as bool? ?? true,
          researchUpdates: profileData?['preferences']?['notifications']?['researchUpdates'] as bool? ?? true,
          achievementNotifications: profileData?['preferences']?['notifications']?['achievementNotifications'] as bool? ?? true,
          followerNotifications: profileData?['preferences']?['notifications']?['followerNotifications'] as bool? ?? true,
        ),
      ),
      statistics: domain_user.UserStatistics(
        jamSeedsCreated: profileData?['statistics']?['jam_seeds_created'] as int? ?? 0,
        jamKitsGenerated: profileData?['statistics']?['jam_kits_generated'] as int? ?? 0,
        communityContributions: profileData?['statistics']?['contributions_made'] as int? ?? 0,
      ),
    );
  }

  domain_user.ThemePreference _parseThemePreference(String? value) {
    if (value == null) return domain_user.ThemePreference.system;
    try {
      return domain_user.ThemePreference.values.byName(value);
    } catch (_) {
      return domain_user.ThemePreference.system;
    }
  }

  SkillLevel _parseSkillLevel(String? value) {
    if (value == null) return SkillLevel.beginner;
    try {
      return SkillLevel.values.byName(value);
    } catch (_) {
      return SkillLevel.beginner;
    }
  }

  LearningStyle _parseLearningStyle(String? value) {
    if (value == null) return LearningStyle.visual;
    try {
      return LearningStyle.values.byName(value);
    } catch (_) {
      return LearningStyle.visual;
    }
  }

  AccessibilityNeed? _parseAccessibilityNeed(String? value) {
    if (value == null) return null;
    try {
      return AccessibilityNeed.values.byName(value);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchUserProfile(String userId, {sb.User? authUser, String? defaultUsername}) async {
    try {
      final response = await _supabaseClient.from('profiles').select().eq('id', userId).single();
      return response;
    } catch (e) {
      _logger.error('Error fetching profile for $userId: $e');
      if (e is sb.PostgrestException && e.code == 'PGRST116') { // Profile not found
        if (authUser != null) { // Only attempt creation if we have auth user context
          _logger.info('Profile not found for $userId (PGRST116), attempting to create...');
          try {
            final newProfileData = {
              'id': authUser.id,
              'username': defaultUsername ?? authUser.email?.split('@').first ?? 'New User',
              'email': authUser.email,
            };
            final profileCreationResponse = await _supabaseClient.from('profiles').insert(newProfileData).select().single();
            _logger.info('Profile created for $userId.');
            return profileCreationResponse;
          } catch (creationError) {
            _logger.error('Error creating profile for $userId after PGRST116: $creationError');
            return null;
          }
        }
      }
      return null;
    }
  }

  Future<AuthResult> _handleAuthResponse(Future<sb.AuthResponse> futureAuthResponse, {String? usernameOnSignUp}) async {
    try {
      final authResponse = await futureAuthResponse;
      if (authResponse.user != null) {
        Map<String, dynamic>? profileData = await _fetchUserProfile(
          authResponse.user!.id,
          authUser: authResponse.user,
          defaultUsername: usernameOnSignUp,
        );
        return AuthResult(success: true, user: _mapSupabaseUser(authResponse.user, profileData));
      } else if (authResponse.session == null && authResponse.user == null) {
        return AuthResult(success: false, error: 'No active session. Email confirmation might be pending.');
      }
      return AuthResult(success: false, error: 'Unknown authentication error');
    } catch (e) {
      _logger.error('Auth Exception: $e');
      String errorMessage = 'An unexpected error occurred.';
      String errorCode = 'unknown';
      if (e is sb.AuthException) {
        errorMessage = e.message;
        errorCode = e.statusCode ?? 'unknown_auth_error';
      }
      return AuthResult(success: false, error: errorMessage, errorCode: errorCode);
    }
  }


  @override
  Stream<domain_user.User?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.asyncMap((sb.AuthState authState) async {
      final supabaseUser = authState.session?.user;
      if (supabaseUser != null) {
        final profileData = await _fetchUserProfile(supabaseUser.id, authUser: supabaseUser);
        return _mapSupabaseUser(supabaseUser, profileData);
      }
      return null;
    });
  }

  @override
  domain_user.User? getCurrentUser() {
    final supabaseUser = _supabaseClient.auth.currentUser;
    if (supabaseUser != null) {
      return _mapSupabaseUser(supabaseUser, null);
    }
    return null;
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) {
    return _handleAuthResponse(
      _supabaseClient.auth.signInWithPassword(email: email, password: password),
    );
  }

  @override
  Future<AuthResult> signUpWithEmailAndPassword(String email, String password, String displayName) {
     return _handleAuthResponse(
      _supabaseClient.auth.signUp(email: email, password: password, data: {'display_name': displayName}),
      usernameOnSignUp: displayName,
    );
  }

  @override
  Future<AuthResult> signInAnonymously() async {
    try {
      final authResponse = await _supabaseClient.auth.signInAnonymously();
      if (authResponse.user != null) {
        Map<String, dynamic>? profileData = await _fetchUserProfile(authResponse.user!.id);
        if (profileData == null) {
            try {
                final anonProfile = {
                    'id': authResponse.user!.id,
                    'username': 'Anonymous User (${authResponse.user!.id.substring(0,6)})',
                };
                profileData = await _supabaseClient.from('profiles').insert(anonProfile).select().single();
            } catch(e) {
                _logger.error("Error creating profile for anon user: $e");
            }
        }
        return AuthResult(success: true, user: _mapSupabaseUser(authResponse.user, profileData));
      }
      return AuthResult(success: false, error: 'Anonymous sign-in failed.');
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
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
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      return const AuthResult(success: false, error: 'User not authenticated.');
    }

    final Map<String, dynamic> updateData = {};
    if (displayName != null) updateData['username'] = displayName;
    if (avatar != null) updateData['avatar_url'] = avatar;
    if (bio != null) updateData['bio'] = bio;
    if (interests != null) updateData['interests'] = interests;
    if (skillLevel != null) updateData['skill_level'] = skillLevel.name;
    if (learningStyle != null) updateData['learning_style'] = learningStyle.name;
    if (accessibilityNeeds != null) updateData['accessibility_needs'] = accessibilityNeeds.map((e) => e.name).toList();

    if (updateData.isEmpty) {
      return const AuthResult(success: true, error: 'No data provided for update.');
    }

    try {
      await _supabaseClient.from('profiles').update(updateData).eq('id', userId);
      final updatedProfileData = await _fetchUserProfile(userId);
      final updatedUser = _mapSupabaseUser(_supabaseClient.auth.currentUser, updatedProfileData);
      return AuthResult(success: true, user: updatedUser);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  @override
  Future<AuthResult> deleteAccount() async {
    // This is a sensitive operation. Supabase typically requires this to be done via a server-side call with service_role key.
    // Directly from client might be disabled or restricted.
    // For now, return not implemented or error.
    // final userId = _supabaseClient.auth.currentUser?.id;
    // if (userId == null) return AuthResult(success: false, error: "User not logged in");
    // await _supabaseClient.rpc('delete_user_account', params: {'user_id_to_delete': userId});
    _logger.warn("deleteAccount: This operation should ideally be handled by a trusted server environment using a service role key.");
    return const AuthResult(success: false, error: 'Account deletion from client-side is not directly supported for security reasons. Please implement a server-side function.');
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
      return const AuthResult(success: true);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  @override
  Future<AuthResult> verifyEmail() async {
    return const AuthResult(success: false, error: 'verifyEmail not directly applicable or implemented. Email verification is typically link-based.');
  }

  @override
  Future<AuthResult> sendEmailVerification() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null || user.email == null) {
      return const AuthResult(success: false, error: 'User not found or no email associated.');
    }
    try {
      await _supabaseClient.auth.resend(email: user.email!, type: sb.OtpType.signup);
      return const AuthResult(success: true, error: 'Verification email sent. Please check your inbox.');
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  @override
  Future<AuthResult> updatePassword(String newPassword) async {
    try {
      final response = await _supabaseClient.auth.updateUser(sb.UserAttributes(password: newPassword));
      if (response.user != null) {
         final profileData = await _fetchUserProfile(response.user!.id);
        return AuthResult(success: true, user: _mapSupabaseUser(response.user, profileData));
      }
      return const AuthResult(success: false, error: 'Password update failed.');
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  @override
  Future<AuthResult> linkWithEmail(String email, String password) async {
    if (!_supabaseClient.auth.currentUser!.isAnonymous) {
        return const AuthResult(success: false, error: "Only anonymous users can link accounts this way.");
    }
    return const AuthResult(success: false, error: 'linkWithEmail for anonymous users needs a custom flow or server-side logic with Supabase.');
  }

  @override
  Future<domain_user.User?> getUserById(String userId) async {
    final profileData = await _fetchUserProfile(userId);
    if (profileData != null) {
      return domain_user.User(
        id: userId,
        email: profileData['email'] as String? ?? '',
        displayName: profileData['username'] as String? ?? 'User $userId',
        avatar: profileData['avatar_url'] as String?,
        bio: profileData['bio'] as String?,
      );
    }
    return null;
  }

  @override
  Future<List<domain_user.User>> searchUsers(String query) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .ilike('username', '%$query%')
          .limit(10);

      return response
          .map((data) => domain_user.User(
                id: data['id'] as String,
                email: data['email'] as String? ?? '',
                displayName: data['username'] as String? ?? '',
                avatar: data['avatar_url'] as String?,
                bio: data['bio'] as String?,
              ))
          .toList();
    } catch (e) {
      _logger.error('Error searching users: $e');
      return [];
    }
  }

  @override
  Future<AuthResult> followUser(String userIdToFollow) async {
    final currentUserId = _supabaseClient.auth.currentUser?.id;
    if (currentUserId == null) return const AuthResult(success: false, error: "Not authenticated");
    if (currentUserId == userIdToFollow) return const AuthResult(success: false, error: "Cannot follow yourself");

    try {
      await _supabaseClient.from('user_follows').insert({
        'follower_id': currentUserId,
        'following_id': userIdToFollow,
      });
      return const AuthResult(success: true);
    } catch (e) {
      return AuthResult(success: false, error: "Failed to follow user: ${e.toString()}");
    }
  }

  @override
  Future<AuthResult> unfollowUser(String userIdToUnfollow) async {
    final currentUserId = _supabaseClient.auth.currentUser?.id;
    if (currentUserId == null) return const AuthResult(success: false, error: "Not authenticated");

    try {
      await _supabaseClient.from('user_follows').delete()
        .eq('follower_id', currentUserId)
        .eq('following_id', userIdToUnfollow);
      return const AuthResult(success: true);
    } catch (e) {
      return AuthResult(success: false, error: "Failed to unfollow user: ${e.toString()}");
    }
  }

  @override
  Future<List<domain_user.User>> getUserFollowers(String userId) async {
    try {
      final response = await _supabaseClient
          .from('user_follows')
          .select('profiles!user_follows_follower_id_fkey(*)')
          .eq('following_id', userId);

      return response
          .map((data) {
            final profile = data['profiles'];
            return domain_user.User(
              id: profile['id'] as String,
              email: profile['email'] as String? ?? '',
              displayName: profile['username'] as String? ?? '',
              avatar: profile['avatar_url'] as String?,
            );
          }).toList();
    } catch (e) {
      // print("Error getting user followers: $e");
      return [];
    }
  }

  @override
  Future<List<domain_user.User>> getUserFollowing(String userId) async {
     try {
      final response = await _supabaseClient
          .from('user_follows')
          .select('profiles!user_follows_following_id_fkey(*)')
          .eq('follower_id', userId);

       return response
          .map((data) {
            final profile = data['profiles'];
            return domain_user.User(
              id: profile['id'] as String,
              email: profile['email'] as String? ?? '',
              displayName: profile['username'] as String? ?? '',
              avatar: profile['avatar_url'] as String?,
            );
          }).toList();
    } catch (e) {
      _logger.error("Error getting user following: $e"); // Corrected log message
      return [];
    }
  }

  @override
  Future<AuthResult> updateUserReputation(String userId, int reputationChange) async {
    return const AuthResult(success: false, error: "updateUserReputation should be server-side via RPC.");
  }

  @override
  Future<AuthResult> addUserBadge(String userId, String badge) async {
    return const AuthResult(success: false, error: "addUserBadge should be server-side or via RPC.");
  }

  @override
  Future<AuthResult> removeUserBadge(String userId, String badge) async {
    return const AuthResult(success: false, error: "removeUserBadge should be server-side or via RPC.");
  }

  @override
  Future<List<domain_user.UserActivity>> getUserActivity(String userId) async {
    // Example: Fetch from an 'user_activities' table
    // final response = await _supabaseClient.from('user_activities').select().eq('user_id', userId).order('timestamp', ascending: false);
    // return response.map((data) => domain_user.UserActivity(...)).toList();
    _logger.info("getUserActivity: Not implemented. Requires 'user_activities' table and schema.");
    return [];
  }

  @override
  Future<AuthResult> updateUserPreferences(domain_user.UserPreferences preferences) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return const AuthResult(success: false, error: "Not authenticated");

    try {
      await _supabaseClient.from('profiles').update({
        'preferences': {
          'theme': preferences.theme.name,
          'notifications': {
            'emailNotifications': preferences.notifications.emailNotifications,
            'pushNotifications': preferences.notifications.pushNotifications,
            'communityUpdates': preferences.notifications.communityUpdates,
            'researchUpdates': preferences.notifications.researchUpdates,
            'achievementNotifications': preferences.notifications.achievementNotifications,
            'followerNotifications': preferences.notifications.followerNotifications,
          },
          'privacy': {
            'profileVisibility': preferences.privacy.profileVisibility.name,
            'showEmail': preferences.privacy.showEmail,
            'showActivity': preferences.privacy.showActivity,
            'allowFollowRequests': preferences.privacy.allowFollowRequests,
            'allowMessages': preferences.privacy.allowMessages,
          },
          'accessibility': {
             'screenReaderSupport': preferences.accessibility.screenReaderSupport,
             'highContrastMode': preferences.accessibility.highContrastMode,
             'largeText': preferences.accessibility.largeText,
             'reducedMotion': preferences.accessibility.reducedMotion,
             'voiceNavigation': preferences.accessibility.voiceNavigation,
          },
          'language': preferences.language,
        }
      }).eq('id', userId);
      final profileData = await _fetchUserProfile(userId);
      return AuthResult(success: true, user: _mapSupabaseUser(_supabaseClient.auth.currentUser, profileData));
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  @override
  Future<domain_user.UserStatistics> getUserStatistics(String userId) async {
    final profileData = await _fetchUserProfile(userId);
    if (profileData != null && profileData['statistics'] != null) {
      final stats = profileData['statistics'];
      return domain_user.UserStatistics(
        jamSeedsCreated: stats['jam_seeds_created'] as int? ?? 0,
        jamKitsGenerated: stats['jam_kits_generated'] as int? ?? 0,
        communityContributions: stats['contributions_made'] as int? ?? 0,
      );
    }
    return const domain_user.UserStatistics(jamSeedsCreated: 0, jamKitsGenerated: 0, communityContributions: 0);
  }
}
