import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/user_provider.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    if (user == null) {
      return Scaffold(
        backgroundColor: ComicColors.cream,
        appBar: AppBar(
          backgroundColor: ComicColors.blue,
          elevation: 0,
          title: const Text('👤 الملف الشخصي', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
          shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
        ),
        body: ComicBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ComicCard(
                color: ComicColors.yellow,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('😶', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 12),
                    const Text('لم تقم بتسجيل الدخول!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: ComicColors.black)),
                    const SizedBox(height: 16),
                    ComicButton(
                      label: '🔑 تسجيل الدخول',
                      color: ComicColors.blue,
                      textColor: Colors.white,
                      onTap: () => context.push('/login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final winRate = user.winRate;
    final winRatePercent = (winRate * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.blue,
        elevation: 0,
        title: const Text('👤 الملف الشخصي', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _showEditProfileDialog(context, ref, user),
              child: const ComicTag(label: '✏️ تعديل', color: ComicColors.yellow),
            ),
          ),
        ],
      ),
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.blue,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar card
              ComicCard(
                color: ComicColors.blue,
                shadowOffset: 7,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: ComicColors.black, width: 3),
                            boxShadow: const [BoxShadow(color: ComicColors.black, offset: Offset(3, 3), blurRadius: 0)],
                          ),
                          child: ClipOval(
                            child: user.photoUrl != null
                              ? Image.network(user.photoUrl!, fit: BoxFit.cover)
                              : Center(child: Text(
                                  user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
                                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: ComicColors.blue))),
                          ),
                        ),
                        if (user.isPremium)
                          Positioned(
                            bottom: 0, right: 0,
                            child: const ComicBadge(text: '⭐', color: ComicColors.yellow),
                          ),
                      ],
                    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user.displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                        if (user.isPremium) ...[
                          const SizedBox(width: 8),
                          const ComicBadge(text: '✓', color: ComicColors.green),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(user.email, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8, runSpacing: 8,
                      children: [
                        ComicTag(label: '⭐ Lv.${user.level}', color: ComicColors.yellow),
                        ComicTag(label: '🪙 ${user.coins}', color: ComicColors.orange),
                        if (user.streak > 0)
                          ComicTag(label: '🔥 ${user.streak} يوم', color: ComicColors.red, textColor: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Stats grid
              Row(
                children: [
                  Expanded(child: _StatCard(emoji: '🎮', value: '${user.gamesPlayed}', label: 'الألعاب', color: ComicColors.purple)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(emoji: '🏆', value: '${user.gamesWon}', label: 'الفوز', color: ComicColors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(emoji: '📈', value: '$winRatePercent%', label: 'نسبة الفوز', color: ComicColors.blue)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _StatCard(emoji: '⭐', value: '${user.xp}', label: 'نقاط XP', color: ComicColors.yellow)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(emoji: '🔥', value: '${user.streak}', label: 'متتالي', color: ComicColors.orange)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(emoji: '🪙', value: '${user.coins}', label: 'عملات', color: ComicColors.pink)),
                ],
              ),
              const SizedBox(height: 20),
              // Menu
              ComicCard(
                color: Colors.white,
                child: Column(
                  children: [
                    _MenuTile(emoji: '⚙️', label: 'الإعدادات', onTap: () => context.push('/settings')),
                    const Divider(color: ComicColors.black, thickness: 1.5),
                    _MenuTile(emoji: '🏅', label: 'الإنجازات', onTap: () => context.push('/achievements')),
                    const Divider(color: ComicColors.black, thickness: 1.5),
                    _MenuTile(emoji: '👥', label: 'الأصدقاء', onTap: () => context.push('/friends')),
                    if (user.isAdmin) ...[
                      const Divider(color: ComicColors.black, thickness: 1.5),
                      _MenuTile(emoji: '🔐', label: 'لوحة المشرف', onTap: () => context.push('/admin'), color: ComicColors.red, textColor: Colors.white),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ComicButton(
                label: '🚪 تسجيل الخروج',
                color: ComicColors.red,
                textColor: Colors.white,
                onTap: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  if (context.mounted) context.go('/home');
                },
                shadowOffset: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserModel user) {
    final nameController = TextEditingController(text: user.displayName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: ComicColors.black, width: 3),
        ),
        title: const Text('✏️ تعديل الملف', textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black, fontSize: 20)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ComicColors.black),
          decoration: InputDecoration(
            labelText: 'اسم العرض',
            labelStyle: const TextStyle(color: ComicColors.blue, fontWeight: FontWeight.w900),
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.black, width: 2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.blue, width: 2.5)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ComicColors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: ComicColors.black, width: 2))),
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isEmpty) return;
              await ref.read(userRepositoryProvider).updateProfile(user.id, {'displayName': newName});
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('💾 حفظ', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, value, label;
  final Color color;
  const _StatCard({required this.emoji, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ComicCard(
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String emoji, label;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  const _MenuTile({required this.emoji, required this.label, required this.onTap, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: textColor ?? ComicColors.black))),
            Icon(Icons.chevron_right, color: textColor ?? ComicColors.black),
          ],
        ),
      ),
    );
  }
}
