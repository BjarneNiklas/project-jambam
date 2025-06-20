import 'package:flutter_test/flutter_test.dart';
import 'package:project_jambam/src/features/b_authentication/data/mock_auth_repository.dart';
import 'package:project_jambam/src/features/b_authentication/domain/auth_repository.dart';
import 'package:project_jambam/src/core/logger.dart';

void main() {
  group('Auth Performance Tests', () {
    late AuthRepository authRepository;
    late Logger logger;

    setUp(() {
      authRepository = MockAuthRepository();
      logger = Logger('AuthPerformanceTest');
    });

    test('Login performance test', () async {
      final stopwatch = Stopwatch()..start();
      
      try {
        await authRepository.signInWithEmailAndPassword('test@example.com', 'password123');
        stopwatch.stop();
        
        logger.info('Login completed in ${stopwatch.elapsedMilliseconds}ms');
        
        // Performance assertion: login should complete within 5 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      } catch (e) {
        stopwatch.stop();
        logger.error('Login failed after ${stopwatch.elapsedMilliseconds}ms: $e');
        rethrow;
      }
    });

    test('Registration performance test', () async {
      final stopwatch = Stopwatch()..start();
      
      try {
        await authRepository.signUpWithEmailAndPassword('newuser@example.com', 'password123', 'NewUser');
        stopwatch.stop();
        
        logger.info('Registration completed in ${stopwatch.elapsedMilliseconds}ms');
        
        // Performance assertion: registration should complete within 10 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(10000));
      } catch (e) {
        stopwatch.stop();
        logger.error('Registration failed after ${stopwatch.elapsedMilliseconds}ms: $e');
        rethrow;
      }
    });

    test('Password reset performance test', () async {
      final stopwatch = Stopwatch()..start();
      
      try {
        await authRepository.resetPassword('test@example.com');
        stopwatch.stop();
        
        logger.info('Password reset completed in ${stopwatch.elapsedMilliseconds}ms');
        
        // Performance assertion: password reset should complete within 3 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(3000));
      } catch (e) {
        stopwatch.stop();
        logger.error('Password reset failed after ${stopwatch.elapsedMilliseconds}ms: $e');
        rethrow;
      }
    });
  });
} 