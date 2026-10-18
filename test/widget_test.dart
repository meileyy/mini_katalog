import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/components/mini_card_tile.dart';
import 'package:mini_katalog/components/product_card_tile.dart';
import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/products_model.dart';
import 'package:mini_katalog/state/cart_controller.dart';

void main() {
  // Global sepet testler arasında durum taşır; her test boş sepetle başlar.
  setUp(() => cartController.clear());

  testWidgets('Uygulama açılınca ana sayfa geliyor', (
    WidgetTester tester,
  ) async {
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

  testWidgets('Sepet rozeti: boşken görünmez, ürün eklenince adet görünür', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiniKatalogApp());

    // Sepet boş: rozet etiketi gizli.
    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isFalse);

    // Ürün eklenir; ListenableBuilder ikonu yeniden çizer.
    cartController.add(
      const Product(
        id: 1,
        name: 'iPhone 15 Pro',
        tagline: '',
        description: '',
        price: '\$999',
        currency: 'USD',
        image: '',
        specs: {},
      ),
    );
    await tester.pump();
    expect(find.widgetWithText(Badge, '1'), findsOneWidget);
  });

  testWidgets(
    'Akış: ana sayfa → detay → Add to Cart → sepet → "‹ Cart" ile detaya dönüş',
    (WidgetTester tester) async {
      // Arama testindeki gibi: önbellek temizlenir, JSON gerçek zamanda okunur.
      rootBundle.clear();
      await tester.pumpWidget(const MiniKatalogApp());
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 500)),
      );
      await tester.pump();

      // Ürüne dokun → detay ekranı (route arguments). Test penceresi
      // 800x600; kartın alttaki metni ekran dışında kalır, bu yüzden
      // metne değil kartın ortasına dokunulur.
      await tester.tap(find.widgetWithText(ProductCardTile, 'iPhone 15 Pro'));
      await tester.pump(); // geçiş başlar
      await tester.pump(const Duration(milliseconds: 500)); // geçiş biter
      expect(find.text('Description'), findsOneWidget);

      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      expect(cartController.count, 1);

      // Detay AppBar'ındaki sepet ikonu → sepet ekranı
      await tester.tap(find.byTooltip('Cart'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MiniCardTile), findsOneWidget);
      expect(find.text('iPhone 15 Pro'), findsOneWidget);

      // "‹ Cart" → detay ekranına geri
      await tester.tap(find.text('Cart'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MiniCardTile), findsNothing);
      expect(find.text('Add to Cart'), findsOneWidget);
    },
  );
}
