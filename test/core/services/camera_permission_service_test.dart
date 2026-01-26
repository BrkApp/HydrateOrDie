import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/core/services/camera_permission_service.dart';

void main() {
  group('CameraPermissionService', () {
    late CameraPermissionService service;

    setUp(() {
      service = CameraPermissionService();
    });

    group('CameraPermissionStatus enum', () {
      test('should have all expected values', () {
        // Assert
        expect(CameraPermissionStatus.values.length, 4);
        expect(
          CameraPermissionStatus.values,
          containsAll([
            CameraPermissionStatus.granted,
            CameraPermissionStatus.denied,
            CameraPermissionStatus.permanentlyDenied,
            CameraPermissionStatus.restricted,
          ]),
        );
      });

      test('enum values should be distinct', () {
        // Assert
        final values = CameraPermissionStatus.values.toSet();
        expect(values.length, CameraPermissionStatus.values.length);
      });

      test('enum should have granted status', () {
        // Assert
        expect(
          CameraPermissionStatus.values.contains(
            CameraPermissionStatus.granted,
          ),
          isTrue,
        );
      });

      test('enum should have denied status', () {
        // Assert
        expect(
          CameraPermissionStatus.values.contains(CameraPermissionStatus.denied),
          isTrue,
        );
      });

      test('enum should have permanentlyDenied status', () {
        // Assert
        expect(
          CameraPermissionStatus.values.contains(
            CameraPermissionStatus.permanentlyDenied,
          ),
          isTrue,
        );
      });

      test('enum should have restricted status', () {
        // Assert
        expect(
          CameraPermissionStatus.values.contains(
            CameraPermissionStatus.restricted,
          ),
          isTrue,
        );
      });
    });

    group('Service instantiation', () {
      test('should create instance of CameraPermissionService', () {
        // Assert
        expect(service, isA<CameraPermissionService>());
      });

      test('should have checkPermissionStatus method', () {
        // Assert
        expect(service.checkPermissionStatus, isA<Function>());
      });

      test('should have requestPermission method', () {
        // Assert
        expect(service.requestPermission, isA<Function>());
      });

      test('should have canRequestPermission method', () {
        // Assert
        expect(service.canRequestPermission, isA<Function>());
      });

      test('should have openSettings method', () {
        // Assert
        expect(service.openSettings, isA<Function>());
      });
    });
  });
}
