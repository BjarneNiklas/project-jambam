import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:project_jambam/src/features/b_authentication/domain/auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/user.dart' as domain_user;
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart'; // For UserPreferences, SkillLevel etc.

class SupabaseAuthRepository implements AuthRepository {
  final sb.SupabaseClient _supabaseClient;

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
      // Initialize other fields from profileData or with defaults if not available
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
      preferences: domain_user.UserPreferences( // Assuming UserPreferences can handle nulls or has defaults
        theme: profileData?['preferences']?['theme'] as String? ?? 'system', // Example, adapt to UserPreferences structure
        notificationsEnabled: profileData?['preferences']?['notifications_enabled'] as bool? ?? true,
      ),
      statistics: domain_user.UserStatistics( // Assuming UserStatistics can handle nulls or has defaults
        jamSeedsCreated: profileData?['statistics']?['jam_seeds_created'] as int? ?? 0,
        jamKitsGenerated: profileData?['statistics']?['jam_kits_generated'] as int? ?? 0,
        contributionsMade: profileData?['statistics']?['contributions_made'] as int? ?? 0,
      ),
    );
  }

  // Helper methods for safe enum parsing
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
      print('Error fetching profile for $userId: $e');
      if (e is sb.PostgrestException && e.code == 'PGRST116') { // Profile not found
        if (authUser != null) { // Only attempt creation if we have auth user context
          print('Profile not found for $userId (PGRST116), attempting to create...');
          try {
            final newProfileData = {
              'id': authUser.id,
              'username': defaultUsername ?? authUser.email?.split('@').first ?? 'New User',
              'email': authUser.email,
              // Add other default fields for profile here
            };
            final profileCreationResponse = await _supabaseClient.from('profiles').insert(newProfileData).select().single();
            print('Profile created for $userId.');
            return profileCreationResponse;
          } catch (creationError) {
            print('Error creating profile for $userId after PGRST116: $creationError');
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
        // Pass the authUser and usernameOnSignUp (as defaultUsername) to _fetchUserProfile
        Map<String, dynamic>? profileData = await _fetchUserProfile(
          authResponse.user!.id,
          authUser: authResponse.user,
          defaultUsername: usernameOnSignUp, // Will be used if profile is auto-created
        );

        // Original explicit profile creation for sign-up is now part of _fetchUserProfile's fallback.
        // We can remove the specific block below if _fetchUserProfile handles it.
        // if (profileData == null && authResponse.session != null && usernameOnSignUp != null) {
        //   // This block is now largely covered by _fetchUserProfile logic
        // }
        return AuthResult(success: true, user: _mapSupabaseUser(authResponse.user, profileData));
      } else if (authResponse.session == null && authResponse.user == null) {
        // This case might indicate email confirmation needed for signup
        // Supabase signUp returns a user object even if confirmation is needed, but no session.
        // Let's check if it's a signup that needs confirmation.
        // The current Supabase client (supabase_flutter >2.0) for signUp:
        // - if email confirmation is required: user is not null, session is null.
        // - if email confirmation is not required (e.g. auto confirm enabled): user is not null, session is not null.
        return AuthResult(success: false, error: 'No active session. Email confirmation might be pending.');
      }
      return AuthResult(success: false, error: 'Unknown authentication error');
    } catch (e) {
      print('Auth Exception: $e');
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
        // Pass Supabase user to _fetchUserProfile so it can create profile if missing
        final profileData = await _fetchUserProfile(supabaseUser.id, authUser: supabaseUser);
        return _mapSupabaseUser(supabaseUser, profileData);
      }
      return null;
    });
  }

  @override
  domain_user.User? getCurrentUser() {
    final supabaseUser = _supabaseClient.auth.currentUser;
    // This is tricky because profile data isn't available synchronously here.
    // The profile data would need to be fetched when authStateChanges updates the user state,
    // and then currentUserSync provider (or similar) would access that state.
    // For now, mapping with null profile is a placeholder.
    // A better approach for a sync current user with profile would be to have a Riverpod provider
    // that holds the latest User object (with profile) from the authStateChanges stream.
    if (supabaseUser != null) {
      // This will only have full profile data if _fetchUserProfile was called elsewhere and cached/stored.
      // Or, if we decide getCurrentUser should be async and fetch profile.
      // Given the interface, it's sync. So, it relies on prior population.
      // The AuthState provider in auth_repository_provider.dart will get user from authStateChanges stream.
      return _mapSupabaseUser(supabaseUser, null); // Passing null for profile - to be populated by stream
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
        // For anonymous users, a profile might not be automatically created or desired.
        // We can choose to create one or use user metadata.
        // For now, let's assume no separate profile, or it's handled like other users if they later link account.
        Map<String, dynamic>? profileData = await _fetchUserProfile(authResponse.user!.id);
        if (profileData == null) {
             // Create a basic profile for anonymous user
            try {
                final anonProfile = {
                    'id': authResponse.user!.id,
                    'username': 'Anonymous User (${authResponse.user!.id.substring(0,6)})',
                };
                profileData = await _supabaseClient.from('profiles').insert(anonProfile).select().single();
            } catch(e) {
                print("Error creating profile for anon user: $e");
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
    if (displayName != null) updateData['username'] = displayName; // Assuming 'username' in 'profiles' table
    if (avatar != null) updateData['avatar_url'] = avatar;
    if (bio != null) updateData['bio'] = bio;
    if (interests != null) updateData['interests'] = interests;
    if (skillLevel != null) updateData['skill_level'] = skillLevel.name;
    if (learningStyle != null) updateData['learning_style'] = learningStyle.name;
    if (accessibilityNeeds != null) updateData['accessibility_needs'] = accessibilityNeeds.map((e) => e.name).toList();

    // For nested preferences and statistics, need to fetch existing first if not replacing wholesale
    // Example for preferences (assuming it's a JSONB column named 'preferences')
    // if (preferences != null) updateData['preferences'] = preferences.toJson();


    if (updateData.isEmpty) {
      return const AuthResult(success: true, error: 'No data provided for update.'); // Or success:true if no change is not an error
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
    print("deleteAccount: This operation should ideally be handled by a trusted server environment using a service role key.");
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
    // Supabase handles email verification via link. Client might re-authenticate or refresh token.
    // This method might be to trigger a refresh or check status.
    // For now, this seems more like a server/callback thing or handled by onAuthStateChange.
    // If it's about resending verification:
    // final email = _supabaseClient.auth.currentUser?.email;
    // if (email == null) return AuthResult(success: false, error: "No user email found");
    // await _supabaseClient.auth.resend({'type': 'signup', 'email': email});
    return const AuthResult(success: false, error: 'verifyEmail not directly applicable or implemented. Email verification is typically link-based.');
  }

  @override
  Future<AuthResult> sendEmailVerification() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null || user.email == null) {
      return const AuthResult(success: false, error: 'User not found or no email associated.');
    }
    try {
      // Note: Supabase's resend is for all message types like signup, recovery, etc.
      // Check if user's email is already verified before sending.
      // The `email_confirmed_at` field on the user object might not be immediately up-to-date on client.
      // A specific "send verification email" might be useful if user's email is not confirmed.
      // Supabase handles this automatically on signup if email confirmation is enabled.
      // This method is more for scenarios where a user wants to resend it.
      await _supabaseClient.auth.resend(email: user.email!, type: sb.OtpType.signup);
      return const AuthResult(success: true, error: 'Verification email sent. Please check your inbox.'); // Error field used for info message
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
    // This is for linking an anonymous account to an email/password account.
    // Supabase handles this by signing up the new identity and then linking.
    // The current user must be anonymous.
    if (!_supabaseClient.auth.currentUser!.isAnonymous) {
        return const AuthResult(success: false, error: "Only anonymous users can link accounts this way.");
    }
    // This specific flow is not directly exposed by supabase-flutter's updateUser or linkIdentity.
    // Typically, you would sign out the anonymous user and sign up/in with the new credentials.
    // Or, use a custom server function.
    // A simpler client-side approach might be to sign up with the new credentials,
    // then migrate data from the anonymous user ID to the new user ID on the backend.
    // Supabase's `linkIdentity` is for OAuth.
    return const AuthResult(success: false, error: 'linkWithEmail for anonymous users needs a custom flow or server-side logic with Supabase.');
  }

  // --- User Profile specific methods beyond basic auth ---
  // These might involve more complex queries or RPCs to your Supabase backend.

  @override
  Future<domain_user.User?> getUserById(String userId) async {
    // This should fetch from 'profiles' table or equivalent
    final profileData = await _fetchUserProfile(userId);
    if (profileData != null) {
      // We don't have the full Supabase sb.User object here, only profile.
      // We need to construct a domain_user.User.
      // We're missing auth-specific details like isAnonymous if we *only* fetch profile.
      // This implies that our domain_user.User might need to be more flexible or
      // we always fetch the sb.User if possible (e.g., if userId is current user).
      // For now, create user from profile, email might be missing if not in profile.
      return domain_user.User(
        id: userId,
        email: profileData['email'] as String? ?? '',
        displayName: profileData['username'] as String? ?? 'User $userId',
        avatar: profileData['avatar_url'] as String?,
        bio: profileData['bio'] as String?,
        // ... map other fields from profileData ...
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
          .ilike('username', '%$query%') // Case-insensitive search on username
          .limit(10); // Example limit

      return response
          .map((data) => domain_user.User(
                id: data['id'] as String,
                email: data['email'] as String? ?? '',
                displayName: data['username'] as String? ?? '',
                avatar: data['avatar_url'] as String?,
                bio: data['bio'] as String?,
                // ... map other fields ...
              ))
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // Social graph features (follow/unfollow, etc.) would typically involve another table
  // e.g., 'user_follows' (follower_id, following_id)
  // These are placeholders and require backend table structure and RPCs or direct table access.

  @override
  Future<AuthResult> followUser(String userIdToFollow) async {
    final currentUserId = _supabaseClient.auth.currentUser?.id;
    if (currentUserId == null) return const AuthResult(success: false, error: "Not authenticated");
    if (currentUserId == userIdToFollow) return const AuthResult(success: false, error: "Cannot follow yourself");

    try {
      // Assuming a 'user_follows' table: { follower_id: UUID, following_id: UUID }
      await _supabaseClient.from('user_follows').insert({
        'follower_id': currentUserId,
        'following_id': userIdToFollow,
      });
      return const AuthResult(success: true);
    } catch (e) {
      // Handle potential errors, e.g., already following (unique constraint violation)
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
          .select('profiles!user_follows_follower_id_fkey(*)') // Assuming 'profiles' table and FK name
          .eq('following_id', userId);

      return response
          .map((data) {
            final profile = data['profiles'];
            return domain_user.User(
              id: profile['id'] as String,
              email: profile['email'] as String? ?? '',
              displayName: profile['username'] as String? ?? '',
              avatar: profile['avatar_url'] as String?,
              // ... other fields
            );
          }).toList();
    } catch (e) {
      print("Error getting user followers: $e");
      return [];
    }
  }

  @override
  Future<List<domain_user.User>> getUserFollowing(String userId) async {
     try {
      final response = await _supabaseClient
          .from('user_follows')
          .select('profiles!user_follows_following_id_fkey(*)') // Assuming 'profiles' table and FK name
          .eq('follower_id', userId);

       return response
          .map((data) {
            final profile = data['profiles'];
            return domain_user.User(
              id: profile['id'] as String,
              email: profile['email'] as String? ?? '',
              displayName: profile['username'] as String? ?? '',
              avatar: profile['avatar_url'] as String?,
              // ... other fields
            );
          }).toList();
    } catch (e) {
      print("Error getting user following: $e");
      return [];
    }
  }

  // Reputation and Badges - these would update fields in the 'profiles' table or related tables.
  @override
  Future<AuthResult> updateUserReputation(String userId, int reputationChange) async {
    // This typically should be an RPC call to prevent direct client manipulation of reputation.
    // await _supabaseClient.rpc('update_user_reputation', params: {'user_id_target': userId, 'change': reputationChange});
    return const AuthResult(success: false, error: "updateUserReputation should be server-side via RPC.");
  }

  @override
  Future<AuthResult> addUserBadge(String userId, String badge) async {
    // Also likely an RPC or server-side logic.
    // Example: fetch profile, append to badges array, update profile.
    return const AuthResult(success: false, error: "addUserBadge should be server-side or via RPC.");
  }

  @override
  Future<AuthResult> removeUserBadge(String userId, String badge) async {
    return const AuthResult(success: false, error: "removeUserBadge should be server-side or via RPC.");
  }

  // --- User Activity, Preferences, Statistics ---
  // These are highly dependent on your specific schema in 'profiles' or other tables.

  @override
  Future<List<domain_user.UserActivity>> getUserActivity(String userId) async {
    // Example: Fetch from an 'user_activities' table
    // final response = await _supabaseClient.from('user_activities').select().eq('user_id', userId).order('timestamp', ascending: false);
    // return response.map((data) => domain_user.UserActivity(...)).toList();
    print("getUserActivity: Not implemented. Requires 'user_activities' table and schema.");
    return [];
  }

  @override
  Future<AuthResult> updateUserPreferences(domain_user.UserPreferences preferences) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return const AuthResult(success: false, error: "Not authenticated");

    try {
      // Assuming 'preferences' is a JSONB column in 'profiles' table
      await _supabaseClient.from('profiles').update({
        'preferences': {
          'theme': preferences.theme,
          'notifications_enabled': preferences.notificationsEnabled,
          // Add other preference fields here
        }
      }).eq('id', userId);
      // Refetch user to include updated preferences
      final profileData = await _fetchUserProfile(userId);
      return AuthResult(success: true, user: _mapSupabaseUser(_supabaseClient.auth.currentUser, profileData));
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  @override
  Future<domain_user.UserStatistics> getUserStatistics(String userId) async {
    // Example: Fetch from 'profiles' table or a dedicated 'user_statistics' table
    final profileData = await _fetchUserProfile(userId);
    if (profileData != null && profileData['statistics'] != null) {
      final stats = profileData['statistics'];
      return domain_user.UserStatistics(
        jamSeedsCreated: stats['jam_seeds_created'] as int? ?? 0,
        jamKitsGenerated: stats['jam_kits_generated'] as int? ?? 0,
        contributionsMade: stats['contributions_made'] as int? ?? 0,
      );
    }
    // Return default/empty stats if not found
    return const domain_user.UserStatistics(jamSeedsCreated: 0, jamKitsGenerated: 0, contributionsMade: 0);
  }
}
