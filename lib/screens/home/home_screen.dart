import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../data/product_repository.dart';
import '../../models/product.dart';

// Ana sayfa. Şimdilik yalnızca ürünlerin JSON'dan okunduğunu gösterir.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future initState'te bir kez oluşturulur; build içinde oluşturulsaydı
  // her yeniden çizimde JSON tekrar okunurdu.
  late final Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = const ProductRepository().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            tooltip: 'Sepet',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // Veri henüz gelmediyse yükleniyor göstergesi
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Okuma sırasında hata olduysa mesaj
          if (snapshot.hasError) {
            return Center(
              child: Text('Ürünler yüklenemedi: ${snapshot.error}'),
            );
          }

          final List<Product> products = snapshot.data ?? [];

          // GEÇİCİ: ürün sayısı yazısı ve detay butonu Adım 6'da kaldırılacak.
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${products.length} ürün yüklendi'),
                const SizedBox(height: 16),
                ElevatedButton(
                  // Liste boşsa buton pasif olur.
                  onPressed: products.isEmpty
                      ? null
                      : () => Navigator.pushNamed(
                            context,
                            AppRoutes.detail,
                            arguments: products.first,
                          ),
                  child: const Text('İlk ürünün detayına git'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
