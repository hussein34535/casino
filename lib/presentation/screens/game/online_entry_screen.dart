import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/design/xo_design.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/design/xo_widgets.dart';
import 'package:game_show_app/presentation/providers/room_provider.dart';

/// Online entry: joining a room by code is the hero,
/// creating a room is the secondary action.
class OnlineEntryScreen extends ConsumerStatefulWidget {
  const OnlineEntryScreen({super.key});

  @override
  ConsumerState<OnlineEntryScreen> createState() => _OnlineEntryScreenState();
}

class _OnlineEntryScreenState extends ConsumerState<OnlineEntryScreen> {
  final _codeKey = GlobalKey<XoCodeInputState>();
  bool _isJoining = false;
  bool _codeReady = false;

  Future<void> _join() async {
    final code = _codeKey.currentState?.code ?? '';
    if (code.length != 6 || _isJoining) return;
    setState(() => _isJoining = true);
    try {
      await ref.read(roomNotifierProvider.notifier).joinRoom(code);
      if (mounted) context.push('/waiting-room');
    } catch (e) {
      if (mounted) showXoSnack(context, '$e', error: true);
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
            // ── Hero: join by code ──────────────────────────
            XoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: XoDesign.indigoGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const XoIcon('doorOpen', color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('انضم إلى غرفة', style: XoDesign.h2.copyWith(color: XoDesign.ink)),
                            Text('اكتب كود الغرفة المكوّن من 6 أرقام',
                                style: XoDesign.caption.copyWith(color: XoDesign.muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  XoCodeInput(
                    key: _codeKey,
                    onCompleted: (_) => _join(),
                    onChanged: () => setState(() =>
                        _codeReady = (_codeKey.currentState?.code.length ?? 0) == 6),
                  ),
                  const SizedBox(height: 20),
                  XoButton(
                    label: 'انضم للغرفة',
                    icon: 'logIn',
                    loading: _isJoining,
                    onTap: _codeReady ? _join : null,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06, end: 0),

            // ── Divider ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('أو', style: XoDesign.body.copyWith(color: XoDesign.onDarkMuted)),
                  ),
                  const Expanded(child: Divider(color: Colors.white24)),
                ],
              ),
            ),

            // ── Secondary: create room ──────────────────────
            XoGlassCard(
              onTap: () => context.push('/create-room'),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: XoDesign.goldGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const XoIcon('plus', color: XoDesign.navy900, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
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
                  const XoIcon('arrowLeft', color: XoDesign.gold, size: 22),
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
