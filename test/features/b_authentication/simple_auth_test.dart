import 'package:flutter_test/flutter_test.dart';
import 'package:project_jambam/src/features/b_authentication/data/mock_auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/user.dart';
import 'package:logging/logging.dart';

final _logger = Logger('SimpleAuthTest');

void main() {
  group('Simple Authentication Tests', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    group('Basic Authentication', () {
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
      });

      test('should sign in anonymously', () async {
        final result = await repository.signInAnonymously();

        expect(result.success, isTrue);
        expect(result.user, isNotNull);
        expect(result.user!.isAnonymous, isTrue);
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
        );

        expect(result.success, isTrue);
        expect(result.user!.displayName, equals('Updated Name'));
        expect(result.user!.bio, equals('Updated bio'));
      });

      test('should delete account successfully', () async {
        final result = await repository.deleteAccount();

        expect(result.success, isTrue);
        expect(repository.getCurrentUser(), isNull);
      });
    });

    group('User Management', () {
      test('should get user by ID', () async {
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

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

      test('should follow and unfollow user', () async {
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

        final currentUser = repository.getCurrentUser();
        final otherUser = await repository.getUserById('admin_1');

        // Follow
        final followResult = await repository.followUser(otherUser!.id);
        expect(followResult.success, isTrue);

        // Check following
        final following = await repository.getUserFollowing(currentUser!.id);
        expect(following.any((user) => user.id == otherUser.id), isTrue);

        // Unfollow
        final unfollowResult = await repository.unfollowUser(otherUser.id);
        expect(unfollowResult.success, isTrue);

        // Check not following
        final followingAfter = await repository.getUserFollowing(currentUser.id);
        expect(followingAfter.any((user) => user.id == otherUser.id), isFalse);
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

    group('User Properties', () {
      test('should calculate user level correctly', () async {
        await repository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

        final user = repository.getCurrentUser();
        expect(user!.level, equals(UserLevel.intermediate));
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

    group('Performance Tests', () {
      test('should handle multiple login attempts efficiently', () async {
        final stopwatch = Stopwatch()..start();
        
        final futures = List.generate(10, (index) {
          return repository.signInWithEmailAndPassword(
            'test@jambam.com',
            'password123',
          );
        });

        final results = await Future.wait(futures);
        stopwatch.stop();

        // All should succeed
        expect(results.every((result) => result.success), isTrue);
        
        // Should complete within reasonable time (500ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
        
        _logger.info('Multiple login attempts completed in ${stopwatch.elapsedMilliseconds}ms');
      });

      test('should handle rapid state changes efficiently', () async {
        final stopwatch = Stopwatch()..start();
        
        // Simulate rapid sign in/out cycles
        for (int i = 0; i < 50; i++) {
          await repository.signInWithEmailAndPassword(
            'test@jambam.com',
            'password123',
          );
          await repository.signOut();
        }
        
        stopwatch.stop();
        
        // Should complete within reasonable time (1 second)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        
        _logger.info('Rapid state changes completed in ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('Error Handling', () {
      test('should handle network errors gracefully', () async {
        // Simulate network error by using invalid repository
        final invalidRepository = MockAuthRepository();
        invalidRepository.dispose(); // This will cause errors

        final result = await invalidRepository.signInWithEmailAndPassword(
          'test@jambam.com',
          'password123',
        );

        expect(result.success, isFalse);
        expect(result.error, isNotNull);
      });

      test('should handle invalid user operations', () async {
        // Try to get user without being signed in
        final user = repository.getCurrentUser();
        expect(user, isNull);

        // Try to update profile without being signed in
        final result = await repository.updateProfile(
          displayName: 'Test',
        );

        expect(result.success, isFalse);
      });
    });

    group('Data Validation', () {
      test('should validate email format', () async {
        // Test invalid email formats
        final invalidEmails = [
          'invalid-email',
          'test@',
          '@jambam.com',
          'test.jambam.com',
          '',
        ];

        for (final email in invalidEmails) {
          final result = await repository.signInWithEmailAndPassword(
            email,
            'password123',
          );

          expect(result.success, isFalse);
          expect(result.errorCode, equals('INVALID_CREDENTIALS'));
        }
      });

      test('should validate password length', () async {
        // Test short passwords
        final shortPasswords = ['', '123', 'pass'];

        for (final password in shortPasswords) {
          final result = await repository.signUpWithEmailAndPassword(
            'test@jambam.com',
            password,
            'Test User',
          );

          expect(result.success, isFalse);
        }
      });

      test('should validate display name length', () async {
        // Test short display names
        final shortNames = ['', 'A'];

        for (final name in shortNames) {
          final result = await repository.signUpWithEmailAndPassword(
            'test@jambam.com',
            'password123',
            name,
          );

          expect(result.success, isFalse);
        }
      });
    });
  });
} 