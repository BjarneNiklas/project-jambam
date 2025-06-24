import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/enhanced_ai_providers.dart';

class AISecurityScreen extends ConsumerStatefulWidget {
  const AISecurityScreen({super.key});

  @override
  ConsumerState<AISecurityScreen> createState() => _AISecurityScreenState();
}

class _AISecurityScreenState extends ConsumerState<AISecurityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Security & Privacy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshSecurityData,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportSecurityReport,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.security), text: 'Security'),
            Tab(icon: Icon(Icons.privacy_tip), text: 'Privacy'),
            Tab(icon: Icon(Icons.history), text: 'Audit Log'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSecurityTab(),
                _buildPrivacyTab(),
                _buildAuditLogTab(),
              ],
            ),
    );
  }

  Widget _buildSecurityTab() {
    final securityData = ref.watch(securityReportProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Status Overview
          _buildSecurityStatusCard(securityData),
          
          const SizedBox(height: 24),
          
          // Security Controls
          _buildSecurityControlsCard(securityData),
          
          const SizedBox(height: 24),
          
          // Threat Detection
          _buildThreatDetectionCard(securityData),
          
          const SizedBox(height: 24),
          
          // Recent Security Events
          _buildRecentSecurityEventsCard(securityData),
        ],
      ),
    );
  }

  Widget _buildSecurityStatusCard(Map<String, dynamic> data) {
    final securityStatus = data['security_status'] as Map<String, dynamic>? ?? {};
    final overallStatus = securityStatus['overall_status'] ?? 'unknown';
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getSecurityStatusIcon(overallStatus),
                  color: _getSecurityStatusColor(overallStatus),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Status',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        overallStatus.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          color: _getSecurityStatusColor(overallStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSecurityMetricRow('Threats Detected', securityStatus['threats_detected']?.toString() ?? '0'),
            _buildSecurityMetricRow('Last Scan', securityStatus['last_scan'] ?? 'Never'),
            _buildSecurityMetricRow('Next Scan', securityStatus['next_scan'] ?? 'Not scheduled'),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityControlsCard(Map<String, dynamic> data) {
    final securityControls = data['security_controls'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Input Validation'),
              subtitle: const Text('Validate all AI inputs for malicious content'),
              value: securityControls['input_validation'] ?? true,
              onChanged: (value) => _updateSecurityControl('input_validation', value),
            ),
            
            SwitchListTile(
              title: const Text('Output Sanitization'),
              subtitle: const Text('Sanitize AI outputs for security'),
              value: securityControls['output_sanitization'] ?? true,
              onChanged: (value) => _updateSecurityControl('output_sanitization', value),
            ),
            
            SwitchListTile(
              title: const Text('Rate Limiting'),
              subtitle: const Text('Limit AI request frequency'),
              value: securityControls['rate_limiting'] ?? true,
              onChanged: (value) => _updateSecurityControl('rate_limiting', value),
            ),
            
            SwitchListTile(
              title: const Text('Content Filtering'),
              subtitle: const Text('Filter inappropriate or harmful content'),
              value: securityControls['content_filtering'] ?? true,
              onChanged: (value) => _updateSecurityControl('content_filtering', value),
            ),
            
            SwitchListTile(
              title: const Text('Encryption'),
              subtitle: const Text('Encrypt all AI communications'),
              value: securityControls['encryption'] ?? true,
              onChanged: (value) => _updateSecurityControl('encryption', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreatDetectionCard(Map<String, dynamic> data) {
    final threatDetection = data['threat_detection'] as Map<String, dynamic>? ?? {};
    final recentThreats = threatDetection['recent_threats'] as List<dynamic>? ?? [];
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Threat Detection',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: recentThreats.isEmpty ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    recentThreats.isEmpty ? 'CLEAN' : '${recentThreats.length} THREATS',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (recentThreats.isEmpty)
              const Text(
                'No threats detected in recent activity.',
                style: TextStyle(color: Colors.green),
              )
            else
              ...recentThreats.take(3).map((threat) {
                final threatData = threat as Map<String, dynamic>;
                return ListTile(
                  leading: Icon(
                    Icons.warning,
                    color: _getThreatLevelColor(threatData['level']),
                  ),
                  title: Text(threatData['type'] ?? 'Unknown'),
                  subtitle: Text(threatData['description'] ?? ''),
                  trailing: Text(_formatTimestamp(threatData['timestamp'])),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSecurityEventsCard(Map<String, dynamic> data) {
    final auditLog = data['audit_log_summary'] as Map<String, dynamic>? ?? {};
    final recentEvents = auditLog['recent_events'] as List<dynamic>? ?? [];
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Security Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            ...recentEvents.take(5).map((event) {
              final eventData = event as Map<String, dynamic>;
              return ListTile(
                leading: Icon(_getSecurityEventIcon(eventData['event_type'])),
                title: Text(eventData['event_type']?.toString().toUpperCase() ?? 'Unknown'),
                subtitle: Text(_formatTimestamp(eventData['timestamp'])),
                trailing: Icon(
                  _getEventStatusIcon(eventData['status']),
                  color: _getEventStatusColor(eventData['status']),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyTab() {
    final privacyData = ref.watch(securityReportProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Privacy Overview
          _buildPrivacyOverviewCard(privacyData),
          
          const SizedBox(height: 24),
          
          // Privacy Controls
          _buildPrivacyControlsCard(privacyData),
          
          const SizedBox(height: 24),
          
          // Data Retention
          _buildDataRetentionCard(privacyData),
          
          const SizedBox(height: 24),
          
          // Data Export/Deletion
          _buildDataManagementCard(privacyData),
        ],
      ),
    );
  }

  Widget _buildPrivacyOverviewCard(Map<String, dynamic> data) {
    final privacyControls = data['privacy_controls'] as Map<String, dynamic>? ?? {};
    final dataRetention = data['data_retention_status'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildPrivacyMetricRow('Anonymization', privacyControls['anonymization_enabled'] ?? false),
            _buildPrivacyMetricRow('Audit Logging', privacyControls['audit_logging_enabled'] ?? false),
            _buildPrivacyMetricRow('Data Retention', dataRetention['enabled'] ?? false),
            _buildPrivacyMetricRow('Data Encryption', privacyControls['data_encryption'] ?? true),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyControlsCard(Map<String, dynamic> data) {
    final privacyControls = data['privacy_controls'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Anonymization'),
              subtitle: const Text('Automatically anonymize personal data'),
              value: privacyControls['anonymization_enabled'] ?? false,
              onChanged: (value) => _updatePrivacySetting('anonymization_enabled', value),
            ),
            
            SwitchListTile(
              title: const Text('Audit Logging'),
              subtitle: const Text('Log all AI interactions for compliance'),
              value: privacyControls['audit_logging_enabled'] ?? false,
              onChanged: (value) => _updatePrivacySetting('audit_logging_enabled', value),
            ),
            
            SwitchListTile(
              title: const Text('Data Encryption'),
              subtitle: const Text('Encrypt stored personal data'),
              value: privacyControls['data_encryption'] ?? true,
              onChanged: (value) => _updatePrivacySetting('data_encryption', value),
            ),
            
            SwitchListTile(
              title: const Text('Third-party Sharing'),
              subtitle: const Text('Allow data sharing with third parties'),
              value: privacyControls['third_party_sharing'] ?? false,
              onChanged: (value) => _updatePrivacySetting('third_party_sharing', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRetentionCard(Map<String, dynamic> data) {
    final dataRetention = data['data_retention_status'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Retention',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Enable Data Retention'),
              subtitle: const Text('Automatically delete old data'),
              value: dataRetention['enabled'] ?? false,
              onChanged: (value) => _updateDataRetention('enabled', value),
            ),
            
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Retention Period',
                border: OutlineInputBorder(),
              ),
              value: dataRetention['retention_days']?.toString() ?? '30',
              items: const [
                DropdownMenuItem(value: '7', child: Text('7 Days')),
                DropdownMenuItem(value: '30', child: Text('30 Days')),
                DropdownMenuItem(value: '90', child: Text('90 Days')),
                DropdownMenuItem(value: '365', child: Text('1 Year')),
              ],
              onChanged: (value) => _updateDataRetention('retention_days', int.tryParse(value ?? '30')),
            ),
            
            const SizedBox(height: 16),
            
            _buildPrivacyMetricRow('Oldest Data', dataRetention['oldest_data'] ?? 'None'),
            _buildPrivacyMetricRow('Data Size', dataRetention['data_size'] ?? '0 MB'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataManagementCard(Map<String, dynamic> data) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: _exportUserData,
              icon: const Icon(Icons.download),
              label: const Text('Export My Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _deleteUserData,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete My Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Warning: Deleting your data is permanent and cannot be undone.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditLogTab() {
    final auditData = ref.watch(securityReportProvider);
    final auditLog = auditData['audit_log_summary'] as Map<String, dynamic>? ?? {};
    final allEvents = auditLog['all_events'] as List<dynamic>? ?? [];
    
    return Column(
      children: [
        // Filter Controls
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Event Type',
                    border: OutlineInputBorder(),
                  ),
                  value: 'all',
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Events')),
                    DropdownMenuItem(value: 'security', child: Text('Security')),
                    DropdownMenuItem(value: 'privacy', child: Text('Privacy')),
                    DropdownMenuItem(value: 'ai_interaction', child: Text('AI Interaction')),
                  ],
                  onChanged: (value) => _filterAuditLog(value),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _refreshAuditLog,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        
        // Audit Log List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allEvents.length,
            itemBuilder: (context, index) {
              final event = allEvents[index] as Map<String, dynamic>;
              return _buildAuditLogItem(event);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuditLogItem(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getEventTypeColor(event['event_type']),
          child: Icon(
            _getAuditEventIcon(event['event_type']),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          event['event_type']?.toString().toUpperCase() ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event['description'] ?? ''),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(event['timestamp']),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(
          _getEventStatusIcon(event['status']),
          color: _getEventStatusColor(event['status']),
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildSecurityMetricRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyMetricRow(String label, dynamic value) {
    final isEnabled = value is bool ? value : false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            color: isEnabled ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  IconData _getSecurityStatusIcon(String status) {
    switch (status) {
      case 'secure':
        return Icons.security;
      case 'warning':
        return Icons.warning;
      case 'critical':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getSecurityStatusColor(String status) {
    switch (status) {
      case 'secure':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getThreatLevelColor(String? level) {
    switch (level) {
      case 'low':
        return Colors.orange;
      case 'medium':
        return Colors.red;
      case 'high':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getSecurityEventIcon(String? eventType) {
    switch (eventType) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'data_access':
        return Icons.data_usage;
      case 'security_scan':
        return Icons.security;
      default:
        return Icons.info;
    }
  }

  IconData _getEventStatusIcon(String? status) {
    switch (status) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Color _getEventStatusColor(String? status) {
    switch (status) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getEventTypeColor(String? eventType) {
    switch (eventType) {
      case 'security':
        return Colors.red;
      case 'privacy':
        return Colors.blue;
      case 'ai_interaction':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getAuditEventIcon(String? eventType) {
    switch (eventType) {
      case 'security':
        return Icons.security;
      case 'privacy':
        return Icons.privacy_tip;
      case 'ai_interaction':
        return Icons.psychology;
      default:
        return Icons.info;
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}/${date.month} ${date.hour}:${date.minute}';
    } catch (e) {
      return '';
    }
  }

  // Action methods
  void _updateSecurityControl(String key, bool value) async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      await service.updateSecuritySettings({key: value});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Security setting $key updated to $value')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update security setting: $e')),
      );
    }
  }

  void _updatePrivacySetting(String key, bool value) async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      await service.updatePrivacySettings({key: value});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Privacy setting $key updated to $value')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update privacy setting: $e')),
      );
    }
  }

  void _updateDataRetention(String key, dynamic value) async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      await service.updateDataRetentionSettings({key: value});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data retention setting $key updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update data retention setting: $e')),
      );
    }
  }

  void _exportUserData() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      await service.exportUserData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export user data: $e')),
      );
    }
  }

  void _deleteUserData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User Data'),
        content: const Text(
          'Are you sure you want to delete all your data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final service = ref.read(enhancedAIServiceProvider);
        await service.deleteUserData();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete user data: $e')),
        );
      }
    }
  }

  void _filterAuditLog(String? filter) {
    // Implementation for filtering audit log
  }

  void _refreshAuditLog() {
    // Implementation for refreshing audit log
  }

  void _refreshSecurityData() {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _exportSecurityReport() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      await service.exportSecurityReport();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Security report exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export security report: $e')),
      );
    }
  }
} 