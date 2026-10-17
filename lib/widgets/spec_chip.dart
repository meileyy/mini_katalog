import 'package:flutter/material.dart';

import '../app/theme.dart';

// Detay ekranındaki tek bir özellik kutusu: üstte anahtar (ör. SIZE), altta değer.
class SpecChip extends StatelessWidget {
  final String label;
  final String value;

  const SpecChip({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // JSON'daki anahtar küçük harfli ("size"); büyük harfle gösterilir.
          Text(label.toUpperCase(), style: textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(value, style: textTheme.titleSmall),
        ],
      ),
    );
  }
}
