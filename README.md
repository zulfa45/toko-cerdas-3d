# 🏪 Toko Cerdas 3D — Game Edukasi First-Person di Ruko Sembako

Game edukasi 3D interaktif untuk anak usia 6–12 tahun berbasis **Flutter** dan **Three.js**, berlatar di dalam ruko toko sembako khas Indonesia dengan sudut pandang orang pertama (*first-person*).

Anak berperan sebagai penjaga toko: melayani pembeli yang datang ke ruko, mengambil barang kebutuhan pokok di rak toko, dan menghitung total harga serta uang kembalian dalam Rupiah bulat.

---

## 🌟 Fitur Utama (Prototipe Minggu 1)

1. **Lingkungan 3D Ruko Sembako Realistis (8 × 12 Meter):**
   * Lantai ubin abu muda, dinding krem terang, etalase kaca, dan pintu masuk kaca otomatis.
   * Area luar ruko: trotoar, jalan aspal, dan pohon rindang yang terlihat dari dalam toko.
   * Meja kasir dengan mesin register dan papan nama toko.
   * 5 rak kategori sembako berwarna dengan papan ikon:
     * 🌾 **Sembako Pokok** (Beras, Minyak Goreng, Telur Ayam, Gula Pasir, Terigu)
     * 🍜 **Makanan Kering** (Mie Instan, Biskuit, Roti Tawar)
     * 🥛 **Minuman Dingin** (Susu UHT, Teh Celup, Kopi Sachet, Air Mineral)
     * 🧂 **Bumbu Dapur** (Garam, Kecap Manis, Saus Sambal)
     * 🧼 **Kebutuhan Rumah** (Sabun Mandi, Pasta Gigi, Deterjen)

2. **Kamera First-Person & Dua Mode Kontrol:**
   * Tinggi kamera 1,2 m (tinggi mata anak) dengan FOV 70°.
   * **Mode Ketuk dan Jalan (*Tap to Walk*):** Mengetuk rak atau lantai langsung menggerakkan kamera secara halus ke titik berdiri aman di depan rak (mencegah pusing pada anak usia 6–8 tahun).
   * **Mode Jalan Bebas:** Dilengkapi *virtual joystick* di kiri bawah dan geser layar untuk anak usia 9–12 tahun.
   * **Sistem Pembatas Tabrakan (AABB Collision):** Kamera tidak dapat menembus rak, perabot, dan dinding.
   * **Tombol Cepat Kasir:** Tombol `Ke Kasir` selalu siap di kanan bawah untuk kembali ke kasir seketika.

3. **Sistem Karakter Pembeli Low-Poly & Animasi:**
   * Karakter pembeli low-poly ramah anak ("Bu Sari").
   * Navigasi waypoint lurus: masuk dari trotoar luar $\rightarrow$ pintu geser terbuka otomatis $\rightarrow$ berjalan ke depan meja kasir $\rightarrow$ pintu menutup kembali $\rightarrow$ beralih ke animasi bernapas diam (*idle breathing*).
   * Balon dialog pesanan langsung muncul di kasir.

4. **Raycasting Interaksi Barang:**
   * Mengetuk barang pada rak (Beras, Minyak Goreng, Telur Ayam) memicu efek denyut garis tepi kuning (*pulsing highlight*).
   * Membuka panel detail Flutter native dengan nama barang, satuan, kategori, dan harga bulat Rupiah.

5. **Arsitektur State Management Riverpod:**
   * Logika aplikasi terpisah rapi dari layer grafis 3D.
   * Single source of truth dengan Riverpod (`NotifierProvider`).

---

## 📊 Hasil Uji & Metrik Prototipe

* **FPS Terukur:** 60 FPS stabil (diuji di perangkat Android & Web).
* **Ukuran APK Release:** **18.8 MB** (jauh di bawah batas target PRD 30 MB).
* **Target OS:** Android (RAM 4 GB ke atas) & Web (Chrome).
* **Status Unit Test:** 10/10 pengujian otomatis lulus 100%.

---

## 📁 Struktur Proyek

```text
lib/
  main.dart                      # Inisialisasi aplikasi, orientasi lanskap, ProviderScope
  data/
    product_catalog.dart         # Katalog 18 barang sembako & helper Rupiah
  game/
    game_controller.dart         # State management Riverpod (GameController & GameState)
  ui/
    shop_screen.dart             # Layar utama yang memuat WebView 3D & HUD
    hud_overlay.dart             # HUD atas (judul, FPS live, toggle mode) & bawah (rak, kasir)
    product_detail_dialog.dart   # Modal dialog detail produk hasil raycast
assets/
  three/
    three.min.js                 # Three.js library offline (r128)
    GLTFLoader.js                # glTF loader helper
    index.html                   # Scene ruko 3D, pencahayaan, raycast, animasi, dan kontrol
test/
  unit_test.dart                 # 10 unit test otomatis untuk katalog, state, dan UI
```

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat
* Flutter SDK $\ge 3.29.0$
* Android SDK (API 21+) atau Google Chrome

### Menjalankan di Chrome / Web
```bash
flutter run -d chrome
```

### Menjalankan di Perangkat Android
```bash
flutter run -d android
```

### Membangun APK Release
```bash
flutter build apk --release
```
Berkas APK akan berada di `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📜 Lisensi
Dikembangkan untuk keperluan edukasi anak Indonesia — Toko Cerdas 3D.
