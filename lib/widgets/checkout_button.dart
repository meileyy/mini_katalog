import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../state/cart_controller.dart';

// Sepet ekranının en altındaki siyah, tam genişlikte "Checkout" butonu.
// Görünümü AddToCartButton ile aynı. Ödeme simülasyondur, gerçek işlem yok.
// SafeArea ve kenar boşluğu CartSummary'de verilir.
class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          // Yazı rengi foregroundColor'dan gelir; textStyle'daki renk
          // buton tarafından kullanılmaz.
          foregroundColor: AppColors.surface,
          textStyle: textTheme.titleMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () => _checkout(context),
        child: const Text('Checkout'),
      ),
    );
  }

  void _checkout(BuildContext context) {
    // Peş peşe basılınca SnackBar'lar sıraya girmesin: açık olan kapatılır.
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar();

    if (cartController.count == 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Your cart is empty.')),
      );
      return;
    }

    // Sipariş "verilmiş" sayılır ve sepet boşaltılır.
    cartController.clear();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Thank you! Your order has been placed. (Simulation)'),
      ),
    );
  }
}
