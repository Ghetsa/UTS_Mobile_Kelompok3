# 🏠 JAWARA — Sistem Manajemen Perumahan

**JAWARA** (singkatan dari *Jaringan Warga dan Rumah*) adalah aplikasi manajemen perumahan berbasis Flutter yang dirancang untuk membantu pengelolaan data warga, keuangan, kegiatan, dan komunikasi dalam satu platform terpadu.  
Proyek ini merupakan tugas **UTS** yang berfokus pada **pembuatan tampilan UI (User Interface)** tanpa implementasi proses backend.

---

## 🎯 Tujuan Aplikasi

Aplikasi **JAWARA** dibuat untuk memberikan kemudahan dalam:
- Mengelola data warga dan rumah.
- Memantau pemasukan dan pengeluaran keuangan perumahan.
- Menyampaikan informasi kegiatan dan pengumuman (broadcast).
- Mengatur pengguna dan aktivitas sistem.
- Memfasilitasi komunikasi antarwarga melalui pesan internal.

---

## 🧩 Menu / Menu yang Tersedia

| No | Menu | Jumlah Halaman | Deskripsi Singkat |
|----|--------|----------------|-------------------|
| 1 | **Dashboard** | 3 | Tampilan utama berisi ringkasan statistik, dan informasi penting. |
| 2 | **Data Warga & Rumah** | 5 | Berisi daftar warga, detail rumah, dan informasi kepemilikan. |
| 3 | **Pemasukan** | 5 | Mencatat data keuangan masuk seperti iuran warga, sumbangan, atau donasi. |
| 4 | **Pengeluaran** | 2 | Mencatat pengeluaran dana perumahan. |
| 5 | **Laporan Keuangan** | 3 | Menampilkan laporan rekap pemasukan dan pengeluaran secara periodik. |
| 6 | **Kegiatan & Broadcast** | 4 | Mengelola agenda kegiatan dan menyebarkan pengumuman kepada warga. |
| 7 | **Pesan Warga** | 2 | Fitur pesan internal antarwarga dan pengurus. |
| 8 | **Mutasi Keluarga** | 2 | Mengelola data perpindahan warga (masuk/keluar kompleks). |
| 9 | **Log Aktivitas** | 1 | Menampilkan histori aktivitas pengguna di sistem. |
| 10 | **Manajemen Pengguna** | 2 | Mengatur data pengguna (admin, pengurus, warga). |
| 11 | **Channel Transfer** | 2 | Mengatur metode pembayaran atau transfer dana perumahan. |

---

## 👩‍💻 Pembagian Tugas Tim

| No | Nama | Absen / NIM | Menu yang Dikerjakan |
|----|------|-------------|-----------------------|
| 1 | **Ghetsa Ramadhani Riska A.** | 12 / 2341720004 |Dashboard, Data Warga & Rumah |
| 2 | **Oltha Rosyeda Al'haq** | 12 / 2341720145 | Pemasukan, Laporan Keuangan |
| 3 | **Muhammad Syahrul Gunawan** | 22 / 2341720002 | Manajemen Pengguna, Channel Transfer, Log Aktivitas, Pesan Warga, Login, Register |
| 4 | **Luthfi Triaswangga** | 12 / 2341720208 | Kegiatan & Broadcast, Pengeluaran, Mutasi Keluarga |

---

## 🧱 Teknologi yang Digunakan

- **Flutter** — Framework utama untuk pengembangan UI multiplatform.
- **Dart** — Bahasa pemrograman utama.
- **Firebase** — .
- **Cloudinary** — Storage tempat menyimpan data file/foto.

---

## 🎨 Desain & Tampilan

Aplikasi ini mengusung tema **biru profesional** dengan nuansa lembut (soft blue) agar nyaman dilihat.  
Desain dibuat dengan fokus pada **tampilan mobile** yang **user-friendly** dan **responsif**, menyesuaikan ukuran layar pengguna.

Fitur desain utama:
- Navigasi menggunakan **Drawer Sidebar**.
- Komponen interaktif seperti **Card**, **Button Icon**, dan **ListView**.
- Warna tombol menggunakan **warna kontras tapi tidak mencolok** (misalnya biru muda, merah lembut, abu netral).
- Tampilan responsif untuk user **mobile**.

---

## 🧭 Struktur Navigasi

**JAWARA**
├── **Dashboard**
│ ├── Kegiatan
│ ├── Kependudukan
│ └── Keuangan
├── **Data Warga & Rumah**
│ ├── Warga - Daftar
│ ├── Warga - Tambah
│ ├── Keluarga
│ ├── Rumah - Daftar
│ └── Rumah - Tambah
├── **Pemasukan**
│ ├── Kategori Iuran
│ ├── Tagih Iuran
│ ├── Tagihan
│ ├── Pemasukan Lain - Daftar
│ └── Pemasukan Lain - Tambah
├── **Laporan Keuangan**
│ ├── Semua Pemasukan
│ ├── Semua Pengeluaran
│ └── Cetak Laporan
├── **Manajemen Pengguna**
│ ├── Daftar Pengguna
│ └── Tambah Pengguna
├── **Channel Transfer**
│ ├── Daftar Channel
│ └── Tambah Channel
├── **Log Aktivitas**
│ └── Semua Aktifitas
├── **Pesan Warga**
│ └── Informasi Aspirasi
├── **Kegiatan & Broadcast**
│ ├── Kegiatan - Daftar
│ ├── Kegiatan - Tambah
│ ├── Broadcast - Daftar
│ └── Broadcast - Tambah
└── **Pengeluaran**
│ ├── Daftar
│ └── Tambah
└── **Mutasi Keluarga**
│ ├── Daftar
│ └── Tambah


---

## ⚙️ Status Pengembangan

> **Catatan:**  
> Proyek ini masih dalam tahap *UI Prototype* dan **belum memiliki backend atau database**.  
> Semua data yang tampil masih bersifat **dummy (contoh tampilan)**.

Tahapan selanjutnya (untuk pengembangan penuh):
1. Integrasi dengan backend (misalnya Laravel atau Firebase).
2. Implementasi autentikasi & otorisasi pengguna.
3. Koneksi database untuk manajemen data warga dan keuangan.
4. Deployment agar aplikasi bisa digunakan secara luas.

---

## 📷 Tampilan Preview 

Beberapa halaman utama aplikasi:
- **Dashboard**
- **Daftar Warga**
- **Pemasukan & Pengeluaran**
- **Laporan Keuangan**
- **Kegiatan & Broadcast**
- **Login & Pendaftaran**

---

## 👏 Kontributor

Tim Pengembang UTS — *Aplikasi JAWARA (Manajemen Perumahan)*  
Kelas: **[TI-3D / Pemprograman Mobile]**

| Nama | Peran |
|------|--------|
| Ghetsa Ramadhani Riska A. | UI Dashboard & Data Warga |
| Oltha Rosyeda Al’haq | UI Keuangan (Pemasukan & Laporan) |
| Muhammad Syahrul Gunawan | UI Autentikasi, Pesan Aspirasi, Channel Transfer, Log Aktivitas dan Manajemen Pengguna |
| Luthfi Triaswangga | UI Kegiatan, Broadcast, dan Mutasi Keluarga |

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan **akademik (UTS)** dan **tidak untuk distribusi komersial**.  
Segala aset, warna, dan tampilan bersifat hasil karya kelompok.

---

✨ *"JAWARA — Jalinan Warga, Rumah, dan Rasa Aman dalam Satu Aplikasi."*
