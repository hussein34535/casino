import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/presentation/widgets/common/xo_card.dart';

Widget createTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: Scaffold(body: child),
  );
}

void main() {
  group('XoCard', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoCard(child: Text('Hello')),
      ));
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(createTestWidget(
        XoCard(child: const Text('Tap'), onTap: () => tapped = true),
      ));
      await tester.tap(find.text('Tap'));
      expect(tapped, true);
    });

    testWidgets('calls onLongPress when long pressed', (tester) async {
      var longPressed = false;
      await tester.pumpWidget(createTestWidget(
        XoCard(child: const Text('Long'), onLongPress: () => longPressed = true),
      ));
      await tester.longPress(find.text('Long'));
      expect(longPressed, true);
    });

    testWidgets('premium variant has gold border', (tester) async {
      await tester.pumpWidget(createTestWidget(
        XoCard.premium(child: const Text('Premium')),
      ));
      expect(find.text('Premium'), findsOneWidget);
    });

    testWidgets('applies custom padding', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoCard(padding: EdgeInsets.all(20), child: Text('Padded')),
      ));
      expect(find.text('Padded'), findsOneWidget);
    });

    testWidgets('applies custom margin', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoCard(margin: EdgeInsets.all(10), child: Text('Margined')),
      ));
      expect(find.text('Margined'), findsOneWidget);
    });

    testWidgets('premium variant can be tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(createTestWidget(
        XoCard.premium(child: const Text('Premium Tap'), onTap: () => tapped = true),
      ));
      await tester.tap(find.text('Premium Tap'));
      expect(tapped, true);
    });
  });

  group('XoSectionCard', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoSectionCard(title: 'Section', children: [Text('Content')]),
      ));
      expect(find.text('Section'), findsOneWidget);
    });

    testWidgets('renders children', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoSectionCard(title: 'Test', children: [Text('Child 1'), Text('Child 2')]),
      ));
      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoSectionCard(title: 'Test', icon: Icons.star, children: [Text('Content')]),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders trailing widget', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoSectionCard(
          title: 'Test',
          trailing: Text('Trailing'),
          children: [Text('Content')],
        ),
      ));
      expect(find.text('Trailing'), findsOneWidget);
    });
  });
}
