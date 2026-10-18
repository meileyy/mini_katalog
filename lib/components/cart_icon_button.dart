import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../state/cart_controller.dart';

// Sepete giden ikon; üstünde sepetteki adet rozeti.
// Ana sayfada ve detay ekranında ortak kullanılır.
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Yalnızca ikon sepeti dinler; sepet değişince sadece bu kısım
    // yeniden çizilir, ekranın geri kalanı (ör. arama durumu) etkilenmez.
    return ListenableBuilder(
      listenable: cartController,
      builder: (context, child) {
        final int count = cartController.count;
        return IconButton(
          // Adet 0 ise rozet gizlenir; 999'dan sonrası "999+".
          icon: Badge.count(
            count: count,
            isLabelVisible: count > 0,
            backgroundColor: AppColors.accent,
            textColor: AppColors.surface,
            // Temadaki labelSmall gri ve harf aralıklı;
            // rozette rakamlar sıkı ve kalın görünsün.
            textStyle: textTheme.labelSmall?.copyWith(
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
            ),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          color: AppColors.textPrimary,
          tooltip: 'Cart',
          // Sepetten geri dönülünce hangi ekrandan gelindiyse oraya dönülür.
          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
        );
      },
    );
  }
}
