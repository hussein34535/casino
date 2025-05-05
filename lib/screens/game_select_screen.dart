import 'package:flutter/material.dart';
import 'package:game_show_app/models/game_type.dart';
import 'package:game_show_app/providers/game_provider.dart';
import 'package:game_show_app/screens/game_screen.dart';
// import 'package:game_show_app/screens/home_screen.dart'; // Not needed directly here anymore
import 'package:provider/provider.dart';
// Removed flutter_animate import as animations are removed

// استيراد الألوان المعرفة في main.dart (للون الحدود)
// ملاحظة: الطريقة الأفضل هي تمرير الألوان عبر الـ Theme،
// لكن للاختصار الآن سنعيد تعريف اللون هنا.
const Color netflixLightGrey = Color(0xFF808080);

// Re-add the gradients map
const Map<GameType, List<Color>> gameTypeBackgroundGradients = {
  GameType.trivia: [
    Color(0xFF1A237E),
    Color(0xFF3F51B5)
  ], // Dark Blue -> Indigo
  GameType.movies: [
    Color(0xFF4A148C),
    Color(0xFF7B1FA2)
  ], // Purple -> Dark Purple
  GameType.music: [Color(0xFF004D40), Color(0xFF00796B)], // Teal -> Dark Teal
  GameType.puzzles: [
    Color(0xFFBF360C),
    Color(0xFFF4511E)
  ], // Deep Orange -> Orange
  GameType.words: [Color(0xFFFF6F00), Color(0xFFFFB300)], // Amber -> Yellow
};

class GameSelectScreen extends StatelessWidget {
  final bool isChangingType;

  const GameSelectScreen({super.key, this.isChangingType = false});

  // قائمة أيقونات اختيارية لكل نوع لعبة
  final Map<GameType, IconData> gameTypeIcons = const {
    GameType.trivia: Icons.lightbulb_outline,
    GameType.movies: Icons.theaters_outlined,
    GameType.music: Icons.music_note_outlined,
    GameType.puzzles: Icons.extension_outlined,
    GameType.words: Icons.text_fields_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final availableGameTypes = GameType.values; // الحصول على كل أنواع الألعاب
    // Removed unused screenSize, cardWidth, cardHeight, horizontalPadding

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر نوع التحدي'),
        centerTitle: true,
        // Revert to default AppBar appearance
        // elevation: 0,
        // backgroundColor: Colors.transparent,
      ),
      // Removed extendBodyBehindAppBar
      body: GridView.builder(
        // Back to GridView
        padding: const EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 10.0), // Minimal padding for GridView
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 15.0, // Spacing between columns
          mainAxisSpacing: 15.0, // Spacing between rows
          childAspectRatio: 1.0, // Keep square aspect ratio
        ),
        itemCount: availableGameTypes.length,
        itemBuilder: (context, index) {
          final gameType = availableGameTypes[index];
          final typeName = getGameTypeNameAr(gameType);
          final typeIcon = gameTypeIcons[gameType] ?? Icons.category;
          final gradientColors = gameTypeBackgroundGradients[gameType] ??
              [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0.7)
              ];

          return GameTypeCard(
            icon: typeIcon,
            label: typeName,
            gradientColors: gradientColors,
            onTap: () {
              gameProvider.selectGameType(gameType);
              if (isChangingType) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

// --- Keep square Game Type Card Widget ---
class GameTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const GameTypeCard({
    super.key,
    required this.icon,
    required this.label,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const double cardSize = 150.0; // Keep fixed size for square card

    return SizedBox(
      width: cardSize,
      height: cardSize,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20.0)), // Back to more rounded corners
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              // Back to Column
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 45, color: Colors.white),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
