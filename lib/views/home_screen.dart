import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../components/cart_icon_button.dart';
import '../components/product_card_tile.dart';
import '../components/search_bar_field.dart';
import '../data/product_repository.dart';
import '../models/products_model.dart';
import '../utils/search_text.dart';

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

  // Arama çubuğunun metni ve filtrede kullanılan temizlenmiş sorgu
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _productsFuture = const ProductRepository().loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  const CartIconButton(),
                ],
              ),
              Text(
                'Find your perfect device.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              // Arama: her harfte setState ile sorgu güncellenir, grid yeniden çizilir.
              SearchBarField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
              const SizedBox(height: 16),
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
                    // Okuma sırasında hata olduysa mesaj (ayrıntı konsola yazılır)
                    if (snapshot.hasError) {
                      debugPrint('Ürünler yüklenemedi: ${snapshot.error}');
                      return const Center(
                        child: Text('Failed to load products.'),
                      );
                    }

                    final List<Product> products = snapshot.data ?? [];

                    // Filtre burada yapılır; _productsFuture yeniden
                    // oluşturulmadığı için JSON tekrar okunmaz.
                    // Büyük/küçük harf ve Türkçe karakter farkı gözetilmez
                    // ("ıphone", "İPHONE" → iPhone ürünleri).
                    final String query = normalizeSearchText(_query);
                    final List<Product> filtered = products
                        .where(
                          (p) => normalizeSearchText(p.name).contains(query),
                        )
                        .toList();

                    // Hem boş JSON hem de sonuçsuz arama için aynı mesaj
                    if (filtered.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }
                    return _buildGrid(filtered);
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
      // Grid kaydırılınca klavye kapanır.
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        // genişlik / yükseklik: görsel + 3 satır metin taşmadan sığar
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) =>
          ProductCardTile(product: products[index]),
    );
  }
}
