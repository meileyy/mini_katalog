# Mini Katalog Uygulaması

Flutter eğitim haftası kapsamında geliştirilen, ürünleri listeleyen, ürün detayını gösteren ve basit bir sepet simülasyonu içeren mobil katalog uygulaması.

> 🚧 Geliştirme devam ediyor.

## Özellikler

- Ürünlerin `GridView` ile kart tabanlı listelenmesi
- Ürün adına göre arama / filtreleme
- Named Routes ve Route Arguments ile ürün detay sayfasına geçiş
- Ürün detayında açıklama ve teknik özellikler
- Sepete ekleme / çıkarma, toplam tutar ve boş sepet ekranı
- Ekstra paket kullanılmadan, yalnızca Flutter SDK (`material.dart`) ile geliştirilmiştir

## Kullanılan Teknolojiler

| Araç | Sürüm |
|---|---|
| Flutter | 3.47.7 (stable) |
| Dart | 3.13.5 |
| Hedef platform | Android (Emulator: Medium Phone API 35) |
| Editör | Visual Studio Code |

## Proje Yapısı

```
lib/
├── main.dart
├── app/        # rotalar ve tema
├── models/     # Product modeli
├── data/       # JSON veri okuma (repository)
├── state/      # sepet durumu (ChangeNotifier)
├── screens/    # home, detail, cart ekranları
├── widgets/    # tekrar kullanılan bileşenler
└── utils/      # yardımcı fonksiyonlar
assets/
├── data/       # products.json
└── images/     # banner ve yer tutucu görseller
```

## Çalıştırma Adımları

1. Flutter SDK'nın kurulu olduğundan emin olun:
   ```bash
   flutter doctor
   ```
2. Repoyu klonlayın:
   ```bash
   git clone https://github.com/meileyy/mini_katalog.git
   cd mini_katalog
   ```
3. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
4. Bir Android emülatörü başlatın veya cihaz bağlayın, ardından çalıştırın:
   ```bash
   flutter run
   ```

## Ekran Görüntüleri

_Proje tamamlandığında eklenecek._

<!--
| Ana Sayfa | Ürün Detayı | Sepet | Boş Sepet |
|---|---|---|---|
| ![](screenshots/home.png) | ![](screenshots/detail.png) | ![](screenshots/cart.png) | ![](screenshots/cart_empty.png) |
-->

## Veri Kaynağı

Ürün verileri [wantapi.com](https://wantapi.com/products.php) adresindeki eğitim amaçlı mock veriden alınmış ve `assets/data/products.json` olarak projeye eklenmiştir. Bu veri gerçek bir e-ticaret altyapısını temsil etmez. Ürün adları ve markalar ilgili sahiplerine aittir.
