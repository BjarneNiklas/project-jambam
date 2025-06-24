import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'terminology_config.dart';

class TerminologySettingsScreen extends ConsumerWidget {
  const TerminologySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminologyState = ref.watch(terminologyProvider);
    final notifier = ref.read(terminologyProvider.notifier);
    final info = notifier.getInfo();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminology Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.purple[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        const Text(
                          'Terminology & Language',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Customize the app language and terminology to match your preferences',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Terminology Type Section
            _buildSectionCard(
              'Terminology Type',
              'Choose the terminology style that best fits your use case',
              Icons.category,
              Colors.blue,
              [
                _buildTerminologyOption(
                  context,
                  ref,
                  'gaming',
                  'Gaming',
                  'Perfect for game developers and gaming communities',
                  Icons.sports_esports,
                  Colors.green,
                  terminologyState.type == 'gaming',
                ),
                _buildTerminologyOption(
                  context,
                  ref,
                  'business',
                  'Business',
                  'Professional terminology for business and enterprise use',
                  Icons.business,
                  Colors.blue,
                  terminologyState.type == 'business',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Language Section
            _buildSectionCard(
              'Language',
              'Select your preferred language',
              Icons.translate,
              Colors.purple,
              [
                _buildLanguageOption(
                  context,
                  ref,
                  'de',
                  'Deutsch',
                  'German',
                  '🇩🇪',
                  terminologyState.language == 'de',
                ),
                _buildLanguageOption(
                  context,
                  ref,
                  'en',
                  'English',
                  'English',
                  '🇺🇸',
                  terminologyState.language == 'en',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Preview Section
            _buildPreviewSection(context, ref, terminologyState),
            const SizedBox(height: 24),

            // Info Section
            _buildInfoSection(info),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, String subtitle, IconData icon, Color color, List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTerminologyOption(
    BuildContext context,
    WidgetRef ref,
    String value,
    String title,
    String description,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? color : null,
          ),
        ),
        subtitle: Text(description),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: color, size: 24)
            : Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 24),
        onTap: () {
          ref.read(terminologyProvider.notifier).setTerminology(value);
        },
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String value,
    String nativeName,
    String englishName,
    String flag,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.purple : Colors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected ? Colors.purple.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          nativeName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.purple : null,
          ),
        ),
        subtitle: Text(englishName),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.purple, size: 24)
            : Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 24),
        onTap: () {
          ref.read(terminologyProvider.notifier).setLanguage(value);
        },
      ),
    );
  }

  Widget _buildPreviewSection(BuildContext context, WidgetRef ref, TerminologyState state) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.preview, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Live Preview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Settings:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPreviewItem('Terminology Type', state.type.toUpperCase()),
                  _buildPreviewItem('Language', state.language.toUpperCase()),
                  const SizedBox(height: 12),
                  Text(
                    'Example Terms:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPreviewItem('Arena', ref.read(terminologyProvider.notifier).getTerminology('arena')),
                  _buildPreviewItem('Battles', ref.read(terminologyProvider.notifier).getTerminology('battles')),
                  _buildPreviewItem('Champions', ref.read(terminologyProvider.notifier).getTerminology('champions')),
                  _buildPreviewItem('Legions', ref.read(terminologyProvider.notifier).getTerminology('legions')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> info) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.info, color: Colors.grey, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'System Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoItem('Supported Types', info['supportedTypes'].join(', ')),
            _buildInfoItem('Supported Languages', info['supportedLanguages'].join(', ')),
            _buildInfoItem('Default Type', info['defaultType']),
            _buildInfoItem('Default Language', info['defaultLanguage']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 