import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/views/home_screen.dart';
import 'package:mini_katalog/views/login_screen.dart';

// Login'deki iki alan sırayla: Name, Surname
final Finder nameField = find.byType(TextFormField).at(0);
final Finder surnameField = find.byType(TextFormField).at(1);

void main() {
  // Her test boş kayıtla başlar.
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Varsayılan açılış login; altta gizli ana sayfa yok', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiniKatalogApp());

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Please login to your account'), findsOneWidget);
    // Login'in altında ana sayfa açılmamalı; geri tuşu bir yere götürmemeli.
    expect(find.byType(HomeScreen, skipOffstage: false), findsNothing);
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );
  });

  testWidgets('Alanlar boşken Login hata gösterir, kayıt yapılmaz', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiniKatalogApp());

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your surname'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('user_name'), isNull);
  });

  testWidgets('Yalnızca boşluk girilince de hata gösterilir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiniKatalogApp());

    await tester.enterText(nameField, '   ');
    await tester.enterText(surnameField, '  ');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your surname'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Başarılı giriş: trim edilip kaydedilir, ana sayfaya geçilir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiniKatalogApp());

    await tester.enterText(nameField, '  Melike ');
    await tester.enterText(surnameField, ' Çomak ');
    await tester.tap(find.text('Login'));
    await tester.pump(); // kayıt tamamlanır, geçiş başlar
    await tester.pump(const Duration(milliseconds: 500)); // geçiş biter

    expect(find.text('Discover'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    // pushReplacementNamed: geri tuşu login'e döndürmez.
    expect(
      tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
      isFalse,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('user_name'), 'Melike');
    expect(prefs.getString('user_surname'), 'Çomak');
  });
}
