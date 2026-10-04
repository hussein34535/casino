import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات النظام'),
        backgroundColor: AppColors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSwitchTile(context, 'وضع الصيانة', 'تفعيل وضع الصيانة للصيانة والتحديثات', true, AppColors.orange),
          _buildSwitchTile(context, 'التسجيل مفتوح', 'السماح للمستخدمين الجدد بالتسجيل', true, AppColors.green),
          _buildSettingTile(context, 'النسخة الدنيا من التطبيق', 'v2.1.0', Icons.update, AppColors.teal),
          _buildSettingTile(context, 'الوقت الافتراضي للمباراة', '30 ثانية', Icons.timer, AppColors.purple),
          _buildSettingTile(context, 'الحد الأقصى للاعبين', '100 لاعب', Icons.group, AppColors.orange),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, bool value, Color color) {
    return Card(
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        activeThumbColor: color,
        onChanged: (v) {},
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
