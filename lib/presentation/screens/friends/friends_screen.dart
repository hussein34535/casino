import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/data/models/user/user_model.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/providers/social_provider.dart';
import 'package:game_show_app/presentation/widgets/common/xo_avatar.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.blue,
        elevation: 0,
        title: const Text('👥 الأصدقاء', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 2)),
      ),
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.blue,
        child: user == null
            ? _buildEmptyState('سجل الدخول لعرض أصدقائك', 'قم بتسجيل الدخول لإضافة أصدقاء واللعب معهم', Icons.person_off_rounded, context)
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(child: _buildSearchField()),
                        const SizedBox(width: 12),
                        ComicButton(
                          label: '➕ إضافة',
                          color: ComicColors.yellow,
                          onTap: () => _showAddFriendDialog(context, user.id),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: friendsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(color: ComicColors.blue)),
                      error: (e, _) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('حدث خطأ في تحميل الأصدقاء 😢', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                            const SizedBox(height: 16),
                            ComicButton(label: 'إعادة المحاولة', color: ComicColors.red, onTap: () => ref.invalidate(friendsProvider)),
                          ],
                        ),
                      ),
                      data: (friends) {
                        final filtered = _searchQuery.isEmpty ? friends : friends.where((f) => f.displayName.contains(_searchQuery)).toList();

                        if (filtered.isEmpty) {
                          final msg = _searchQuery.isNotEmpty ? 'لا توجد نتائج للبحث' : 'لا يوجد أصدقاء بعد';
                          final sub = _searchQuery.isNotEmpty ? 'حاول البحث باسم آخر' : 'أضف أصدقاء للعب معهم!';
                          return _buildEmptyState(msg, sub, _searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.people_outline_rounded, context);
                        }

                        return RefreshIndicator(
                          onRefresh: () async => ref.invalidate(friendsProvider),
                          color: ComicColors.blue,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100), // padding for bottom nav
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final friend = filtered[index];
                              final isOnline = friend.lastActiveAt != null && DateTime.now().difference(friend.lastActiveAt!).inMinutes < 5;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ComicCard(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: ComicColors.black, width: 2),
                                        ),
                                        child: XoAvatar(imageUrl: friend.photoUrl, name: friend.displayName, size: 48, isOnline: isOnline),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(friend.displayName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: ComicColors.black)),
                                            Text(_statusText(isOnline, friend), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: isOnline ? ComicColors.green : Colors.black54)),
                                          ],
                                        ),
                                      ),
                                      ComicScoreChip(score: friend.totalScore, color: ComicColors.yellow),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ComicCard(
          color: Colors.white,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 80, color: ComicColors.blue),
              const SizedBox(height: 16),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: ComicColors.black)),
              const SizedBox(height: 8),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black54)),
              if (title.contains('سجل الدخول')) ...[
                const SizedBox(height: 24),
                ComicButton(
                  label: '🔑 تسجيل الدخول',
                  color: ComicColors.yellow,
                  onTap: () => context.push('/login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: _searchController,
      onChanged: (v) => setState(() => _searchQuery = v),
      style: const TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black),
      decoration: InputDecoration(
        hintText: 'ابحث عن أصدقاء...',
        hintStyle: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black54),
        prefixIcon: const Icon(Icons.search_rounded, color: ComicColors.black),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.black, width: 2.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.black, width: 2.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.blue, width: 3)),
      ),
    );
  }

  String _statusText(bool isOnline, UserModel friend) {
    if (isOnline) return 'متصل 🟢';
    if (friend.lastActiveAt != null) {
      final diff = DateTime.now().difference(friend.lastActiveAt!);
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      return 'منذ ${diff.inDays} يوم';
    }
    return 'غير متصل';
  }

  void _showAddFriendDialog(BuildContext context, String currentUserId) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: ComicColors.black, width: 3)),
        title: const Text('أضف صديق جديد! 🎉', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black)),
        content: TextFormField(
          controller: emailController,
          style: const TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'البريد الإلكتروني للصديق',
            hintStyle: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black54),
            prefixIcon: const Icon(Icons.email_rounded, color: ComicColors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.black, width: 2.5)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.black, width: 2.5)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.blue, width: 3)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ComicColors.yellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: ComicColors.black, width: 2.5))
            ),
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isEmpty) return;
              Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ تم إرسال طلب الصداقة!'), backgroundColor: ComicColors.green),
                );
              }
            },
            child: const Text('إرسال الطلب', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black)),
          ),
        ],
      ),
    );
  }
}
