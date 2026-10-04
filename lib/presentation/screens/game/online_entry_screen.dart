import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/design/game_categories.dart';
import 'package:game_show_app/core/design/xo_design.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/design/xo_widgets.dart';
import 'package:game_show_app/data/models/game/game_session_model.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';
import 'package:game_show_app/presentation/providers/room_provider.dart';

/// Online entry: join by code up front, browse open rooms, or create a room.
class OnlineEntryScreen extends ConsumerStatefulWidget {
  const OnlineEntryScreen({super.key});

  @override
  ConsumerState<OnlineEntryScreen> createState() => _OnlineEntryScreenState();
}

class _OnlineEntryScreenState extends ConsumerState<OnlineEntryScreen> {
  final _codeKey = GlobalKey<XoCodeInputState>();
  final _searchController = TextEditingController();
  bool _isJoining = false;
  bool _codeReady = false;
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _join([String? code]) async {
    final target = code ?? _codeKey.currentState?.code ?? '';
    if (target.length != 6 || _isJoining) return;
    setState(() => _isJoining = true);
    try {
      await ref.read(roomNotifierProvider.notifier).joinRoom(target);
      if (mounted) context.push('/waiting-room');
    } catch (e) {
      if (mounted) showXoSnack(context, '$e', error: true);
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  /// Starts a quick local game against a bot — no login required.
  Future<void> _joinBot(_BotRoom bot) async {
    if (_isJoining) return;
    setState(() => _isJoining = true);
    try {
      // Never treat a leftover online room as active while playing locally.
      ref.read(currentRoomIdProvider.notifier).state = null;

      final user = ref.read(authStateProvider).value;
      var playerName = 'أنت';
      if (user != null) {
        playerName = user.displayName.trim().isNotEmpty
            ? user.displayName.trim()
            : user.email.split('@').first;
      }

      final notifier = ref.read(gameStateProvider.notifier);
      notifier.setPlayersWithBot(playerName, bot.botName, bot.difficulty);
      await notifier.initializeGame([bot.category]);
      if (mounted) context.push('/game-select/${bot.category}');
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return XoScaffold(
      title: 'اللعب أونلاين',
      titleIcon: 'wifi',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Join by code — always visible up front ────
            _JoinCard(
              codeKey: _codeKey,
              codeReady: _codeReady,
              isJoining: _isJoining,
              onChanged: () => setState(() =>
                  _codeReady = (_codeKey.currentState?.code.length ?? 0) == 6),
              onJoin: _join,
            ),
            const SizedBox(height: 20),
            // ── Divider ───────────────────────────────────
            Row(
              children: [
                const Expanded(child: Divider(color: Colors.white24)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('أو تصفح الغرف',
                      style: XoDesign.body.copyWith(color: XoDesign.onDarkMuted)),
                ),
                const Expanded(child: Divider(color: Colors.white24)),
              ],
            ),
            const SizedBox(height: 16),
            // ── Browse: real rooms + bot rooms (always) ───
            _BrowseSection(
              search: _search,
              onSearch: (v) => setState(() => _search = v.trim()),
              onJoin: _join,
              onJoinBot: _joinBot,
              isJoining: _isJoining,
            ),
            // ── Divider ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('أو',
                        style: XoDesign.body.copyWith(color: XoDesign.onDarkMuted)),
                  ),
                  const Expanded(child: Divider(color: Colors.white24)),
                ],
              ),
            ),
            // ── Secondary: create room ────────────────────
            XoGlassCard(
              onTap: () => context.push('/create-room'),
              child: const Row(
                children: [
                  _GradientIcon(icon: 'plus', gradient: XoDesign.goldGradient),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('أنشئ غرفتك الخاصة',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
                        SizedBox(height: 2),
                        Text('اعزم أصحابك وابدأ المسابقة',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600, color: XoDesign.onDarkMuted)),
                      ],
                    ),
                  ),
                  XoIcon('arrowLeft', color: XoDesign.gold, size: 22),
                ],
              ),
            ).animate().fadeIn(delay: 120.ms, duration: 400.ms).slideY(begin: 0.06, end: 0),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _GradientIcon extends StatelessWidget {
  final String icon;
  final Gradient gradient;
  const _GradientIcon({required this.icon, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: XoIcon(icon, color: Colors.white, size: 22),
    );
  }
}

class _JoinCard extends StatelessWidget {
  final GlobalKey<XoCodeInputState> codeKey;
  final bool codeReady;
  final bool isJoining;
  final VoidCallback onChanged;
  final Future<void> Function() onJoin;

  const _JoinCard({
    required this.codeKey,
    required this.codeReady,
    required this.isJoining,
    required this.onChanged,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return XoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _GradientIcon(icon: 'doorOpen', gradient: XoDesign.indigoGradient),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('انضم إلى غرفة',
                        style: XoDesign.h2.copyWith(color: XoDesign.ink)),
                    Text('اكتب كود الغرفة المكوّن من 6 أرقام',
                        style: XoDesign.caption.copyWith(color: XoDesign.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          XoCodeInput(
            key: codeKey,
            onCompleted: (_) => onJoin(),
            onChanged: onChanged,
          ),
          const SizedBox(height: 20),
          XoButton(
            label: 'انضم للغرفة',
            icon: 'logIn',
            loading: isJoining,
            onTap: codeReady ? onJoin : null,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06, end: 0);
  }
}

class _BrowseSection extends ConsumerWidget {
  final String search;
  final ValueChanged<String> onSearch;
  final Future<void> Function(String code) onJoin;
  final Future<void> Function(_BotRoom bot) onJoinBot;
  final bool isJoining;

  const _BrowseSection({
    required this.search,
    required this.onSearch,
    required this.onJoin,
    required this.onJoinBot,
    required this.isJoining,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(openRoomsProvider);
    final q = search.toLowerCase();
    final bots = _botRooms
        .where((b) => q.isEmpty || b.title.toLowerCase().contains(q) || b.botName.toLowerCase().contains(q))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: XoDesign.softShadow(),
          ),
          child: TextField(
            onChanged: onSearch,
            style: const TextStyle(fontWeight: FontWeight.w700, color: XoDesign.ink),
            decoration: InputDecoration(
              hintText: 'ابحث بكود الغرفة أو اسم المضيف...',
              hintStyle: const TextStyle(color: XoDesign.muted, fontSize: 14),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: XoIcon('search', size: 20, color: XoDesign.muted),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // ── Real rooms ───────────────────────────────────
        roomsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: XoDesign.gold),
            ),
          ),
          error: (e, _) => XoGlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const XoIcon('x', color: XoDesign.rose, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text('تعذر تحميل الغرف: $e',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ),
              ],
            ),
          ),
          data: (rooms) {
            final visible = rooms.where((r) {
              if (!r.isPublic) return false;
              if (r.players.length >= r.maxPlayers) return false;
              if (q.isEmpty) return true;
              final host = _hostName(r).toLowerCase();
              return r.roomCode.contains(q) || host.contains(q);
            }).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (visible.isEmpty) {
              return const XoGlassCard(
                child: Column(
                  children: [
                    XoIcon('users', color: XoDesign.onDarkMuted, size: 40),
                    SizedBox(height: 12),
                    Text('لا توجد غرف مفتوحة حالياً',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                    SizedBox(height: 4),
                    Text('جرّب غرف البوتات بالأسفل أو أنشئ غرفتك!',
                        style: TextStyle(
                            color: XoDesign.onDarkMuted, fontSize: 13)),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionHeader(icon: 'wifi', label: 'غرف حقيقية'),
                const SizedBox(height: 10),
                for (var i = 0; i < visible.length; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: i == visible.length - 1 ? 0 : 10),
                    child: RepaintBoundary(
                      child: _RoomCard(
                        room: visible[i],
                        isJoining: isJoining,
                        onJoin: () => onJoin(visible[i].roomCode),
                      ).animate().fadeIn(delay: (i * 60).ms, duration: 300.ms),
                    ),
                  ),
              ],
            );
          },
        ),
        // ── Bot rooms (always available) ─────────────────
        if (bots.isNotEmpty) ...[
          const SizedBox(height: 20),
          const _SectionHeader(icon: 'brain', label: 'غرف البوتات — العب فوراً'),
          const SizedBox(height: 10),
          for (var i = 0; i < bots.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == bots.length - 1 ? 0 : 10),
              child: RepaintBoundary(
                child: _BotRoomCard(
                  bot: bots[i],
                  isJoining: isJoining,
                  onJoin: () => onJoinBot(bots[i]),
                ).animate().fadeIn(delay: (i * 60).ms, duration: 300.ms),
              ),
            ),
        ],
      ],
    ).animate().fadeIn(duration: 350.ms);
  }

  static String _hostName(GameSessionModel room) {
    if (room.players.isEmpty) return 'مضيف مجهول';
    final host = room.players.where((p) => p.isHost);
    return (host.isEmpty ? room.players.first : host.first).name;
  }
}

/// Built-in bot rooms so there is always something to join.
class _BotRoom {
  final String title;
  final String botName;
  final String difficulty;
  final String category;

  const _BotRoom({
    required this.title,
    required this.botName,
    required this.difficulty,
    required this.category,
  });
}

const _botRooms = [
  _BotRoom(title: 'مباراة ودّية', botName: 'مبتدئ AI', difficulty: 'easy', category: 'trivia'),
  _BotRoom(title: 'تحدي الأفلام', botName: 'باحث AI', difficulty: 'medium', category: 'movies'),
  _BotRoom(title: 'تحدي الموسيقى', botName: 'عبقري AI', difficulty: 'hard', category: 'music'),
  _BotRoom(title: 'غزو إيلون', botName: 'إيلون AI', difficulty: 'elon', category: 'puzzles'),
];

class _SectionHeader extends StatelessWidget {
  final String icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        XoIcon(icon, color: XoDesign.gold, size: 18),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
      ],
    );
  }
}

class _BotRoomCard extends StatelessWidget {
  final _BotRoom bot;
  final bool isJoining;
  final VoidCallback onJoin;

  const _BotRoomCard({required this.bot, required this.isJoining, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final catInfo = gameCategories.where((c) => c.id == bot.category);
    final cat = catInfo.isEmpty ? gameCategories.first : catInfo.first;

    return XoCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: XoDesign.indigoGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const XoIcon('brain', color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bot.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 16, color: XoDesign.ink),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          XoIcon(cat.icon, size: 13, color: cat.color),
                          const SizedBox(width: 4),
                          Text(cat.titleAr,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: cat.color)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(bot.botName,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800, color: XoDesign.muted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isJoining
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    onJoin();
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: XoDesign.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isJoining
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: XoDesign.navy900),
                    )
                  : const Text('العب',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: XoDesign.navy900)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final GameSessionModel room;
  final bool isJoining;
  final VoidCallback onJoin;

  const _RoomCard({required this.room, required this.isJoining, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final host = room.players.where((p) => p.isHost);
    final hostPlayer = room.players.isEmpty
        ? null
        : (host.isEmpty ? room.players.first : host.first);
    final category = room.categories.isNotEmpty ? room.categories.first : 'trivia';
    final catInfo = gameCategories.where((c) => c.id == category);
    final cat = catInfo.isEmpty ? gameCategories.first : catInfo.first;

    return XoCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          XoAvatar(
              photoUrl: hostPlayer?.photoUrl,
              name: hostPlayer?.name ?? '?',
              size: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hostPlayer?.name ?? 'غرفة مجهولة',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: XoDesign.ink),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          XoIcon(cat.icon, size: 13, color: cat.color),
                          const SizedBox(width: 4),
                          Text(cat.titleAr,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: cat.color)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const XoIcon('users', size: 14, color: XoDesign.muted),
                    const SizedBox(width: 4),
                    Text('${room.players.length}/${room.maxPlayers}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: XoDesign.muted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isJoining
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    onJoin();
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: XoDesign.indigoGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isJoining
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Text('انضم',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
