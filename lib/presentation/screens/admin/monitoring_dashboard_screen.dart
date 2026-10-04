import 'package:flutter/material.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/features/monitoring_service.dart';

class MonitoringDashboardScreen extends StatefulWidget {
  const MonitoringDashboardScreen({super.key});

  @override
  State<MonitoringDashboardScreen> createState() => _MonitoringDashboardScreenState();
}

class _MonitoringDashboardScreenState extends State<MonitoringDashboardScreen> {
  final _dashboard = AnalyticsDashboard();
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _dashboard.getDashboardData();
    setState(() => _data = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحليلات'),
        backgroundColor: AppColors.teal,
      ),
      body: _data == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildMetricCard(context, 'المستخدمين النشطين يومياً', _data!['dailyActiveUsers'].toString(), Icons.people, AppColors.teal),
                  const SizedBox(height: 12),
                  _buildMetricCard(context, 'المباريات اليوم', _data!['gamesPlayedToday'].toString(), Icons.sports_esports, AppColors.yellow),
                  const SizedBox(height: 12),
                  _buildMetricCard(context, 'متوسط وقت الجلسة', '${_data!['averageSessionDuration']} دقيقة', Icons.timer, Colors.orange),
                  const SizedBox(height: 12),
                  _buildMetricCard(context, 'إجمالي الإيرادات', '\$${_data!['totalRevenue']}', Icons.attach_money, Colors.green),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('أفضل التصنيفات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          ...(_data!['topCategories'] as List).map((cat) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(child: Text(cat['name'])),
                                Text('${cat['count']}', style: const TextStyle(color: AppColors.yellow)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('الاحتفاظ بالمستخدمين', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: _data!['userRetention'] as double,
                            backgroundColor: Colors.grey[800],
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                          ),
                          const SizedBox(height: 8),
                          Text('${((_data!['userRetention'] as double) * 100).toStringAsFixed(1)}%'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
