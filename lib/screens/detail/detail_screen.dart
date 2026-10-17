import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/product.dart';
import '../../widgets/back_label_button.dart';
import '../../widgets/product_image.dart';
import '../../widgets/spec_chip.dart';

// Ürün detay ekranı. Ürün constructor ile değil, route arguments ile gelir.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // pushNamed(..., arguments: product) ile gönderilen ürün burada okunur.
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Görsel ekran genişliğinde; piksel karşılığına küçültülerek açılır.
    final int imageCacheWidth =
        (MediaQuery.sizeOf(context).width *
                MediaQuery.devicePixelRatioOf(context))
            .round();

    return Scaffold(
      // Detay ekranı örnekteki gibi beyaz; temadaki gri arka plan kullanılmaz.
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        // İçerik kaydırılınca AppBar'ın rengi değişmesin.
        scrolledUnderElevation: 0,
        // Varsayılan leading alanı (56 px) "‹ Back" için dar; genişletilir.
        leadingWidth: 100,
        leading: const BackLabelButton(label: 'Back'),
      ),
      // Uzun açıklamada taşma olmasın diye içerik kaydırılabilir.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kenardan kenara görsel. Kaydırma alanında yükseklik sınırsız
            // olduğu için yükseklik genişliğe oranla belirlenir.
            AspectRatio(
              aspectRatio: 6 / 5,
              child: ProductImage(
                url: product.image,
                cacheWidth: imageCacheWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    product.tagline,
                    style: textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.price,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Description', style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  // specs boşsa Specifications bölümü hiç gösterilmez.
                  if (product.specs.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('Specifications', style: textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    // Kutular sığmazsa alt satıra kayar.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final entry in product.specs.entries)
                          SpecChip(label: entry.key, value: entry.value),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      // Adım 9: "Add to Cart" butonu buraya bottomNavigationBar olarak
      // eklenecek; böylece kaydırmadan bağımsız, ekranın altında sabit durur.
    );
  }
}
