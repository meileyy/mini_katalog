import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/app/theme.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/screens/detail/detail_screen.dart';

// Detay ekranını, ürünü route argümanı olarak vererek açar (uygulamadaki gibi).
Future<void> pumpDetail(WidgetTester tester, Product product) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const DetailScreen(),
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
}
