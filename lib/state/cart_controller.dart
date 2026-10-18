import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/products_model.dart';
import '../utils/price_parser.dart';

// Sepetteki ürünleri tutan sınıf. Değişiklik olunca dinleyen ekranlara
// notifyListeners() ile haber verir (ListenableBuilder yeniden çizilir).
class CartController extends ChangeNotifier {
  // Asıl liste gizli (_); dışarıdan yalnızca aşağıdaki metotlarla değişir.
  final List<Product> _items = [];

  // Dışarıya listenin salt okunur bir görünümü verilir (kopya değil).
  // Ekranlar items.add(...) ya da items.clear() yaparsa hata alır;
  // böylece notifyListeners atlanamaz.
  List<Product> get items => UnmodifiableListView(_items);

  // Aynı ürün iki kez eklenirse iki satır olur; adet = liste uzunluğu.
  int get count => _items.length;

  // Fiyatlar "$2,499" gibi String olduğu için parsePrice ile sayıya çevrilir.
  double get total {
    double sum = 0;
    for (final product in _items) {
      sum += parsePrice(product.price);
    }
    return sum;
  }

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  // Aynı üründen birden fazla varsa yalnızca ilk eşleşen bir tanesi çıkar.
  // _items.remove(product) kullanılmaz: Product'ta == tanımlı olmadığı için
  // remove nesne referansını karşılaştırır. Aynı ürün JSON'dan tekrar
  // okunursa (ör. testte ya da yeniden yüklemede) farklı nesne olur ve
  // bulunamaz. Bu yüzden ürünler id'ye göre eşleştirilir.
  void remove(Product product) {
    final int index = _items.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      return; // sepette yoksa değişiklik yok, haber vermeye gerek yok
    }
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) {
      return; // zaten boşsa değişiklik yok
    }
    _items.clear();
    notifyListeners();
  }
}

// Uygulamadaki tek sepet. Ekranlar bu dosyayı import edip doğrudan kullanır;
// sepet constructor ya da route argümanı ile taşınmaz.
final cartController = CartController();
