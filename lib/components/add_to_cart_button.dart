import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/products_model.dart';
import '../state/cart_controller.dart';

// Detay ekranının altında, tam genişlikte "Add to Cart" butonu.
class AddToCartButton extends StatelessWidget {
  final Product product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // SafeArea: alttaki sistem çubuğu (gesture bar) butonun üstüne binmesin.
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
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
            onPressed: () {
              cartController.add(product);
              // Peş peşe basılınca SnackBar'lar sıraya girmesin: açık olan
              // kapatılır, yenisi hemen gösterilir.
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Added to cart')));
            },
            child: const Text('Add to Cart'),
          ),
        ),
      ),
    );
  }
}
