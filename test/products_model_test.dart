import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/products_model.dart';
import 'package:mini_katalog/utils/price_parser.dart';

void main() {
  final json = {
    'id': 1,
    'name': 'iPhone 15 Pro',
    'tagline': 'Titanium. So strong. So light. So Pro.',
    'description': 'Açıklama',
    'price': '\$999',
    'currency': 'USD',
    'image': 'https://wantapi.com/assets/images/iphone.png',
    'specs': {'chip': 'A17 Pro', 'material': 'Titanium'},
  };

  group('Product', () {
    test('fromJson tüm alanları doğru okur', () {
      final p = Product.fromJson(json);
      expect(p.id, 1);
      expect(p.name, 'iPhone 15 Pro');
      expect(p.price, '\$999');
      expect(p.specs['chip'], 'A17 Pro');
    });

    test('toJson fromJson ile aynı veriyi geri verir', () {
      expect(Product.fromJson(json).toJson(), json);
    });

    test('eksik alanlarda güvenli varsayılanlar kullanılır', () {
      final p = Product.fromJson({});
      expect(p.id, 0);
      expect(p.name, '');
      expect(p.price, '');
      expect(p.specs, isEmpty);
    });

    test('yanlış tipte veride çökmez: id "abc" → 0, name 123 → "123"', () {
      final p = Product.fromJson({
        'id': 'abc',
        'name': 123,
        'specs': 'bozuk', // Map değil → boş Map
      });
      expect(p.id, 0);
      expect(p.name, '123');
      expect(p.specs, isEmpty);
    });
  });

  group('parsePrice', () {
    test(r'"$999" → 999.0', () => expect(parsePrice('\$999'), 999.0));
    test(r'"$3,499" → 3499.0', () => expect(parsePrice('\$3,499'), 3499.0));
    test('hatalı değerde 0.0 döner', () {
      expect(parsePrice('abc'), 0.0);
      expect(parsePrice(''), 0.0);
    });
  });
}
