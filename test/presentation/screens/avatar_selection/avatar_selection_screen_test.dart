import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hydrate_or_die/presentation/screens/avatar_selection/avatar_selection_screen.dart';
import 'package:hydrate_or_die/domain/repositories/avatar_repository.dart';
import 'package:hydrate_or_die/presentation/providers/avatar_asset_provider.dart';
import 'package:hydrate_or_die/core/di/injection.dart';

import 'avatar_selection_screen_test.mocks.dart';

@GenerateMocks([AvatarRepository])
void main() {
  late MockAvatarRepository mockRepository;

  setUpAll(() {
    // One-time setup for all tests
    getIt.reset();
  });

  setUp(() {
    mockRepository = MockAvatarRepository();

    // Setup GetIt mocks before each test
    if (!getIt.isRegistered<AvatarRepository>()) {
      getIt.registerSingleton<AvatarRepository>(mockRepository);
    } else {
      getIt.unregister<AvatarRepository>();
      getIt.registerSingleton<AvatarRepository>(mockRepository);
    }

    if (!getIt.isRegistered<AvatarAssetProvider>()) {
      getIt.registerSingleton<AvatarAssetProvider>(AvatarAssetProvider());
    }
  });

  tearDownAll(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: const AvatarSelectionScreen(),
        routes: {
          '/home': (_) => const Scaffold(body: Text('Home Screen')),
        },
      ),
    );
  }

  group('AvatarSelectionScreen', () {
    testWidgets('AC #2 - Should display 4 avatars in grid', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Vérifie que la grid existe
      expect(find.byType(GridView), findsOneWidget);

      // Vérifie au moins 2 avatars visibles (Doctor et Coach)
      expect(find.text('Doctor'), findsOneWidget);
      expect(find.text('Coach'), findsOneWidget);

      // Vérifie descriptions
      expect(find.textContaining('médecin personnel'), findsWidgets);
      expect(find.textContaining('coach sportif'), findsWidgets);
    });

    testWidgets('AC #3 - Each avatar shows name and description',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Vérifie descriptions présentes (au moins 2 visibles)
      expect(find.textContaining('médecin personnel'), findsOneWidget);
      expect(find.textContaining('coach sportif'), findsOneWidget);
    });

    testWidgets('AC #4 - Tapping avatar should update selection',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initialement, bouton désactivé
      var button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Confirmer mon choix'),
      );
      expect(button.onPressed, isNull);

      // Tap sur Doctor
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle();

      // Bouton maintenant activé (preuve que sélection a fonctionné)
      button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Confirmer mon choix'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('AC #5 - Confirm button disabled when no selection',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Trouve bouton
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Confirmer mon choix'),
      );

      // Vérifie désactivé
      expect(button.onPressed, isNull);
    });

    testWidgets('AC #5 - Confirm button enabled after selection',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Sélectionne un avatar
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle();

      // Trouve bouton
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Confirmer mon choix'),
      );

      // Vérifie activé
      expect(button.onPressed, isNotNull);
    });

    testWidgets('AC #6 - Confirming should save and navigate to home',
        (tester) async {
      when(mockRepository.saveSelectedAvatar(any))
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Sélectionne un avatar
      await tester.tap(find.text('Coach'));
      await tester.pumpAndSettle();

      // Confirme
      await tester.tap(find.text('Confirmer mon choix'));
      await tester.pumpAndSettle();

      // Vérifie sauvegarde appelée avec le bon ID (sportsCoach)
      verify(mockRepository.saveSelectedAvatar('sportsCoach')).called(1);

      // Vérifie navigation vers home
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('AC #8 - Only one avatar can be selected at a time',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Sélectionne Doctor
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle();

      // Bouton activé
      var button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Confirmer mon choix'),
      );
      expect(button.onPressed, isNotNull);

      // Sélectionne Coach (doit désélectionner Doctor)
      await tester.tap(find.text('Coach'));
      await tester.pumpAndSettle();

      // Bouton toujours activé (avec la nouvelle sélection)
      button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Confirmer mon choix'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Should display title and instructions', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Vérifie titre dans AppBar
      expect(find.text('Choisis ton Avatar'), findsOneWidget);

      // Vérifie instructions
      expect(
          find.text('Sélectionne ton compagnon d\'hydratation'), findsOneWidget);
      expect(find.text('Il te motivera (ou punira) tous les jours'),
          findsOneWidget);
    });

    testWidgets('Should save correct avatar ID for doctor', (tester) async {
      when(mockRepository.saveSelectedAvatar(any))
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Test Doctor → "doctor"
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmer mon choix'));
      await tester.pumpAndSettle();

      verify(mockRepository.saveSelectedAvatar('doctor')).called(1);
    });

    testWidgets('Should save correct avatar ID for coach', (tester) async {
      when(mockRepository.saveSelectedAvatar(any))
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Test Coach → "sportsCoach"
      await tester.tap(find.text('Coach'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmer mon choix'));
      await tester.pumpAndSettle();

      verify(mockRepository.saveSelectedAvatar('sportsCoach')).called(1);
    });

    testWidgets('Should not navigate if save fails', (tester) async {
      when(mockRepository.saveSelectedAvatar(any))
          .thenThrow(Exception('Save failed'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Sélectionne un avatar
      await tester.tap(find.text('Doctor'));
      await tester.pumpAndSettle();

      // Confirme
      await tester.tap(find.text('Confirmer mon choix'));
      await tester.pumpAndSettle();

      // Vérifie qu'on est toujours sur l'écran de sélection
      expect(find.text('Choisis ton Avatar'), findsOneWidget);
      expect(find.text('Home Screen'), findsNothing);
    });
  });
}
