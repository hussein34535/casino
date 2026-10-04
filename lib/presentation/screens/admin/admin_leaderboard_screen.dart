import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminLeaderboardScreen extends ConsumerWidget {
  const AdminLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة لوحة المتصدرين'),
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.outline,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _periodChip('يومي', 'daily'),
                  _periodChip('أسبوعي', 'weekly'),
                  _periodChip('شهري', 'monthly'),
                  _periodChip('كل الأوقات', 'all'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_sweep, size: 18),
                  label: const Text('إعادة تعيين'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                  ),
                ),
                const Spacer(),
                Text('${_leaderboard.length} لاعب', style: const TextStyle(color: AppColors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                final entry = _leaderboard[index];
                final rank = index + 1;
                final IconData medal;
                final Color medalColor;

                if (rank == 1) {
                  medal = Icons.emoji_events;
                  medalColor = AppColors.gold;
                } else if (rank == 2) {
                  medal = Icons.emoji_events;
                  medalColor = const Color(0xFFC0C0C0);
                } else if (rank == 3) {
                  medal = Icons.emoji_events;
                  medalColor = const Color(0xFFCD7F32);
                } else {
                  medal = Icons.circle;
                  medalColor = AppColors.grey;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: rank <= 3 ? medalColor.withValues(alpha: 0.3) : AppColors.grey.withValues(alpha: 0.2),
                      child: rank <= 3
                          ? Icon(medal, color: medalColor, size: 24)
                          : Text('$rank', style: const TextStyle(color: AppColors.grey)),
                    ),
                    title: Text(entry['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(entry['title'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(entry['score'] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.orange)),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.red, size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: value == 'all',
        selectedColor: AppColors.gold,
        labelStyle: const TextStyle(color: AppColors.outline),
      ),
    );
  }
}

const List<Map<String, dynamic>> _leaderboard = [
  {'name': 'أحمد الأسطورة', 'title': 'المتحدي الأول', 'score': '15,230'},
  {'name': 'سارة المتألقة', 'title': 'نجمة اللعبة', 'score': '14,850'},
  {'name': 'محمد العبقري', 'title': 'صاحب الذهب', 'score': '14,120'},
  {'name': 'نورة البطلة', 'title': 'متسابقة محترفة', 'score': '13,500'},
  {'name': 'خالد الفائز', 'title': 'لاعب متميز', 'score': '12,800'},
  {'name': 'فاطمة الماهرة', 'title': 'متحدية', 'score': '12,100'},
  {'name': 'عمر السريع', 'title': 'لاعب نشط', 'score': '11,450'},
  {'name': 'ليلى الذكية', 'title': 'عبقرية الأسئلة', 'score': '10,900'},
  {'name': 'يوسف المحترف', 'title': 'متسابق محترف', 'score': '10,200'},
  {'name': 'هند الجميلة', 'title': 'نجمة صاعدة', 'score': '9,800'},
];
