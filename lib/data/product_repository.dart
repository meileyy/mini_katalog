import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

// Ürün verisini assets içindeki JSON dosyasından okuyan sınıf.
// Ekranlar JSON'a doğrudan dokunmaz; ürünleri yalnızca buradan alır.
class ProductRepository {
  const ProductRepository();

  // Okunacak dosyanın yolu (pubspec.yaml'da assets/data/ tanımlı olmalı).
  static const String _path = 'assets/data/products.json';

  // Dosyayı okur ve ürün listesine çevirir.
  Future<List<Product>> loadProducts() async {
    // rootBundle: uygulamaya gömülü asset dosyalarını okur (JSON simülasyonu).
    final String text = await rootBundle.loadString(_path);
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
