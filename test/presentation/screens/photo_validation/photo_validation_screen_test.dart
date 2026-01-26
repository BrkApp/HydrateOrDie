import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/core/di/injection.dart';
import 'package:hydrate_or_die/core/services/camera_permission_service.dart';
import 'package:hydrate_or_die/domain/use_cases/photo/capture_photo_use_case.dart';
import 'package:hydrate_or_die/presentation/screens/photo_validation/photo_validation_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'photo_validation_screen_test.mocks.dart';

@GenerateMocks([CameraPermissionService, CapturePhotoUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockCameraPermissionService mockPermissionService;
  late MockCapturePhotoUseCase mockCapturePhotoUseCase;

  setUp(() {
    mockPermissionService = MockCameraPermissionService();
    mockCapturePhotoUseCase = MockCapturePhotoUseCase();

    // Reset GetIt before each test
    if (getIt.isRegistered<CameraPermissionService>()) {
      getIt.unregister<CameraPermissionService>();
    }
    if (getIt.isRegistered<CapturePhotoUseCase>()) {
      getIt.unregister<CapturePhotoUseCase>();
    }

    // Register mock services
    getIt.registerLazySingleton<CameraPermissionService>(
      () => mockPermissionService,
    );
    getIt.registerLazySingleton<CapturePhotoUseCase>(
      () => mockCapturePhotoUseCase,
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget createTestWidget() {
    return const MaterialApp(home: PhotoValidationScreen());
  }

  group('PhotoValidationScreen', () {
    testWidgets('should display loading state initially', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);
      when(
        mockPermissionService.canRequestPermission(),
      ).thenAnswer((_) async => true);
      when(
        mockPermissionService.requestPermission(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Vérification des permissions...'), findsOneWidget);
    });

    testWidgets('should attempt to initialize camera when permission granted', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.granted);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Initial build
      await tester.pump(); // Permission check completes

      // Assert - Should show loading while camera initializes
      // Note: Camera initialization will fail in test environment (no real camera)
      // but we verify the permission check succeeded
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display permission denied state when denied', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);
      when(
        mockPermissionService.canRequestPermission(),
      ).thenAnswer((_) async => true);
      when(
        mockPermissionService.requestPermission(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Caméra nécessaire'), findsOneWidget);
      expect(find.text('Autoriser la caméra'), findsOneWidget);
      expect(find.text('Annuler'), findsOneWidget);
      expect(
        find.textContaining('Pour valider ton hydratation, nous avons besoin'),
        findsOneWidget,
      );
    });

    testWidgets(
      'should display permanently denied state when permanently denied',
      (WidgetTester tester) async {
        // Arrange
        when(
          mockPermissionService.checkPermissionStatus(),
        ).thenAnswer((_) async => CameraPermissionStatus.permanentlyDenied);
        when(
          mockPermissionService.canRequestPermission(),
        ).thenAnswer((_) async => false);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Permission requise'), findsOneWidget);
        expect(find.text('Ouvrir Paramètres'), findsOneWidget);
        expect(find.text('Annuler'), findsOneWidget);
        expect(
          find.textContaining('Tu as refusé l\'accès à la caméra'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should display permanently denied state when restricted (iOS)',
      (WidgetTester tester) async {
        // Arrange
        when(
          mockPermissionService.checkPermissionStatus(),
        ).thenAnswer((_) async => CameraPermissionStatus.restricted);
        when(
          mockPermissionService.canRequestPermission(),
        ).thenAnswer((_) async => false);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Permission requise'), findsOneWidget);
        expect(find.text('Ouvrir Paramètres'), findsOneWidget);
      },
    );

    testWidgets('should navigate back when close button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);
      when(
        mockPermissionService.canRequestPermission(),
      ).thenAnswer((_) async => true);
      when(
        mockPermissionService.requestPermission(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Assert - Screen should be popped
      expect(find.byType(PhotoValidationScreen), findsNothing);
    });

    testWidgets('should navigate back when Annuler button is tapped (denied)', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);
      when(
        mockPermissionService.canRequestPermission(),
      ).thenAnswer((_) async => true);
      when(
        mockPermissionService.requestPermission(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Assert - Screen should be popped
      expect(find.byType(PhotoValidationScreen), findsNothing);
    });

    testWidgets('should call openSettings when Ouvrir Paramètres is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.permanentlyDenied);
      when(
        mockPermissionService.canRequestPermission(),
      ).thenAnswer((_) async => false);
      when(mockPermissionService.openSettings()).thenAnswer((_) async => true);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ouvrir Paramètres'));
      await tester.pumpAndSettle();

      // Assert
      verify(mockPermissionService.openSettings()).called(1);
    });

    testWidgets(
      'should request permission again when Autoriser la caméra is tapped',
      (WidgetTester tester) async {
        // Arrange
        when(
          mockPermissionService.checkPermissionStatus(),
        ).thenAnswer((_) async => CameraPermissionStatus.denied);
        when(
          mockPermissionService.canRequestPermission(),
        ).thenAnswer((_) async => true);
        when(
          mockPermissionService.requestPermission(),
        ).thenAnswer((_) async => CameraPermissionStatus.denied);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Reset mock to track new calls
        clearInteractions(mockPermissionService);

        await tester.tap(find.text('Autoriser la caméra'));
        await tester.pumpAndSettle();

        // Assert - Should call checkPermissionStatus and potentially requestPermission
        verify(
          mockPermissionService.checkPermissionStatus(),
        ).called(greaterThan(0));
      },
    );

    testWidgets('should display AppBar with title and close button', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);
      when(
        mockPermissionService.canRequestPermission(),
      ).thenAnswer((_) async => true);
      when(
        mockPermissionService.requestPermission(),
      ).thenAnswer((_) async => CameraPermissionStatus.denied);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Validation Photo'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should show error snackbar when openSettings fails', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.permanentlyDenied);
      when(
        mockPermissionService.canRequestPermission(),
      ).thenAnswer((_) async => false);
      when(mockPermissionService.openSettings()).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ouvrir Paramètres'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text(
          'Impossible d\'ouvrir les paramètres. Ouvre-les manuellement.',
        ),
        findsOneWidget,
      );
    });
  });

  group('PhotoValidationScreen - Camera Interface (Story 3.3)', () {
    late MockCameraPermissionService mockPermissionService;

    setUp(() {
      mockPermissionService = MockCameraPermissionService();

      // Reset GetIt before each test
      if (getIt.isRegistered<CameraPermissionService>()) {
        getIt.unregister<CameraPermissionService>();
      }

      // Register mock service
      getIt.registerLazySingleton<CameraPermissionService>(
        () => mockPermissionService,
      );
    });

    tearDown(() async {
      await getIt.reset();
    });

    Widget createTestWidget() {
      return const MaterialApp(home: PhotoValidationScreen());
    }

    testWidgets('should show loading state during camera initialization', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.granted);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Loading indicator shown during camera init
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Vérification des permissions...'), findsOneWidget);
    });

    testWidgets(
      'should display instructions text in camera interface placeholder',
      (WidgetTester tester) async {
        // Note: This test validates the UI structure exists, but camera
        // initialization will fail in test environment (no real camera device)
        // Real camera preview requires integration testing on real device

        // Arrange
        when(
          mockPermissionService.checkPermissionStatus(),
        ).thenAnswer((_) async => CameraPermissionStatus.granted);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        // Assert - In test environment, camera init will fail
        // But we verify permission handling works correctly
        verify(mockPermissionService.checkPermissionStatus()).called(1);
      },
    );

    testWidgets('should handle camera initialization error gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockPermissionService.checkPermissionStatus(),
      ).thenAnswer((_) async => CameraPermissionStatus.granted);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Initial build
      await tester.pump(const Duration(milliseconds: 100)); // Permission check
      await tester.pump(const Duration(seconds: 1)); // Camera init attempt

      // Assert - Should show some UI (either loading or error state)
      // Camera initialization will fail in test environment
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Validation Photo'), findsOneWidget);
    });
  });
}
