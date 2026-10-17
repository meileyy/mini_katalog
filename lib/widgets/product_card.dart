import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../models/product.dart';

// Ana sayfadaki grid'de tek bir ürünü gösteren kart.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Kart yaklaşık ekranın yarısı kadar geniş. Görsel bu genişliğin piksel
    // karşılığında açılır; 1024 px'lik dosyanın tamamı belleğe alınmaz.
    final int imageCacheWidth = (MediaQuery.sizeOf(context).width /
            2 *
            MediaQuery.devicePixelRatioOf(context))
        .round();

    // Card'ın rengi, köşeleri ve kırpması temadaki cardTheme'den gelir.
    return Card(
      child: InkWell(
        // Ürün, route argümanı olarak detay ekranına gönderilir.
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.detail,
          arguments: product,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel, metinlerden kalan alanın tamamını kaplar.
            Expanded(
              child: Image.network(
                product.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                // Görseli kartın boyutuna küçülterek açar (bellek + kaydırma)
                cacheWidth: imageCacheWidth,
                // Görsel inerken yükleniyor göstergesi
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                // Görsel yüklenemezse gri kutu + ikon
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.background,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.tagline,
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.price,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
