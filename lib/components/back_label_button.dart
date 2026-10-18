import 'package:flutter/material.dart';

import '../app/theme.dart';

// AppBar'ın solundaki "‹ Back" / "‹ Cart" görünümlü geri butonu.
// Dokununca bir önceki ekrana döner (Navigator.pop).
// Kullanım: AppBar(leadingWidth: 100, leading: const BackLabelButton(label: 'Back'))
// leadingWidth verilmezse leading alanı 56 px kalır ve etiket sığmaz.
class BackLabelButton extends StatelessWidget {
  final String label;

  const BackLabelButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        textStyle: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
