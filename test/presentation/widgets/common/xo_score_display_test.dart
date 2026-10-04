import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/presentation/widgets/common/xo_score_display.dart';

Widget createTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: child,
  );
}

void main() {
  group('XoScoreDisplay', () {
    testWidgets('renders score value', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoScoreDisplay(score: 42),
      ));
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('shows star icon for high scores', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoScoreDisplay(score: 10),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('shows trending up icon for positive scores', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoScoreDisplay(score: 5),
      ));
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('shows trending down icon for zero or negative scores', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoScoreDisplay(score: 0),
      ));
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });

    testWidgets('hides icon when showIcon is false', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoScoreDisplay(score: 10, showIcon: false),
      ));
      expect(find.byIcon(Icons.star), findsNothing);
    });
  });

  group('XoBadge', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoBadge(label: 'New'),
      ));
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('yellow variant renders with star icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoBadge.yellow(label: 'Premium'),
      ));
      expect(find.text('Premium'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('red variant renders with error icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoBadge.red(label: 'Danger'),
      ));
      expect(find.text('Danger'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('green variant renders with check icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoBadge.green(label: 'Verified'),
      ));
      expect(find.text('Verified'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('purple variant renders with auto awesome icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoBadge.purple(label: 'Special'),
      ));
      expect(find.text('Special'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });
  });

  group('XoStatItem', () {
    testWidgets('renders value and label', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoStatItem(icon: Icons.star, value: '42', label: 'Points'),
      ));
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Points'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoStatItem(icon: Icons.favorite, value: '10', label: 'Likes'),
      ));
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
