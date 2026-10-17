import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../state/cart_controller.dart';
import '../utils/price_formatter.dart';
import 'checkout_button.dart';

// Sepet ekranının alt paneli: toplam tutar, bilgi kutusu ve Checkout butonu.
// Scaffold.bottomNavigationBar içinde durur; sepet boşken de görünür.
class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // SafeArea: alttaki sistem çubuğu butonun üstüne binmesin.
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Yalnızca toplam satırı sepeti dinler ve yeniden çizilir.
            ListenableBuilder(
              listenable: cartController,
              builder: (context, child) {
                return Row(
                  children: [
                    Text('Total', style: textTheme.titleMedium),
                    const Spacer(),
                    Text(
                      formatPrice(cartController.total),
                      style: textTheme.headlineSmall,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            // Gri bilgi kutusu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is a simulation. No real payment is made.',
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const CheckoutButton(),
          ],
        ),
      ),
    );
  }
}
