import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/main.dart';

void main() {
  testWidgets('Uygulama açılınca ana sayfa geliyor', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniKatalogApp());

    // Ana sayfanın "Discover" başlığı ve sepet (çanta) ikonu görünmeli.
    expect(find.text('Discover'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });
}
