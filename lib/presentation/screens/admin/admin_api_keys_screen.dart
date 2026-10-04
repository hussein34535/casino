import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminApiKeysScreen extends ConsumerWidget {
  const AdminApiKeysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مفاتيح API'),
        backgroundColor: AppColors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _apiKeys.length,
        itemBuilder: (context, index) {
          final key = _apiKeys[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(key['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: key['active'] as bool ? AppColors.green.withValues(alpha: 0.3) : AppColors.red.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          key['active'] as bool ? 'نشط' : 'ملغي',
                          style: TextStyle(
                            fontSize: 12,
                            color: key['active'] as bool ? AppColors.green : AppColors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            key['maskedKey'] as String,
                            style: TextStyle(fontFamily: 'monospace', color: AppColors.grey),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ المفتاح')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text('تاريخ الإنشاء: ${key['created']}', style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          key['active'] as bool ? Icons.block : Icons.check_circle,
                          color: key['active'] as bool ? AppColors.red : AppColors.green,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.teal,
        icon: const Icon(Icons.add),
        label: const Text('إضافة مفتاح'),
      ),
    );
  }
}

const List<Map<String, dynamic>> _apiKeys = [
  {
    'name': 'مفتاح الإنتاج',
    'maskedKey': 'sk-••••••••a1b2',
    'active': true,
    'created': '2025-01-15',
  },
  {
    'name': 'مفتاح التطوير',
    'maskedKey': 'sk-••••••••c3d4',
    'active': true,
    'created': '2025-02-20',
  },
  {
    'name': 'مفتاح الاختبار',
    'maskedKey': 'sk-••••••••e5f6',
    'active': false,
    'created': '2025-03-10',
  },
];
