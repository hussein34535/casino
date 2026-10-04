import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

/// MapScreen — Stub UI until flutter_map & latlong2 are added to pubspec.yaml
/// To activate: run `flutter pub add flutter_map latlong2` then restore FlutterMap widget.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const _liveGames = [
    {'city': 'القاهرة 🇪🇬',  'game': 'لعبة مباشرة #102', 'players': '24'},
    {'city': 'دبي 🇦🇪',       'game': 'تحدي الكازينو',    'players': '18'},
    {'city': 'الرياض 🇸🇦',   'game': 'بطولة XO',          'players': '31'},
    {'city': 'بيروت 🇱🇧',    'game': 'ثقافة عامة LIVE',  'players': '12'},
    {'city': 'الكويت 🇰🇼',   'game': 'رياضة كأس الخليج', 'players': '9'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.blue,
        elevation: 0,
        title: const Text('🗺️ خريطة الألعاب', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.skyBlue,
        child: Column(
          children: [
            // Map placeholder banner
            Padding(
              padding: const EdgeInsets.all(16),
              child: ComicCard(
                color: ComicColors.skyBlue,
                child: Row(
                  children: [
                    const Text('🌍', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ألعاب مباشرة حول العالم!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ComicColors.black)),
                          Text('انضم لأي لعبة في أي مدينة 🚀', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                    ComicBadge(text: '${_liveGames.length}', color: ComicColors.red),
                  ],
                ),
              ),
            ),
            // Live games list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _liveGames.length,
                itemBuilder: (context, index) {
                  final game = _liveGames[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ComicCard(
                      color: Colors.white,
                      onTap: () {},
                      child: Row(
                        children: [
                          // Pulsing live dot
                          Container(
                            width: 12, height: 12,
                            decoration: const BoxDecoration(color: ComicColors.red, shape: BoxShape.circle),
                          ).animate(onPlay: (c) => c.repeat()).fadeOut(duration: 800.ms),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(game['city']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ComicColors.black)),
                                Text(game['game']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black54)),
                              ],
                            ),
                          ),
                          ComicTag(
                            label: '👥 ${game['players']}',
                            color: ComicColors.green,
                            textColor: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ComicColors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: ComicColors.black, width: 2),
                              boxShadow: const [BoxShadow(color: ComicColors.black, offset: Offset(2, 2), blurRadius: 0)],
                            ),
                            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.1, end: 0),
                  );
                },
              ),
            ),
            // Bottom hint
            Padding(
              padding: const EdgeInsets.all(16),
              child: ComicCard(
                color: ComicColors.yellow,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('💡 ', style: TextStyle(fontSize: 18)),
                    Text('الخريطة التفاعلية قريباً! 🗺️', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
