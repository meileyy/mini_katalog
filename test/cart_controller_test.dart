import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/models/products_model.dart';
import 'package:mini_katalog/state/cart_controller.dart';

// Testlerde kullanılan basit ürün; yalnızca id ve fiyat önemli.
Product makeProduct(int id, String price) => Product(
  id: id,
  name: 'Product $id',
  tagline: '',
  description: '',
  price: price,
  currency: 'USD',
  image: '',
  specs: const {},
);

// Her test kendi CartController örneğini oluşturur; global örneğe
// dokunulmadığı için testler birbirini etkilemez.
void main() {
  final Product iphone = makeProduct(1, '\$999');
  final Product macbook = makeProduct(2, '\$2,499');

  test('başlangıçta sepet boş, toplam 0', () {
    final cart = CartController();
    expect(cart.items, isEmpty);
    expect(cart.count, 0);
    expect(cart.total, 0.0);
  });

  test(r'add: adet artar, toplam "$999" + "$2,499" = 3498', () {
    final cart = CartController();
    cart.add(iphone);
    cart.add(macbook);
    expect(cart.count, 2);
    expect(cart.total, 3498.0);
  });

  test('aynı ürün iki kez eklenirse ayrı satır olur', () {
    final cart = CartController();
    cart.add(iphone);
    cart.add(iphone);
    expect(cart.count, 2);
    expect(cart.total, 1998.0);
  });

  test('remove: kopyalardan yalnızca biri çıkar', () {
    final cart = CartController();
    cart.add(iphone);
    cart.add(iphone);
    cart.remove(iphone);
    expect(cart.count, 1);
  });

  test('remove: farklı nesne ama aynı id ise de çıkar', () {
    final cart = CartController();
    cart.add(iphone);
    // Aynı ürün, farklı nesne (JSON'dan tekrar okunmuş gibi)
    cart.remove(makeProduct(1, '\$999'));
    expect(cart.count, 0);
  });

  test('clear: sepet boşalır', () {
    final cart = CartController();
    cart.add(iphone);
    cart.add(macbook);
    cart.clear();
    expect(cart.count, 0);
    expect(cart.total, 0.0);
  });

  test('items dışarıdan değiştirilemez', () {
    final cart = CartController();
    cart.add(iphone);
    expect(() => cart.items.add(macbook), throwsUnsupportedError);
    expect(cart.count, 1);
  });

  test('her değişiklikte notifyListeners çağrılır', () {
    final cart = CartController();
    int calls = 0;
    cart.addListener(() => calls++);

    cart.add(iphone); // 1
    cart.remove(iphone); // 2
    cart.add(macbook); // 3
    cart.clear(); // 4
    expect(calls, 4);

    // Değişiklik olmayan çağrılar haber vermez.
    cart.remove(iphone); // sepette yok
    cart.clear(); // zaten boş
    expect(calls, 4);
  });
}
