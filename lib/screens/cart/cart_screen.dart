import 'package:flutter/material.dart';

// Sepet ekranı. GEÇİCİ: Adım 10'da liste, toplam ve Checkout eklenecek.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sepet')),
      body: const SizedBox.shrink(),
    );
  }
}
