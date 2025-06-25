import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/a_ideation/presentation/settings/edit_profile_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _soundEffects = true;
  bool _autoSave = true;
  String _selectedLanguage = 'English';
  String _selectedTerminology = 'Gaming';

  final List<String> _languages = [
    'English',
    'Deutsch',
    'Français',
    'Español',
    'Italiano',
  ];

  final List<String> _terminologies = [
    'Gaming',
    'Business',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildProfileSection(),
          _buildAppearanceSection(),
          _buildTerminologySection(),
          _buildLanguageSection(),
          _buildNotificationSection(),
          _buildPrivacySection(),
          _buildAccountSection(),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.purple,
                  child: const Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'John Developer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'john.developer@rockstar.com',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme'),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
              secondary: const Icon(Icons.dark_mode),
            ),
            SwitchListTile(
              title: const Text('Sound Effects'),
              subtitle: const Text('Play sound effects'),
              value: _soundEffects,
              onChanged: (value) {
                setState(() {
                  _soundEffects = value;
                });
              },
              secondary: const Icon(Icons.volume_up),
            ),
            SwitchListTile(
              title: const Text('Auto Save'),
              subtitle: const Text('Automatically save changes'),
              value: _autoSave,
              onChanged: (value) {
                setState(() {
                  _autoSave = value;
                });
              },
              secondary: const Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminologySection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terminology',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose the terminology style for your organization',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTerminology,
              decoration: const InputDecoration(
                labelText: 'Terminology Style',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              items: _terminologies.map((terminology) {
                return DropdownMenuItem(
                  value: terminology,
                  child: Text(terminology),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTerminology = value;
                  });
                  _updateTerminologyConfiguration(value);
                  debugPrint('Terminology configuration updated to: $value');
                }
              },
            ),
            const SizedBox(height: 16),
            _buildTerminologyPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminologyPreview() {
    final isGaming = _selectedTerminology == 'Gaming';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          _buildPreviewItem('Battles', isGaming ? 'Battles' : 'Competitions'),
          _buildPreviewItem('Legions', isGaming ? 'Legions' : 'Organizations'),
          _buildPreviewItem('Squads', isGaming ? 'Squads' : 'Teams'),
          _buildPreviewItem('Champions', isGaming ? 'Champions' : 'Members'),
          _buildPreviewItem('Power', isGaming ? 'Power' : 'Performance'),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String gaming, String business) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$gaming → ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            business,
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'App Language',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              items: _languages.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  _updateLanguage(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              secondary: const Icon(Icons.notifications),
            ),
            SwitchListTile(
              title: const Text('Battle Reminders'),
              subtitle: const Text('Remind about upcoming battles'),
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              secondary: const Icon(Icons.sports_esports),
            ),
            SwitchListTile(
              title: const Text('Project Updates'),
              subtitle: const Text('Updates about your projects'),
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              secondary: const Icon(Icons.work),
            ),
            SwitchListTile(
              title: const Text('Achievement Alerts'),
              subtitle: const Text('When you earn achievements'),
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              secondary: const Icon(Icons.emoji_events),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy & Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Profile Visibility'),
              subtitle: const Text('Control who can see your profile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showProfileVisibilityDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Manage your privacy preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showPrivacySettingsDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text('Add extra security to your account'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _show2FASettingsDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.data_usage),
              title: const Text('Data Usage'),
              subtitle: const Text('Control how your data is used'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showDataUsageSettingsDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              subtitle: const Text('Update your profile information'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _editProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Change Email'),
              subtitle: const Text('Update your email address'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _changeEmail();
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
              subtitle: const Text('Update your password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _changePassword();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export Data'),
              subtitle: const Text('Download your data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _exportData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              subtitle: const Text('Permanently delete your account'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red),
              onTap: () {
                _deleteAccount();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showTermsOfService();
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showPrivacyPolicy();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showHelpAndSupport();
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _sendFeedback();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateTerminologyConfiguration(String terminology) {
    // Update terminology configuration in the app
    // This would typically call a service or provider to update the app's terminology
    // For now, we'll simulate the update
    debugPrint('Updating terminology configuration to: $terminology');
    
    // Example: Update app-wide terminology settings
    // context.read<TerminologyProvider>().updateTerminology(terminology);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terminology updated to $terminology'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateLanguage(String language) {
    // Update app language
    debugPrint('Updating language to: $language');
    
    // Example: Update app locale
    // context.read<LocaleProvider>().updateLocale(language);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language updated to $language'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateProfileVisibility(String visibility) {
    // Update profile visibility settings
    debugPrint('Updating profile visibility to: $visibility');
    
    // Example: Update user profile settings
    // context.read<UserProfileProvider>().updateVisibility(visibility);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile visibility updated to $visibility'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updatePrivacySettings(Map<String, bool> settings) {
    // Update privacy settings
    debugPrint('Updating privacy settings: $settings');
    
    // Example: Update user privacy preferences
    // context.read<PrivacyProvider>().updateSettings(settings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings updated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _update2FASettings(bool enabled) {
    // Update 2FA settings
    debugPrint('Updating 2FA settings: $enabled');
    
    if (enabled) {
      _show2FASetupDialog();
    } else {
      _show2FADisableDialog();
    }
  }

  void _show2FASetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Two-Factor Authentication'),
        content: const Text('This will add an extra layer of security to your account. You\'ll need to scan a QR code with your authenticator app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement 2FA setup logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('2FA setup initiated')),
              );
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _show2FADisableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Two-Factor Authentication'),
        content: const Text('Are you sure you want to disable 2FA? This will make your account less secure.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement 2FA disable logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('2FA disabled')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }

  void _updateDataUsageSettings(Map<String, bool> settings) {
    // Update data usage settings
    debugPrint('Updating data usage settings: $settings');
    
    // Example: Update data usage preferences
    // context.read<DataUsageProvider>().updateSettings(settings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data usage settings updated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _editProfile() {
    // Navigate to edit profile screen
    debugPrint('Navigating to edit profile screen');
    
    // Example: Navigate to profile edit screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile feature coming soon')),
    );
  }

  void _changeEmail() {
    // Show change email dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Current Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'New Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email change request sent')),
              );
            },
            child: const Text('Change Email'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    // Show change password dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully')),
              );
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    // Export user data
    debugPrint('Exporting user data');
    
    // Example: Export user data
    // context.read<DataExportProvider>().exportUserData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export initiated')),
    );
  }

  void _showTermsOfService() {
    // Show terms of service
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using JambaM, you agree to our terms of service...\n\n'
            '1. You will use the platform responsibly\n'
            '2. You will not violate any laws\n'
            '3. You will respect other users\n'
            '4. You will not spam or abuse the system\n\n'
            'Full terms available at: jambam.com/terms',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    // Show privacy policy
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy is important to us...\n\n'
            'We collect:\n'
            '- Account information\n'
            '- Usage data\n'
            '- Project data\n\n'
            'We use this data to:\n'
            '- Provide our services\n'
            '- Improve the platform\n'
            '- Ensure security\n\n'
            'Full policy available at: jambam.com/privacy',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpAndSupport() {
    // Show help and support
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help? Here are your options:'),
            SizedBox(height: 16),
            Text('📧 Email: support@jambam.com'),
            Text('💬 Chat: Available 24/7'),
            Text('📖 Documentation: docs.jambam.com'),
            Text('🎥 Tutorials: youtube.com/jambam'),
            SizedBox(height: 16),
            Text('Response time: Usually within 2 hours'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _sendFeedback() {
    // Show feedback dialog
    final feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('We\'d love to hear your thoughts!'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                labelText: 'Your Feedback',
                border: OutlineInputBorder(),
                hintText: 'Tell us what you think...',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (feedbackController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback!')),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    // Show delete account confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDeleteAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    // Show final confirmation for account deletion
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This is your final warning.'),
            SizedBox(height: 8),
            Text('Type "DELETE" to confirm:'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'DELETE',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion initiated')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showProfileVisibilityDialog() {
    String selectedVisibility = 'Public';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Visibility'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose who can see your profile:'),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('Public'),
              subtitle: const Text('Anyone can see your profile'),
              value: 'Public',
              groupValue: selectedVisibility,
              onChanged: (value) {
                selectedVisibility = value!;
              },
            ),
            RadioListTile<String>(
              title: const Text('Friends Only'),
              subtitle: const Text('Only your friends can see your profile'),
              value: 'Friends Only',
              groupValue: selectedVisibility,
              onChanged: (value) {
                selectedVisibility = value!;
              },
            ),
            RadioListTile<String>(
              title: const Text('Private'),
              subtitle: const Text('Only you can see your profile'),
              value: 'Private',
              groupValue: selectedVisibility,
              onChanged: (value) {
                selectedVisibility = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateProfileVisibility(selectedVisibility);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettingsDialog() {
    Map<String, bool> privacySettings = {
      'Show Online Status': true,
      'Allow Friend Requests': true,
      'Show Activity Status': false,
      'Allow Messages from Strangers': false,
    };
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Show Online Status'),
              subtitle: const Text('Let others see when you\'re online'),
              value: privacySettings['Show Online Status']!,
              onChanged: (value) {
                privacySettings['Show Online Status'] = value;
              },
            ),
            SwitchListTile(
              title: const Text('Allow Friend Requests'),
              subtitle: const Text('Let others send you friend requests'),
              value: privacySettings['Allow Friend Requests']!,
              onChanged: (value) {
                privacySettings['Allow Friend Requests'] = value;
              },
            ),
            SwitchListTile(
              title: const Text('Show Activity Status'),
              subtitle: const Text('Let others see your recent activity'),
              value: privacySettings['Show Activity Status']!,
              onChanged: (value) {
                privacySettings['Show Activity Status'] = value;
              },
            ),
            SwitchListTile(
              title: const Text('Allow Messages from Strangers'),
              subtitle: const Text('Let non-friends send you messages'),
              value: privacySettings['Allow Messages from Strangers']!,
              onChanged: (value) {
                privacySettings['Allow Messages from Strangers'] = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updatePrivacySettings(privacySettings);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _show2FASettingsDialog() {
    bool is2FAEnabled = false;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Enable 2FA'),
              subtitle: const Text('Add an extra layer of security'),
              value: is2FAEnabled,
              onChanged: (value) {
                is2FAEnabled = value;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Two-factor authentication adds an extra layer of security to your account by requiring a second form of verification.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _update2FASettings(is2FAEnabled);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDataUsageSettingsDialog() {
    Map<String, bool> dataSettings = {
      'Analytics': true,
      'Crash Reports': true,
      'Usage Statistics': false,
      'Personalized Ads': false,
    };
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Usage Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Analytics'),
              subtitle: const Text('Help us improve the app'),
              value: dataSettings['Analytics']!,
              onChanged: (value) {
                dataSettings['Analytics'] = value;
              },
            ),
            SwitchListTile(
              title: const Text('Crash Reports'),
              subtitle: const Text('Send crash reports automatically'),
              value: dataSettings['Crash Reports']!,
              onChanged: (value) {
                dataSettings['Crash Reports'] = value;
              },
            ),
            SwitchListTile(
              title: const Text('Usage Statistics'),
              subtitle: const Text('Share usage data for improvements'),
              value: dataSettings['Usage Statistics']!,
              onChanged: (value) {
                dataSettings['Usage Statistics'] = value;
              },
            ),
            SwitchListTile(
              title: const Text('Personalized Ads'),
              subtitle: const Text('Show personalized advertisements'),
              value: dataSettings['Personalized Ads']!,
              onChanged: (value) {
                dataSettings['Personalized Ads'] = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateDataUsageSettings(dataSettings);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 