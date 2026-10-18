import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mini_katalog/services/local_storage_service.dart';

void main() {
  final LocalStorageService service = LocalStorageService();

  test('Kayıt yokken ad/soyad null, hasUser false', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await service.getName(), isNull);
    expect(await service.getSurname(), isNull);
    expect(await service.hasUser(), isFalse);
  });

  test('Kaydedilen ad ve soyad geri okunur', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await service.saveUser('Melike', 'Çomak'), isTrue);

    expect(await service.getName(), 'Melike');
    expect(await service.getSurname(), 'Çomak');
    expect(await service.hasUser(), isTrue);
  });

  test('clearUser yalnızca kullanıcı bilgisini siler', () async {
    SharedPreferences.setMockInitialValues({
      'user_name': 'Melike',
      'user_surname': 'Çomak',
      'other_key': 'kalmalı',
    });

    await service.clearUser();

    expect(await service.getName(), isNull);
    expect(await service.getSurname(), isNull);
    expect(await service.hasUser(), isFalse);
    // Başka anahtarlara dokunulmaz (prefs.clear() kullanılmıyor).
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('other_key'), 'kalmalı');
  });
}
