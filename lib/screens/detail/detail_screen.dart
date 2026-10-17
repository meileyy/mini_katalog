import 'package:flutter/material.dart';

import '../../models/product.dart';

// Ürün detay ekranı. Ürün constructor ile değil, route arguments ile gelir.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // pushNamed(..., arguments: product) ile gönderilen ürün burada okunur.
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // GEÇİCİ: Adım 8'de görsel, açıklama ve özellikler eklenecek.
      body: Center(
        child: Text(
          product.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
