import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminAchievementsScreen extends ConsumerWidget {
  const AdminAchievementsScreen({super.key});

  static const List<_Achievement> _achievements = [
    _Achievement(name: 'البداية', description: 'أجب على أول سؤال صحيح', icon: Icons.star, xp: 50, progress: 1),
    _Achievement(name: 'المحترف', description: 'أجب على 100 سؤال صحيح', icon: Icons.military_tech, xp: 500, progress: 100),
    _Achievement(name: 'السرعة الخاطفة', description: 'أجب على 10 أسئلة في أقل من 5 ثوانٍ', icon: Icons.bolt, xp: 300, progress: 10),
    _Achievement(name: 'الجامع', description: 'اجمع 1000 نقطة', icon: Icons.diamond, xp: 200, progress: 1000),
    _Achievement(name: 'المثابر', description: 'لعب 50 مباراة', icon: Icons.assignment, xp: 400, progress: 50),
    _Achievement(name: 'المتحدي', description: 'تغلب على الزعيم', icon: Icons.dangerous, xp: 1000, progress: 1),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الإنجازات'),
        backgroundColor: AppColors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _achievements.length,
        itemBuilder: (context, index) {
          final a = _achievements[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                child: Icon(a.icon, color: AppColors.gold),
              ),
              title: Text(a.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${a.description}\n${a.xp} XP • ${a.progress} مطلوب'),
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

class _Achievement {
  final String name;
  final String description;
  final IconData icon;
  final int xp;
  final int progress;

  const _Achievement({
    required this.name,
    required this.description,
    required this.icon,
    required this.xp,
    required this.progress,
  });
}
