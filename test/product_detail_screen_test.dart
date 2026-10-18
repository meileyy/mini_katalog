import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/app/theme.dart';
import 'package:mini_katalog/models/products_model.dart';
import 'package:mini_katalog/views/product_detail_screen.dart';
import 'package:mini_katalog/state/cart_controller.dart';

// Detay ekranını, ürünü route argümanı olarak vererek açar (uygulamadaki gibi).
Future<void> pumpDetail(WidgetTester tester, Product product) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const ProductDetailScreen(),
        settings: RouteSettings(name: settings.name, arguments: product),
      ),
    ),
  );
  // Görsel testte indirilemez; hata kutusu çizilsin diye bir kare daha.
  // Yükleme göstergesi döndüğü için pumpAndSettle kullanılmaz.
  await tester.pump();
}

const Product homePodMini = Product(
  id: 20,
  name: 'HomePod Mini',
  tagline: 'Color-pop.',
  description: 'Big sound for its size.',
  price: '\$99',
  currency: 'USD',
  image: 'https://example.com/homepod_mini.png',
  specs: {'size': '3.3 inches', 'audio': '360-degree'},
);

void main() {
  // Global sepet aynı dosyadaki testler arasında durum taşır; her test boş başlar.
  setUp(() => cartController.clear());

  testWidgets(
    'Ürün argümanla açılınca ad, Description ve Specifications görünür',
    (WidgetTester tester) async {
      await pumpDetail(tester, homePodMini);

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('HomePod Mini'), findsOneWidget);
      expect(find.text('\$99'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Specifications'), findsOneWidget);
      // Spec anahtarı büyük harfle, değeri olduğu gibi gösterilir.
      expect(find.text('SIZE'), findsOneWidget);
      expect(find.text('3.3 inches'), findsOneWidget);
    },
  );

  testWidgets('specs boşsa Specifications bölümü gösterilmez', (
    WidgetTester tester,
  ) async {
    const Product noSpecs = Product(
      id: 99,
      name: 'Test Product',
      tagline: '',
      description: 'No specs here.',
      price: '\$1',
      currency: 'USD',
      image: '',
      specs: {},
    );
    await pumpDetail(tester, noSpecs);

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('Specifications'), findsNothing);
  });

  testWidgets(
    'Add to Cart: "Added to cart" görünür, sepet adedi ve rozet artar',
    (WidgetTester tester) async {
      await pumpDetail(tester, homePodMini);
      expect(cartController.count, 0);

      // AppBar'daki rozet: sepet boşken etiket gizli.
      final Finder appBarBadge = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(Badge),
      );
      expect(tester.widget<Badge>(appBarBadge).isLabelVisible, isFalse);

      await tester.tap(find.text('Add to Cart'));
      await tester.pump(); // SnackBar açılmaya başlar
      expect(find.text('Added to cart'), findsOneWidget);
      expect(cartController.count, 1);
      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('1')),
        findsOneWidget,
      );

      // İkinci basış: aynı ürün ayrı satır olarak eklenir, rozet 2 olur.
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      expect(cartController.count, 2);
      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('2')),
        findsOneWidget,
      );
    },
  );
}
