import 'package:flutter/material.dart';

import 'app/theme.dart';

void main() {
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Geçici ana ekran: Adım 5'te HomeScreen, Gün 3'te onGenerateRoute gelecek.
      home: const Scaffold(
        body: Center(child: Text('Mini Katalog')),
      ),
    );
  }
}
