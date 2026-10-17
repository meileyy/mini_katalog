import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../widgets/back_label_button.dart';

// Sepet ekranı. GEÇİCİ: Adım 10'da liste, toplam ve Checkout eklenecek.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Örnekteki gibi beyaz (detay ekranıyla aynı)
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        // İçerik kaydırılınca AppBar'ın rengi değişmesin.
        scrolledUnderElevation: 0,
        // Varsayılan leading alanı (56 px) "‹ Cart" için dar; genişletilir.
        leadingWidth: 100,
        // Ayrıca title verilmez; "‹ Cart" etiketi başlık görevi görür.
        leading: const BackLabelButton(label: 'Cart'),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
