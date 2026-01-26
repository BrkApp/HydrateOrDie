import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:hydrate_or_die/core/di/injection.dart';
import 'package:hydrate_or_die/domain/entities/avatar_state.dart';
import 'package:hydrate_or_die/domain/entities/glass_size.dart';
import 'package:hydrate_or_die/domain/entities/hydration_log.dart';
import 'package:hydrate_or_die/domain/use_cases/hydration/record_hydration_use_case.dart';
import 'package:hydrate_or_die/presentation/screens/photo/glass_size_selection_screen.dart';

import 'glass_size_selection_screen_test.mocks.dart';

/// Widget tests pour GlassSizeSelectionScreen (Story 3.9).
///
/// Tests couverts (AC7):
/// - Affichage des 3 options avec labels corrects
/// - Medium pré-sélectionné par défaut
/// - Tap change la sélection visuelle
/// - Tap appelle RecordHydrationUseCase avec bon glassSize
/// - Navigation vers HomeScreen après enregistrement
@GenerateMocks([RecordHydrationUseCase])
void main() {
  late MockRecordHydrationUseCase mockRecordHydrationUseCase;

  setUp(() {
    mockRecordHydrationUseCase = MockRecordHydrationUseCase();

    // Setup GetIt mock
    if (getIt.isRegistered<RecordHydrationUseCase>()) {
      getIt.unregister<RecordHydrationUseCase>();
    }
    getIt.registerSingleton<RecordHydrationUseCase>(mockRecordHydrationUseCase);
  });

  tearDown(() {
    if (getIt.isRegistered<RecordHydrationUseCase>()) {
      getIt.unregister<RecordHydrationUseCase>();
    }
  });

  /// Helper pour créer un RecordHydrationResult mock.
  RecordHydrationResult createMockResult(GlassSize glassSize) {
    final mockLog = HydrationLog(
      id: 'test-log-id',
      timestamp: DateTime.now(),
      photoPath: '/test/path/photo.jpg',
      glassSize: glassSize,
      validated: true,
    );

    return RecordHydrationResult(
      log: mockLog,
      totalVolumeToday: 0.5,
      dailyGoalLiters: 2.0,
      progressPercentage: 0.25,
      avatarState: AvatarState.fresh,
    );
  }

  /// Helper pour créer le widget testé avec navigation.
  Widget createWidgetUnderTest(String photoPath) {
    return MaterialApp(
      home: GlassSizeSelectionScreen(photoPath: photoPath),
      routes: {
        '/home': (_) => const Scaffold(body: Text('Home Screen')),
        '/feedback': (_) => const Scaffold(body: Text('Feedback Screen')),
      },
    );
  }

  group('GlassSizeSelectionScreen - UI', () {
    testWidgets('AC2: affiche 3 options avec labels corrects', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Assert - Vérifier les 3 labels avec volumes en ml (AC2)
      expect(find.text('Petit verre (200ml)'), findsOneWidget);
      expect(find.text('Verre moyen (250ml)'), findsOneWidget);
      expect(find.text('Grand verre (400ml)'), findsOneWidget);
    });

    testWidgets('AC3: affiche icons proportionnels à la taille', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Assert - Vérifier présence des icons local_drink
      final icons = find.byIcon(Icons.local_drink);
      expect(icons, findsNWidgets(3)); // 3 icons (small, medium, large)
    });

    testWidgets('AC4: aucune option pré-sélectionnée par défaut', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Assert - Vérifier qu'aucun checkmark n'est présent initialement
      final checkmarks = find.byIcon(Icons.check_circle);
      expect(checkmarks, findsNothing);
    });

    testWidgets('affiche instructions claires en haut', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Assert - Vérifier titre et sous-titre
      expect(find.text('Quelle taille de verre as-tu bu ?'), findsOneWidget);
      expect(
        find.text('Tape pour sélectionner et enregistrer'),
        findsOneWidget,
      );
    });
  });

  group('GlassSizeSelectionScreen - Interactions', () {
    testWidgets('AC5: tap sur option appelle RecordHydrationUseCase', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Mock use case success
      when(
        mockRecordHydrationUseCase(
          photoPath: anyNamed('photoPath'),
          glassSize: anyNamed('glassSize'),
        ),
      ).thenAnswer((_) async => createMockResult(GlassSize.large));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Tap sur "Grand verre (400ml)"
      await tester.tap(find.text('Grand verre (400ml)'));
      await tester.pumpAndSettle();

      // Assert - Vérifier appel use case avec bon glassSize (AC6)
      verify(
        mockRecordHydrationUseCase(
          photoPath: testPhotoPath,
          glassSize: GlassSize.large,
        ),
      ).called(1);
    });

    testWidgets('AC5: navigation vers FeedbackScreen après enregistrement', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Mock use case success
      when(
        mockRecordHydrationUseCase(
          photoPath: anyNamed('photoPath'),
          glassSize: anyNamed('glassSize'),
        ),
      ).thenAnswer((_) async => createMockResult(GlassSize.small));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Tap sur "Petit verre (200ml)"
      await tester.tap(find.text('Petit verre (200ml)'));
      await tester.pumpAndSettle();

      // Assert - Vérifier navigation vers FeedbackScreen (Story 3.7)
      expect(find.text('Feedback Screen'), findsOneWidget);
      expect(find.byType(GlassSizeSelectionScreen), findsNothing);
    });

    testWidgets('AC6: passe le bon glassSize au use case (small)', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Mock use case success
      when(
        mockRecordHydrationUseCase(
          photoPath: anyNamed('photoPath'),
          glassSize: anyNamed('glassSize'),
        ),
      ).thenAnswer((_) async => createMockResult(GlassSize.small));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Tap sur "Petit verre (200ml)"
      await tester.tap(find.text('Petit verre (200ml)'));
      await tester.pumpAndSettle();

      // Assert - Vérifier glassSize = small
      verify(
        mockRecordHydrationUseCase(
          photoPath: testPhotoPath,
          glassSize: GlassSize.small,
        ),
      ).called(1);
    });

    testWidgets('AC6: passe le bon glassSize au use case (medium)', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Mock use case success
      when(
        mockRecordHydrationUseCase(
          photoPath: anyNamed('photoPath'),
          glassSize: anyNamed('glassSize'),
        ),
      ).thenAnswer((_) async => createMockResult(GlassSize.medium));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Tap sur "Verre moyen (250ml)"
      await tester.tap(find.text('Verre moyen (250ml)'));
      await tester.pumpAndSettle();

      // Assert - Vérifier glassSize = medium
      verify(
        mockRecordHydrationUseCase(
          photoPath: testPhotoPath,
          glassSize: GlassSize.medium,
        ),
      ).called(1);
    });

    testWidgets('affiche loading pendant enregistrement', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Mock use case avec délai
      when(
        mockRecordHydrationUseCase(
          photoPath: anyNamed('photoPath'),
          glassSize: anyNamed('glassSize'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return createMockResult(GlassSize.large);
      });

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Tap sur une option
      await tester.tap(find.text('Grand verre (400ml)'));
      await tester.pump(); // Déclencher le setState

      // Assert - Vérifier message de loading
      expect(find.text('Enregistrement en cours...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Attendre la fin
      await tester.pumpAndSettle();
    });
  });

  group('GlassSizeSelectionScreen - Gestion Erreurs', () {
    testWidgets('affiche erreur si RecordHydrationUseCase échoue', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';
      const errorMessage = 'Échec enregistrement';

      // Mock use case failure
      when(
        mockRecordHydrationUseCase(
          photoPath: anyNamed('photoPath'),
          glassSize: anyNamed('glassSize'),
        ),
      ).thenThrow(RecordHydrationException(errorMessage));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Tap sur une option
      await tester.tap(find.text('Petit verre (200ml)'));
      await tester.pumpAndSettle();

      // Assert - Vérifier SnackBar avec message d'erreur
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);

      // Vérifier qu'on reste sur l'écran de sélection (pas de navigation)
      expect(find.byType(GlassSizeSelectionScreen), findsOneWidget);
      expect(find.text('Feedback Screen'), findsNothing);
    });

    testWidgets('bouton close désactivé pendant enregistrement', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Mock use case avec délai
      when(
        mockRecordHydrationUseCase(
          photoPath: anyNamed('photoPath'),
          glassSize: anyNamed('glassSize'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return createMockResult(GlassSize.large);
      });

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Tap sur une option
      await tester.tap(find.text('Grand verre (400ml)'));
      await tester.pump(); // Déclencher le setState

      // Essayer de fermer
      final closeButton = find.byIcon(Icons.close);
      await tester.tap(closeButton);
      await tester.pump();

      // Assert - Vérifier qu'on reste sur l'écran (bouton désactivé)
      expect(find.byType(GlassSizeSelectionScreen), findsOneWidget);

      // Attendre la fin
      await tester.pumpAndSettle();
    });
  });

  group('GlassSizeSelectionScreen - Widget Rendering', () {
    testWidgets('cards ont les bons styles visuels', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testPhotoPath = '/test/path/photo.jpg';

      // Act
      await tester.pumpWidget(createWidgetUnderTest(testPhotoPath));

      // Assert - Vérifier présence des 3 Cards
      final cards = find.byType(Card);
      expect(cards, findsNWidgets(3));

      // Vérifier InkWell pour tap gesture
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsAtLeastNWidgets(3));
    });
  });
}
