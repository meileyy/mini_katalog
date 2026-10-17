import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/app/theme.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/screens/cart/cart_screen.dart';
import 'package:mini_katalog/state/cart_controller.dart';
import 'package:mini_katalog/widgets/cart_item_tile.dart';

// Sepet ekranını tek başına açar. Görseller testte indirilemez;
// hata kutusu çizilsin diye bir kare daha (pumpAndSettle kullanılmaz).
Future<void> pumpCart(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(theme: AppTheme.light, home: const CartScreen()),
  );
  await tester.pump();
}

const Product iphone = Product(
  id: 1,
  name: 'iPhone 15 Pro',
  tagline: 'Titanium.',
  description: '',
  price: '\$999',
  currency: 'USD',
  image: 'https://example.com/iphone.png',
  specs: {},
);

const Product macbook = Product(
  id: 2,
  name: 'MacBook Pro 16"',
  tagline: 'Mind-blowing.',
  description: '',
  price: '\$2,499',
  currency: 'USD',
  image: 'https://example.com/macbook.png',
  specs: {},
);

void main() {
  // Global sepet testler arasında durum taşır; her test boş sepetle başlar.
  setUp(() => cartController.clear());

  testWidgets('Boş sepette boş durum mesajı ve \$0 görünür', (tester) async {
    await pumpCart(tester);

    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Add items to start shopping'), findsOneWidget);
    expect(find.text('\$0'), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(
      find.text('This is a simulation. No real payment is made.'),
      findsOneWidget,
    );
  });

  testWidgets('Ürünler satır olarak, toplam binlik ayraçlı görünür', (
    tester,
  ) async {
    cartController.add(iphone);
    cartController.add(macbook);
    await pumpCart(tester);

    expect(find.byType(CartItemTile), findsNWidgets(2));
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('MacBook Pro 16"'), findsOneWidget);
    expect(find.text('\$3,498'), findsOneWidget);
    expect(find.text('Your cart is empty'), findsNothing);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsNothing);

    // Satırda tagline italik, fiyat koyu ve normal ağırlıkta.
    final Text tagline = tester.widget<Text>(find.text('Titanium.'));
    expect(tagline.style?.fontStyle, FontStyle.italic);
    final Text price = tester.widget<Text>(find.text('\$999'));
    expect(price.style?.color, AppColors.textPrimary);
    expect(price.style?.fontWeight, isNot(FontWeight.bold));
  });

  testWidgets('⊖ ikonuna basınca satır azalır ve toplam güncellenir', (
    tester,
  ) async {
    cartController.add(iphone);
    cartController.add(macbook);
    await pumpCart(tester);

    // İlk satırın (iPhone) ⊖ ikonu
    await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
    await tester.pump();

    expect(find.byType(CartItemTile), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsNothing);
    expect(find.text('\$3,498'), findsNothing);
    // Kalan tek ürünün fiyatı hem satırda hem toplamda: 2 kez
    expect(find.text('\$2,499'), findsNWidgets(2));
  });

  testWidgets('Dolu sepette Checkout sepeti boşaltır ve SnackBar gösterir', (
    tester,
  ) async {
    cartController.add(iphone);
    await pumpCart(tester);

    await tester.tap(find.text('Checkout'));
    await tester.pump(); // SnackBar açılmaya başlar

    expect(
      find.text('Thank you! Your order has been placed. (Simulation)'),
      findsOneWidget,
    );
    expect(cartController.count, 0);
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('\$0'), findsOneWidget);
  });

  testWidgets('Boş sepette Checkout uyarı SnackBar\'ı gösterir', (
    tester,
  ) async {
    await pumpCart(tester);

    await tester.tap(find.text('Checkout'));
    await tester.pump();

    expect(find.text('Your cart is empty.'), findsOneWidget);
    expect(
      find.text('Thank you! Your order has been placed. (Simulation)'),
      findsNothing,
    );
  });
}
