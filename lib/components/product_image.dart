import 'package:flutter/material.dart';

import '../app/theme.dart';

// Ürün görselini internetten yükler: yüklenirken gösterge, hata olursa gri kutu.
// Boyutu ebeveyn belirlemeli (kartta Expanded, detayda AspectRatio, sepet
// satırında SizedBox). Görsel verilen alanı doldurur.
class ProductImage extends StatelessWidget {
  final String url;
  final int? cacheWidth;

  const ProductImage({super.key, required this.url, this.cacheWidth});

  @override
  Widget build(BuildContext context) {
    // Açılışta ekran genişliği kısa süre 0 görünebilir; hesaplanan değer
    // 0 veya negatif olursa Image.network assert hatası verir. Bu durumda
    // null geçilir, görsel tam boyutunda açılır.
    final int? safeCacheWidth = (cacheWidth != null && cacheWidth! > 0)
        ? cacheWidth
        : null;

    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      // Görseli gösterileceği boyuta küçülterek açar (bellek + kaydırma)
      cacheWidth: safeCacheWidth,
      // Görsel inerken yükleniyor göstergesi
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
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
    );
  }
}
