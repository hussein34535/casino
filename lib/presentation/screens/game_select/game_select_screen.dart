import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class GameSelectScreen extends ConsumerWidget {
  final bool isChangingType;
  const GameSelectScreen({super.key, this.isChangingType = false});

  static const List<Map<String, dynamic>> _categories = [
    {'type': 'trivia',     'label': 'معلومات عامة',    'emoji': '🧠', 'color': Color(0xFFFFD600)},
    {'type': 'movies',     'label': 'أفلام ومسلسلات',  'emoji': '🎬', 'color': Color(0xFF00C2FF)},
    {'type': 'music',      'label': 'موسيقى',           'emoji': '🎵', 'color': Color(0xFF8B2BE2)},
    {'type': 'puzzles',    'label': 'ألغاز وأحاجي',    'emoji': '🧩', 'color': Color(0xFFFF6B00)},
    {'type': 'words',      'label': 'كلمات',            'emoji': '📝', 'color': Color(0xFF00D26A)},
    {'type': 'science',    'label': 'علوم',             'emoji': '🔬', 'color': Color(0xFF0066FF)},
    {'type': 'history',    'label': 'تاريخ',            'emoji': '🏛️', 'color': Color(0xFFFF1F4B)},
    {'type': 'sports',     'label': 'رياضة',            'emoji': '⚽', 'color': Color(0xFF00D26A)},
    {'type': 'technology', 'label': 'تكنولوجيا',        'emoji': '💻', 'color': Color(0xFF00C2FF)},
    {'type': 'geography',  'label': 'جغرافيا',          'emoji': '🌍', 'color': Color(0xFF00C2FF)},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.purple,
        elevation: 0,
        title: const Text('🎯 اختر فئة الأسئلة', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
        actions: [
          if (isChangingType)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: const ComicTag(label: '← رجوع', color: ComicColors.yellow),
              ),
            ),
        ],
      ),
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.purple,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ComicCard(
                color: ComicColors.purple,
                child: const Row(
                  children: [
                    Text('🎮', style: TextStyle(fontSize: 36)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('اختار موضوع اللعبة!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                          Text('كل موضوع فيه أسئلة ناارة 🔥', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final color = cat['color'] as Color;
                  return ComicCard(
                    color: color,
                    onTap: () async {
                      await ref.read(gameStateProvider.notifier).selectGameType(cat['type'] as String);
                      if (isChangingType) {
                        if (context.mounted) context.pop();
                      } else {
                        if (context.mounted) context.push('/game-select/${cat['type']}');
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat['emoji'] as String, style: const TextStyle(fontSize: 44))
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
                        const SizedBox(height: 10),
                        Text(cat['label'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white), textAlign: TextAlign.center),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 60).ms).scale(begin: const Offset(0.85, 0.85), duration: 400.ms, curve: Curves.easeOutBack);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
