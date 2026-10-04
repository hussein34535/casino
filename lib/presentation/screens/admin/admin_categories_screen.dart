import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  static const List<_Category> _categories = [
    _Category(name: 'تريفيا', questions: 1520, status: 'نشط', icon: Icons.lightbulb),
    _Category(name: 'أفلام', questions: 890, status: 'نشط', icon: Icons.movie),
    _Category(name: 'موسيقى', questions: 675, status: 'نشط', icon: Icons.music_note),
    _Category(name: 'ألغاز', questions: 430, status: 'غير نشط', icon: Icons.extension),
    _Category(name: 'كلمات', questions: 1120, status: 'نشط', icon: Icons.short_text),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفئات'),
        backgroundColor: AppColors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isActive = cat.status == 'نشط';
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.yellow.withValues(alpha: 0.2),
                child: Icon(cat.icon, color: AppColors.yellow),
              ),
              title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${cat.questions} سؤال • ${cat.status}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.teal),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.red),
                    onPressed: () {},
                  ),
                  Switch(
                    value: isActive,
                    activeThumbColor: AppColors.green,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.outline,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Category {
  final String name;
  final int questions;
  final String status;
  final IconData icon;

  const _Category({
    required this.name,
    required this.questions,
    required this.status,
    required this.icon,
  });
}
