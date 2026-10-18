import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Giriş yapan kullanıcının ad ve soyadını cihazda saklayan sınıf.
// Ekranlar SharedPreferences'a doğrudan dokunmaz, yalnızca bu sınıfı kullanır.
class LocalStorageService {
  static const String _nameKey = 'user_name';
  static const String _surnameKey = 'user_surname';

  // SharedPreferences örneği alanda saklanmaz, her çağrıda yeniden alınır.
  // Böylece testlerde setMockInitialValues ile verilen değerler hep geçerli olur.
  // Okuma/yazma hatalarında uygulama çökmez: hata konsola yazılır ve
  // güvenli bir değer döner.

  // Ad ve soyadı kaydeder; başarılıysa true döner.
  Future<bool> saveUser(String name, String surname) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nameKey, name);
      await prefs.setString(_surnameKey, surname);
      return true;
    } catch (e) {
      debugPrint('Kullanıcı bilgisi kaydedilemedi: $e');
      return false;
    }
  }

  // Kayıtlı adı döner; kayıt yoksa ya da okunamazsa null.
  Future<String?> getName() => _read(_nameKey);

  // Kayıtlı soyadı döner; kayıt yoksa ya da okunamazsa null.
  Future<String?> getSurname() => _read(_surnameKey);

  // Ad ve soyadın ikisi de kayıtlıysa true; okunamazsa false.
  Future<bool> hasUser() async {
    final String? name = await getName();
    final String? surname = await getSurname();
    return (name ?? '').isNotEmpty && (surname ?? '').isNotEmpty;
  }

  // Çıkış: yalnızca bu sınıfın anahtarları silinir (prefs.clear() kullanılmaz).
  Future<void> clearUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_nameKey);
      await prefs.remove(_surnameKey);
    } catch (e) {
      debugPrint('Kullanıcı bilgisi silinemedi: $e');
    }
  }

  Future<String?> _read(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      debugPrint('Kullanıcı bilgisi okunamadı ($key): $e');
      return null;
    }
  }
}
