import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/main.dart';

void main() {
  testWidgets('Uygulama açılınca ana sayfa geliyor', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniKatalogApp());

    // Ana sayfanın "Discover" başlığı ve sepet (çanta) ikonu görünmeli.
    expect(find.text('Discover'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });

  testWidgets('Arama ürünleri ada göre filtreler', (WidgetTester tester) async {
    // rootBundle okunan dosyayı önbelleğe alır. Önceki testte başlayıp
    // tamamlanmayan okuma burada tekrar kullanılmasın diye önbellek temizlenir.
    rootBundle.clear();
    await tester.pumpWidget(const MiniKatalogApp());
    // products.json gerçek zamanda okunur; sahte test zamanında
    // tamamlanmadığı için runAsync ile kısa süre beklenir.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    // Görsel yükleme göstergesi döndüğü için pumpAndSettle kullanılmaz.
    await tester.pump();
    expect(find.text('iPhone 15 Pro'), findsOneWidget);

    // "MacBook" yazınca iPhone 15 Pro kaybolur, MacBook'lar kalır.
    await tester.enterText(find.byType(TextField), 'MacBook');
    await tester.pump();
    expect(find.text('iPhone 15 Pro'), findsNothing);
    expect(find.textContaining('MacBook'), findsWidgets);

    // Anlamsız bir metin yazınca boş sonuç mesajı çıkar.
    await tester.enterText(find.byType(TextField), 'xyzxyz');
    await tester.pump();
    expect(find.text('No products found.'), findsOneWidget);

    // Türkçe karakter uyumu: "ıphone" ve "İPHONE" de iPhone ürünlerini bulur.
    await tester.enterText(find.byType(TextField), 'ıphone');
    await tester.pump();
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('MacBook Pro 16"'), findsNothing);

    await tester.enterText(find.byType(TextField), 'İPHONE');
    await tester.pump();
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
  });
}
