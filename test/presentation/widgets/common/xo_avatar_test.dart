import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/presentation/widgets/common/xo_avatar.dart';

Widget createTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: child,
  );
}

void main() {
  group('XoAvatar', () {
    testWidgets('renders name initials', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar(name: 'Ahmed'),
      ));
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('renders first letter of name', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar(name: 'Mohamed'),
      ));
      expect(find.text('M'), findsOneWidget);
    });

    testWidgets('renders question mark when no name provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar(),
      ));
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('shows online indicator when isOnline is true', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar(name: 'Ali', isOnline: true),
      ));
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('small variant uses smaller size', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar.small(name: 'Sam'),
      ));
      expect(find.text('S'), findsOneWidget);
    });

    testWidgets('large variant uses larger size', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar.large(name: 'Large'),
      ));
      expect(find.text('L'), findsOneWidget);
    });

    testWidgets('renders with border when showBorder is true', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar(name: 'Bordered', showBorder: true),
      ));
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('small variant with online indicator', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar.small(name: 'Sam', isOnline: true),
      ));
      expect(find.text('S'), findsOneWidget);
    });

    testWidgets('large variant with online indicator', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoAvatar.large(name: 'Large', isOnline: true),
      ));
      expect(find.text('L'), findsOneWidget);
    });
  });
}
