import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/detail/detail_screen.dart';
import '../screens/home/home_screen.dart';

// Uygulamadaki rota adları ve rotaları üreten fonksiyon.
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String cart = '/cart';

  // Navigator.pushNamed ile yapılan her geçiş buradan geçer.
  // settings mutlaka MaterialPageRoute'a verilir; verilmezse hedef ekranda
  // ModalRoute.of(context)!.settings.arguments null gelir.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
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
          builder: (_) => const DetailScreen(),
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
