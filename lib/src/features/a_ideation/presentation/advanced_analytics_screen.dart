import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class AdvancedAnalyticsScreen extends ConsumerStatefulWidget {
  const AdvancedAnalyticsScreen({super.key});

  @override
  ConsumerState<AdvancedAnalyticsScreen> createState() => _AdvancedAnalyticsScreenState();
}

class _AdvancedAnalyticsScreenState extends ConsumerState<AdvancedAnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

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
        title: const Text('Advanced Analytics'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _exportAdvancedAnalytics();
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareAdvancedAnalytics();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'DASHBOARD'),
            Tab(text: 'PREDICTIVE'),
            Tab(text: 'BUSINESS'),
            Tab(text: 'INSIGHTS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildPredictiveTab(),
          _buildBusinessTab(),
          _buildInsightsTab(),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalyticsHeader(),
          const SizedBox(height: 16),
          _buildKpiCards(),
          const SizedBox(height: 16),
          _buildPerformanceChart(),
          const SizedBox(height: 16),
          _buildTrendAnalysisCard(),
          const SizedBox(height: 16),
          _buildRealTimeMetricsCard(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.cyan[400]!, Colors.blue[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Advanced Analytics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Data-driven insights for your business',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAnalyticsStat('Revenue', '\$2.4M', '+15%', Colors.white),
                _buildAnalyticsStat('Users', '45.2K', '+8%', Colors.white),
                _buildAnalyticsStat('Projects', '156', '+12%', Colors.white),
                _buildAnalyticsStat('Efficiency', '94%', '+3%', Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsStat(String label, String value, String change, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            change,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCards() {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            'Revenue Growth',
            '\$2.4M',
            '+15% vs last month',
            Icons.trending_up,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            'User Engagement',
            '87%',
            '+5% vs last week',
            Icons.people,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildChartBar('Jan', 0.6, Colors.blue),
                  _buildChartBar('Feb', 0.7, Colors.blue),
                  _buildChartBar('Mar', 0.8, Colors.blue),
                  _buildChartBar('Apr', 0.9, Colors.blue),
                  _buildChartBar('May', 0.85, Colors.blue),
                  _buildChartBar('Jun', 0.95, Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildChartStat('Peak', 'June', Colors.blue),
                _buildChartStat('Growth', '+35%', Colors.green),
                _buildChartStat('Trend', 'Upward', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(String label, double value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 120 * value,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildChartStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendAnalysisCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trend Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTrendItem('Revenue Growth', 'Consistent upward trend', '+15%', Colors.green),
            _buildTrendItem('User Acquisition', 'Steady growth', '+8%', Colors.blue),
            _buildTrendItem('Project Completion', 'Improving efficiency', '+12%', Colors.orange),
            _buildTrendItem('Team Productivity', 'Peak performance', '+18%', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(String metric, String description, String change, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealTimeMetricsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Real-Time Metrics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildRealTimeMetric('Active Users', '1,247', Colors.blue),
                ),
                Expanded(
                  child: _buildRealTimeMetric('Projects', '23', Colors.green),
                ),
                Expanded(
                  child: _buildRealTimeMetric('Revenue', '\$12.5K', Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealTimeMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPredictiveTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPredictiveHeader(),
        const SizedBox(height: 16),
        _buildForecastCard(),
        const SizedBox(height: 16),
        _buildPredictiveModelsCard(),
        const SizedBox(height: 16),
        _buildRiskAnalysisCard(),
      ],
    );
  }

  Widget _buildPredictiveHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.psychology, color: Colors.cyan, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Predictive Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.cyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'AI-powered',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildForecastItem('Next Month', '\$2.8M', '+16%', Colors.green),
                ),
                Expanded(
                  child: _buildForecastItem('Next Quarter', '\$8.2M', '+18%', Colors.blue),
                ),
                Expanded(
                  child: _buildForecastItem('Next Year', '\$32.5M', '+22%', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Confidence Level: 87%',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastItem(String period, String value, String growth, Color color) {
    return Column(
      children: [
        Text(
          period,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            growth,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPredictiveModelsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predictive Models',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildModelItem('Revenue Prediction', 'Linear Regression', '92%', Colors.blue),
            _buildModelItem('User Growth', 'Time Series', '88%', Colors.green),
            _buildModelItem('Churn Prediction', 'Random Forest', '85%', Colors.orange),
            _buildModelItem('Market Trends', 'Neural Network', '90%', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildModelItem(String name, String algorithm, String accuracy, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  algorithm,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              accuracy,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAnalysisCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Risk Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRiskItem('Market Volatility', 'Low Risk', Colors.green),
            _buildRiskItem('Competition', 'Medium Risk', Colors.orange),
            _buildRiskItem('Technology Changes', 'Low Risk', Colors.green),
            _buildRiskItem('Economic Factors', 'Medium Risk', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskItem(String factor, String risk, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              factor,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              risk,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBusinessHeader(),
        const SizedBox(height: 16),
        _buildFinancialMetricsCard(),
        const SizedBox(height: 16),
        _buildMarketAnalysisCard(),
        const SizedBox(height: 16),
        _buildCompetitiveAnalysisCard(),
      ],
    );
  }

  Widget _buildBusinessHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.business, color: Colors.cyan, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Business Intelligence',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.cyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Enterprise',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialMetricsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFinancialMetric('Revenue', '\$2.4M', '+15%', Colors.green),
                ),
                Expanded(
                  child: _buildFinancialMetric('Profit', '\$850K', '+22%', Colors.blue),
                ),
                Expanded(
                  child: _buildFinancialMetric('ROI', '320%', '+18%', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFinancialMetric('CAC', '\$45', '-8%', Colors.purple),
                ),
                Expanded(
                  child: _buildFinancialMetric('LTV', '\$1.2K', '+12%', Colors.teal),
                ),
                Expanded(
                  child: _buildFinancialMetric('Margin', '35%', '+5%', Colors.indigo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialMetric(String metric, String value, String change, Color color) {
    return Column(
      children: [
        Text(
          metric,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            change,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketAnalysisCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Market Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMarketItem('Market Size', '\$45B', 'Growing', Colors.green),
            _buildMarketItem('Market Share', '2.3%', 'Expanding', Colors.blue),
            _buildMarketItem('Growth Rate', '12%', 'Above Average', Colors.orange),
            _buildMarketItem('Competition', 'Medium', 'Stable', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketItem(String factor, String value, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              factor,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 14,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitiveAnalysisCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Competitive Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCompetitorItem('Competitor A', 'Market Leader', '35%', Colors.red),
            _buildCompetitorItem('Competitor B', 'Growing', '28%', Colors.orange),
            _buildCompetitorItem('Our Company', 'Innovative', '23%', Colors.green),
            _buildCompetitorItem('Competitor C', 'Declining', '14%', Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitorItem(String name, String status, String share, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            share,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInsightsHeader(),
        const SizedBox(height: 16),
        _buildKeyInsightsCard(),
        const SizedBox(height: 16),
        _buildRecommendationsCard(),
        const SizedBox(height: 16),
        _buildActionItemsCard(),
      ],
    );
  }

  Widget _buildInsightsHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.cyan, size: 24),
            const SizedBox(width: 12),
            const Text(
              'AI Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.cyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Powered by AI',
                style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyInsightsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              'Revenue growth is accelerating',
              'Based on current trends, revenue is expected to grow 25% next quarter',
              Colors.green,
            ),
            _buildInsightItem(
              'User engagement is improving',
              'Recent feature updates have increased user retention by 15%',
              Colors.blue,
            ),
            _buildInsightItem(
              'Market opportunity identified',
              'Untapped market segment could generate \$500K additional revenue',
              Colors.orange,
            ),
            _buildInsightItem(
              'Efficiency gains detected',
              'Process optimization has reduced costs by 12%',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              'Increase marketing budget',
              'High impact, low risk',
              'Priority: High',
              Colors.red,
            ),
            _buildRecommendationItem(
              'Launch new feature',
              'Expected 20% revenue boost',
              'Priority: Medium',
              Colors.orange,
            ),
            _buildRecommendationItem(
              'Optimize pricing strategy',
              'Potential 15% margin increase',
              'Priority: High',
              Colors.green,
            ),
            _buildRecommendationItem(
              'Expand to new markets',
              'Long-term growth opportunity',
              'Priority: Medium',
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String action, String impact, String priority, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.recommend,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  impact,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              priority,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItemsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Action Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionItem('Review marketing strategy', 'Due: This week', Colors.blue),
            _buildActionItem('Implement pricing changes', 'Due: Next week', Colors.green),
            _buildActionItem('Launch beta feature', 'Due: Next month', Colors.orange),
            _buildActionItem('Market expansion plan', 'Due: Next quarter', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(String action, String dueDate, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.task,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  dueDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _takeAction(action);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Action'),
          ),
        ],
      ),
    );
  }

  void _exportAdvancedAnalytics() {
    // Generate comprehensive analytics report
    final report = _generateAdvancedAnalyticsReport();

    // Show export options
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Advanced Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose export format:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF Report'),
              subtitle: const Text('Comprehensive analysis'),
              onTap: () {
                Navigator.pop(context);
                _exportAsPDF(report);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Excel Spreadsheet'),
              subtitle: const Text('Raw data and charts'),
              onTap: () {
                Navigator.pop(context);
                _exportAsExcel(report);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('PowerBI Dashboard'),
              subtitle: const Text('Interactive dashboard'),
              onTap: () {
                Navigator.pop(context);
                _exportAsPowerBI(report);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _shareAdvancedAnalytics() {
    final analyticsSummary = _generateAdvancedAnalyticsSummary();

    Share.share(
      analyticsSummary,
      subject: 'Advanced Analytics Report - Jambam',
    );
  }

  void _takeAction(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Take Action: $action'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('What would you like to do with "$action"?'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Schedule for later'),
              onTap: () {
                Navigator.pop(context);
                _scheduleAction(action);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Create task'),
              onTap: () {
                Navigator.pop(context);
                _createTask(action);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Assign to team'),
              onTap: () {
                Navigator.pop(context);
                _assignToTeam(action);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Analyze impact'),
              onTap: () {
                Navigator.pop(context);
                _analyzeImpact(action);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _generateAdvancedAnalyticsReport() {
    return '''
Advanced Analytics Report - ${DateTime.now().toString().split(' ')[0]}

Executive Summary:
- Revenue: \$2.4M (+15% vs last month)
- Users: 45.2K (+8% vs last month)
- Projects: 156 (+12% vs last month)
- Efficiency: 94% (+3% vs last month)

Key Insights:
1. Marketing budget increase recommended (High impact, low risk)
2. New feature launch expected to boost revenue by 20%
3. Pricing optimization could increase margins by 15%
4. Market expansion opportunity identified

Predictive Analysis:
- Q4 revenue projection: \$3.1M
- User growth forecast: 52K by year-end
- Market penetration: 15% increase expected

Action Items:
- Review marketing strategy (Due: This week)
- Implement pricing changes (Due: Next week)
- Launch beta feature (Due: Next month)
- Market expansion plan (Due: Next quarter)
    ''';
  }

  String _generateAdvancedAnalyticsSummary() {
    return '''
📊 Advanced Analytics Report - Jambam

🚀 Key Performance Indicators:
• Revenue: \$2.4M (+15% growth)
• Users: 45.2K (+8% growth)
• Projects: 156 (+12% growth)
• Efficiency: 94% (+3% improvement)

🎯 Strategic Recommendations:
• Increase marketing budget (High impact, low risk)
• Launch new feature (20% revenue boost expected)
• Optimize pricing strategy (15% margin increase)
• Expand to new markets (Long-term growth)

📈 Predictive Insights:
• Q4 revenue projection: \$3.1M
• User growth forecast: 52K by year-end
• Market penetration: 15% increase expected

Check out our advanced analytics dashboard!
    ''';
  }

  void _exportAsPDF(String report) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF export started...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportAsExcel(String report) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Excel export started...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportAsPowerBI(String report) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PowerBI dashboard export started...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _scheduleAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scheduled: $action'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _createTask(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task created: $action'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _assignToTeam(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assigned to team: $action'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _analyzeImpact(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Impact analysis started for: $action'),
        backgroundColor: Colors.purple,
      ),
    );
  }
} 