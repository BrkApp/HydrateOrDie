import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/presentation/widgets/hydration_progress_bar.dart';

void main() {
  group('HydrationProgressBar', () {
    testWidgets('should display progress bar with 0% progress', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 0,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(HydrationProgressBar), findsOneWidget);
      expect(find.text('0% • 0.0L / 2.5L'), findsOneWidget);
    });

    testWidgets('should display progress bar with 50% progress', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 1250,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('50% • 1.3L / 2.5L'), findsOneWidget);
    });

    testWidgets('should display progress bar with 100% progress', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 2500,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('100% • 2.5L / 2.5L'), findsOneWidget);
    });

    testWidgets('should display progress bar with over 100% progress', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 3000,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert - Should clamp to 100%
      expect(find.text('120% • 3.0L / 2.5L'), findsOneWidget);
    });

    testWidgets('should display custom height', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 1000,
              goalVolume: 2500,
              height: 60.0,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(AnimatedContainer),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.constraints?.maxHeight, 60.0);
    });

    testWidgets('should handle zero goal volume', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 100,
              goalVolume: 0,
            ),
          ),
        ),
      );

      // Assert - Should display 0% when goal is 0
      expect(find.text('0% • 0.1L / 0.0L'), findsOneWidget);
    });

    testWidgets('should format volume correctly in liters', (tester) async {
      // Test various volumes
      final testCases = [
        (500, 2500, '0.5L / 2.5L'),
        (1000, 2000, '1.0L / 2.0L'),
        (1750, 3500, '1.8L / 3.5L'),
        (2345, 2500, '2.3L / 2.5L'),
      ];

      for (final testCase in testCases) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HydrationProgressBar(
                currentVolume: testCase.$1,
                goalVolume: testCase.$2,
              ),
            ),
          ),
        );

        expect(find.textContaining(testCase.$3), findsOneWidget);
      }
    });

    testWidgets('should have gradient background for fill bar', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 1250,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());

      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors, contains(const Color(0xFF64B5F6))); // Light blue
      expect(gradient.colors, contains(const Color(0xFF2196F3))); // Hydration blue
    });

    testWidgets('should have rounded corners (8px radius)', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 1000,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(AnimatedContainer),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8.0));
    });

    testWidgets('should animate fill smoothly (500ms)', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 1000,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert - Check animation duration
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      expect(animatedContainer.duration, const Duration(milliseconds: 500));
      expect(animatedContainer.curve, Curves.easeInOut);
    });

    testWidgets('should display gray background (0xFFE0E0E0)', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 500,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(AnimatedContainer),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFE0E0E0));
    });

    testWidgets('should display percentage and volume text', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HydrationProgressBar(
              currentVolume: 1250,
              goalVolume: 2500,
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('50% • 1.3L / 2.5L'));
      expect(textWidget.style?.fontSize, 14.0);
      expect(textWidget.style?.fontWeight, FontWeight.w600);
      expect(textWidget.style?.color, Colors.black87);
    });
  });
}
