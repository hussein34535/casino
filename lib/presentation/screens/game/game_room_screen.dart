import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/design/game_categories.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/design/xo_design.dart';
import 'package:game_show_app/core/design/xo_widgets.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';
import 'package:game_show_app/presentation/providers/room_provider.dart';

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
      showXoSnack(context, 'لازم تسجّل دخولك الأول قبل إنشاء غرفة', error: true);
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
      if (mounted) showXoSnack(context, 'خطأ: $e', error: true);
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);
    if (!authAsync.hasValue) {
      return const XoScaffold(
        title: 'إنشاء غرفة',
        titleIcon: 'plus',
        body: Center(
          child: CircularProgressIndicator(color: XoDesign.gold),
        ),
      );
    }
    if (authAsync.value == null) {
      return XoScaffold(
        title: 'إنشاء غرفة',
        titleIcon: 'plus',
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: XoGlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const XoIcon('lock', color: XoDesign.gold, size: 44),
                  const SizedBox(height: 16),
                  Text('سجّل دخولك الأول',
                      style: XoDesign.h2.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('الحساب مطلوب لإنشاء غرفة أونلاين',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: XoDesign.onDarkMuted, fontSize: 14)),
                  const SizedBox(height: 20),
                  XoButton(
                    label: 'تسجيل الدخول',
                    icon: 'logIn',
                    onTap: () => context.push('/login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return XoScaffold(
      title: 'إنشاء غرفة',
      titleIcon: 'plus',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('اختر أنواع الأسئلة',
                style: XoDesign.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 4),
            Text('يمكنك اختيار أكثر من نوع',
                style: XoDesign.caption.copyWith(color: XoDesign.onDarkMuted)),
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
            Text('أقصى عدد للاعبين',
                style: XoDesign.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 4),
            Text('من 2 لـ 5 لاعبين',
                style: XoDesign.caption.copyWith(color: XoDesign.onDarkMuted)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: XoDesign.glass,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
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
                              color: XoDesign.gold,
                            ),
                          ),
                        ),
                        const Text(
                          'لاعبين',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: XoDesign.onDarkMuted),
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
            Text('ظهور الغرفة', style: XoDesign.h2.copyWith(color: Colors.white)),
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
            XoButton(
              label: 'إنشاء الغرفة',
              icon: 'swords',
              loading: _isCreating,
              onTap: _createRoom,
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => context.push('/online'),
                child: const Text(
                  'عندك كود؟ انضم لغرفة موجودة',
                  style: TextStyle(
                      color: XoDesign.gold, fontSize: 14, fontWeight: FontWeight.w800),
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
          gradient: selected ? XoDesign.goldGradient : null,
          color: selected ? null : XoDesign.glass,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          children: [
            XoIcon(icon,
                size: 22,
                color: selected ? XoDesign.navy900 : Colors.white70),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: selected ? XoDesign.navy900 : Colors.white)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? XoDesign.navy900.withValues(alpha: 0.7)
                              : Colors.white54)),
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
          gradient: enabled ? XoDesign.goldGradient : null,
          color: enabled ? null : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: XoIcon(icon,
            size: 24,
            color: enabled ? XoDesign.navy900 : Colors.white24),
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
    return XoCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: selected ? 1 : 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: XoIcon(category.icon,
                color: selected ? Colors.white : category.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(category.titleAr,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 16, color: XoDesign.ink)),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected ? XoDesign.indigoGradient : null,
              border: Border.all(
                  color: selected ? Colors.transparent : const Color(0xFFD5D8E4), width: 2),
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
    final currentUser = ref.watch(authStateProvider).value;

    return sessionAsync.when(
      loading: () => const _WaitingScaffold(
        child: Center(child: CircularProgressIndicator(color: XoDesign.gold)),
      ),
      error: (e, _) => _WaitingScaffold(
        child: Center(
          child: Text('خطأ: $e', style: const TextStyle(color: Colors.white)),
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
                  CircularProgressIndicator(color: XoDesign.gold, strokeWidth: 3),
                  SizedBox(height: 20),
                  Text('جاري تجهيز الغرفة...',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: Colors.white, fontSize: 17)),
                ],
              ),
            );
          }
          return _WaitingScaffold(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: XoCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: XoDesign.rose.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: const XoIcon('x', color: XoDesign.rose, size: 32),
                      ),
                      const SizedBox(height: 16),
                      const Text('الغرفة انتهت أو لم توجد',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                      const SizedBox(height: 20),
                      XoButton.indigo(
                        label: 'رجوع للرئيسية',
                        icon: 'arrowLeft',
                        onTap: () => context.go('/home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final isHost = currentUser?.id == session.hostId;

        // Auto-navigate to game when status changes to playing.
        if (session.status == 'playing') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              final type = session.categories.isNotEmpty ? session.categories.first : 'trivia';
              if (isHost) {
                ref.read(gameStateProvider.notifier).initializeGame(session.categories);
              }
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
              icon: const XoIcon('logIn', color: XoDesign.rose, size: 18),
              label: const Text('خروج',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Room code hero card
                XoCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const XoIcon('users', color: XoDesign.muted, size: 18),
                          const SizedBox(width: 8),
                          Text('شارك الكود مع أصدقائك',
                              style: XoDesign.body.copyWith(color: XoDesign.muted)),
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
                                color: XoDesign.ink,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: session.roomCode));
                                showXoSnack(context, 'تم نسخ الكود');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: XoDesign.indigoGradient,
                                  borderRadius: BorderRadius.circular(12),
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
                    const XoIcon('users', color: XoDesign.gold, size: 20),
                    const SizedBox(width: 8),
                    Text('اللاعبون المتصلون',
                        style: XoDesign.h2.copyWith(color: Colors.white)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: XoDesign.glass,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                      ),
                      child: Text('${session.players.length} / ${session.maxPlayers}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
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
                                child: XoCard(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  child: Row(
                                    children: [
                                      XoAvatar(
                                          photoUrl: player.photoUrl,
                                          name: player.name,
                                          size: 46),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                player.name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16,
                                                    color: XoDesign.ink),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (player.isHost) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 9, vertical: 4),
                                                decoration: BoxDecoration(
                                                  gradient: XoDesign.goldGradient,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    XoIcon('crown',
                                                        size: 13, color: XoDesign.navy900),
                                                    SizedBox(width: 4),
                                                    Text('مضيف',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w900,
                                                            color: XoDesign.navy900)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: XoDesign.mint.withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const XoIcon('check',
                                            color: XoDesign.mint, size: 15),
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
                if (isHost)
                  XoButton(
                    label: session.players.isNotEmpty
                        ? 'ابدأ المسابقة الآن'
                        : 'في انتظار لاعب على الأقل',
                    icon: 'play',
                    onTap: session.players.isNotEmpty
                        ? () => ref.read(roomNotifierProvider.notifier).startGame()
                        : null,
                  )
                else
                  const XoGlassCard(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: XoDesign.gold),
                        ),
                        SizedBox(width: 12),
                        Text('في انتظار المضيف لبدء اللعبة...',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Waiting-room scaffold (dark, no back button by default).
class _WaitingScaffold extends StatelessWidget {
  final Widget child;
  final List<Widget>? actions;

  const _WaitingScaffold({required this.child, this.actions});

  @override
  Widget build(BuildContext context) {
    return XoScaffold(
      title: 'غرفة الانتظار',
      titleIcon: 'timer',
      showBack: false,
      actions: actions,
      body: child,
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
        const XoIcon('loader2', color: XoDesign.gold, size: 44)
            .animate(onPlay: (c) => c.repeat())
            .rotate(duration: 1200.ms),
        const SizedBox(height: 16),
        Text('بانتظار دخول اللاعبين...',
            style: XoDesign.body.copyWith(color: XoDesign.onDarkMuted)),
      ],
    );
  }
}
