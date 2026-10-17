import 'package:flutter/material.dart';

import '../app/theme.dart';

// Ortada açık gri ikon, gri başlık ve daha açık gri açıklama gösteren
// boş durum ekranı. Sepet boşken kullanılır.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Açık gri: textSecondary'nin yarı saydam hâli
            Icon(
              icon,
              size: 72,
              color: AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            // titleMedium 15 punto; kalınlık normal, renk orta gri yapılır.
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            // bodySmall 12 punto; başlıktan daha açık gri.
            Text(
              message,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
