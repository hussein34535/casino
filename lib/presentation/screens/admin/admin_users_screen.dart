import 'package:flutter/material.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _searchController = TextEditingController();
  final List<Map<String, dynamic>> _users = List.generate(50, (i) => {
    'id': 'user_$i',
    'name': 'لاعب ${i + 1}',
    'email': 'player${i + 1}@example.com',
    'level': (i % 20) + 1,
    'score': i * 100,
    'gamesPlayed': i * 5,
    'isBanned': i % 15 == 0,
    'isPremium': i % 5 == 0,
    'lastActive': DateTime.now().subtract(Duration(hours: i * 2)).toIso8601String(),
  });

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _users.where((u) =>
        u['name'].toString().contains(_searchController.text) ||
        u['email'].toString().contains(_searchController.text)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المستخدمين'), backgroundColor: AppColors.teal),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن مستخدم...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                filled: true,
                fillColor: AppColors.white,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final user = filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: user['isBanned'] ? AppColors.red : (user['isPremium'] ? AppColors.gold : AppColors.teal),
                      child: Text(user['name'][0]),
                    ),
                    title: Text('${user['name']} ${user['isBanned'] ? '(محظور)' : ''}'),
                    subtitle: Text('${user['email']} | المستوى ${user['level']} | ${user['gamesPlayed']} لعبة'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'ban') {
                          setState(() => user['isBanned'] = !user['isBanned']);
                        } else if (value == 'premium') {
                          setState(() => user['isPremium'] = !user['isPremium']);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'ban', child: Text(user['isBanned'] ? 'رفع الحظر' : 'حظر')),
                        PopupMenuItem(value: 'premium', child: Text(user['isPremium'] ? 'إلغاء الاشتراك' : 'ترقية Premium')),
                        const PopupMenuItem(value: 'delete', child: Text('حذف الحساب', style: TextStyle(color: AppColors.red))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
