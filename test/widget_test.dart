import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hydrate_or_die/main.dart';

void main() {
  testWidgets('App loads with correct title', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Wait for Firebase initialization (async in main)
    await tester.pumpAndSettle();

    // Verify app title is displayed
    expect(find.text('Hydrate or Die - MVP'), findsOneWidget);

    // Verify welcome message
    expect(find.text('💧 Welcome to Hydrate or Die!'), findsOneWidget);

    // Verify Clean Architecture is mentioned
    expect(find.text('✅ Clean Architecture structure'), findsOneWidget);
  });

  testWidgets('Counter increments when button pressed', (
    WidgetTester tester,
  ) async {
    // Build our app
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Wait for initialization
    await tester.pumpAndSettle();

    // Verify counter starts at 0
    expect(find.text('Counter: 0'), findsOneWidget);
    expect(find.text('Counter: 1'), findsNothing);

    // Tap the '+' icon and trigger a frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify counter has incremented
    expect(find.text('Counter: 0'), findsNothing);
    expect(find.text('Counter: 1'), findsOneWidget);
  });

  testWidgets('All setup checkmarks are displayed', (
    WidgetTester tester,
  ) async {
    // Build our app
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    await tester.pumpAndSettle();

    // Verify all setup items are shown
    expect(find.text('✅ Clean Architecture structure'), findsOneWidget);
    expect(find.text('✅ Riverpod state management'), findsOneWidget);
    expect(find.text('✅ Firebase mock configuration'), findsOneWidget);
    expect(find.text('✅ All MVP dependencies installed'), findsOneWidget);
  });
}
