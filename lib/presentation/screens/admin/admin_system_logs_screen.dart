import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminSystemLogsScreen extends ConsumerWidget {
  const AdminSystemLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجلات النظام'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (_) {},
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('الكل')),
              const PopupMenuItem(value: 'info', child: Text('معلومات')),
              const PopupMenuItem(value: 'warning', child: Text('تحذيرات')),
              const PopupMenuItem(value: 'error', child: Text('أخطاء')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          final log = _logs[index];
          final level = log['level'] as String;
          final Color levelColor;
          final Color bgColor;
          final String levelLabel;

          switch (level) {
            case 'error':
              levelColor = AppColors.red;
              bgColor = AppColors.red.withValues(alpha: 0.15);
              levelLabel = 'خطأ';
            case 'warning':
              levelColor = AppColors.orange;
              bgColor = AppColors.orange.withValues(alpha: 0.15);
              levelLabel = 'تحذير';
            default:
              levelColor = AppColors.green;
              bgColor = AppColors.green.withValues(alpha: 0.15);
              levelLabel = 'معلومات';
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 6),
            color: bgColor,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: levelColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(levelLabel,
                            style: TextStyle(fontSize: 10, color: levelColor, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text(log['timestamp'] as String,
                          style: const TextStyle(color: AppColors.grey, fontSize: 11, fontFamily: 'monospace')),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    log['message'] as String,
                    style: TextStyle(
                      color: levelColor,
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

const List<Map<String, dynamic>> _logs = [
  {
    'timestamp': '2025-01-15 14:32:18',
    'level': 'info',
    'message': 'تم بدء تشغيل الخادم بنجاح على المنفذ 8080',
  },
  {
    'timestamp': '2025-01-15 14:32:20',
    'level': 'info',
    'message': 'تم الاتصال بقاعدة البيانات بنجاح',
  },
  {
    'timestamp': '2025-01-15 14:35:42',
    'level': 'warning',
    'message': 'ارتفاع استخدام الذاكرة: 85% من الحد المسموح',
  },
  {
    'timestamp': '2025-01-15 14:36:01',
    'level': 'error',
    'message': 'فشل الاتصال بخدمة الدفع: HTTP 503 Service Unavailable',
  },
  {
    'timestamp': '2025-01-15 14:36:15',
    'level': 'info',
    'message': 'إعادة محاولة الاتصال بخدمة الدفع...',
  },
  {
    'timestamp': '2025-01-15 14:40:00',
    'level': 'warning',
    'message': 'طلب API بطيء: 4.2 ثانية (المستخدم: أحمد)',
  },
  {
    'timestamp': '2025-01-15 14:45:30',
    'level': 'error',
    'message': 'استثناء غير معالج: NullReferenceException في وحدة المصادقة',
  },
  {
    'timestamp': '2025-01-15 14:50:12',
    'level': 'info',
    'message': 'تم تحديث 150 سجلاً في قاعدة البيانات',
  },
  {
    'timestamp': '2025-01-15 14:55:00',
    'level': 'error',
    'message': 'فشل تحميل الصورة: الملف غير موجود في المسار /uploads/...',
  },
  {
    'timestamp': '2025-01-15 15:00:00',
    'level': 'info',
    'message': 'اكتمال عملية النسخ الاحتياطي اليومي بنجاح',
  },
];
