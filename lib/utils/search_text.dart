// Arama için metni sadeleştirir: büyük/küçük harf ve Türkçe karakter farkı
// ortadan kalkar. Örnek: "İPHONE", "ıphone", "iPhone" → "iphone".
String normalizeSearchText(String text) {
  // 1) Büyük İ ve I önce elle "i" yapılır. toLowerCase() bazı platformlarda
  //    (ör. web) "İ"yi "i" + birleşik nokta (i̇) yapar; bu adım bunu önler.
  String result = text.replaceAll('İ', 'i').replaceAll('I', 'i');

  // 2) Kalan harfler küçültülür (Ç → ç, Ş → ş, M → m gibi).
  result = result.toLowerCase();

  // 3) Türkçe karakterler İngilizce karşılıklarına çevrilir.
  result = result
      .replaceAll('ı', 'i')
      .replaceAll('ş', 's')
      .replaceAll('ç', 'c')
      .replaceAll('ğ', 'g')
      .replaceAll('ö', 'o')
      .replaceAll('ü', 'u');

  return result;
}
