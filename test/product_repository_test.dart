import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/data/product_repository.dart';

void main() {
  // rootBundle'ın testte asset okuyabilmesi için Flutter binding'i başlatılır.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('products.json dosyasından 20 ürün okunur', () async {
    final products = await const ProductRepository().loadProducts();
    expect(products.length, 20);
    expect(products.first.name, 'iPhone 15 Pro');
  });

  test("'data' yoksa boş liste döner", () {
    expect(ProductRepository.parseProducts('{"status": "success"}'), isEmpty);
  });

  test("'data' liste değilse boş liste döner", () {
    expect(ProductRepository.parseProducts('{"data": "bozuk"}'), isEmpty);
  });
}
