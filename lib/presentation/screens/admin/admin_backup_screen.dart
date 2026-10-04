import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminBackupScreen extends ConsumerWidget {
  const AdminBackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي'),
        backgroundColor: AppColors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.backup, size: 64, color: AppColors.teal),
                  const SizedBox(height: 12),
                  const Text('آخر نسخة احتياطية', style: TextStyle(fontSize: 14, color: AppColors.grey)),
                  const SizedBox(height: 4),
                  const Text('2025-01-15 03:00:00 صباحاً',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.outline)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('إنشاء نسخة احتياطية'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: AppColors.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.restore),
                          label: const Text('استعادة من نسخة'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.teal,
                            side: const BorderSide(color: AppColors.teal),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.schedule),
                          label: const Text('جدولة النسخ الاحتياطي'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.yellow,
                            side: const BorderSide(color: AppColors.yellow),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('النسخ الاحتياطية السابقة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._backups.map((backup) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.backup_table, color: AppColors.teal),
                  title: Text(backup['name'] as String),
                  subtitle: Text('${backup['size']} • ${backup['date']}',
                      style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.restore, color: AppColors.green),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.red),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

const List<Map<String, dynamic>> _backups = [
  {'name': 'full_backup_2025-01-15', 'size': '2.4 GB', 'date': '2025-01-15 03:00'},
  {'name': 'full_backup_2025-01-14', 'size': '2.3 GB', 'date': '2025-01-14 03:00'},
  {'name': 'full_backup_2025-01-13', 'size': '2.3 GB', 'date': '2025-01-13 03:00'},
  {'name': 'full_backup_2025-01-12', 'size': '2.2 GB', 'date': '2025-01-12 03:00'},
  {'name': 'full_backup_2025-01-11', 'size': '2.2 GB', 'date': '2025-01-11 03:00'},
];
