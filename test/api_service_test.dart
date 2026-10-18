import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:mini_katalog/models/products_model.dart';
import 'package:mini_katalog/services/api_service.dart';

// API'nin döndüreceği küçük, geçerli bir yanıt (2 ürün).
// Ürün adları assets'tekilerden farklı; verinin nereden geldiği anlaşılır.
const String apiBody = '''
{
  "status": "success",
  "data": [
    {"id": 101, "name": "API Phone", "price": "\$1,099"},
    {"id": 102, "name": "API Tablet", "price": "\$799"}
  ]
}
''';

// Yedek veriye düşüldüğünü assets'teki 20 ürün ve ilk ürünün adıyla doğrular.
void expectAssetProducts(List<Product> products) {
  expect(products.length, 20);
  expect(products.first.name, 'iPhone 15 Pro');
}

// Testlerde gerçek internete çıkılmaz; tüm istekler MockClient'a gider.
void main() {
  // rootBundle'ın testte asset okuyabilmesi için Flutter binding'i başlatılır.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('fetchProducts', () {
    test('API başarılıysa ürünler API\'den gelir', () async {
      final service = ApiService(
        client: MockClient((request) async => http.Response(apiBody, 200)),
      );
      final products = await service.fetchProducts();
      expect(products.length, 2);
      expect(products.first.name, 'API Phone');
      expect(products.first.price, '\$1,099');
    });

    test('API 500 dönerse assets\'teki JSON kullanılır', () async {
      final service = ApiService(
        client: MockClient((request) async => http.Response('error', 500)),
      );
      expectAssetProducts(await service.fetchProducts());
    });

    test('bağlantı hatasında assets\'teki JSON kullanılır', () async {
      final service = ApiService(
        client: MockClient(
          (request) async => throw http.ClientException('No internet'),
        ),
      );
      expectAssetProducts(await service.fetchProducts());
    });

    test('zaman aşımında assets\'teki JSON kullanılır', () async {
      // API 1 sn sonra yanıt verir; timeout 100 ms olduğu için beklenmez.
      final service = ApiService(
        client: MockClient((request) async {
          await Future<void>.delayed(const Duration(seconds: 1));
          return http.Response(apiBody, 200);
        }),
        timeout: const Duration(milliseconds: 100),
      );
      expectAssetProducts(await service.fetchProducts());
    });

    test('bozuk JSON gelirse assets\'teki JSON kullanılır', () async {
      final service = ApiService(
        client: MockClient((request) async => http.Response('abc', 200)),
      );
      expectAssetProducts(await service.fetchProducts());
    });

    test('boş veri gelirse assets\'teki JSON kullanılır', () async {
      final service = ApiService(
        client: MockClient(
          (request) async => http.Response('{"data": []}', 200),
        ),
      );
      expectAssetProducts(await service.fetchProducts());
    });
  });

  test('loadFromAssets: products.json dosyasından 20 ürün okunur', () async {
    expectAssetProducts(await ApiService().loadFromAssets());
  });

  group('parseProducts', () {
    test("'data' yoksa boş liste döner", () {
      expect(ApiService.parseProducts('{"status": "success"}'), isEmpty);
    });

    test("'data' liste değilse boş liste döner", () {
      expect(ApiService.parseProducts('{"data": "bozuk"}'), isEmpty);
    });
  });
}
