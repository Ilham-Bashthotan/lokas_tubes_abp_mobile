# Catatan Integrasi API (Penghapusan Data Dummy)

Berikut adalah ringkasan perubahan yang telah dilakukan untuk menghubungkan aplikasi Flutter dengan backend API dan menghapus penggunaan data dummy secara keseluruhan.

## 1. Pembuatan & Pembaruan Service (API Client)
- **`ItemsService`**: Ditambahkan fungsi `fetchItemByQr` untuk mendukung fitur pemindaian kode QR, sehingga hasil scan langsung divalidasi ke backend.
- **`LoansService`**: Dibuat `LoansService` baru untuk memfasilitasi komunikasi dengan endpoint terkait peminjaman barang, termasuk `fetchMyLoans` (mengambil data pinjaman staf), `createLoan` (membuat pengajuan pinjaman), dan `returnItem` (memproses pengembalian barang).
- **`Loan` Model**: Dibuat model data `Loan` untuk memetakan respons JSON dari endpoint `/loans`.

## 2. Pembaruan Controllers (Penghapusan Dummy)
- **`HomeController`**: 
  - Tidak lagi menggunakan statistik dummy.
  - Sekarang memanggil `LoansService.fetchMyLoans()` untuk mengambil dan menghitung jumlah "Pinjaman Aktif", "Menunggu", dan "Riwayat" sesuai data spesifik untuk user staff yang sedang login.
  - Daftar pinjaman aktif yang ditampilkan di halaman beranda (Home) kini diambil langsung dari backend (berdasarkan response `myActiveLoans`).
- **`ItemsController`**: Penggunaan `DummyItems.getItems()` telah diganti dengan `ItemsService.fetchItems()`. Semua filter dan pencarian sekarang dikirim dan diproses oleh server.
- **`ItemDetailController`**: Penggunaan `DummyItems.findById()` telah diganti dengan `ItemsService.fetchItem()`.
- **`ScanQrController`**: Map data dummy dihapus. Ketika kode QR di-scan, aplikasi kini menggunakan `ItemsService.fetchItemByQr()` untuk memverifikasi dan menarik data aktual barang dari backend.
- **`LoanFormController`**: Diperbarui agar menggunakan data model `Item` yang sesungguhnya dan kini telah dilengkapi fungsi `submitLoanRequest()` yang memanggil `LoansService.createLoan()` untuk membuat permohonan ke backend.
- **`MyLoansController`**: (Sebelumnya kosong). Diimplementasikan agar memanggil `LoansService.fetchMyLoans()` dengan kemampuan filter (aktif, pending, returned).
- **`ReturnFormController`**: (Sebelumnya kosong). Diimplementasikan fungsionalitasnya untuk memanggil `LoansService.returnItem()` yang mengirim data kondisi barang dan catatan pengembalian ke backend.

## 3. Penyesuaian View (UI)
- **`HomeView`**: Hardcode tampilan `_ActiveLoanCard` dihapus dan digantikan dengan mapping data secara dinamis dari `controller.myActiveLoans`. Label diubah dari `borrowedCount` menjadi `activeLoansCount` menyesuaikan wireframe Dashboard khusus untuk Staff.

## Kesimpulan
Aplikasi mobile telah secara penuh dikonversi dari kondisi prototipe (data dummy statis) menjadi aplikasi fungsional yang terhubung dengan backend REST API berdasarkan dokumentasi yang diberikan. Alur scan barang, form peminjaman, serta riwayat berjalan secara dinamis sesuai respons dari server.
