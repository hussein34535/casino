import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/presentation/providers/seed_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة المشرف'),
        backgroundColor: AppColors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('مرحباً بك في لوحة التحكم', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCard(context, Icons.people, 'المستخدمين', AppColors.teal, () => context.push('/admin/users')),
                  _buildCard(context, Icons.quiz, 'الأسئلة', AppColors.purple, () => context.push('/admin/questions')),
                  _buildCard(context, Icons.sports_esports, 'المباريات', AppColors.orange, () {}),
                  _buildCard(context, Icons.analytics, 'التحليلات', AppColors.yellow, () => context.push('/admin/monitoring')),
                  _buildCard(context, Icons.security, 'الأمان', AppColors.red, () => context.push('/admin/security')),
                  _buildCard(context, Icons.business, 'المؤسسات', AppColors.teal, () => context.push('/admin/enterprise')),
                  _buildCard(context, Icons.report, 'التقارير', AppColors.red, () {}),
                  _buildCard(context, Icons.settings, 'الإعدادات', AppColors.grey, () {}),
                  _buildSeedCard(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Card(
      color: color.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedCard(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.green.withValues(alpha: 0.2),
      child: InkWell(
        onTap: () => _showSeedDialog(context, ref),
        borderRadius: BorderRadius.circular(20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storage, size: 48, color: Colors.green),
            SizedBox(height: 8),
            Text('بذر الأسئلة', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showSeedDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('بذر الأسئلة في Firestore'),
        content: const Text('سيتم قراءة الأسئلة من ملفات assets المحلية وكتابتها في مجموعة questions في Firestore. هل تريد المتابعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _runSeed(context, ref);
            },
            child: const Text('بدء البذر'),
          ),
        ],
      ),
    );
  }

  Future<void> _runSeed(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await ref.read(seedServiceProvider).seedAllQuestions();
      navigator.pop();
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(result.hasErrors ? 'تم مع أخطاء' : 'تم بنجاح'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إجمالي الأسئلة: ${result.totalQuestions}'),
              if (result.hasErrors) ...[
                const SizedBox(height: 12),
                const Text('الأخطاء:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...result.errors.map((e) => Text(e, style: const TextStyle(color: Colors.red))),
              ],
            ],
          ),
          actions: [
            ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('حسناً')),
          ],
        ),
      );
    } catch (e) {
      navigator.pop();
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('خطأ'),
          content: Text('حدث خطأ أثناء البذر: $e'),
          actions: [
            ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('حسناً')),
          ],
        ),
      );
    }
  }
}
