import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/services/enterprise/enterprise_service.dart';

class EnterpriseAdminScreen extends ConsumerWidget {
  const EnterpriseAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المؤسسات'),
        backgroundColor: AppColors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.business, color: AppColors.teal, size: 32),
                        const SizedBox(width: 12),
                        Text('باقة Enterprise', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPlanCard(context, 'Starter', enterpriseService.getCloudPlan('starter')),
                    const SizedBox(height: 8),
                    _buildPlanCard(context, 'Growing', enterpriseService.getCloudPlan('growing')),
                    const SizedBox(height: 8),
                    _buildPlanCard(context, 'Scale', enterpriseService.getCloudPlan('scale')),
                    const SizedBox(height: 8),
                    _buildPlanCard(context, 'Enterprise', enterpriseService.getCloudPlan('enterprise')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_business),
              label: const Text('إنشاء حساب مؤسسي'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => _showCreateEnterpriseDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, String name, Map<String, dynamic> plan) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('السعر: \$${plan['price']} | المستخدمين: ${plan['users']}'),
        trailing: Text('${plan['gamesPerMonth']} لعبة/شهر'),
      ),
    );
  }

  void _showCreateEnterpriseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل مؤسسة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم المؤسسة', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'البريد الإلكتروني', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              enterpriseService.registerApp(nameController.text, emailController.text);
              Navigator.pop(ctx);
            },
            child: const Text('تسجيل'),
          ),
        ],
      ),
    );
  }
}
