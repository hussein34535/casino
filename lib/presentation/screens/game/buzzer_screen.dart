import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

final buzzerPlayersProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);
final isBuzzerActiveProvider = StateProvider<bool>((ref) => true);

class BuzzerScreen extends ConsumerStatefulWidget {
  const BuzzerScreen({super.key});

  @override
  ConsumerState<BuzzerScreen> createState() => _BuzzerScreenState();
}

class _BuzzerScreenState extends ConsumerState<BuzzerScreen> {
  bool isHost = false;
  String? playerName;

  @override
  Widget build(BuildContext context) {
    if (!isHost && playerName == null) return _buildJoinScreen();

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.red,
        elevation: 0,
        title: Text(isHost ? '🎛️ شاشة التحكم (Host)' : '⚡ جرس المسابقة',
          style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
        actions: isHost ? [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => ref.read(buzzerPlayersProvider.notifier).state = [],
              child: const ComicTag(label: '↺ Reset', color: ComicColors.yellow),
            ),
          ),
        ] : null,
      ),
      body: isHost ? _buildHostView() : _buildPlayerView(),
    );
  }

  Widget _buildJoinScreen() {
    final nameController = TextEditingController();
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        backgroundColor: ComicColors.red,
        elevation: 0,
        title: const Text('⚡ نظام الجرس', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: ComicBackground(
        bgColor: const Color(0xFFFFF5F5),
        dotColor: ComicColors.red,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⚡', style: TextStyle(fontSize: 80))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(duration: 1.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
              const SizedBox(height: 24),
              ComicCard(
                color: ComicColors.yellow,
                child: const Text('اختار دورك في المسابقة! 👇',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: ComicColors.black),
                  textAlign: TextAlign.center),
              ),
              const SizedBox(height: 24),
              ComicButton(
                label: '🎛️ أنا صاحب المسابقة (Host)',
                color: ComicColors.blue,
                textColor: Colors.white,
                onTap: () => setState(() => isHost = true),
                shadowOffset: 6,
              ),
              const SizedBox(height: 24),
              ComicCard(
                color: Colors.white,
                child: Column(
                  children: [
                    const Text('أو انضم كلاعب:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: ComicColors.black)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: ComicColors.black),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'أدخل اسمك هنا...',
                        hintStyle: const TextStyle(color: Colors.black45),
                        filled: true, fillColor: ComicColors.cream,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.black, width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.red, width: 2.5)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ComicButton(
                      label: '⚡ انضم كلاعب!',
                      color: ComicColors.red,
                      textColor: Colors.white,
                      onTap: () {
                        if (nameController.text.isNotEmpty) setState(() => playerName = nameController.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHostView() {
    final buzzedPlayers = ref.watch(buzzerPlayersProvider);
    return ComicBackground(
      bgColor: const Color(0xFFFFF5F5),
      dotColor: ComicColors.red,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ComicCard(
              color: buzzedPlayers.isEmpty ? ComicColors.yellow : ComicColors.green,
              shadowOffset: 7,
              child: Column(
                children: [
                  const Text('⚡ اللاعب الأسرع:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ComicColors.black)),
                  const SizedBox(height: 8),
                  if (buzzedPlayers.isEmpty)
                    const Text('بانتظار الضغط... 👀', style: TextStyle(fontSize: 22, color: ComicColors.black, fontWeight: FontWeight.w900))
                  else
                    Text(buzzedPlayers.first['name'],
                      style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w900)
                    ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: buzzedPlayers.length,
              itemBuilder: (context, index) {
                final p = buzzedPlayers[index];
                const rankEmojis = ['🥇', '🥈', '🥉'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ComicCard(
                    color: index == 0 ? ComicColors.yellow : Colors.white,
                    shadowOffset: index == 0 ? 6 : 4,
                    child: Row(
                      children: [
                        Text(index < 3 ? rankEmojis[index] : '${index + 1}.', style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(child: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: ComicColors.black))),
                        ComicTag(label: '+${p['time']}ms', color: ComicColors.blue, textColor: Colors.white),
                      ],
                    ),
                  ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.1, end: 0),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ComicButton(
              label: '↺ إعادة تعيين الجرس',
              color: ComicColors.orange,
              textColor: Colors.white,
              onTap: () {
                ref.read(buzzerPlayersProvider.notifier).state = [];
                ref.read(isBuzzerActiveProvider.notifier).state = true;
              },
              shadowOffset: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerView() {
    final isActive = ref.watch(isBuzzerActiveProvider);
    final buzzedPlayers = ref.watch(buzzerPlayersProvider);
    final hasBuzzed = buzzedPlayers.any((p) => p['name'] == playerName);

    return ComicBackground(
      bgColor: hasBuzzed ? const Color(0xFFE8FFE8) : const Color(0xFFFFF5F5),
      dotColor: hasBuzzed ? ComicColors.green : ComicColors.red,
      child: GestureDetector(
        onTap: () {
          if (isActive && !hasBuzzed) {
            final now = DateTime.now().millisecondsSinceEpoch;
            ref.read(buzzerPlayersProvider.notifier).update((state) => [
              ...state,
              {'name': playerName, 'time': state.isEmpty ? 0 : now % 1000}
            ]);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BIG COMIC BUZZER BUTTON
              Stack(
                alignment: Alignment.center,
                children: [
                  if (!hasBuzzed) ...[
                    Container(
                      width: 280, height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ComicColors.red.withValues(alpha: 0.3), width: 3),
                      ),
                    ).animate(onPlay: (c) => c.repeat()).scale(duration: 1.5.seconds).fadeOut(),
                    Container(
                      width: 220, height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ComicColors.red.withValues(alpha: 0.5), width: 4),
                      ),
                    ).animate(onPlay: (c) => c.repeat()).scale(duration: 1.2.seconds).fadeOut(),
                  ],
                  // Big circular button
                  Container(
                    width: 180, height: 180,
                    decoration: BoxDecoration(
                      color: hasBuzzed ? ComicColors.green : ComicColors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: ComicColors.black, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: ComicColors.black,
                          offset: hasBuzzed ? const Offset(0, 0) : const Offset(8, 8),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(hasBuzzed ? '✅' : '⚡', style: const TextStyle(fontSize: 72)),
                    ),
                  ).animate(target: hasBuzzed ? 1 : 0).custom(
                    duration: 100.ms,
                    builder: (context, value, child) => Transform.translate(
                      offset: Offset(value * 8, value * 8),
                      child: child,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ComicCard(
                color: hasBuzzed ? ComicColors.green : ComicColors.red,
                shadowOffset: 6,
                child: Text(
                  hasBuzzed ? '✅ تم تسجيل ضغطتك!' : '👆 اضغط الجرس الآن!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ).animate(target: hasBuzzed ? 1 : 0).shake(),
              if (!hasBuzzed) ...[
                const SizedBox(height: 16),
                ComicTag(label: 'أسرع واحد بيكسب الجولة 🏆', color: ComicColors.yellow),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
