import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../models/product.dart';
import 'product_image.dart';

// Ana sayfadaki grid'de tek bir ürünü gösteren kart.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Kart yaklaşık ekranın yarısı kadar geniş. Görsel bu genişliğin piksel
    // karşılığında açılır; 1024 px'lik dosyanın tamamı belleğe alınmaz.
    final int imageCacheWidth =
        (MediaQuery.sizeOf(context).width /
                2 *
                MediaQuery.devicePixelRatioOf(context))
            .round();

    // Card'ın rengi, köşeleri ve kırpması temadaki cardTheme'den gelir.
    return Card(
      child: InkWell(
        onTap: () {
          // Klavye açıksa kapanır; detaydan dönünce tekrar açılmaz.
          FocusScope.of(context).unfocus();
          // Ürün, route argümanı olarak detay ekranına gönderilir.
          Navigator.pushNamed(context, AppRoutes.detail, arguments: product);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel, metinlerden kalan alanın tamamını kaplar.
            Expanded(
              child: ProductImage(
                url: product.image,
                cacheWidth: imageCacheWidth,
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
