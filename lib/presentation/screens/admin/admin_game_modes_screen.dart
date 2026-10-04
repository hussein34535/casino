import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/features/game_modes.dart';

class AdminGameModesScreen extends ConsumerWidget {
  const AdminGameModesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات أوضاع اللعب'),
        backgroundColor: AppColors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: GameMode.values.length,
        itemBuilder: (context, index) {
          final mode = GameMode.values[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.yellow.withValues(alpha: 0.2),
                child: Text(mode.icon, style: const TextStyle(fontSize: 24)),
              ),
              title: Text(mode.nameAr, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(mode.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Switch(
                value: true,
                activeThumbColor: AppColors.green,
                onChanged: (v) {},
              ),
            ),
          );
        },
      ),
    );
  }
}
