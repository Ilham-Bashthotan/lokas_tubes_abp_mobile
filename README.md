# LoKas Mobile: Loan & Asset Keeper

Aplikasi manajemen peminjaman barang inventaris berbasis mobile. Dibangun menggunakan **Flutter** sebagai frontend yang terhubung ke backend **Laravel** melalui REST API.

---

## Daftar Isi

- [Deskripsi](#deskripsi)
- [Fitur Utama](#fitur-utama)
- [Arsitektur](#arsitektur)
- [Requirement](#requirement)
- [Persiapan Environment Lokal](#persiapan-environment-lokal)
- [Setup & Instalasi](#setup--instalasi)
- [Dokumentasi](#dokumentasi)

---

## Deskripsi

LoKas Mobile dikembangkan untuk memudahkan staf dan pengguna dalam mengakses siklus hidup peminjaman barang secara langsung dari perangkat genggam — mulai dari pengajuan, persetujuan, dokumentasi foto kondisi barang, pemindaian QR Code, hingga pengembalian.

Sistem ini merupakan bagian klien (frontend) dari sistem LoKas:

| Bagian | Teknologi | Keterangan |
|---|---|---|
| Backend | Laravel (Eksternal) | Logika bisnis, autentikasi, REST API |
| Mobile Frontend | Flutter | Aplikasi Android/iOS, memanggil data via API endpoint |
| CLI Tool | Get CLI | Manajemen pattern, module, dan route (GetX) |

Aplikasi mobile ini melakukan pemanggilan ke endpoint API backend menggunakan HTTP client, mengirimkan token autentikasi (Sanctum) untuk setiap request.

---

## Fitur Utama

- **Autentikasi Token**: Akses aman melalui token yang dikirim via `Authorization` header.
- **Pemindaian QR Code**: Kemudahan scan QR code pada barang untuk melihat detail atau melakukan peminjaman.
- **Kamera Terintegrasi**: Mengambil dokumentasi foto kondisi barang sebelum dan sesudah peminjaman secara langsung.
- **Peta & Geolokasi**: Melihat lokasi gudang dan rute menggunakan peta interaktif.
- **Transaksi Peminjaman**: Melihat riwayat peminjaman, status barang, pengajuan, dan pengembalian.
- **Notifikasi**: Menampilkan status *overdue* atau barang yang perlu dikembalikan.

---

## Arsitektur

```
lokas_tubes_abp_mobile/
├── android/                  # Konfigurasi project Android
├── ios/                      # Konfigurasi project iOS
├── lib/
│   ├── app/
│   │   ├── data/             # Model data, provider API, services
│   │   ├── modules/          # Halaman aplikasi (View, Controller, Binding) via GetX
│   │   │   ├── home/
│   │   │   ├── login/
│   │   │   ├── items/
│   │   │   ├── loans/
│   │   │   └── scan/
│   │   └── routes/           # Definisi rute navigasi (AppPages, AppRoutes)
│   ├── core/                 # Tema, warna, konstanta, utils
│   └── main.dart             # Entry point aplikasi
├── assets/                   # Gambar, ikon, dan file statis lainnya
├── doc/                      # Wireframe, desain, dan dokumentasi tambahan
└── pubspec.yaml              # Dependensi Flutter
```

---

## Requirement

| Komponen | Versi |
|---|---|
| Flutter SDK | >= 3.x |
| Dart SDK | >= 3.x |
| Android Studio / VS Code | Versi terbaru |
| Emulator / Real Device | Android / iOS |
| Get CLI | Versi terbaru (pub.dev) |

---

## Persiapan Environment Lokal

Sebelum melakukan instalasi project, pastikan environment Flutter kamu sudah siap.

**1. Instalasi Flutter SDK**
Pastikan Flutter sudah terinstal dan berjalan dengan baik. Jalankan perintah `flutter doctor` di terminal untuk memastikan tidak ada masalah pada setup Flutter, Android SDK, dan toolchain lainnya.

**2. Instalasi Get CLI**
Project ini menggunakan Get CLI untuk manajemen modul dan file. Instal secara global menggunakan perintah:
```bash
flutter pub global activate get_cli
```
Pastikan path pub global sudah terdaftar di environment variable sistem Anda agar perintah `get` bisa dijalankan.

**3. Rekomendasi Extension VS Code**
Agar pengalaman coding Flutter makin mulus, instal ekstensi berikut:
- **Flutter** (Dart Code): Wajib untuk debugging, auto-complete, dan fitur Flutter lainnya.
- **Dart** (Dart Code): Bahasa pemrograman yang digunakan Flutter.
- **GetX Snippets** (opsional): Jika menggunakan GetX, ini sangat membantu mempercepat penulisan boilerplate.

---

## Setup & Instalasi

### 1. Clone & Install Dependency

```bash
git clone https://github.com/your-org/lokas_tubes_abp_mobile.git
cd lokas_tubes_abp_mobile

flutter pub get
```

### 2. Jalankan Backend Laravel (Server Lokal)

Project mobile ini membutuhkan backend Laravel yang aktif agar API bisa diakses.

1. Buka project Laravel (backend) di terminal.
2. Cek IP lokal perangkat kamu terlebih dahulu:

```bash
ipconfig
```

3. Cari nilai **IPv4 Address** pada adapter yang sedang kamu pakai (Wi-Fi/LAN). Contoh: `192.168.18.103`.
4. Masuk ke folder `public` pada project Laravel:

```bash
cd public
```

5. Jalankan server Laravel dengan host IP lokal tersebut (contoh):

```bash
php -S [IP_ADDRESS]:8000
```

> Gunakan IP milik perangkat kamu sendiri dari hasil `ipconfig`, jangan selalu pakai IP contoh di atas. Contoh `php -S 192.XXX.XXX.XXX:8000`

### 3. Buat File `.env` di Project Mobile

Setelah backend berjalan, buat file `.env` di root project Flutter ini, lalu isi:

```dotenv
BASE_URL=http://[IP_ADDRESS]/api/
```

Ganti `[IP_ADDRESS]` dengan IP lokal kamu dari langkah `ipconfig`.

### 4. Konfigurasi Firebase (FCM)

Aplikasi mobile ini menggunakan Firebase Cloud Messaging (FCM) untuk notifikasi native real-time. Konfigurasikan kredensial Firebase klien Anda sebagai berikut:
1. Daftarkan aplikasi Android Anda ke **Firebase Console** dengan nama paket wajib: `com.tubesabp.lokas_tubes_abp_mobile`.
2. Unduh file konfigurasi **`google-services.json`** yang dihasilkan oleh Firebase.
3. Pindahkan file tersebut ke direktori berikut di dalam project Flutter Anda:
   `android/app/google-services.json`
*(Catatan: File ini sudah terdaftar di `.gitignore` untuk melindungi informasi API key klien Anda).*

### 5. Build & Run Aplikasi

Pastikan emulator sudah berjalan atau perangkat fisik sudah terhubung (USB debugging aktif).

```bash
flutter run
```

---

## Akun Default (Testing API)

Gunakan akun yang telah di-seed di backend Laravel untuk mencoba aplikasi:

| Role | Email | Password |
|---|---|---|
| Staff | `budi@example.com` | `password123` |

---

## Dokumentasi Tambahan

- **Wireframe Mobile**: Desain tata letak aplikasi dapat dilihat di [`doc/wireframe_mobile_inventory_track.html`](./doc/wireframe_mobile_inventory_track.html)
- **API Endpoint**: Silakan merujuk pada dokumentasi backend untuk struktur endpoint dan payload.
