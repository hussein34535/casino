import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/infrastructure_provider.dart';

class XoOfflineBanner extends ConsumerWidget {
  const XoOfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider).valueOrNull ?? true;
    if (isOnline) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: ComicColors.red,
          border: Border(bottom: BorderSide(color: ComicColors.black, width: 3)),
        ),
        child: const Text(
          'أنت غير متصل بالإنترنت',
          textAlign: TextAlign.center,
          style: TextStyle(color: ComicColors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
