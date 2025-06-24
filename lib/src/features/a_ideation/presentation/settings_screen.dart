import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                    // TODO: Edit profile
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
                setState(() {
                  _selectedTerminology = value!;
                });
                // TODO: Update terminology configuration
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
        color: Colors.grey.withAlpha(26),
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
                setState(() {
                  _selectedLanguage = value!;
                });
                // TODO: Update language
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
                // TODO: Profile visibility settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Manage your privacy preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Privacy settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text('Add extra security to your account'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: 2FA settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.data_usage),
              title: const Text('Data Usage'),
              subtitle: const Text('Control how your data is used'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Data usage settings
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
                // TODO: Edit profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Change Email'),
              subtitle: const Text('Update your email address'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Change email
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
              subtitle: const Text('Update your password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Change password
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export Data'),
              subtitle: const Text('Download your data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Export data
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
                _showDeleteAccountDialog();
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
                // TODO: Terms of service
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Privacy policy
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Help & support
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Send feedback
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete account
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} 