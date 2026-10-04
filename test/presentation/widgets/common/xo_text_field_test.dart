import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/presentation/widgets/common/xo_text_field.dart';

Widget createTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: Scaffold(body: child),
  );
}

void main() {
  group('XoTextField', () {
    testWidgets('accepts text input', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoTextField(),
      ));
      await tester.enterText(find.byType(TextFormField), 'Hello');
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('calls onChanged when text changes', (tester) async {
      String? changed;
      await tester.pumpWidget(createTestWidget(
        XoTextField(onChanged: (v) => changed = v),
      ));
      await tester.enterText(find.byType(TextFormField), 'test');
      expect(changed, 'test');
    });

    testWidgets('passes validator to TextFormField', (tester) async {
      await tester.pumpWidget(createTestWidget(
        Form(
          child: Column(
            children: const [
              XoTextField(
                label: 'Field',
                validator: _alwaysError,
              ),
            ],
          ),
        ),
      ));
      final formField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(formField.validator, isNotNull);
      expect(formField.validator!('test'), 'Error message');
    });

    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoTextField(label: 'Username'),
      ));
      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('renders hint text', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoTextField(hintText: 'Enter your name'),
      ));
      expect(find.text('Enter your name'), findsOneWidget);
    });

    testWidgets('renders prefix icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoTextField(prefixIcon: Icons.person),
      ));
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders suffix icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoTextField(suffixIcon: Icons.search),
      ));
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const XoTextField(obscureText: true),
      ));
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}

String? _alwaysError(String? value) => 'Error message';
