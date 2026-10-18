import 'package:flutter/material.dart';

// Ana sayfadaki arama çubuğu.
// Metni ana sayfa tutar; bu widget yalnızca gösterir ve değişikliği bildirir.
class SearchBarField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchBarField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Renkler ve kenarlık temadaki inputDecorationTheme'den gelir.
    return TextField(
      controller: controller,
      onChanged: onChanged,
      // Klavyede "ara" tuşu gösterilir.
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search products',
        prefixIcon: const Icon(Icons.search),
        // Temizle (✕) butonu yalnızca sorgu doluyken görünür.
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Clear',
                onPressed: () {
                  controller.clear();
                  // clear() onChanged'i tetiklemez; ana sayfaya elle bildirilir.
                  onChanged('');
                },
              ),
      ),
    );
  }
}
