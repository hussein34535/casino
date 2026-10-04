import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/features/multi_language.dart';

class AdminLocalizationScreen extends ConsumerWidget {
  const AdminLocalizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = XoLocale.supportedLocales;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الترجمة'),
        backgroundColor: AppColors.amber,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: locales.length,
        itemBuilder: (context, index) {
          final locale = locales[index];
          final flagCode = locale.code.length == 2 ? locale.code.toUpperCase() : '';
          final completion = _completionPercentages[index % _completionPercentages.length];

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            flagCode.isNotEmpty ? _flagEmoji(flagCode) : locale.code[0].toUpperCase(),
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(locale.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(locale.nativeName,
                                style: const TextStyle(color: AppColors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      if (locale.isRtl)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('RTL', style: TextStyle(fontSize: 10, color: AppColors.teal)),
                        ),
                      const SizedBox(width: 8),
                      Text('$completion%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: completion >= 80
                                ? AppColors.green
                                : completion >= 50
                                    ? AppColors.yellow
                                    : AppColors.red,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completion / 100,
                      backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        completion >= 80
                            ? AppColors.green
                            : completion >= 50
                                ? AppColors.yellow
                                : AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.amber,
        icon: const Icon(Icons.add),
        label: const Text('إضافة لغة'),
      ),
    );
  }

  String _flagEmoji(String countryCode) {
    final code = countryCode.codeUnits;
    final flag = String.fromCharCodes(code.map((c) => 0x1F1E6 - 65 + c));
    return flag;
  }
}

const List<int> _completionPercentages = [100, 95, 80, 75, 70, 50, 45, 40, 35, 30, 25, 20, 15, 10, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5];
