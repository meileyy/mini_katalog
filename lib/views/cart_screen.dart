import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../components/back_label_button.dart';
import '../components/cart_summary.dart';
import '../components/empty_cart.dart';
import '../components/mini_card_tile.dart';
import '../models/products_model.dart';
import '../state/cart_controller.dart';

// Sepet ekranı. Sepet global cartController'dan okunur; constructor ya da
// route argümanı ile gelmez.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Örnekteki gibi beyaz (detay ekranıyla aynı)
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        // İçerik kaydırılınca AppBar'ın rengi değişmesin.
        scrolledUnderElevation: 0,
        // Varsayılan leading alanı (56 px) "‹ Cart" için dar; genişletilir.
        leadingWidth: 100,
        // Ayrıca title verilmez; "‹ Cart" etiketi başlık görevi görür.
        leading: const BackLabelButton(label: 'Cart'),
      ),
      // Sepet değişince (ekle/çıkar/temizle) liste yeniden çizilir.
      body: ListenableBuilder(
        listenable: cartController,
        builder: (context, child) {
          final List<Product> items = cartController.items;

          if (items.isEmpty) {
            return const EmptyCart(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              message: 'Add items to start shopping',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            itemCount: items.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MiniCardTile(product: items[index]),
            ),
          );
        },
      ),
      // Toplam + bilgi kutusu + Checkout; kaydırma alanının dışında, sabit.
      // SnackBar da otomatik olarak bu panelin üstünde açılır.
      bottomNavigationBar: const CartSummary(),
    );
  }
}
