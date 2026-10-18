import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/components/product_image.dart';

// ProductImage'ı sabit boyutlu bir alanda çizer. Görsel testte indirilemez;
// hata kutusu çizilsin diye bir kare daha (pumpAndSettle kullanılmaz).
Future<void> pumpImage(WidgetTester tester, int? cacheWidth) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SizedBox(
        width: 100,
        height: 100,
        child: ProductImage(
          url: 'https://example.com/test.png',
          cacheWidth: cacheWidth,
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  // Açılışta ekran genişliği 0 görünürse hesaplanan cacheWidth 0 olur.
  testWidgets('cacheWidth: 0 ile hata fırlatmadan çizilir', (tester) async {
    await pumpImage(tester, 0);
    expect(tester.takeException(), isNull);
    expect(find.byType(ProductImage), findsOneWidget);

    // Image.network'e 0 değil null iletilir.
    final Image image = tester.widget<Image>(find.byType(Image));
    final ResizeImage? resized = image.image is ResizeImage
        ? image.image as ResizeImage
        : null;
    expect(resized, isNull);
  });

  testWidgets('negatif cacheWidth ile de hata fırlatmaz', (tester) async {
    await pumpImage(tester, -5);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pozitif cacheWidth Image.network\'e aynen iletilir', (
    tester,
  ) async {
    await pumpImage(tester, 300);
    final Image image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<ResizeImage>());
    expect((image.image as ResizeImage).width, 300);
  });
}
