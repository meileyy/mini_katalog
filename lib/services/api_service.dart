import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/products_model.dart';

// Ürünleri API'den çeken sınıf. API'ye ulaşılamazsa uygulamaya gömülü
// JSON dosyasına düşer. Ekranlar http'ye veya JSON'a doğrudan dokunmaz.
class ApiService {
  // client ve timeout dışarıdan verilebilir; testlerde MockClient ve kısa
  // bir süre kullanılır. Uygulamada varsayılanlar geçerlidir.
  ApiService({http.Client? client, this.timeout = const Duration(seconds: 10)})
    : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  static const String _url = 'https://wantapi.com/products.php';

  // Yedek dosyanın yolu (pubspec.yaml'da assets/data/ tanımlı olmalı).
  static const String _assetPath = 'assets/data/products.json';

  // Önce API denenir; hata olursa yerel JSON okunur.
  // Yerel JSON da okunamazsa hata yakalanmaz, FutureBuilder'a gider.
  Future<List<Product>> fetchProducts() async {
    try {
      return await _fetchFromApi();
    } catch (e) {
      // Zaman aşımı, bağlantı hatası, 200 dışı yanıt, bozuk veya boş veri
      debugPrint('API\'den ürünler alınamadı, yerel veriye geçiliyor: $e');
      return loadFromAssets();
    }
  }

  // API'ye GET isteği atar; sorun varsa hata fırlatır.
  Future<List<Product>> _fetchFromApi() async {
    final http.Response response = await _client
        .get(Uri.parse(_url))
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    // Bozuk JSON'da jsonDecode FormatException fırlatır.
    final List<Product> products = parseProducts(response.body);
    if (products.isEmpty) {
      throw Exception('API boş veri döndü');
    }
    return products;
  }

  // Uygulamaya gömülü JSON dosyasını okur (JSON simülasyonu).
  Future<List<Product>> loadFromAssets() async {
    // rootBundle: uygulamaya gömülü asset dosyalarını okur.
    final String text = await rootBundle.loadString(_assetPath);
    return parseProducts(text);
  }

  // JSON metnini List<Product>'a çevirir.
  // Kök bir Map değilse ya da 'data' bir liste değilse çökmeden boş liste döner.
  static List<Product> parseProducts(String text) {
    final dynamic json = jsonDecode(text);
    if (json is! Map<String, dynamic>) return [];

    final dynamic data = json['data'];
    if (data is! List) return [];

    // Listede Map olmayan bozuk eleman varsa atlanır.
    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => Product.fromJson(item))
        .toList();
  }
}
