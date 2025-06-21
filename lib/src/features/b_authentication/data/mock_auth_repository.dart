import 'dart:async';

import 'package:project_jambam/src/features/b_authentication/domain/auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/user.dart';
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart';

/// Mock implementation of AuthRepository for testing and development
class MockAuthRepository implements AuthRepository {
  MockAuthRepository() {
    _initializeMockData();
  }

  User? _currentUser;
  StreamController<User?>? _authStateController;
  final Map<String, User> _users = {};
  final Map<String, List<UserActivity>> _userActivities = {};
  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};

  @override
  Stream<User?> get authStateChanges {
    _authStateController ??= StreamController<User?>.broadcast();
    // If no user is logged in, sign in anonymously.
    if (_currentUser == null) {
      signInAnonymously();
    }
    return _authStateController!.stream;
  }

  @override
  User? getCurrentUser() => _currentUser;

  @override
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Reduced delay for tests
    
    // Mock authentication logic
    if (email == 'test@jambam.com' && password == 'password123') {
      final user = _users.values.firstWhere(
        (user) => user.email == email,
        orElse: () => _createMockUser(email, 'Test User'),
      );
      _currentUser = user;
      _authStateController?.add(user);
      return AuthResult(success: true, user: user);
    } else if (email == 'admin@jambam.com' && password == 'admin123') {
      final user = _createMockAdminUser();
      _currentUser = user;
      _authStateController?.add(user);
      return AuthResult(success: true, user: user);
    } else {
      return AuthResult(
        success: false,
        error: 'Invalid email or password',
        errorCode: 'INVALID_CREDENTIALS',
      );
    }
  }

  @override
  Future<AuthResult> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Reduced delay for tests
    
    // Validate input
    if (email.isEmpty || !email.contains('@')) {
      return AuthResult(
        success: false,
        error: 'Invalid email format',
        errorCode: 'INVALID_EMAIL',
      );
    }
    
    if (password.length < 6) {
      return AuthResult(
        success: false,
        error: 'Password too short',
        errorCode: 'WEAK_PASSWORD',
      );
    }
    
    if (displayName.length < 2) {
      return AuthResult(
        success: false,
        error: 'Display name too short',
        errorCode: 'INVALID_DISPLAY_NAME',
      );
    }
    
    // Check if user already exists
    if (_users.values.any((user) => user.email == email)) {
      return AuthResult(
        success: false,
        error: 'User with this email already exists',
        errorCode: 'EMAIL_ALREADY_IN_USE',
      );
    }

    // Create new user
    final newUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );

    _users[newUser.id] = newUser;
    _userActivities[newUser.id] = [];
    _followers[newUser.id] = [];
    _following[newUser.id] = [];

    _currentUser = newUser;
    _authStateController?.add(newUser);

    return AuthResult(success: true, user: newUser);
  }

  @override
  Future<AuthResult> signInAnonymously() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    final anonymousUser = User(
      id: 'anon_${DateTime.now().millisecondsSinceEpoch}',
      email: 'anonymous@jambam.com',
      displayName: 'Anonymous User',
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );

    _currentUser = anonymousUser;
    _authStateController?.add(anonymousUser);

    return AuthResult(success: true, user: anonymousUser);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    _currentUser = null;
    _authStateController?.add(null);
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
    await Future.delayed(const Duration(milliseconds: 100)); // Reduced delay for tests
    
    if (_currentUser == null) {
      return AuthResult(
        success: false,
        error: 'No user signed in',
        errorCode: 'NO_USER_SIGNED_IN',
      );
    }

    final updatedUser = _currentUser!.copyWith(
      displayName: displayName,
      avatar: avatar,
      bio: bio,
      interests: interests,
      skillLevel: skillLevel,
      learningStyle: learningStyle,
      accessibilityNeeds: accessibilityNeeds,
      lastActive: DateTime.now(),
    );

    _users[_currentUser!.id] = updatedUser;
    _currentUser = updatedUser;
    _authStateController?.add(updatedUser);

    return AuthResult(success: true, user: updatedUser);
  }

  @override
  Future<AuthResult> deleteAccount() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Reduced delay for tests
    
    if (_currentUser == null) {
      return AuthResult(
        success: false,
        error: 'No user signed in',
        errorCode: 'NO_USER_SIGNED_IN',
      );
    }

    _users.remove(_currentUser!.id);
    _userActivities.remove(_currentUser!.id);
    _followers.remove(_currentUser!.id);
    _following.remove(_currentUser!.id);

    _currentUser = null;
    _authStateController?.add(null);

    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Reduced delay for tests
    
    if (_users.values.any((user) => user.email == email)) {
      return AuthResult(success: true);
    } else {
      return AuthResult(
        success: false,
        error: 'No user found with this email',
        errorCode: 'USER_NOT_FOUND',
      );
    }
  }

  @override
  Future<AuthResult> verifyEmail() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    if (_currentUser == null) {
      return AuthResult(
        success: false,
        error: 'No user signed in',
        errorCode: 'NO_USER_SIGNED_IN',
      );
    }

    final updatedUser = _currentUser!.copyWith(isEmailVerified: true);
    _users[_currentUser!.id] = updatedUser;
    _currentUser = updatedUser;
    _authStateController?.add(updatedUser);

    return AuthResult(success: true, user: updatedUser);
  }

  @override
  Future<AuthResult> sendEmailVerification() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> updatePassword(String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Reduced delay for tests
    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> linkWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Reduced delay for tests
    
    if (_currentUser == null || !_currentUser!.isAnonymous) {
      return AuthResult(
        success: false,
        error: 'No anonymous user signed in',
        errorCode: 'NO_ANONYMOUS_USER',
      );
    }

    final linkedUser = _currentUser!.copyWith(
      email: email,
      isEmailVerified: true,
    );

    _users[linkedUser.id] = linkedUser;
    _currentUser = linkedUser;
    _authStateController?.add(linkedUser);

    return AuthResult(success: true, user: linkedUser);
  }

  @override
  Future<User?> getUserById(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    return _users[userId];
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    return _users.values
        .where((user) => 
            user.displayName.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<AuthResult> followUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    if (_currentUser == null) {
      return AuthResult(
        success: false,
        error: 'No user signed in',
        errorCode: 'NO_USER_SIGNED_IN',
      );
    }

    if (_currentUser!.id == userId) {
      return AuthResult(
        success: false,
        error: 'Cannot follow yourself',
        errorCode: 'CANNOT_FOLLOW_SELF',
      );
    }

    final currentUserId = _currentUser!.id;
    
    // Initialize lists if they don't exist
    _following[currentUserId] ??= [];
    _followers[userId] ??= [];
    
    if (!_following[currentUserId]!.contains(userId)) {
      _following[currentUserId]!.add(userId);
      _followers[userId]!.add(currentUserId);
    }

    return AuthResult(success: true);
  }

  @override
  Future<AuthResult> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    if (_currentUser == null) {
      return AuthResult(
        success: false,
        error: 'No user signed in',
        errorCode: 'NO_USER_SIGNED_IN',
      );
    }

    final currentUserId = _currentUser!.id;
    
    _following[currentUserId]?.remove(userId);
    _followers[userId]?.remove(currentUserId);

    return AuthResult(success: true);
  }

  @override
  Future<List<User>> getUserFollowers(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    final followerIds = _followers[userId] ?? [];
    return followerIds.map((id) => _users[id]).whereType<User>().toList();
  }

  @override
  Future<List<User>> getUserFollowing(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    final followingIds = _following[userId] ?? [];
    return followingIds.map((id) => _users[id]).whereType<User>().toList();
  }

  @override
  Future<AuthResult> updateUserReputation(String userId, int reputationChange) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    final user = _users[userId];
    if (user == null) {
      return AuthResult(
        success: false,
        error: 'User not found',
        errorCode: 'USER_NOT_FOUND',
      );
    }

    final updatedUser = user.copyWith(reputation: user.reputation + reputationChange);
    _users[userId] = updatedUser;

    if (_currentUser?.id == userId) {
      _currentUser = updatedUser;
      _authStateController?.add(updatedUser);
    }

    return AuthResult(success: true, user: updatedUser);
  }

  @override
  Future<AuthResult> addUserBadge(String userId, String badge) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    final user = _users[userId];
    if (user == null) {
      return AuthResult(
        success: false,
        error: 'User not found',
        errorCode: 'USER_NOT_FOUND',
      );
    }

    if (!user.badges.contains(badge)) {
      final updatedUser = user.copyWith(badges: [...user.badges, badge]);
      _users[userId] = updatedUser;

      if (_currentUser?.id == userId) {
        _currentUser = updatedUser;
        _authStateController?.add(updatedUser);
      }

      return AuthResult(success: true, user: updatedUser);
    }

    return AuthResult(success: true, user: user);
  }

  @override
  Future<AuthResult> removeUserBadge(String userId, String badge) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    final user = _users[userId];
    if (user == null) {
      return AuthResult(
        success: false,
        error: 'User not found',
        errorCode: 'USER_NOT_FOUND',
      );
    }

    final updatedUser = user.copyWith(badges: user.badges.where((b) => b != badge).toList());
    _users[userId] = updatedUser;

    if (_currentUser?.id == userId) {
      _currentUser = updatedUser;
      _authStateController?.add(updatedUser);
    }

    return AuthResult(success: true, user: updatedUser);
  }

  @override
  Future<List<UserActivity>> getUserActivity(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    return _userActivities[userId] ?? [];
  }

  @override
  Future<AuthResult> updateUserPreferences(UserPreferences preferences) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    if (_currentUser == null) {
      return AuthResult(
        success: false,
        error: 'No user signed in',
        errorCode: 'NO_USER_SIGNED_IN',
      );
    }

    final updatedUser = _currentUser!.copyWith(preferences: preferences);
    _users[_currentUser!.id] = updatedUser;
    _currentUser = updatedUser;
    _authStateController?.add(updatedUser);

    return AuthResult(success: true, user: updatedUser);
  }

  @override
  Future<UserStatistics> getUserStatistics(String userId) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced delay for tests
    
    final user = _users[userId];
    if (user == null) {
      return const UserStatistics();
    }

    final followers = _followers[userId]?.length ?? 0;
    final following = _following[userId]?.length ?? 0;

    return UserStatistics(
      followers: followers,
      following: following,
      reputation: user.reputation,
      badges: user.badges,
      researchPoints: user.researchPoints,
      lastActive: user.lastActive,
    );
  }

  /// Initialize mock data
  void _initializeMockData() {
    // Create mock users
    final mockUsers = [
      _createMockUser('test@jambam.com', 'Test User'),
      _createMockAdminUser(),
      _createMockUser('inspirator@jambam.com', 'Creative Inspirator'),
      _createMockUser('developer@jambam.com', 'Game Developer'),
      _createMockUser('researcher@jambam.com', 'Lab Researcher'),
    ];

    for (final user in mockUsers) {
      _users[user.id] = user;
      _userActivities[user.id] = _createMockActivities(user.id);
      _followers[user.id] = [];
      _following[user.id] = [];
    }

    // Set up some mock relationships
    _followers['user_1'] = ['user_2', 'user_3'];
    _following['user_1'] = ['user_2'];
    _followers['user_2'] = ['user_1', 'user_4'];
    _following['user_2'] = ['user_1', 'user_3'];
  }

  User _createMockUser(String email, String displayName) {
    return User(
      id: 'user_${_users.length + 1}',
      email: email,
      displayName: displayName,
      bio: 'Passionate game developer and community member',
      interests: ['Game Design', 'Unity', 'Flutter', 'AI'],
      skillLevel: SkillLevel.intermediate,
      learningStyle: LearningStyle.visual,
      accessibilityNeeds: [],
      reputation: 250,
      badges: ['contributor'],
      researchPoints: 50,
      isEmailVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActive: DateTime.now(),
    );
  }

  User _createMockAdminUser() {
    return User(
      id: 'admin_1',
      email: 'admin@jambam.com',
      displayName: 'JambaM Admin',
      bio: 'System administrator and community moderator',
      interests: ['Community Management', 'System Administration', 'Game Development'],
      skillLevel: SkillLevel.expert,
      learningStyle: LearningStyle.reading,
      accessibilityNeeds: [],
      reputation: 5000,
      badges: ['admin', 'moderator', 'inspirator'],
      researchPoints: 500,
      isEmailVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      lastActive: DateTime.now(),
    );
  }

  List<UserActivity> _createMockActivities(String userId) {
    return [
      UserActivity(
        id: 'activity_1',
        type: ActivityType.jamSeedCreated,
        description: 'Created "Cyberpunk Gardening" jam seed',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        data: {'jamSeedId': 'seed_1'},
      ),
      UserActivity(
        id: 'activity_2',
        type: ActivityType.communityContribution,
        description: 'Added mechanic suggestion to "Space Pirates"',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        data: {'contributionId': 'contrib_1'},
      ),
      UserActivity(
        id: 'activity_3',
        type: ActivityType.badgeEarned,
        description: 'Earned "Inspirator" badge',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        data: {'badge': 'inspirator'},
      ),
    ];
  }

  void dispose() {
    _authStateController?.close();
    _authStateController = null;
  }
} 