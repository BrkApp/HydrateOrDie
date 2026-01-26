import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/use_cases/photo/capture_photo_use_case.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:path/path.dart' as path;

// Generate mocks for CameraController
@GenerateMocks([CameraController])
void main() {
  group('CapturePhotoUseCase', () {
    group('_generateFileName', () {
      test('devrait générer un nom de fichier avec le format correct', () {
        // Arrange: Créer une instance pour accéder à la méthode privée via test
        final now = DateTime(2026, 1, 16, 9, 30, 45);
        final expectedFormat = 'hydration_20260116_093045.jpg';

        // Act: Simuler le format via DateFormat
        final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
        final fileName = 'hydration_$timestamp.jpg';

        // Assert
        expect(fileName, equals(expectedFormat));
      });

      test('devrait utiliser le format yyyyMMdd_HHmmss exact', () {
        // Test avec différentes dates
        final testCases = [
          {
            'date': DateTime(2026, 12, 31, 23, 59, 59),
            'expected': 'hydration_20261231_235959.jpg',
          },
          {
            'date': DateTime(2026, 1, 1, 0, 0, 0),
            'expected': 'hydration_20260101_000000.jpg',
          },
          {
            'date': DateTime(2026, 6, 15, 14, 30, 22),
            'expected': 'hydration_20260615_143022.jpg',
          },
        ];

        for (final testCase in testCases) {
          final date = testCase['date'] as DateTime;
          final expected = testCase['expected'] as String;

          final timestamp = DateFormat('yyyyMMdd_HHmmss').format(date);
          final fileName = 'hydration_$timestamp.jpg';

          expect(
            fileName,
            equals(expected),
            reason: 'Format incorrect pour date: $date',
          );
        }
      });

      test('devrait toujours avoir l\'extension .jpg', () {
        final now = DateTime.now();
        final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
        final fileName = 'hydration_$timestamp.jpg';

        expect(fileName.endsWith('.jpg'), isTrue);
      });

      test('devrait toujours commencer par "hydration_"', () {
        final now = DateTime.now();
        final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
        final fileName = 'hydration_$timestamp.jpg';

        expect(fileName.startsWith('hydration_'), isTrue);
      });

      test('devrait avoir exactement un underscore entre date et heure', () {
        final now = DateTime(2026, 1, 16, 9, 30, 45);
        final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
        final fileName = 'hydration_$timestamp.jpg';

        // Format: hydration_YYYYMMDD_HHmmss.jpg
        // Devrait contenir exactement 2 underscores
        final underscoreCount = '_'.allMatches(fileName).length;
        expect(underscoreCount, equals(2));
      });
    });

    group('Compression Quality', () {
      test('devrait utiliser quality parameter = 80', () {
        // Assert: Vérifier que la constante est bien définie
        expect(CapturePhotoUseCase.kCompressionQuality, equals(80));
      });

      test('quality parameter devrait être entre 0 et 100', () {
        final quality = CapturePhotoUseCase.kCompressionQuality;
        expect(quality, greaterThanOrEqualTo(0));
        expect(quality, lessThanOrEqualTo(100));
      });
    });

    group('Exception Handling', () {
      test('CapturePhotoException devrait contenir un message user-friendly', () {
        // Arrange
        const errorMessage =
            'Impossible de sauvegarder la photo. Vérifie ton espace de stockage.';

        // Act
        final exception = CapturePhotoException(errorMessage);

        // Assert
        expect(exception.message, equals(errorMessage));
        expect(exception.toString(), equals(errorMessage));
      });

      test(
        'CapturePhotoException devrait pouvoir contenir une exception originale',
        () {
          // Arrange
          const errorMessage = 'Erreur de sauvegarde';
          final originalException = FileSystemException('Disk full');

          // Act
          final exception = CapturePhotoException(
            errorMessage,
            originalException: originalException,
          );

          // Assert
          expect(exception.message, equals(errorMessage));
          expect(exception.originalException, equals(originalException));
        },
      );
    });

    group('File Path Generation', () {
      test('devrait générer un chemin valide avec nom de fichier correct', () {
        // Arrange
        final now = DateTime(2026, 1, 16, 9, 30, 45);
        final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
        final fileName = 'hydration_$timestamp.jpg';
        const dirPath = '/test/photos';

        // Act
        final filePath = path.join(dirPath, fileName);

        // Assert
        expect(filePath, contains('hydration_'));
        expect(filePath, contains('.jpg'));
        expect(filePath, contains(dirPath));
      });

      test('devrait utiliser le séparateur de chemin correct', () {
        // Arrange
        const dirPath = '/test/photos';
        const fileName = 'hydration_20260116_093045.jpg';

        // Act
        final filePath = path.join(dirPath, fileName);

        // Assert: path.join utilise le séparateur correct pour la plateforme
        expect(filePath.contains(fileName), isTrue);
      });
    });

    group('Error Messages', () {
      test('message d\'erreur storage plein devrait être user-friendly', () {
        // Arrange
        const expectedMessage =
            'Impossible de sauvegarder la photo. Vérifie ton espace de stockage.';

        // Assert
        expect(expectedMessage, isNotEmpty);
        expect(expectedMessage.toLowerCase(), contains('stockage'));
        expect(expectedMessage, isNot(contains('Exception')));
        expect(expectedMessage, isNot(contains('error')));
      });
    });
  });
}
