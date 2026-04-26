# FlowCash - Manajemen Keuangan Pribadi

FlowCash adalah aplikasi mobile berbasis **Flutter** yang dirancang untuk membantu pengguna mengelola keuangan harian dengan antarmuka yang elegan, bersih, dan fungsional. Proyek ini disusun untuk memenuhi tugas besar UAS pengembangan Aplikasi Mobile,

---

## Daftar Fitur
Aplikasi ini dikembangkan dengan fitur-fitur utama sebagai berikut:
* **Ringkasan Saldo (Dashboard):** Visualisasi total pemasukan dan pengeluaran dalam bentuk kartu (Card) yang informatif.
* **Pencatatan Transaksi:** Form input untuk mencatat nominal, kategori (Makan, Transportasi, dll), serta tanggal transaksi.
* **Riwayat Transaksi:** Daftar Kronologis semua aktivitas keuangan menggunakan `ListView` yang interaktif.
* **Validasi Data:** Memastikan data yang dimasukkan akurat (tidak boleh kosong atau nol).
* **UI Elegan:** Menggunakan desain minimalis dengan tipografi yang jelas (Poppins) dan palet warna profesional.

---

## Cara Kerja Aplikasi 
1. **Halaman Utama:** Saat aplikasi dibuka, pengguna akan melihat total saldo yang dihitung secara otomatis dari selisih pemasukan dan pengeluaran.
2. **Menambah Data:** Pengguna menekan tombol "Tambah", mengisi detail transaksi, lalu menyimpan nya,
3. **Sinkronisasi State:** Setelah data disimpan, Dashboard akan otomatis terupdate tanpa perlu memuat ulang aplikasi (State Management).
4. **Manajemen Riwayat:** Pengguna bisa melihat kembali daftar pengeluaran untuk melakukan evaluasi keuangan mandiri.

---

## Rencana Pengembangan (Blueprint)
* **Minggu 1:** Inisialisasi Proyek & Sinkronisasi GIT (Current).
* **Minggu 2:** Pengembangan Layout UI (Dashboard & List).
* **Minggu 3:** Implementasi Logika Bisnis & Database.
* **Minggu 4:** Pengujian (Testing) & Finalisasi Dokumentasi.
* **Minggu 5:** Pendaftaran & Publikasi ke Google Play Store.

---
## Tech Stack
* **Framework:** Flutter
* **Language:** Dart
* **Fonts:** Poppins / Inter
* **State Management:** Provider / SetState
* **Database:** SQLite / Local Storange