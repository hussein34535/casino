import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

final settingsProvider = FutureProvider<Map<String, bool>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'notifications': prefs.getBool('notifications') ?? true,
    'soundFx':       prefs.getBool('soundFx')       ?? true,
    'vibration':     prefs.getBool('vibration')     ?? true,
  };
});

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _prefsFuture = SharedPreferences.getInstance();

  Future<void> _toggle(String key, bool value) async {
    final prefs = await _prefsFuture;
    await prefs.setBool(key, value);
    ref.invalidate(settingsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.green,
        elevation: 0,
        title: const Text('⚙️ الإعدادات', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
      ),
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.green,
        child: settingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: ComicColors.yellow)),
          error: (e, _) => Center(child: ComicCard(color: ComicColors.red, child: Text('خطأ: $e', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)))),
          data: (settings) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Notifications section
              _SectionHeader(emoji: '🔔', title: 'الإشعارات'),
              ComicCard(
                color: Colors.white,
                child: Column(
                  children: [
                    _ComicSwitch(
                      emoji: '🔔', label: 'الإشعارات', subtitle: 'استلم إشعارات الألعاب',
                      value: settings['notifications'] ?? true,
                      onChanged: (v) => _toggle('notifications', v),
                    ),
                    const Divider(color: ComicColors.black, thickness: 1.5),
                    _ComicSwitch(
                      emoji: '🔊', label: 'المؤثرات الصوتية', subtitle: 'أصوات اللعبة',
                      value: settings['soundFx'] ?? true,
                      onChanged: (v) => _toggle('soundFx', v),
                    ),
                    const Divider(color: ComicColors.black, thickness: 1.5),
                    _ComicSwitch(
                      emoji: '📳', label: 'الاهتزاز', subtitle: 'اهتزاز عند التفاعل',
                      value: settings['vibration'] ?? true,
                      onChanged: (v) => _toggle('vibration', v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Language section
              _SectionHeader(emoji: '🌍', title: 'اللغة'),
              ComicCard(
                color: Colors.white,
                child: Column(
                  children: [
                    _MenuRow(emoji: '✅', label: 'العربية', trailing: const ComicTag(label: 'مفعلة', color: ComicColors.green, textColor: Colors.white)),
                    const Divider(color: ComicColors.black, thickness: 1.5),
                    Opacity(opacity: 0.4, child: _MenuRow(emoji: '🇺🇸', label: 'English', trailing: const ComicTag(label: 'قريباً', color: ComicColors.grey))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Account section
              if (user != null) ...[
                _SectionHeader(emoji: '👤', title: 'الحساب'),
                ComicCard(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _MenuRow(emoji: '📧', label: 'البريد الإلكتروني', subtitle: user.email),
                      const Divider(color: ComicColors.black, thickness: 1.5),
                      GestureDetector(
                        onTap: () => _showDeleteAccountDialog(context),
                        child: _MenuRow(emoji: '🗑️', label: 'حذف الحساب', subtitle: 'سيتم حذف جميع بياناتك', labelColor: ComicColors.red),
                      ),
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
                const SizedBox(height: 16),
              ],
              // About section
              _SectionHeader(emoji: 'ℹ️', title: 'حول'),
              ComicCard(
                color: Colors.white,
                child: Column(
                  children: [
                    const _MenuRow(emoji: '🏷️', label: 'الإصدار', subtitle: '2.0.0 Comic Edition'),
                    const Divider(color: ComicColors.black, thickness: 1.5),
                    GestureDetector(
                      onTap: () {},
                      child: const _MenuRow(emoji: '🔒', label: 'سياسة الخصوصية'),
                    ),
                    const Divider(color: ComicColors.black, thickness: 1.5),
                    GestureDetector(
                      onTap: () {},
                      child: const _MenuRow(emoji: '📋', label: 'شروط الاستخدام'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: ComicColors.black, width: 3),
        ),
        title: const Text('🗑️ حذف الحساب', textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.red, fontSize: 20)),
        content: const Text(
          'هل أنت متأكد؟ لا يمكن التراجع! سيتم حذف جميع بياناتك بما في ذلك الألعاب والإنجازات.',
          style: TextStyle(fontWeight: FontWeight.w700, color: ComicColors.black),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(fontWeight: FontWeight.w900))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ComicColors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: ComicColors.black, width: 2))),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ تم إرسال طلب حذف الحساب'), backgroundColor: ComicColors.red),
              );
            },
            child: const Text('🗑️ حذف', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String emoji, title;
  const _SectionHeader({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ComicColors.black)),
        ],
      ),
    );
  }
}

class _ComicSwitch extends StatelessWidget {
  final String emoji, label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ComicSwitch({required this.emoji, required this.label, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SwitchListTile(
        secondary: Text(emoji, style: const TextStyle(fontSize: 24)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black)),
        subtitle: Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
        value: value,
        activeThumbColor: ComicColors.green,
        onChanged: onChanged,
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String emoji, label;
  final String? subtitle;
  final Widget? trailing;
  final Color labelColor;
  const _MenuRow({required this.emoji, required this.label, this.subtitle, this.trailing, this.labelColor = ComicColors.black});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: labelColor)),
                if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
              ],
            ),
          ),
          if (trailing != null) trailing! else const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }
}


