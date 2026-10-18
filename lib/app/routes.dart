import 'package:flutter/material.dart';

import '../models/products_model.dart';
import '../views/cart_screen.dart';
import '../views/home_screen.dart';
import '../views/login_screen.dart';
import '../views/product_detail_screen.dart';

// Uygulamadaki rota adları ve rotaları üreten fonksiyon.
class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String detail = '/detail';
  static const String cart = '/cart';

  // Uygulama açılışında yalnızca istenen tek rota açılır.
  // Bu verilmezse Flutter '/login' adını bölüp önce '/' (ana sayfa), üstüne
  // '/login' rotasını açar: ana sayfa arkada gizlice yüklenir ve login'deki
  // geri tuşu giriş yapmadan ana sayfaya götürür.
  static List<Route<dynamic>> onGenerateInitialRoutes(String initialRoute) {
    return [onGenerateRoute(RouteSettings(name: initialRoute))];
  }

  // Navigator.pushNamed ile yapılan her geçiş buradan geçer.
  // settings mutlaka MaterialPageRoute'a verilir; verilmezse hedef ekranda
  // ModalRoute.of(context)!.settings.arguments null gelir.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case detail:
        // Argüman Product değilse (ör. hiç gönderilmediyse) detay ekranı
        // çökeceği için ana sayfa açılır.
        if (settings.arguments is! Product) {
          return MaterialPageRoute(
            builder: (_) => const HomeScreen(),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const ProductDetailScreen(),
          settings: settings,
        );
      case cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );
      default:
        // Bilinmeyen rota adı: çökmek yerine ana sayfa açılır.
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
    }
  }
}
