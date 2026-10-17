import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/utils/price_formatter.dart';
import 'package:mini_katalog/utils/price_parser.dart';

void main() {
  group('formatPrice', () {
    test('binlik ayracı doğru yere konur', () {
      expect(formatPrice(0), '\$0');
      expect(formatPrice(99), '\$99');
      expect(formatPrice(999), '\$999');
      expect(formatPrice(1000), '\$1,000');
      expect(formatPrice(2499), '\$2,499');
      expect(formatPrice(3498), '\$3,498');
      expect(formatPrice(12345), '\$12,345');
      expect(formatPrice(1234567), '\$1,234,567');
    });

    test('kuruşlar yuvarlanır', () {
      expect(formatPrice(2499.4), '\$2,499');
      expect(formatPrice(2499.6), '\$2,500');
    });

    test('parsePrice ile geri çevrilince aynı sayı elde edilir', () {
      expect(parsePrice(formatPrice(3498)), 3498.0);
    });
  });
}
