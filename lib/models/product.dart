// Katalogdaki tek bir ürünü temsil eden model sınıfı.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price; // "$2,499" gibi; ekranda olduğu gibi gösterilir
  final String currency;
  final String image; // network URL
  final Map<String, String> specs; // anahtarlar ürüne göre değişir

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  // JSON (Map) → Product. Alan eksik, null ya da yanlış tipte olsa bile çökmez.
  factory Product.fromJson(Map<String, dynamic> json) {
    // specs bir Map değilse boş Map kullanılır; anahtar ve değerler String'e çevrilir.
    final rawSpecs = json['specs'];
    final Map<String, String> specs = rawSpecs is Map
        ? rawSpecs.map(
            (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
          )
        : {};

    return Product(
      // id "abc" gibi sayıya çevrilemezse tryParse null döner → 0 kullanılır
      id: int.tryParse(json['id'].toString()) ?? 0,
      // toString() ile 123 gibi sayılar da "123" olur; null ise '' kalır
      name: json['name']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      specs: specs,
    );
  }

  // Product → JSON (Map).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'currency': currency,
      'image': image,
      'specs': specs,
    };
  }
}
