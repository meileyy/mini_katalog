// 3498.0 → "$3,498"  (intl paketi yasak; binlik ayracı elle eklenir)
// Kuruşlar yuvarlanır (veride kuruşlu fiyat yok). Negatif değer beklenmez.
String formatPrice(double value) {
  final String digits = value.round().toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    // Sağdan sayınca her 3 basamakta bir virgül konur.
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  return '\$$buffer';
}
