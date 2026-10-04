import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminModerationScreen extends ConsumerWidget {
  const AdminModerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مراقبة المحتوى'),
          backgroundColor: AppColors.orange,
          bottom: const TabBar(
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.white,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'قيد الانتظار'),
              Tab(text: 'تم الحل'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReportList(context, 'all'),
            _buildReportList(context, 'pending'),
            _buildReportList(context, 'resolved'),
          ],
        ),
      ),
    );
  }

  Widget _buildReportList(BuildContext context, String filter) {
    final reports = _reports.where((r) {
      if (filter == 'all') return true;
      return r['status'] == filter;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        final typeIcon = report['type'] == 'question'
            ? Icons.quiz
            : report['type'] == 'comment'
                ? Icons.comment
                : Icons.person;
        final typeLabel = report['type'] == 'question'
            ? 'سؤال'
            : report['type'] == 'comment'
                ? 'تعليق'
                : 'مستخدم';

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(typeIcon, size: 20, color: AppColors.orange),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(typeLabel, style: const TextStyle(fontSize: 11, color: AppColors.orange)),
                    ),
                    const Spacer(),
                    Text(report['reporter'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('السبب: ${report['reason']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report['contentPreview'] as String,
                    style: const TextStyle(color: AppColors.grey),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (report['status'] == 'pending') ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('قبول'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.green),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.cancel, size: 18),
                        label: const Text('رفض'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.orange),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('حذف'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.red),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

const List<Map<String, dynamic>> _reports = [
  {
    'type': 'question',
    'reporter': 'أحمد',
    'reason': 'محتوى غير لائق',
    'contentPreview': 'ما هو لون السماء؟ هذا السؤال يحتوي على...',
    'status': 'pending',
  },
  {
    'type': 'comment',
    'reporter': 'سارة',
    'reason': 'لغة مسيئة',
    'contentPreview': 'هذا التعليق يحتوي على كلمات غير...',
    'status': 'pending',
  },
  {
    'type': 'user',
    'reporter': 'محمد',
    'reason': 'اسم مستخدم غير مناسب',
    'contentPreview': 'المستخدم: @xxx_123 تم الإبلاغ عنه من قبل عدة...',
    'status': 'resolved',
  },
  {
    'type': 'question',
    'reporter': 'نورة',
    'reason': 'إجابة خاطئة',
    'contentPreview': 'السؤال يحتوي على إجابة غير صحيحة...',
    'status': 'pending',
  },
  {
    'type': 'comment',
    'reporter': 'خالد',
    'reason': 'سبام',
    'contentPreview': 'رابط مشبوه في التعليق...',
    'status': 'resolved',
  },
];
