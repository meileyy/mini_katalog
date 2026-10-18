import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mini_katalog/app/routes.dart';

import 'package:mini_katalog/components/mini_card_tile.dart';
import 'package:mini_katalog/components/product_card_tile.dart';
import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/products_model.dart';
import 'package:mini_katalog/state/cart_controller.dart';
import 'package:mini_katalog/views/login_screen.dart';

void main() {
  // Global sepet testler arasında durum taşır; her test boş sepetle başlar.
  // Ana sayfa kayıtlı adı okuduğu için her test boş kayıtla başlar.
  setUp(() {
    cartController.clear();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('initialRoute home verilince ana sayfa açılır', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiniKatalogApp(initialRoute: AppRoutes.home));

    // Ana sayfanın "Discover" başlığı ve sepet (çanta) ikonu görünmeli.
    expect(find.text('Discover'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });

  testWidgets('Arama ürünleri ada göre filtreler', (WidgetTester tester) async {
    // rootBundle okunan dosyayı önbelleğe alır. Önceki testte başlayıp
    // tamamlanmayan okuma burada tekrar kullanılmasın diye önbellek temizlenir.
    rootBundle.clear();
    await tester.pumpWidget(const MiniKatalogApp(initialRoute: AppRoutes.home));
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
    await tester.pumpWidget(const MiniKatalogApp(initialRoute: AppRoutes.home));

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
      await tester.pumpWidget(
        const MiniKatalogApp(initialRoute: AppRoutes.home),
      );
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

  testWidgets(
    'Kayıtlı kullanıcı varken "Welcome, Melike" görünür, ekran zıplamaz',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'user_name': 'Melike',
        'user_surname': 'Çomak',
      });
      await tester.pumpWidget(
        const MiniKatalogApp(initialRoute: AppRoutes.home),
      );

      // İlk karede ad henüz yüklenmedi; selamlamanın yeri yine de ayrılmış.
      expect(find.text('Welcome, Melike'), findsNothing);
      final Offset before = tester.getTopLeft(find.text('Discover'));

      await tester.pump(); // ad yüklendi, setState ile yeniden çizildi
      expect(find.text('Welcome, Melike'), findsOneWidget);
      expect(tester.getTopLeft(find.text('Discover')), before);
    },
  );

  testWidgets('Kayıtlı kullanıcı yokken selamlama görünmez', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiniKatalogApp(initialRoute: AppRoutes.home));
    await tester.pump();

    expect(find.textContaining('Welcome'), findsNothing);
    expect(find.text('Discover'), findsOneWidget);
  });

  testWidgets('Logout: kayıt silinir, sepet boşalır, login açılır', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'user_name': 'Melike',
      'user_surname': 'Çomak',
    });
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
    await tester.pumpWidget(const MiniKatalogApp(initialRoute: AppRoutes.home));
    await tester.pump();

    await tester.tap(find.byTooltip('Logout'));
    await tester.pump(); // kayıt silinir, geçiş başlar
    await tester.pump(const Duration(milliseconds: 500)); // geçiş biter

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    // pushNamedAndRemoveUntil: geri tuşu ana sayfaya döndürmez.
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
    expect(cartController.count, 0);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('user_name'), isNull);
    expect(prefs.getString('user_surname'), isNull);
  });
}
