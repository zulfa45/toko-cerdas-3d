# 🏪 Toko Cerdas 3D — Game Edukasi First-Person di Ruko Sembako

Game edukasi 3D interaktif untuk anak usia 6–12 tahun yang dibangun dengan **Flutter** dan **Three.js**, berlatar di dalam ruko toko sembako khas Indonesia dari sudut pandang orang pertama (*first-person*).

Anak berperan sebagai penjaga toko: melayani pembeli yang datang, mengambilkan barang pesanan di rak sembako, kembali ke kasir untuk menghitung total belanja, menerima uang pembayaran, dan menyusun uang kembalian menggunakan pecahan Rupiah pas.

---

## 🌟 Fitur Lengkap yang Telah Selesai Dibangun

### 1. Lingkungan 3D Ruko Sembako Realistis (8 × 12 Meter)
* **Arsitektur Ruko:** Lantai ubin abu muda, dinding krem hangat, etalase kaca, plafon dengan downlight, dan pintu kaca geser otomatis.
* **Pemandangan Luar:** Potongan jalan aspal, trotoar, dan pohon rindang yang terlihat dari dalam ruko.
* **Meja Kasir & Register:** Terletak di dekat pintu masuk, dilengkapi mesin kasir dan papan nama toko kustom.
* **5 Rak Berkategori Lengkap (18 Barang Sembako):**
  1. 🌾 **Sembako Pokok:** Beras 1 kg, Minyak Goreng 1L, Telur Ayam 1 pak, Gula Pasir 1 kg, Tepung Terigu 1 kg.
  2. 🍜 **Makanan Kering:** Mie Instan, Biskuit Kaleng, Roti Tawar.
  3. 🥛 **Minuman Dingin:** Susu UHT, Teh Celup, Kopi Sachet, Air Mineral.
  4. 🧂 **Bumbu Dapur:** Garam Dapur, Kecap Manis, Saus Sambal.
  5. 🧼 **Kebutuhan Rumah:** Sabun Mandi, Pasta Gigi, Deterjen.

### 2. Kamera First-Person & Dua Mode Kontrol Ramah Anak
* **Tinggi Kamera 1,2 m (Tinggi Mata Anak)** dengan sudut pandang (FOV) 70° dan batas kemiringan vertikal untuk mencegah pusing.
* **Mode Ketuk dan Jalan (*Tap to Walk* - Bawaan Umur 6–8 Tahun):** Mengetuk rak atau lantai akan menggerakkan kamera secara otomatis dan halus mengikuti jalur aman.
* **Mode Jalan Bebas (Bawaan Umur 9–12 Tahun):** Dilengkapi *virtual joystick* di kiri bawah dan usap layar di kanan.
* **Pembatas Tabrakan Kotak (AABB Collision):** Kamera tidak dapat menembus rak, etalase, meja kasir, dan dinding ruko.
* **Tombol Kasir Cepat:** Membawa pemain kembali ke belakang kasir seketika saat keranjang sudah lengkap.

### 3. Sistem Pembeli Dinamis (12 Variasi Karakter)
* 12 variasi penampilan pembeli (kombinasi warna kulit, baju batik/dress, hijab, rambut, celana, sepatu).
* Siklus hidup pembeli lengkap:
  $$\text{Muncul di Trotoar} \longrightarrow \text{Pintu Buka Otomatis} \longrightarrow \text{Jalan ke Kasir (Animasi Ayunan Kaki \& Tangan)} \longrightarrow \text{Berdiri \& Memesan} \longrightarrow \text{Membayar} \longrightarrow \text{Reaksi Senang \& Bawa Kantong Belanja} \longrightarrow \text{Keluar Ruko}$$

### 4. Transaksi Lengkap & Panel Kasir 2D
* **Daftar Belanja (*Shopping List* HUD):** Menempel di sisi kiri layar dengan indikator jumlah barang ($0/1$, $1/1$, dst.) dan warna kategori.
* **Keranjang Belanja Interaktif:** Mengambil barang di rak memicu highlight berdenyut dan suara klik pop.
* **Panel Kasir 2D (Langkah 1 - Hitung Total):**
  * Hari 1–2: Pilihan Ganda (3 kartu angka besar).
  * Hari 3–5: Papan Angka / Keypad interaktif (angka 0–9, 000, DEL, C).
  * Petunjuk bertahap lembut jika salah hitung (tanpa hukuman nilai).
* **Panel Kasir 2D (Langkah 2 - Susun Kembalian):**
  * Pembeli menyerahkan uang lembaran (Rp20.000, Rp50.000, Rp100.000).
  * Rak pecahan Rupiah realistis: Rp1.000, Rp2.000, Rp5.000, Rp10.000, Rp20.000, Rp50.000.
  * Indikator real-time: *"Sudah kamu berikan: Rp... | Kurang: Rp..."*.
  * Hadiah +15 Koin jika tepat pada percobaan pertama.

### 5. Progresi 5 Hari & Fase Isi Stok (Restock)
* **Hari 1:** 3 Pembeli (1 barang/pesanan). Mengenal rak & mengambil barang.
* **Hari 2:** 4 Pembeli (1–2 barang). Penjumlahan dua harga sembako.
* **Hari 3:** 4 Pembeli (2–3 barang). Menghitung kembalian pecahan campuran dengan papan angka.
* **Hari 4:** 5 Pembeli (3–4 barang, ada jumlah $\times 2$ atau $\times 3$). Perkalian harga satuan.
* **Hari 5:** 5 Pembeli (4–6 barang campuran). Tantangan mandiri tanpa panah penunjuk lantai.
* **Fase Isi Stok Antar Hari:** Memilih 2 barang untuk mengisi kembali stok rak yang berkurang.

### 6. Desain Visual Claymorphism & UI Bersih
* Mengadopsi prinsip desain ramah anak: tombol tebal minimal $56\times 56$ px, sudut membulat 18–24 px (*soft 3D*), kontras tinggi, teks berukuran $\ge 18$ px.
* **Layar Awal:** Pilihan umur, progres 5 hari dengan bintang (⭐ ⭐ ⭐), dan pintu masuk orang tua.
* **Layar Briefing Hari:** Informasi jumlah pembeli, kemampuan baru, dan tips matematika.
* **Layar Ringkasan Hari:** Evaluasi bintang, koin terkumpul, dan tips review.
* **Dasbor Orang Tua:** Pantauan kemampuan matematika (Penjumlahan, Kembalian, Perkalian), statistik transaksi benar, ganti nama toko, atur suara, dan reset data 2 langkah.

### 7. Engine Audio Sintetis Tanpa Aset Eksternal
* Menggunakan **Web Audio API** terintegrasi di scene 3D:
  * 🔔 Bel pintu ting-tong saat pembeli masuk/keluar.
  * 👟 Suara langkah kaki lembut saat berjalan.
  * 📦 Suara klik pop saat barang diambil.
  * 🛎️ Suara *ka-ching* saat panel kasir dibuka.
  * 🪙 Suara denting koin saat reward bertambah.
  * 🎶 Fanfare arpeggio saat kembalian pas dan transaksi sukses.
  * 💡 Nada lembut saat jawaban perlu dicoba kembali.

---

## 📊 Metrik & Hasil Uji Teknis

| Parameter | Hasil Terukur | Keterangan |
|---|---|---|
| **Frame Rate** | **60 FPS** | Sangat stabil dan mulus di Android & Web |
| **Ukuran APK Release** | **21.1 MB** | Jauh di bawah batas target PRD (30 MB) |
| **Penyimpanan Lokal** | SharedPreferences | Offline penuh, tanpa akun, tanpa koneksi internet |
| **Unit Test Coverage** | 13/13 Lulus (100%) | Mencakup katalog, level, order, transaksi, dan UI |

---

## 📁 Struktur Berkas Proyek

```text
lib/
  main.dart                      # Inisialisasi aplikasi, orientasi lanskap, ProviderScope
  data/
    product_catalog.dart         # Katalog 18 barang sembako lengkap 5 kategori & helper harga
    level_config.dart            # Konfigurasi 5 hari, generator pesanan, & kemampuan matematika
    local_storage.dart           # Layanan penyimpanan lokal (hari, koin, bintang, nama toko)
  game/
    game_controller.dart         # State management Riverpod (GameController & GameState)
  ui/
    home_screen.dart             # Layar awal playful (umur, hari, bintang, koin, pintu orang tua)
    day_briefing_screen.dart     # Layar persiapan hari (target pembeli & tips belajar)
    shop_screen.dart             # Layar utama yang memuat WebView 3D & seluruh modal
    hud_overlay.dart             # HUD atas (judul, FPS live, mode) & bawah (rak, kasir)
    shopping_list_widget.dart    # Kartu daftar belanja dengan checklist dinamis
    product_detail_dialog.dart   # Modal detail produk saat barang diketuk di rak
    cashier_panel_modal.dart     # Checkout kasir 2D (hitung total & susun kembalian Rupiah)
    day_summary_screen.dart      # Layar ringkasan akhir hari (3 bintang, koin, tips)
    restock_screen.dart          # Layar fase isi stok rak di antara hari
    parent_dashboard_screen.dart # Dasbor orang tua (pantauan kemampuan & pengaturan)
assets/
  three/
    three.min.js                 # Library Three.js offline (r128)
    GLTFLoader.js                # glTF loader helper
    index.html                   # Scene ruko 3D, pencahayaan, raycast, animasi, dan audio synth
test/
  unit_test.dart                 # 13 unit test otomatis untuk seluruh alur permainan
```

---

## 🚀 Panduan Menjalankan

### Menjalankan di Google Chrome / Web:
```bash
flutter run -d chrome
```

### Menjalankan di Perangkat Android Fisik atau Emulator:
```bash
flutter run -d android
```

### Membangun Berkas APK Release:
```bash
flutter build apk --release
```
Berkas APK siap dipasang terletak di:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📜 Lisensi
Dikembangkan untuk keperluan edukasi anak Indonesia — Toko Cerdas 3D.
