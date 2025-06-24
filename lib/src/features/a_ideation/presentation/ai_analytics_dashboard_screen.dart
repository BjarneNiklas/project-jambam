import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/enhanced_ai_providers.dart';

class AIAnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AIAnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AIAnalyticsDashboardScreen> createState() => _AIAnalyticsDashboardScreenState();
}

class _AIAnalyticsDashboardScreenState extends ConsumerState<AIAnalyticsDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('AI Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Performance'),
            Tab(icon: Icon(Icons.person), text: 'User Insights'),
            Tab(icon: Icon(Icons.security), text: 'Security'),
            Tab(icon: Icon(Icons.lightbulb), text: 'Recommendations'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPerformanceTab(),
                _buildUserInsightsTab(),
                _buildSecurityTab(),
                _buildRecommendationsTab(),
              ],
            ),
    );
  }

  Widget _buildPerformanceTab() {
    final analyticsData = ref.watch(analyticsDashboardProvider);
    final performanceMetrics = analyticsData['performance_metrics'] as Map<String, dynamic>? ?? {};
    final usageStats = analyticsData['usage_statistics'] as Map<String, dynamic>? ?? {};
    final trends = analyticsData['trends'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Overview Cards
          _buildPerformanceOverviewCards(performanceMetrics),
          
          const SizedBox(height: 24),
          
          // Usage Statistics
          _buildUsageStatisticsCard(usageStats),
          
          const SizedBox(height: 24),
          
          // Trends
          _buildTrendsCard(trends),
          
          const SizedBox(height: 24),
          
          // Detailed Performance Table
          _buildPerformanceTable(performanceMetrics),
        ],
      ),
    );
  }

  Widget _buildPerformanceOverviewCards(Map<String, dynamic> metrics) {
    final totalRequests = metrics.values.fold<int>(0, (sum, metric) => 
        sum + (metric['total_requests'] as int? ?? 0));
    
    final avgResponseTime = metrics.values.fold<double>(0.0, (sum, metric) => 
        sum + (metric['average_response_time'] as double? ?? 0.0)) / metrics.length;
    
    final avgConfidence = metrics.values.fold<double>(0.0, (sum, metric) => 
        sum + (metric['average_confidence'] as double? ?? 0.0)) / metrics.length;
    
    final avgSatisfaction = metrics.values.fold<double>(0.0, (sum, metric) => 
        sum + (metric['average_satisfaction'] as double? ?? 0.0)) / metrics.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard(
              'Total Requests',
              totalRequests.toString(),
              Icons.request_page,
              Colors.blue,
            ),
            _buildMetricCard(
              'Avg Response Time',
              '${avgResponseTime.toStringAsFixed(0)}ms',
              Icons.speed,
              Colors.green,
            ),
            _buildMetricCard(
              'Avg Confidence',
              '${(avgConfidence * 100).toStringAsFixed(1)}%',
              Icons.psychology,
              Colors.orange,
            ),
            _buildMetricCard(
              'Avg Satisfaction',
              '${(avgSatisfaction * 100).toStringAsFixed(1)}%',
              Icons.sentiment_satisfied,
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStatisticsCard(Map<String, dynamic> usageStats) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usage Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...usageStats.entries.map((entry) {
              final data = entry.value as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data['count'].toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${data['percentage']}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsCard(Map<String, dynamic> trends) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...trends.entries.map((entry) {
              final trendData = entry.value as Map<String, dynamic>;
              final isImproving = trendData['trend'] == 'improving';
              
              return ListTile(
                leading: Icon(
                  isImproving ? Icons.trending_up : Icons.trending_down,
                  color: isImproving ? Colors.green : Colors.red,
                ),
                title: Text(
                  entry.key.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  '${trendData['change_percentage']}% ${trendData['trend']}',
                  style: TextStyle(
                    color: isImproving ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTable(Map<String, dynamic> metrics) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detailed Performance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Task Type')),
                  DataColumn(label: Text('Response Time')),
                  DataColumn(label: Text('Confidence')),
                  DataColumn(label: Text('Satisfaction')),
                  DataColumn(label: Text('Requests')),
                ],
                rows: metrics.entries.map((entry) {
                  final metric = entry.value as Map<String, dynamic>;
                  return DataRow(
                    cells: [
                      DataCell(Text(entry.key.toUpperCase())),
                      DataCell(Text('${metric['average_response_time'].toStringAsFixed(0)}ms')),
                      DataCell(Text('${(metric['average_confidence'] * 100).toStringAsFixed(1)}%')),
                      DataCell(Text('${(metric['average_satisfaction'] * 100).toStringAsFixed(1)}%')),
                      DataCell(Text(metric['total_requests'].toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInsightsTab() {
    final userInsights = ref.watch(userInsightsProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Card
          _buildUserProfileCard(userInsights),
          
          const SizedBox(height: 24),
          
          // Task Type Preferences
          _buildTaskPreferencesCard(userInsights),
          
          const SizedBox(height: 24),
          
          // Common Keywords
          _buildKeywordsCard(userInsights),
          
          const SizedBox(height: 24),
          
          // Interaction History
          _buildInteractionHistoryCard(userInsights),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(Map<String, dynamic> insights) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProfileRow('Expertise Level', insights['expertise_level'] ?? 'Unknown'),
            _buildProfileRow('Total Interactions', insights['total_interactions']?.toString() ?? '0'),
            _buildProfileRow('Average Satisfaction', 
                '${((insights['average_satisfaction'] ?? 0.0) * 100).toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskPreferencesCard(Map<String, dynamic> insights) {
    final preferences = insights['task_type_preferences'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Type Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...preferences.entries.map((entry) {
              final percentage = (entry.value * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                        ),
                        Text('$percentage%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value as double,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPreferenceColor(entry.value as double),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getPreferenceColor(double value) {
    if (value > 0.7) return Colors.green;
    if (value > 0.4) return Colors.orange;
    return Colors.red;
  }

  Widget _buildKeywordsCard(Map<String, dynamic> insights) {
    final keywords = insights['common_keywords'] as List<dynamic>? ?? [];
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Common Keywords',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keywords.map((keyword) {
                return Chip(
                  label: Text(keyword.toString()),
                  backgroundColor: Colors.blue[100],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionHistoryCard(Map<String, dynamic> insights) {
    final history = insights['interaction_history'] as List<dynamic>? ?? [];
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Interactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...history.take(5).map((interaction) {
              final data = interaction as Map<String, dynamic>;
              return ListTile(
                leading: Icon(_getTaskIcon(data['task_type'])),
                title: Text(data['task_type']?.toString().toUpperCase() ?? 'Unknown'),
                subtitle: Text('Satisfaction: ${((data['satisfaction'] ?? 0.0) * 100).toStringAsFixed(1)}%'),
                trailing: Text(_formatTimestamp(data['timestamp'])),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  IconData _getTaskIcon(String? taskType) {
    switch (taskType) {
      case 'classification':
        return Icons.category;
      case 'generation':
        return Icons.auto_awesome;
      case 'analysis':
        return Icons.analytics;
      case 'retrieval':
        return Icons.search;
      default:
        return Icons.help;
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

  Widget _buildSecurityTab() {
    final securityReport = ref.watch(securityReportProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Overview
          _buildSecurityOverviewCard(securityReport),
          
          const SizedBox(height: 24),
          
          // Privacy Controls
          _buildPrivacyControlsCard(securityReport),
          
          const SizedBox(height: 24),
          
          // Data Retention
          _buildDataRetentionCard(securityReport),
          
          const SizedBox(height: 24),
          
          // Recent Security Events
          _buildSecurityEventsCard(securityReport),
        ],
      ),
    );
  }

  Widget _buildSecurityOverviewCard(Map<String, dynamic> report) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSecurityRow('Anonymization', report['privacy_controls']?['anonymization_enabled'] ?? false),
            _buildSecurityRow('Audit Logging', report['privacy_controls']?['audit_logging_enabled'] ?? false),
            _buildSecurityRow('Data Retention', report['data_retention_status']?['enabled'] ?? false),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityRow(String label, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyControlsCard(Map<String, dynamic> report) {
    final controls = report['privacy_controls'] as Map<String, dynamic>? ?? {};
    
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
              value: controls['anonymization_enabled'] ?? false,
              onChanged: (value) => _updatePrivacySetting('anonymization_enabled', value),
            ),
            SwitchListTile(
              title: const Text('Audit Logging'),
              subtitle: const Text('Log all AI interactions for compliance'),
              value: controls['audit_logging_enabled'] ?? false,
              onChanged: (value) => _updatePrivacySetting('audit_logging_enabled', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRetentionCard(Map<String, dynamic> report) {
    final retention = report['data_retention_status'] as Map<String, dynamic>? ?? {};
    
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
            _buildProfileRow('Enabled', retention['enabled']?.toString() ?? 'false'),
            _buildProfileRow('Retention Days', retention['retention_days']?.toString() ?? '30'),
            _buildProfileRow('Oldest Data', retention['oldest_data'] ?? 'None'),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityEventsCard(Map<String, dynamic> report) {
    final events = report['audit_log_summary']?['recent_events'] as List<dynamic>? ?? [];
    
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
            ...events.take(5).map((event) {
              final data = event as Map<String, dynamic>;
              return ListTile(
                leading: Icon(_getSecurityEventIcon(data['event_type'])),
                title: Text(data['event_type']?.toString().toUpperCase() ?? 'Unknown'),
                subtitle: Text(_formatTimestamp(data['timestamp'])),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  IconData _getSecurityEventIcon(String? eventType) {
    switch (eventType) {
      case 'request_received':
        return Icons.input;
      case 'request_secured':
        return Icons.security;
      case 'security_error':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Widget _buildRecommendationsTab() {
    final recommendations = ref.watch(recommendationsProvider);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Recommendations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...recommendations.map((recommendation) {
            return _buildRecommendationCard(recommendation);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
    final priority = recommendation['priority'] as String? ?? 'medium';
    final type = recommendation['type'] as String? ?? 'general';
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getRecommendationIcon(type),
                  color: _getPriorityColor(priority),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation['message'] ?? 'No message',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(priority),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    priority.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${type.toUpperCase()}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRecommendationIcon(String type) {
    switch (type) {
      case 'performance':
        return Icons.speed;
      case 'model':
        return Icons.psychology;
      case 'user_experience':
        return Icons.person;
      default:
        return Icons.lightbulb;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Actions
  void _refreshData() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate refresh
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _exportData() async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      final analyticsData = service.getAnalyticsDashboard();
      final userData = service.getUserInsights();
      final securityData = service.getSecurityReport();
      
      // In a real app, you'd save this to a file or share it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  void _updatePrivacySetting(String setting, bool value) async {
    try {
      final service = ref.read(enhancedAIServiceProvider);
      await service.updatePrivacySettings({setting: value});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$setting updated to $value')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update setting: $e')),
      );
    }
  }
} 