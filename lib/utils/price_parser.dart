// "$2,499" → 2499.0  ($ ve virgül temizlenir, hatalıysa 0.0 döner)
double parsePrice(String price) {
  final cleaned = price.replaceAll('\$', '').replaceAll(',', '').trim();
  return double.tryParse(cleaned) ?? 0.0; // tryParse hata fırlatmaz, null döner
}
