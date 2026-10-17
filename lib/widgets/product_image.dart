import 'package:flutter/material.dart';

import '../app/theme.dart';

// Ürün görselini internetten yükler: yüklenirken gösterge, hata olursa gri kutu.
// Boyutu ebeveyn belirlemeli (kartta Expanded, detayda AspectRatio; sepet
// satırında SizedBox içinde kullanılacak). Görsel verilen alanı doldurur.
class ProductImage extends StatelessWidget {
  final String url;
  final int? cacheWidth;

  const ProductImage({super.key, required this.url, this.cacheWidth});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      // Görseli gösterileceği boyuta küçülterek açar (bellek + kaydırma)
      cacheWidth: cacheWidth,
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
