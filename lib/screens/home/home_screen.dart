import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../data/product_repository.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

// Ana sayfa: başlık, banner ve 2 sütunlu ürün grid'i.
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // AppBar yok; SafeArea içeriği durum çubuğunun altına taşırmaz.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık ve sağda sepet ikonu
              Row(
                children: [
                  Expanded(
                    child: Text('Discover', style: textTheme.headlineMedium),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    color: AppColors.textPrimary,
                    tooltip: 'Sepet',
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.cart),
                  ),
                ],
              ),
              Text(
                'Find your perfect device.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              // Adım 7: arama çubuğu buraya gelecek.
              // Banner: uygulamaya gömülü görsel (Image.asset)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/banner.png',
                  width: double.infinity,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Yalnızca grid kaydırılır; üstteki kısım sabit kalır.
              Expanded(
                child: FutureBuilder<List<Product>>(
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
                    if (products.isEmpty) {
                      return const Center(child: Text('Ürün bulunamadı.'));
                    }
                    return _buildGrid(products);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2 sütunlu ürün grid'i; kartlar yalnızca ekranda göründükçe üretilir.
  Widget _buildGrid(List<Product> products) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        // genişlik / yükseklik: görsel + 3 satır metin taşmadan sığar
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}
