import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/b_authentication/presentation/login_screen_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginScreenControllerProvider.notifier);
    final state = ref.watch(loginScreenControllerProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and Title
                    _buildHeader(context),
                    const SizedBox(height: 48),

                    // Login/Signup Form
                    _buildForm(context, controller, state),
                    const SizedBox(height: 24),

                    // Action Buttons
                    _buildActionButtons(context, controller, state),
                    const SizedBox(height: 24),

                    // Anonymous Sign In
                    _buildAnonymousSignIn(context, controller, state),
                    const SizedBox(height: 32),

                    // Mode Toggle
                    _buildModeToggle(context, controller, state),
                    const SizedBox(height: 24),

                    // Error Messages
                    if (state.error != null) _buildErrorWidget(state.error!),
                    if (state.showResetPasswordSuccess) _buildSuccessWidget(),

                    // Loading Indicator
                    if (state.isLoading) _buildLoadingIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.games,
            size: 40,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 16),
        
        // Title
        Text(
          'JambaM',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          'Next-Generation Game Development Platform',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, LoginScreenController controller, LoginScreenState state) {
    return Card(
      elevation: 8,
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display Name Field (Sign Up only)
            if (state.isSignUp) ...[
              _buildTextField(
                context: context,
                label: 'Display Name',
                hint: 'Enter your display name',
                icon: Icons.person,
                value: state.displayName,
                onChanged: controller.updateDisplayName,
                error: controller.getDisplayNameError(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
            ],

            // Email Field
            _buildTextField(
              context: context,
              label: 'Email',
              hint: 'Enter your email address',
              icon: Icons.email,
              value: state.email,
              onChanged: controller.updateEmail,
              error: controller.getEmailError(),
              keyboardType: TextInputType.emailAddress,
              textInputAction: state.isSignUp ? TextInputAction.next : TextInputAction.done,
            ),
            const SizedBox(height: 16),

            // Password Field
            _buildTextField(
              context: context,
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock,
              value: state.password,
              onChanged: controller.updatePassword,
              error: controller.getPasswordError(),
              isPassword: true,
              isPasswordVisible: state.isPasswordVisible,
              onTogglePasswordVisibility: controller.togglePasswordVisibility,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
    required String value,
    required ValueChanged<String> onChanged,
    String? error,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePasswordVisibility,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    onPressed: onTogglePasswordVisibility,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, LoginScreenController controller, LoginScreenState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary Action Button
        ElevatedButton(
          onPressed: state.isFormValid && !state.isLoading
              ? (state.isSignUp ? controller.signUp : controller.signIn)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
          child: Text(
            state.isSignUp ? 'Create Account' : 'Sign In',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),

        // Forgot Password Button (Login only)
        if (!state.isSignUp)
          TextButton(
            onPressed: state.email.isNotEmpty && !state.isLoading
                ? controller.resetPassword
                : null,
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnonymousSignIn(BuildContext context, LoginScreenController controller, LoginScreenState state) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: !state.isLoading ? controller.signInAnonymously : null,
          icon: const Icon(Icons.person_outline),
          label: const Text('Continue as Guest'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explore the platform without creating an account',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModeToggle(BuildContext context, LoginScreenController controller, LoginScreenState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.isSignUp ? 'Already have an account?' : 'Don\'t have an account?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: controller.toggleMode,
          child: Text(
            state.isSignUp ? 'Sign In' : 'Sign Up',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Password reset email sent! Check your inbox.',
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
} 