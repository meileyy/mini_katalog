import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../components/cart_icon_button.dart';
import '../components/product_card_tile.dart';
import '../components/search_bar_field.dart';
import '../models/products_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../state/cart_controller.dart';
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

  // Selamlamadaki ad; yüklenene kadar ya da kayıt yoksa null.
  String? _name;

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService().fetchProducts();
    _loadName();
  }

  // Kayıtlı ad okunur; hata olursa servis null döner, selamlama gizli kalır.
  Future<void> _loadName() async {
    final String? name = await LocalStorageService().getName();
    // await sırasında ekran kapanmış olabilir.
    if (!mounted) return;
    setState(() => _name = name);
  }

  // Çıkış: kayıt silinir, sepet boşaltılır ve login'e dönülür.
  Future<void> _logout() async {
    await LocalStorageService().clearUser();
    // Sepet yalnızca bellekte; sonraki kullanıcı önceki sepeti görmesin.
    cartController.clear();
    if (!mounted) return;
    // Tüm rotalar kaldırılır; geri tuşu ana sayfaya döndürmez.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
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
              // Selamlama: Text ad yokken de çizilir (içerik ''). Boş Text de
              // bir satır yüksekliği kapladığı için ad yüklenince ekran zıplamaz.
              Text(
                (_name ?? '').isEmpty ? '' : 'Welcome, $_name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              // Başlık ve sağda sepet ve çıkış ikonları
              Row(
                children: [
                  Expanded(
                    child: Text('Discover', style: textTheme.headlineMedium),
                  ),
                  const CartIconButton(),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    color: AppColors.textPrimary,
                    tooltip: 'Logout',
                    onPressed: _logout,
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
