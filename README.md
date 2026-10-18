# Mini Katalog Uygulaması

Flutter eğitim haftası kapsamında geliştirilen; ürünleri listeleyen, ürün detayını gösteren ve basit bir sepet simülasyonu içeren mobil katalog uygulaması.

## Özellikler

- Ad/soyad ile login; bilgiler `shared_preferences` ile cihazda saklanır, sonraki açılışta login atlanır
- Ana sayfada *"Welcome, <Ad>"* selamlaması ve logout (kayıt silinir, sepet boşaltılır, login ekranına dönülür)
- Ürünlerin `http` paketiyle API'den çekilmesi (`wantapi.com`, 10 sn zaman aşımı)
- API'ye ulaşılamazsa yerel JSON dosyasına düşülmesi (`rootBundle` ile JSON simülasyonu)
- Ürünlerin 2 sütunlu `GridView` ile kart tabanlı listelenmesi
- Ürün adına göre arama / filtreleme (`setState`)
- Named Routes ve Route Arguments ile ürün detay sayfasına geçiş
- Ürün detayında açıklama ve teknik özellikler (Specifications)
- Sepete ekleme / çıkarma, toplam tutar, boş sepet ekranı ve Checkout simülasyonu
- Sepet durumunun `ChangeNotifier` ile yönetimi
- Flutter SDK (`material.dart`) dışında yalnızca hocanın derste gösterdiği paketler kullanılmıştır (bkz. Kullanılan Paketler)

## Kullanılan Paketler

Yönerge ekstra paket kullanılmamasını ister. Aşağıdaki iki paket, hocanın 8 Ekim ders kaydında gösterdiği ve
**"localStorage veya API'den veri çekme"** ek kriteri için izin verilen paketlerdir; bunların dışında paket yoktur.

| Paket | Kullanım amacı | Durum |
|---|---|---|
| [`http`](https://pub.dev/packages/http) | Ürünleri `https://wantapi.com/products.php` adresinden çekmek | Eklendi |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Login: kullanıcı adı/soyadını cihazda saklamak | Eklendi |

Testlerde gerçek internete çıkılmaz; `http` paketinin kendi `MockClient`'ı (`package:http/testing.dart`) kullanılır.
Yerel saklama testlerinde `shared_preferences` paketinin kendi `SharedPreferences.setMockInitialValues` metodu kullanılır.

## Kullanılan Teknolojiler

| Araç | Sürüm |
|---|---|
| Flutter | 3.47.7 (stable) |
| Dart | 3.13.5 |
| Hedef platform | Android (Emulator: Medium Phone API 35) |
| Editör | Visual Studio Code |
| Emülatör aracı | Android Studio (yalnızca Android Emulator için) |

> Sürüm bilgisi `flutter --version` komutunun çıktısından alınmıştır.

## Proje Yapısı

```
lib/
├── main.dart
├── app/          # rotalar ve tema
├── models/       # products_model.dart: Product modeli (fromJson / toJson)
├── services/     # api_service.dart: API'den ürün çekme (http) + yerel JSON yedeği
│                 # local_storage_service.dart: kullanıcı ad/soyadını saklama (shared_preferences)
├── state/        # sepet durumu (ChangeNotifier)
├── views/        # login, home, product detail, cart ekranları
├── components/   # tekrar kullanılan bileşenler
└── utils/        # yardımcı fonksiyonlar (fiyat çevirme)
assets/
├── data/       # products.json (API'ye ulaşılamazsa kullanılan yedek veri)
└── images/     # banner görseli
screenshots/    # README ekran görüntüleri
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

> Ürünler ve görselleri internetten yüklendiği için cihazın/emülatörün internet bağlantısı olmalıdır.
> İnternet yoksa ürün listesi yerel JSON'dan gelir; görseller yerine gri yer tutucu görünür.

## Ekran Görüntüleri

| Ana Sayfa | Ürün Detayı | Sepet | Boş Sepet |
|---|---|---|---|
| <img src="screenshots/home.png" width="200"> | <img src="screenshots/detail.png" width="200"> | <img src="screenshots/cart.png" width="200"> | <img src="screenshots/cart_empty.png" width="200"> |

## Veri Kaynağı

Ürün verileri uygulama açılışında [wantapi.com](https://wantapi.com/products.php) adresindeki eğitim amaçlı mock API'den `http` ile çekilir. Aynı verinin bir kopyası `assets/data/products.json` olarak projede bulunur; istek başarısız olursa (zaman aşımı, bağlantı hatası, 200 dışı yanıt, bozuk veri) bu yedek kullanılır. Bu veri gerçek bir e-ticaret altyapısını temsil etmez. Ürün adları ve markalar ilgili sahiplerine aittir; veri yalnızca eğitim amaçlı kullanılmıştır.
