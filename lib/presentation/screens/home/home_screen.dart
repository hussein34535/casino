import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ComicColors.cream,
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.orange,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    children: [

                      _buildModeGrid(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Big bold comic title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: ComicColors.yellow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ComicColors.black, width: 2.5),
                    boxShadow: const [BoxShadow(color: ComicColors.black, offset: Offset(4, 4), blurRadius: 0)],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      XoIcon('gamepad2', size: 24, color: ComicColors.black),
                      SizedBox(width: 8),
                      Text(
                        'XO GAME SHOW!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: ComicColors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(begin: const Offset(0.9, 0.9), duration: 500.ms, curve: Curves.elasticOut),
                const SizedBox(height: 6),
                const Text(
                  'اختار وضع اللعب!',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ComicColors.black),
                ),
              ],
            ),
          ),
          // Settings button
          GestureDetector(
            onTap: () => context.push('/settings'),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ComicColors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: ComicColors.black, width: 2.5),
                boxShadow: const [BoxShadow(color: ComicColors.black, offset: Offset(3, 3), blurRadius: 0)],
              ),
              child: const Icon(Icons.settings_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildModeGrid(BuildContext context) {
    return Column(
      children: [
        // ONLINE — full width, big card
        _BigModeCard(
          icon: 'wifi',
          title: 'ONLINE',
          subtitle: 'تحدى الكل أونلاين!',
          color: ComicColors.blue,
          textColor: Colors.white,
          onTap: () => context.push('/online'),
        ),
        const SizedBox(height: 16),
        // OFFLINE + BUZZER side by side
        Row(
          children: [
            Expanded(
              child: _SmallModeCard(
                icon: 'users',
                title: 'OFFLINE',
                subtitle: 'لعب محلي',
                color: ComicColors.green,
                onTap: () => context.push('/local-setup'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SmallModeCard(
                icon: 'zap',
                title: 'BUZZER',
                subtitle: 'الأسرع يفوز!',
                color: ComicColors.orange,
                onTap: () => context.push('/buzzer'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BigModeCard extends StatelessWidget {
  final String icon;
  final String title, subtitle;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _BigModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ComicCard(
      color: color,
      onTap: onTap,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(20),
            ),
            child: XoIcon(icon, size: 44, color: textColor),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: textColor, letterSpacing: 1)),
                Text(subtitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textColor.withValues(alpha: 0.85))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
              border: Border.all(color: ComicColors.black, width: 2),
            ),
            child: Icon(Icons.arrow_forward_rounded, color: textColor, size: 24),
          ),
        ],
      ),
    ).animate().slideX(begin: -0.1, duration: 600.ms, curve: Curves.easeOutBack);
  }
}

class _SmallModeCard extends StatelessWidget {
  final String icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SmallModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ComicCard(
      color: color,
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(16),
            ),
            child: XoIcon(icon, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
          Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70)),
        ],
      ),
    ).animate().slideY(begin: 0.1, duration: 700.ms, curve: Curves.easeOutBack);
  }
}


