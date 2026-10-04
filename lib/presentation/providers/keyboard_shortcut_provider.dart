import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/presentation/providers/game_provider.dart';

final isDesktopProvider = Provider<bool>((ref) {
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;
});

final keyboardShortcutActionsProvider = Provider<Map<ShortcutActivator, VoidCallback>>((ref) {
  return {};
});

class KeyboardShortcutHandler extends ConsumerWidget {
  final Widget child;
  const KeyboardShortcutHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ref.watch(isDesktopProvider);
    if (!isDesktop) return child;

    return Focus(
      autofocus: true,
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyP): () {
            _handleAction(context, ref, 'pause');
          },
          const SingleActivator(LogicalKeyboardKey.keyR): () {
            _handleAction(context, ref, 'show_results');
          },
          const SingleActivator(LogicalKeyboardKey.keyF): () {
            _handleAction(context, ref, 'fullscreen');
          },
          const SingleActivator(LogicalKeyboardKey.escape): () {
            if (context.canPop()) context.pop();
          },
        },
        child: child,
      ),
    );
  }

  static void _handleAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'next_question':
      case 'pause':
        try {
          final gameNotifier = ref.read(gameStateProvider.notifier);
          if (action == 'next_question') gameNotifier.nextQuestion();
        } catch (_) {}
      case 'show_results':
        context.push('/game-select/trivia/results');
      case 'fullscreen':
        if (Theme.of(context).platform == TargetPlatform.android) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        }
    }
  }
}
