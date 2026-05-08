# LoKas: Loan & Asset Keeper

Sistem manajemen peminjaman barang inventaris berbasis web. Dibangun menggunakan **Laravel** sebagai backend sekaligus frontend melalui **Inertia.js + React.js**.

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

LoKas (Loan & Asset Keeper) dikembangkan untuk mengotomatisasi siklus hidup peminjaman barang secara terpusat — mulai dari pengajuan, persetujuan, dokumentasi foto kondisi barang, hingga pengembalian.

Sistem dibangun dalam satu project Laravel yang menangani dua hal sekaligus:

| Bagian | Teknologi | Keterangan |
|---|---|---|
| Backend | Laravel | Logika bisnis, autentikasi, REST API |
| Frontend | Inertia.js + React.js | Tampilan web, memanggil data via API endpoint |

Frontend tidak menggunakan Inertia props secara langsung untuk data, melainkan tetap melakukan pemanggilan ke endpoint API (`routes/api.php`) menggunakan Axios, sama seperti klien eksternal lainnya.

---

## Fitur Utama

- **Autentikasi Token**: Token akses dikelola oleh Sanctum dan dikirim via `Authorization` header
- **Manajemen Pengguna**: CRUD user dengan role `admin` dan `staff`
- **Manajemen Gudang**: Data gudang dengan koordinat geolokasi & peta interaktif
- **Manajemen Kategori & Barang**: CRUD barang dengan upload foto dan QR Code
- **Transaksi Peminjaman**: Pengajuan, persetujuan, penolakan, dan pengembalian barang
- **Dokumentasi Foto**: Foto kondisi barang sebelum dan sesudah peminjaman
- **Alert Otomatis**: Scheduled job harian untuk deteksi overdue, due soon, not returned

---

## Arsitektur

```
lokas/
├── app/
│   ├── Http/
endpoint API
│   │   └── Middleware/
│   │       └── ApiAuthMiddleware.php   # Validasi token via header Authorization
│   └── Models/               # User, Warehouse, Item, Loan, LoanAlert, dst.
├── database/
│   └── migrations/
├── resources/
│   └── js/
│       └── Pages/            # Komponen React (via Inertia)
│           ├── Auth/
│           ├── Dashboard/
│           ├── Users/
│           ├── Warehouses/
│           ├── Categories/
│           ├── Items/
│           ├── Loans/
│           └── Alerts/
├── routes/
│   ├── web.php               # Route halaman (render Inertia)
│   └── api.php               # REST API endpoint
├── storage/
│   └── app/public/           # Upload foto barang & loan
└── docs/
    ├── api/                  # Dokumentasi API endpoint
    └── routes/               # Dokumentasi halaman web
```

---

## Requirement

| Komponen | Versi |
|---|---|
| PHP | >= 8.2 |
| Laravel | >= 11.x |
| Composer | >= 2.x |
| Node.js | >= 18.x |
| SQLite | Built-in (via PHP) |
| Laravel Herd | Opsional (lokal) |

---

## Persiapan Environment Lokal

Sebelum melakukan instalasi project, pastikan environment kamu sudah siap agar proses coding dan instalasi berjalan lancar.

**1. Instalasi Laravel Herd**

Untuk pengguna Windows/macOS, **jangan gunakan XAMPP**. Sangat disarankan untuk menginstal Laravel Herd. Herd sudah memaketkan PHP, Composer, dan Node.js secara otomatis, berjalan jauh lebih cepat, dan minim konfigurasi.

**2. Setup Git Bash untuk Laravel Herd (Khusus Windows)**

Jika kamu menggunakan Git Bash dan mendapati pesan error bash: php: command not found atau composer: command not found, kamu perlu mendaftarkan path Herd secara manual:

1. Buka Git Bash dan ketik: nano `~/.bashrc`

2. Untuk mencari path PHP dari Herd, jalankan:

```bash
where.exe php
```

Gunakan hasil path tersebut sebagai referensi. Lalu tambahkan konfigurasi alias berikut (ganti `NAMA_USER_KAMU` dengan nama folder user Windows-mu):

``` Bash
alias php='/c/Users/NAMA_USER_KAMU/.config/herd/bin/php.bat'
alias composer='/c/Users/NAMA_USER_KAMU/.config/herd/bin/composer.bat'
```

3. Simpan dengan tekan `Ctrl+O` -> `Enter` -> `Ctrl+X`.

4. Terapkan perubahan dengan mengetik: `source ~/.bashrc`

**3. Rekomendasi Extension VS Code**

Agar pengalaman coding Laravel dan React makin mulus, instal ekstensi berikut:

- **PHP Intelephense** (Ben Mewburn): Wajib untuk auto-complete dan deteksi error kode PHP. (Matikan fitur bawaan VS Code "PHP Language Features" agar tidak bentrok).

- **Laravel Extension Pack** (Winfred Wang): Bundle paket esensial untuk kebutuhan Laravel.

- **Prettier - Code formatter**: Untuk merapikan (auto-format) kode React, JavaScript, dan CSS.

- **SQLite** (alexcvzz): Untuk melihat dan mengelola isi file database database.sqlite langsung dari dalam VS Code.

## Setup & Instalasi

### 1. Clone & Install Dependency

```bash
git clone https://github.com/your-org/lokas.git
cd lokas

composer install
npm ci
```

### 2. Konfigurasi Environment

```bash
cp .env.example .env
php artisan key:generate
```

Edit `.env`:

```env
APP_NAME=LoKas
APP_URL=http://lokas-tubes-abp.test

DB_CONNECTION=sqlite
DB_DATABASE=database/database.sqlite

SESSION_DRIVER=cookie
```

### 3. Migrasi & Seeder

```bash
touch database/database.sqlite
php artisan migrate --seed
php artisan storage:link
```

### 4. Build Frontend

```bash
npm run dev       # development (hot reload)
npm run build     # production
```

### 5. Jalankan Aplikasi

**Laravel Herd** — tambahkan folder project ke Herd, akses via:

```
http://lokas-tubes-abp.test
```

**Artisan** — jika tidak menggunakan Herd:

```bash
php artisan serve
```

### 6. Scheduler (Alert Otomatis)

```bash
# Development
php artisan schedule:work

# Production — tambahkan ke crontab server
* * * * * cd /path/to/lokas && php artisan schedule:run >> /dev/null 2>&1
```

---

## Akun Default

| Role | Email | Password |
|---|---|---|
| Admin | `admin@lokas.test` | `password` |
| Staff | `staff@lokas.test` | `password` |

---

## Dokumentasi

### API Endpoint — [`docs/api/`](./docs/api/)

| File | Keterangan |
|---|---|
| [`01-auth.md`](./docs/api/01-auth.md) | Login, Logout, Me |
| [`02-users.md`](./docs/api/02-users.md) | Manajemen Pengguna |
| [`03-warehouses.md`](./docs/api/03-warehouses.md) | Manajemen Gudang |
| [`04-categories.md`](./docs/api/04-categories.md) | Manajemen Kategori |
| [`05-items.md`](./docs/api/05-items.md) | Manajemen Barang & QR |
| [`06-loans.md`](./docs/api/06-loans.md) | Transaksi Peminjaman |
| [`07-alerts.md`](./docs/api/07-alerts.md) | Alert Overdue |

> Base URL: `http://lokas-tubes-abp.test/api`

### Halaman Web — [`docs/routes/`](./docs/routes/)

| File | Halaman |
|---|---|
| [`01-auth.md`](./docs/routes/01-auth.md) | Login |
| [`02-dashboard.md`](./docs/routes/02-dashboard.md) | Dashboard & Statistik |
| [`03-users.md`](./docs/routes/03-users.md) | Manajemen Pengguna |
| [`04-warehouses.md`](./docs/routes/04-warehouses.md) | Manajemen Gudang |
| [`05-categories.md`](./docs/routes/05-categories.md) | Manajemen Kategori |
| [`06-items.md`](./docs/routes/06-items.md) | Manajemen Barang |
| [`07-loans.md`](./docs/routes/07-loans.md) | Monitoring Peminjaman |
| [`08-alerts.md`](./docs/routes/08-alerts.md) | Alert Overdue |
