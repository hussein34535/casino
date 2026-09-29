import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_show_app/core/design/game_categories.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class LocalSetupScreen extends ConsumerStatefulWidget {
  const LocalSetupScreen({super.key});

  @override
  ConsumerState<LocalSetupScreen> createState() => _LocalSetupScreenState();
}

class _LocalSetupScreenState extends ConsumerState<LocalSetupScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(text: 'لاعب 1'),
    TextEditingController(text: 'لاعب 2'),
  ];
  final Set<String> _selectedCategories = {'trivia'};
  bool _playAgainstBot = false;
  String _botDifficulty = 'medium';

  static const _botLevels = {
    'easy': ('sparkles', 'مبتدئ AI'),
    'medium': ('brain', 'باحث AI'),
    'hard': ('zap', 'عبقري AI'),
    'elon': ('crown', 'إيلون AI'),
  };

  void _addPlayer() {
    if (_controllers.length >= 10) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _controllers.add(TextEditingController(text: 'لاعب ${_controllers.length + 1}'));
    });
  }

  void _removePlayer(int index) {
    if (_controllers.length <= 2) return;
    HapticFeedback.lightImpact();
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _startGame() async {
    if (_selectedCategories.isEmpty) return;

    final notifier = ref.read(gameStateProvider.notifier);

    if (_playAgainstBot) {
      final playerName = _controllers.isNotEmpty ? _controllers.first.text.trim() : 'لاعب 1';
      if (playerName.isEmpty) return;
      final botName = _botLevels[_botDifficulty]!.$2;
      notifier.setPlayersWithBot(playerName, botName, _botDifficulty);
    } else {
      final names = _controllers.map((c) => c.text.trim()).where((n) => n.isNotEmpty).toList();
      if (names.length < 2) return;
      notifier.setPlayers(names);
    }

    await notifier.initializeGame(_selectedCategories.toList());
    
    if (mounted) {
      final type = _selectedCategories.first;
      context.push('/game-select/$type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: AppBar(
        backgroundColor: ComicColors.green,
        elevation: 0,
        title: const Text('👥 تجهيز اللعب المحلي',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: ComicBackground(
        bgColor: const Color(0xFFF0F7FF),
        dotColor: ComicColors.green,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Game Type Selection
              const Text('🎮 اختر نوع اللعبة',
                  style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black, fontSize: 18)),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: gameCategories.map((cat) {
                    final isSelected = _selectedCategories.contains(cat.id);
                    return Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            if (isSelected) {
                              if (_selectedCategories.length > 1) {
                                _selectedCategories.remove(cat.id);
                              }
                            } else {
                              _selectedCategories.add(cat.id);
                            }
                          });
                        },
                        child: ComicCard(
                          color: isSelected ? ComicColors.green : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shadowOffset: isSelected ? 4 : 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: cat.color.withValues(
                                      alpha: isSelected ? 0.25 : 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: XoIcon(cat.icon,
                                    size: 24,
                                    color: isSelected ? Colors.white : cat.color),
                              ),
                              const SizedBox(height: 4),
                              Text(cat.titleAr, style: TextStyle(fontWeight: FontWeight.w900, color: isSelected ? Colors.white : ComicColors.black, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),

              // Bot Toggle
              ComicCard(
                color: _playAgainstBot ? ComicColors.blue : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shadowOffset: _playAgainstBot ? 4 : 2,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ComicColors.purple.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const XoIcon('brain',
                          size: 26, color: ComicColors.purple),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'العب ضد الذكاء الاصطناعي',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: _playAgainstBot ? Colors.white : ComicColors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _playAgainstBot ? 'البوت نشط - اختر الصعوبة أسفله' : 'فعّل للعب ضد بوت',
                            style: TextStyle(
                              color: _playAgainstBot ? Colors.white70 : ComicColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _playAgainstBot,
                      onChanged: (val) {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _playAgainstBot = val;
                          if (val && _controllers.length > 2) {
                            // Remove extra players when bot is enabled
                            while (_controllers.length > 2) {
                              _controllers.last.dispose();
                              _controllers.removeLast();
                            }
                          }
                        });
                      },
                      activeThumbColor: Colors.white,
                      activeTrackColor: ComicColors.green,
                    ),
                  ],
                ),
              ),

              // Bot Difficulty Selection
              if (_playAgainstBot) ...[
                const SizedBox(height: 12),
                const Row(
                  children: [
                    XoIcon('zap', size: 18, color: ComicColors.black),
                    SizedBox(width: 6),
                    Text('صعوبة البوت',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ComicColors.black,
                            fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 92,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _botLevels.entries.map((entry) {
                      final isSelected = _botDifficulty == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12, bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _botDifficulty = entry.key);
                          },
                          child: ComicCard(
                            color: isSelected ? ComicColors.orange : Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shadowOffset: isSelected ? 4 : 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                XoIcon(entry.value.$1,
                                    size: 24,
                                    color: isSelected
                                        ? Colors.white
                                        : ComicColors.orange),
                                const SizedBox(height: 4),
                                Text(entry.value.$2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: isSelected ? Colors.white : ComicColors.black,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              const SizedBox(height: 32),
              
              // Players List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      XoIcon('users', size: 20, color: ComicColors.black),
                      SizedBox(width: 6),
                      Text('أسماء اللاعبين',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: ComicColors.black,
                              fontSize: 18)),
                    ],
                  ),
                  GestureDetector(
                    onTap: _addPlayer,
                    child: const ComicTag(label: '+ إضافة لاعب', color: ComicColors.yellow),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._controllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ComicCard(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          shadowOffset: 3,
                          child: TextField(
                            controller: controller,
                            style: const TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'اسم اللاعب ${index + 1}',
                              prefixIcon: const Icon(Icons.person, color: ComicColors.black),
                            ),
                          ),
                        ),
                      ),
                      if (_controllers.length > 2) ...[
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _removePlayer(index),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ComicColors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: ComicColors.black, width: 2),
                              boxShadow: const [BoxShadow(color: ComicColors.black, offset: Offset(2, 2))],
                            ),
                            child: const Icon(Icons.delete_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ],
                  ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, end: 0),
                );
              }),

              const SizedBox(height: 40),
              ComicButton(
                label: '🚀 ابدأ اللعب!',
                color: ComicColors.yellow,
                onTap: _startGame,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
