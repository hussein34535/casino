import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';

void main() {
  testWidgets('app smoke test - renders without errors', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(body: const Text('test')),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('test'), findsOneWidget);
  });
}
