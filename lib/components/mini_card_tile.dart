import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/products_model.dart';
import '../state/cart_controller.dart';
import 'product_image.dart';

// Sepet listesindeki tek satır: küçük görsel, ad, tagline, fiyat ve ⊖ butonu.
class MiniCardTile extends StatelessWidget {
  final Product product;

  const MiniCardTile({super.key, required this.product});

  // Soldaki küçük görselin kenar uzunluğu
  static const double imageSize = 56;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // Görsel yalnızca 56 px'lik kutunun piksel karşılığında açılır.
    final int imageCacheWidth =
        (imageSize * MediaQuery.devicePixelRatioOf(context)).round();

    // Kart beyaz ve kenarlıksız (temadaki cardTheme); beyaz ekranda
    // satırlar örnekteki gibi düz görünür.
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        // Ad + tagline + fiyat: üç satırlık yükseklik
        isThreeLine: true,
        // ProductImage boyutu ebeveynden alır; SizedBox sabit boyut verir.
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: ProductImage(
              url: product.image,
              cacheWidth: imageCacheWidth,
            ),
          ),
        ),
        title: Text(
          product.name,
          style: textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // bodySmall zaten gri; italik yapılır.
            Text(
              product.tagline,
              style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // bodyMedium: koyu (textPrimary), normal ağırlık
            Text(
              product.price,
              style: textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        // Ürünü sepetten çıkarır; liste ListenableBuilder ile yeniden çizilir.
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          color: AppColors.textSecondary,
          tooltip: 'Remove',
          onPressed: () => cartController.remove(product),
        ),
      ),
    );
  }
}
