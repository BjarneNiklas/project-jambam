import 'package:flutter_test/flutter_test.dart';
import 'package:project_jambam/src/features/b_authentication/data/mock_auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/user.dart';
import 'package:project_jambam/src/features/a_ideation/domain/accessibility_system.dart';

void main() {
  group('MockAuthRepository', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    group('Authentication', () {
      test('should sign in with valid credentials', () async {
        final result = await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

        expect(result.success, isTrue);
        expect(result.user, isNotNull);
        expect(result.user!.email, equals('test@jambam.com'));
        expect(result.user!.displayName, equals('Test User'));
      });

      test('should sign in admin with valid credentials', () async {
        final result = await repository.signInWithEmailAndPassword(
          'admin@jambam.com',
          'admin123',
        );

        expect(result.success, isTrue);
        expect(result.user, isNotNull);
        expect(result.user!.email, equals('admin@jambam.com'));
        expect(result.user!.displayName, equals('JambaM Admin'));
        expect(result.user!.badges, contains('admin'));
      });

      test('should fail with invalid credentials', () async {
        final result = await repository.signInWithEmailAndPassword(
          'invalid@email.com',
          'wrongpassword',
        );

        expect(result.success, isFalse);
        expect(result.error, isNotNull);
        expect(result.errorCode, equals('INVALID_CREDENTIALS'));
      });

      test('should sign up new user successfully', () async {
        final result = await repository.signUpWithEmailAndPassword(
          'newuser@jambam.com',
          'password123',
          'New User',
        );

        expect(result.success, isTrue);
        expect(result.user, isNotNull);
        expect(result.user!.email, equals('newuser@jambam.com'));
        expect(result.user!.displayName, equals('New User'));
        expect(result.user!.isEmailVerified, isFalse);
      });

      test('should fail sign up with existing email', () async {
        final result = await repository.signUpWithEmailAndPassword(
          'test@jambam.com',
          'password123',
          'Test User',
        );

        expect(result.success, isFalse);
        expect(result.error, equals('User with this email already exists'));
        expect(result.errorCode, equals('EMAIL_ALREADY_IN_USE'));
      });

      test('should sign in anonymously', () async {
        final result = await repository.signInAnonymously();

        expect(result.success, isTrue);
        expect(result.user, isNotNull);
        expect(result.user!.isAnonymous, isTrue);
        expect(result.user!.email, equals('anonymous@jambam.com'));
      });

      test('should sign out successfully', () async {
        // First sign in
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

        // Then sign out
        await repository.signOut();

        final currentUser = repository.getCurrentUser();
        expect(currentUser, isNull);
      });
    });

    group('User Profile', () {
      setUp(() async {
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );
      });

      test('should update profile successfully', () async {
        final result = await repository.updateProfile(
          displayName: 'Updated Name',
          bio: 'Updated bio',
          interests: ['Game Design', 'Flutter'],
          skillLevel: SkillLevel.advanced,
          learningStyle: LearningStyle.kinesthetic,
        );

        expect(result.success, isTrue);
        expect(result.user!.displayName, equals('Updated Name'));
        expect(result.user!.bio, equals('Updated bio'));
        expect(result.user!.interests, contains('Game Design'));
        expect(result.user!.skillLevel, equals(SkillLevel.advanced));
        expect(result.user!.learningStyle, equals(LearningStyle.kinesthetic));
      });

      test('should delete account successfully', () async {
        final result = await repository.deleteAccount();

        expect(result.success, isTrue);
        expect(repository.getCurrentUser(), isNull);
      });

      test('should verify email successfully', () async {
        final result = await repository.verifyEmail();

        expect(result.success, isTrue);
        expect(result.user!.isEmailVerified, isTrue);
      });

      test('should send email verification', () async {
        final result = await repository.sendEmailVerification();

        expect(result.success, isTrue);
      });

      test('should update password', () async {
        final result = await repository.updatePassword('newpassword123');

        expect(result.success, isTrue);
      });

      test('should link anonymous account with email', () async {
        // First sign in anonymously
        await repository.signOut();
        await repository.signInAnonymously();

        final result = await repository.linkWithEmail(
          'linked@jambam.com',
          'password123',
        );

        expect(result.success, isTrue);
        expect(result.user!.email, equals('linked@jambam.com'));
        expect(result.user!.isEmailVerified, isTrue);
      });
    });

    group('User Management', () {
      setUp(() async {
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );
      });

      test('should get user by ID', () async {
        final currentUser = repository.getCurrentUser();
        final user = await repository.getUserById(currentUser!.id);

        expect(user, isNotNull);
        expect(user!.id, equals(currentUser.id));
      });

      test('should search users', () async {
        final results = await repository.searchUsers('Test');

        expect(results, isNotEmpty);
        expect(results.any((user) => user.displayName.contains('Test')), isTrue);
      });

      test('should follow user', () async {
        final currentUser = repository.getCurrentUser();
        final otherUser = await repository.getUserById('admin_1');

        final result = await repository.followUser(otherUser!.id);

        expect(result.success, isTrue);

        final following = await repository.getUserFollowing(currentUser!.id);
        expect(following.any((user) => user.id == otherUser.id), isTrue);
      });

      test('should unfollow user', () async {
        final currentUser = repository.getCurrentUser();
        final otherUser = await repository.getUserById('admin_1');

        // First follow
        await repository.followUser(otherUser!.id);

        // Then unfollow
        final result = await repository.unfollowUser(otherUser.id);

        expect(result.success, isTrue);

        final following = await repository.getUserFollowing(currentUser!.id);
        expect(following.any((user) => user.id == otherUser.id), isFalse);
      });

      test('should get user followers', () async {
        final followers = await repository.getUserFollowers('user_1');

        expect(followers, isNotEmpty);
      });

      test('should get user following', () async {
        final following = await repository.getUserFollowing('user_1');

        expect(following, isNotEmpty);
      });

      test('should update user reputation', () async {
        final currentUser = repository.getCurrentUser();
        final initialReputation = currentUser!.reputation;

        final result = await repository.updateUserReputation(
          currentUser.id,
          100,
        );

        expect(result.success, isTrue);
        expect(result.user!.reputation, equals(initialReputation + 100));
      });

      test('should add user badge', () async {
        final currentUser = repository.getCurrentUser();
        final initialBadges = currentUser!.badges.length;

        final result = await repository.addUserBadge(
          currentUser.id,
          'inspirator',
        );

        expect(result.success, isTrue);
        expect(result.user!.badges.length, equals(initialBadges + 1));
        expect(result.user!.badges, contains('inspirator'));
      });

      test('should remove user badge', () async {
        final currentUser = repository.getCurrentUser();
        
        // First add a badge
        await repository.addUserBadge(currentUser!.id, 'test_badge');

        // Then remove it
        final result = await repository.removeUserBadge(
          currentUser.id,
          'test_badge',
        );

        expect(result.success, isTrue);
        expect(result.user!.badges, isNot(contains('test_badge')));
      });

      test('should get user activity', () async {
        final activities = await repository.getUserActivity('user_1');

        expect(activities, isNotEmpty);
        expect(activities.first.type, isA<ActivityType>());
      });

      test('should update user preferences', () async {
        final newPreferences = UserPreferences(
          notifications: NotificationPreferences(
            emailNotifications: false,
            pushNotifications: true,
          ),
          privacy: PrivacyPreferences(
            profileVisibility: ProfileVisibility.followers,
          ),
          theme: ThemePreference.dark,
        );

        final result = await repository.updateUserPreferences(newPreferences);

        expect(result.success, isTrue);
        expect(result.user!.preferences.theme, equals(ThemePreference.dark));
      });

      test('should get user statistics', () async {
        final stats = await repository.getUserStatistics('user_1');

        expect(stats, isNotNull);
        expect(stats.reputation, isA<int>());
        expect(stats.badges, isA<List<String>>());
      });
    });

    group('Password Reset', () {
      test('should reset password for existing user', () async {
        final result = await repository.resetPassword('test@jambam.com');

        expect(result.success, isTrue);
      });

      test('should fail reset password for non-existing user', () async {
        final result = await repository.resetPassword('nonexistent@email.com');

        expect(result.success, isFalse);
        expect(result.error, equals('No user found with this email'));
      });
    });

    group('Auth State Changes', () {
      test('should emit auth state changes', () async {
        final authStates = <User?>[];
        
        repository.authStateChanges.listen(authStates.add);

        // Sign in
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

        // Sign out
        await repository.signOut();

        expect(authStates.length, equals(2));
        expect(authStates.first, isNotNull);
        expect(authStates.last, isNull);
      });
    });

    group('User Properties', () {
      test('should calculate user level correctly', () async {
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

        final user = repository.getCurrentUser();
        expect(user!.level, equals(UserLevel.intermediate));
      });

      test('should calculate user role correctly', () async {
        await repository.signInWithEmailAndPassword(
          'admin@jambam.com',
          'admin123',
        );

        final user = repository.getCurrentUser();
        expect(user!.role, equals(UserRole.admin));
      });

      test('should check anonymous status', () async {
        await repository.signInAnonymously();

        final user = repository.getCurrentUser();
        expect(user!.isAnonymous, isTrue);
      });

      test('should check verification status', () async {
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

        final user = repository.getCurrentUser();
        expect(user!.isVerified, isTrue);
      });
    });
  });
} 