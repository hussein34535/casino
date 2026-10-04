import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/presentation/widgets/common/xo_button.dart';

Widget createTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: child,
  );
}

void main() {
  group('XoButton', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Click Me', expanded: false),
      ));
      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(createTestWidget(
        XoButton(label: 'Click', onPressed: () => pressed = true, expanded: false),
      ));
      await tester.tap(find.text('Click'));
      expect(pressed, true);
    });

    testWidgets('shows CircularProgressIndicator when loading', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Loading', isLoading: true, expanded: false),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('does not call onPressed when loading', (tester) async {
      var pressed = false;
      await tester.pumpWidget(createTestWidget(
        XoButton(
          label: 'Loading',
          isLoading: true,
          onPressed: () => pressed = true,
          expanded: false,
        ),
      ));
      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, false);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Icon', icon: Icons.star, expanded: false),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders suffix icon when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Suffix', suffixIcon: Icons.arrow_forward, expanded: false),
      ));
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('renders both prefix and suffix icons', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(
          label: 'Both',
          icon: Icons.search,
          suffixIcon: Icons.arrow_forward,
          expanded: false,
        ),
      ));
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('expanded mode takes full width', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Full Width', expanded: true),
      ));
      final button = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(button.width, double.infinity);
    });

    testWidgets('non-expanded mode takes minimum width', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Compact', expanded: false),
      ));
      expect(find.byType(SizedBox), findsNothing);
    });

    testWidgets('renders secondary variant', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Secondary', variant: XoButtonVariant.secondary, expanded: false),
      ));
      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('renders danger variant', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Danger', variant: XoButtonVariant.danger, expanded: false),
      ));
      expect(find.text('Danger'), findsOneWidget);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoButton(label: 'Disabled', expanded: false),
      ));
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.onPressed, isNull);
    });
  });
}
