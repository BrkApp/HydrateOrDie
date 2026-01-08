import 'package:flutter_test/flutter_test.dart';
import 'package:hydrate_or_die/domain/entities/glass_size.dart';

void main() {
  group('GlassSize', () {
    group('volumeLiters', () {
      test('should return 0.2 liters for small glass', () {
        expect(GlassSize.small.volumeLiters, 0.2);
      });

      test('should return 0.25 liters for medium glass', () {
        expect(GlassSize.medium.volumeLiters, 0.25);
      });

      test('should return 0.4 liters for large glass', () {
        expect(GlassSize.large.volumeLiters, 0.4);
      });
    });

    group('displayName', () {
      test('should return correct display name for small', () {
        expect(GlassSize.small.displayName, 'Petit verre (200ml)');
      });

      test('should return correct display name for medium', () {
        expect(GlassSize.medium.displayName, 'Verre moyen (250ml)');
      });

      test('should return correct display name for large', () {
        expect(GlassSize.large.displayName, 'Grand verre (400ml)');
      });
    });

    test('should have 3 glass sizes', () {
      expect(GlassSize.values.length, 3);
    });
  });
}
