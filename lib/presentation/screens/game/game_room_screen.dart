import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/design/game_categories.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';
import 'package:game_show_app/presentation/providers/room_provider.dart';
import 'package:game_show_app/presentation/widgets/common/xo_avatar.dart';

// ─── Create Room Screen ──────────────────────────────────────────────────────

class CreateRoomScreen extends ConsumerStatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  final Set<String> _selectedCategories = {'trivia'};
  int _maxPlayers = 4;
  bool _isPublic = true;
  bool _isCreating = false;

  Future<void> _createRoom() async {
    if (_selectedCategories.isEmpty || _isCreating) return;
    if (ref.read(authStateProvider).value == null) {
      showComicSnack(context, 'لازم تسجّل دخولك الأول قبل إنشاء غرفة', error: true);
      context.push('/login');
      return;
    }
    setState(() => _isCreating = true);
    try {
      await ref.read(roomNotifierProvider.notifier).createRoom(
            categories: _selectedCategories.toList(),
            maxPlayers: _maxPlayers,
            isPublic: _isPublic,
          );
      if (mounted) context.push('/waiting-room');
    } catch (e) {
      if (mounted) showComicSnack(context, 'خطأ: $e', error: true);
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);
    if (!authAsync.hasValue) {
      return const _ComicScaffold(
        title: 'إنشاء غرفة',
        emoji: '➕',
        body: Center(
          child: CircularProgressIndicator(color: ComicColors.blue),
        ),
      );
    }
    if (authAsync.value == null) {
      return _ComicScaffold(
        title: 'إنشاء غرفة',
        emoji: '➕',
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ComicCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const XoIcon('lock', color: ComicColors.orange, size: 44),
                  const SizedBox(height: 16),
                  const Text('سجّل دخولك الأول',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w900, color: ComicColors.black)),
                  const SizedBox(height: 8),
                  const Text('الحساب مطلوب لإنشاء غرفة أونلاين',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ComicColors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  ComicButton(
                    label: 'تسجيل الدخول',
                    color: ComicColors.blue,
                    textColor: Colors.white,
                    onTap: () => context.push('/login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return _ComicScaffold(
      title: 'إنشاء غرفة',
      emoji: '➕',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('اختر أنواع الأسئلة',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900, color: ComicColors.black)),
            const SizedBox(height: 4),
            const Text('يمكنك اختيار أكثر من نوع',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: ComicColors.grey)),
            const SizedBox(height: 14),
            ...gameCategories.map((cat) {
              final selected = _selectedCategories.contains(cat.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CategoryTile(
                  category: cat,
                  selected: selected,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (selected) {
                        if (_selectedCategories.length > 1) {
                          _selectedCategories.remove(cat.id);
                        }
                      } else {
                        _selectedCategories.add(cat.id);
                      }
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            const Text('أقصى عدد للاعبين',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900, color: ComicColors.black)),
            const SizedBox(height: 4),
            const Text('من 2 لـ 5 لاعبين',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: ComicColors.grey)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ComicColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ComicColors.black, width: 3),
                boxShadow: const [
                  BoxShadow(color: ComicColors.black, offset: Offset(4, 4), blurRadius: 0),
                ],
              ),
              child: Row(
                children: [
                  _StepperButton(
                    icon: 'minus',
                    enabled: _maxPlayers > 2,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _maxPlayers = (_maxPlayers - 1).clamp(2, 5));
                    },
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          transitionBuilder: (child, anim) => ScaleTransition(
                              scale: anim, child: child),
                          child: Text(
                            '$_maxPlayers',
                            key: ValueKey(_maxPlayers),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              color: ComicColors.blue,
                            ),
                          ),
                        ),
                        const Text(
                          'لاعبين',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: ComicColors.grey),
                        ),
                      ],
                    ),
                  ),
                  _StepperButton(
                    icon: 'plus',
                    enabled: _maxPlayers < 5,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _maxPlayers = (_maxPlayers + 1).clamp(2, 5));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('ظهور الغرفة',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900, color: ComicColors.black)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _VisibilityOption(
                    selected: _isPublic,
                    icon: 'users',
                    title: 'عامة',
                    subtitle: 'تظهر في البحث',
                    onTap: () => setState(() => _isPublic = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _VisibilityOption(
                    selected: !_isPublic,
                    icon: 'lock',
                    title: 'خاصة',
                    subtitle: 'بالكود فقط',
                    onTap: () => setState(() => _isPublic = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ComicButton(
              label: _isCreating ? 'جارٍ الإنشاء...' : 'إنشاء الغرفة',
              onTap: _isCreating ? () {} : _createRoom,
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => context.push('/online'),
                child: const Text(
                  'عندك كود؟ انضم لغرفة موجودة',
                  style: TextStyle(
                      color: ComicColors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  final bool selected;
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _VisibilityOption({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? ComicColors.yellow : ComicColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ComicColors.black, width: selected ? 3 : 2),
          boxShadow: selected
              ? const [
                  BoxShadow(
                      color: ComicColors.black, offset: Offset(3, 3), blurRadius: 0),
                ]
              : null,
        ),
        child: Row(
          children: [
            XoIcon(icon,
                size: 22,
                color: selected ? ComicColors.black : ComicColors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: selected
                              ? ComicColors.black
                              : ComicColors.black)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? ComicColors.black.withValues(alpha: 0.7)
                              : ComicColors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final String icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onTap();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: enabled ? ComicColors.yellow : ComicColors.cream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ComicColors.black, width: 2.5),
        ),
        child: XoIcon(icon,
            size: 24,
            color: enabled ? ComicColors.black : ComicColors.grey),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final GameCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTile({required this.category, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ComicCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: selected ? 1 : 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ComicColors.black, width: 2),
            ),
            child: XoIcon(category.icon,
                color: selected ? Colors.white : category.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(category.titleAr,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 16, color: ComicColors.black)),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? ComicColors.green : null,
              border: Border.all(
                  color: selected ? ComicColors.black : ComicColors.grey, width: 2),
            ),
            child: selected
                ? const XoIcon('check', color: Colors.white, size: 15)
                : null,
          ),
        ],
      ),
    );
  }
}

// ─── Waiting Room Screen ─────────────────────────────────────────────────────

class WaitingRoomScreen extends ConsumerWidget {
  const WaitingRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(roomSessionStreamProvider);

    return sessionAsync.when(
      loading: () => const _WaitingScaffold(
        child: Center(child: CircularProgressIndicator(color: ComicColors.blue)),
      ),
      error: (e, _) => _WaitingScaffold(
        child: Center(
          child: Text('خطأ: $e',
              style: const TextStyle(
                  color: ComicColors.black, fontWeight: FontWeight.w800)),
        ),
      ),
      data: (session) {
        final currentRoomId = ref.watch(currentRoomIdProvider);

        if (session == null) {
          if (currentRoomId != null) {
            return const _WaitingScaffold(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: ComicColors.blue, strokeWidth: 3),
                  SizedBox(height: 20),
                  Text('جاري تجهيز الغرفة...',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: ComicColors.black,
                          fontSize: 17)),
                ],
              ),
            );
          }
          return _WaitingScaffold(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ComicCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ComicColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: ComicColors.black, width: 3),
                        ),
                        child: const XoIcon('x', color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 16),
                      const Text('الغرفة انتهت أو لم توجد',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      const SizedBox(height: 20),
                      ComicButton(
                        label: 'رجوع للرئيسية',
                        color: ComicColors.blue,
                        textColor: Colors.white,
                        onTap: () => context.go('/home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // App is the host: every client prepares the game identically when
        // the room starts — no player holds special powers.
        if (session.status == 'playing') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              final type = session.categories.isNotEmpty ? session.categories.first : 'trivia';
              ref.read(gameStateProvider.notifier).initializeGame(session.categories);
              context.go('/game-select/$type');
            }
          });
        }

        return _WaitingScaffold(
          actions: [
            TextButton.icon(
              onPressed: () async {
                await ref.read(roomNotifierProvider.notifier).leaveRoom();
                if (context.mounted) context.go('/home');
              },
              icon: const XoIcon('logIn', color: ComicColors.yellow, size: 18),
              label: const Text('خروج',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Room code hero card
                ComicCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const XoIcon('users', color: ComicColors.grey, size: 18),
                          const SizedBox(width: 8),
                          Text('شارك الكود مع أصدقائك',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: ComicColors.grey)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              session.roomCode,
                              style: const TextStyle(
                                fontSize: 46,
                                letterSpacing: 10,
                                fontWeight: FontWeight.w900,
                                color: ComicColors.black,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: session.roomCode));
                                showComicSnack(context, 'تم نسخ الكود');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: ComicColors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: ComicColors.black, width: 2.5),
                                ),
                                child: const XoIcon('copy',
                                    size: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.06, end: 0),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const XoIcon('users', color: ComicColors.blue, size: 20),
                    const SizedBox(width: 8),
                    const Text('اللاعبون المتصلون',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: ComicColors.black)),
                    const Spacer(),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ComicColors.yellow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ComicColors.black, width: 2),
                      ),
                      child: Text('${session.players.length} / ${session.maxPlayers}',
                          style: const TextStyle(
                              color: ComicColors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: session.players.isEmpty
                      ? const _EmptyPlayers()
                      : ListView.builder(
                          itemCount: session.players.length,
                          itemBuilder: (context, index) {
                            final player = session.players[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: RepaintBoundary(
                                child: ComicCard(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  child: Row(
                                    children: [
                                      XoAvatar(
                                          imageUrl: player.photoUrl,
                                          name: player.name,
                                          size: 46,
                                          showBorder: true),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          player.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              color: ComicColors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: ComicColors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: ComicColors.black,
                                              width: 2),
                                        ),
                                        child: const XoIcon('check',
                                            color: Colors.white, size: 15),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(delay: (index * 60).ms, duration: 300.ms),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 14),
                // Everyone is equal — any player can start (the app runs the game).
                ComicButton(
                  label: session.players.length >= 2
                      ? 'ابدأ المسابقة الآن'
                      : 'في انتظار لاعب آخر...',
                  onTap: session.players.length >= 2
                      ? () => ref.read(roomNotifierProvider.notifier).startGame()
                      : () {},
                ),
                const SizedBox(height: 8),
                const Text('أي لاعب يقدر يبدأ — مافيش هوست',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: ComicColors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Waiting-room scaffold (comic, no back button by default).
class _WaitingScaffold extends StatelessWidget {
  final Widget child;
  final List<Widget>? actions;

  const _WaitingScaffold({required this.child, this.actions});

  @override
  Widget build(BuildContext context) {
    return _ComicScaffold(
      title: 'غرفة الانتظار',
      emoji: '⏳',
      showBack: false,
      actions: actions,
      body: child,
    );
  }
}

/// Shared Comic scaffold for this file's screens.
class _ComicScaffold extends StatelessWidget {
  final String title;
  final String emoji;
  final Widget body;
  final List<Widget>? actions;
  final bool showBack;

  const _ComicScaffold({
    required this.title,
    required this.emoji,
    required this.body,
    this.actions,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        automaticallyImplyLeading: showBack,
        title: Text('$emoji $title'),
        actions: actions,
      ),
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.blue,
        child: SafeArea(child: body),
      ),
    );
  }
}

class _EmptyPlayers extends StatelessWidget {
  const _EmptyPlayers();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const XoIcon('loader2', color: ComicColors.blue, size: 44)
            .animate(onPlay: (c) => c.repeat())
            .rotate(duration: 1200.ms),
        const SizedBox(height: 16),
        const Text('بانتظار دخول اللاعبين...',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: ComicColors.grey)),
      ],
    );
  }
}
