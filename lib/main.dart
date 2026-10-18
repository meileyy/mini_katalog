import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'app/theme.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  // runApp'ten önce SharedPreferences (platform kanalı) kullanılacağı için gerekli.
  WidgetsFlutterBinding.ensureInitialized();

  // Kayıtlı kullanıcı varsa login atlanır. Kayıt okunamazsa hasUser false
  // döner ve login açılır.
  final bool hasUser = await LocalStorageService().hasUser();
  runApp(
    MiniKatalogApp(initialRoute: hasUser ? AppRoutes.home : AppRoutes.login),
  );
}

class MiniKatalogApp extends StatelessWidget {
  // Açılış rotası dışarıdan verilir; testler istediği ekranla başlatabilir.
  const MiniKatalogApp({super.key, this.initialRoute = AppRoutes.login});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Tüm rotalar AppRoutes'ta üretilir; açılışta yalnızca initialRoute açılır.
      initialRoute: initialRoute,
      onGenerateInitialRoutes: AppRoutes.onGenerateInitialRoutes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
