import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/utils/search_text.dart';

void main() {
  test('normalizeSearchText "ıphone" → "iphone"', () {
    expect(normalizeSearchText('ıphone'), 'iphone');
  });

  test('normalizeSearchText "İPHONE" → "iphone"', () {
    expect(normalizeSearchText('İPHONE'), 'iphone');
  });

  test('normalizeSearchText "MacBook" → "macbook"', () {
    expect(normalizeSearchText('MacBook'), 'macbook');
  });

  test('normalizeSearchText "çşğöü" ve "ÇŞĞÖÜ" → "csgou"', () {
    expect(normalizeSearchText('çşğöü'), 'csgou');
    expect(normalizeSearchText('ÇŞĞÖÜ'), 'csgou');
  });
}
