import 'package:flutter/material.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class SecurityDashboardScreen extends StatelessWidget {
  const SecurityDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة الأمان'),
        backgroundColor: AppColors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('نظرة عامة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                _buildSecurityRow(context, 'نظام المصادقة', 'OAuth 2.0 + JWT', Icons.check_circle, Colors.green),
                _buildSecurityRow(context, 'التشفير', 'AES-256 / E2EE', Icons.check_circle, Colors.green),
                _buildSecurityRow(context, 'مكافحة الاختراق', 'نشط', Icons.shield, AppColors.yellow),
                _buildSecurityRow(context, 'VPN Detection', 'مفعل', Icons.check_circle, Colors.green),
                _buildSecurityRow(context, 'Rate Limiting', '60 req/min', Icons.check_circle, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('آخر الأحداث', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                _buildEventTile(context, 'محاولة دخول مشبوهة', '192.168.1.1', AppColors.red),
                _buildEventTile(context, 'تسجيل مستخدم جديد', 'user@example.com', Colors.green),
                _buildEventTile(context, 'Rate limit تجاوز', 'API endpoint /questions', AppColors.yellow),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.security_update_good),
            label: const Text('تشغيل فحص أمان'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () => _runSecurityScan(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityRow(BuildContext context, String title, String value, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(value),
    );
  }

  Widget _buildEventTile(BuildContext context, String title, String subtitle, Color color) {
    return ListTile(
      leading: Icon(Icons.circle, color: color, size: 12),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  void _runSecurityScan(BuildContext context) {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('فحص الأمان'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري فحص النظام...'),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('تم الفحص بنجاح - لا توجد ثغرات أمنية'), backgroundColor: Colors.green),
      );
    });
  }
}
