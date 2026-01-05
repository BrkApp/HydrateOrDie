import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hydrate_or_die/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HydrateOrDieApp());

    // Verify that splash screen appears
    expect(find.text('HydrateOrDie'), findsOneWidget);
    expect(find.text('Bois ou souffre'), findsOneWidget);
  });
}
