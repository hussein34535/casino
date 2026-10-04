import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/presentation/widgets/common/xo_loading.dart';

Widget createTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: child,
  );
}

void main() {
  group('XoLoading', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoLoading(),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders message when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoLoading(message: 'Loading...'),
      ));
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('does not render message when not provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoLoading(),
      ));
      // Only the spinner should be present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('XoEmptyState', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoEmptyState(title: 'No items found'),
      ));
      expect(find.text('No items found'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoEmptyState(title: 'Empty', subtitle: 'Try again later'),
      ));
      expect(find.text('Try again later'), findsOneWidget);
    });

    testWidgets('renders default icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoEmptyState(title: 'Empty'),
      ));
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('renders custom icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoEmptyState(title: 'Empty', icon: Icons.search_off),
      ));
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('renders action button when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        XoEmptyState(title: 'Empty', actionLabel: 'Retry', onAction: () {}),
      ));
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('calls onAction when action button tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(createTestWidget(
        XoEmptyState(title: 'Empty', actionLabel: 'Retry', onAction: () => tapped = true),
      ));
      await tester.tap(find.text('Retry'));
      expect(tapped, true);
    });
  });

  group('XoErrorWidget', () {
    testWidgets('renders error message', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoErrorWidget(message: 'Something went wrong'),
      ));
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('renders retry button when onRetry is provided', (tester) async {
      await tester.pumpWidget(createTestWidget(
        XoErrorWidget(message: 'Error', onRetry: () {}),
      ));
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(createTestWidget(
        XoErrorWidget(message: 'Error', onRetry: () => retried = true),
      ));
      await tester.tap(find.text('إعادة المحاولة'));
      expect(retried, true);
    });

    testWidgets('does not render retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoErrorWidget(message: 'Error'),
      ));
      expect(find.text('إعادة المحاولة'), findsNothing);
    });
  });
}
