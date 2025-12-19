# 🏠 JAWARA — Sistem Manajemen Perumahan

**JAWARA** (singkatan dari *Jaringan Warga dan Rumah*) adalah aplikasi manajemen perumahan berbasis Flutter yang dirancang untuk membantu pengelolaan data kependudukan, keuangan, kegiatan, dan komunikasi dalam satu platform terpadu.  
Proyek ini merupakan tugas **UAS** yang telah selesai dan mencakup implementasi fitur end-to-end untuk **Admin** dan **Warga**.

---

## 🎯 Tujuan Aplikasi

Aplikasi **JAWARA** dibuat untuk memberikan kemudahan dalam:
- Mengelola **data kependudukan & rumah** (warga, keluarga, rumah, mutasi).
- Memantau **pemasukan dan pengeluaran** keuangan perumahan.
- Mengelola **kegiatan warga** serta penyebaran informasi/pengumuman.
- Mengatur pengguna dan memantau aktivitas sistem.
- Memfasilitasi komunikasi warga melalui informasi & aspirasi.
- Mengelola **tagihan** dan alur **pembayaran warga → verifikasi admin**.

---

## 🧩 Menu / Fitur yang Tersedia

| No | Menu | Deskripsi Singkat |
|----|------|-------------------|
| 1 | **Dashboard (Admin)** | Ringkasan statistik & informasi penting (kependudukan, kegiatan, keuangan). |
| 2 | **Data Kependudukan & Rumah (Admin)** | Kelola data **Warga, Rumah, Keluarga**, serta **Mutasi Keluarga**. |
| 3 | **Pesan Warga (Admin)** | Informasi & aspirasi dari warga (lihat & kelola). |
| 4 | **Keuangan → Pemasukan (Admin)** | Kelola **Kategori Iuran**, **Tagihan**, serta **Pemasukan Lainnya**. |
| 5 | **Keuangan → Pengeluaran (Admin)** | Kelola daftar pengeluaran dan tambah pengeluaran. |
| 6 | **Kegiatan & Broadcast (Admin)** | Kelola kegiatan (CRUD kegiatan) serta publikasi informasi. |
| 7 | **Manajemen Pengguna (Admin)** | Kelola pengguna (tambah/lihat). |
| 8 | **Channel Transfer (Admin)** | Kelola metode pembayaran/transfer. |
| 9 | **Log Aktivitas (Admin)** | Riwayat aktivitas pengguna pada sistem. |
| 10 | **Dashboard (Warga)** | Ringkasan informasi untuk warga. |
| 11 | **Kegiatan Warga (Warga)** | Warga melihat daftar kegiatan & detail kegiatan. |
| 12 | **Informasi & Aspirasi (Warga)** | Warga mengirim aspirasi / melihat informasi. |
| 13 | **Profil Saya (Warga)** | Lihat data profil warga. |
| 14 | **Tagihan (Warga)** | Lihat tagihan, lakukan pembayaran, dan pantau status (Belum Dibayar → Menunggu Verifikasi → Sudah Dibayar). |

---

## 👩‍💻 Pembagian Tugas Tim (UAS)

| No | Nama | Absen | NIM | Modul yang Dikerjakan |
|----|------|------|-----|------------------------|
| 1 | **Ghetsa Ramadhani Riska A.** | 12 | 2341720004 | **Project Manager (PM)**, **Seluruh sisi Warga (Dashboard Warga, Kegiatan Warga, Informasi & Aspirasi Warga, Profil Warga, Tagihan Warga + Bayar Tagihan)**, **CRUD Kegiatan (Admin)**, serta kontribusi besar pada integrasi alur fitur utama |
| 2 | **Oltha Rosyeda Al'haq** | 25 | 2341720145 | Pemasukan, Laporan Keuangan |
| 3 | **Muhammad Syahrul Gunawan** | 22 | 2341720002 | Autentikasi, Manajemen Pengguna, Channel Transfer, Log Aktivitas, Pesan Warga |
| 4 | **Luthfi Triaswangga** | 19 | 2341720208 | Kegiatan & Broadcast, Pengeluaran, Mutasi Keluarga |

> Catatan: **UAT dikerjakan keseluruhan** (bukan hanya oleh Ghetsa).

---

## 🧱 Teknologi yang Digunakan

- **Flutter** — Framework utama untuk pengembangan aplikasi multiplatform.
- **Dart** — Bahasa pemrograman utama.
- **Firebase Authentication** — Autentikasi pengguna (Admin/Warga).
- **Database/Backend** — Terintegrasi sesuai implementasi proyek (fitur CRUD dan alur data berjalan).
- **PDF & Printing** — Export / cetak laporan pada modul tertentu.

---

## 🎨 Desain & Tampilan

Aplikasi ini mengusung tema **biru profesional** dengan nuansa lembut (soft blue) agar nyaman dilihat dan tetap modern.  
Desain dibuat dengan fokus pada **tampilan mobile** yang **user-friendly** dan **responsif**.

Fitur desain utama:
- Navigasi menggunakan **Drawer Sidebar** (Admin & Warga).
- Komponen interaktif seperti **Card**, **Icon Button**, **ListView**, **Dialog/Form**.
- Warna status & tombol dibuat kontras namun tetap lembut (biru/hijau/oranye/merah sesuai konteks).
- Tampilan responsif menyesuaikan ukuran layar.

---

## ⚙️ Status Pengembangan

✅ **Selesai (UAS)** — Fitur aplikasi sudah terimplementasi untuk peran **Admin** dan **Warga**, termasuk alur pembayaran tagihan dan verifikasi.

---

## ✅ Alur Utama yang Berjalan

- **Warga melihat tagihan** → klik **Bayar Tagihan** → status menjadi **Menunggu Verifikasi**
- **Admin membuka tagihan** → melakukan **Verifikasi / Tolak** → status berubah menjadi **Sudah Dibayar** atau kembali **Belum Dibayar**
- Laporan tertentu dapat **diexport/cetak PDF** (bergantung platform dan dukungan plugin)

---

## 👏 Kontributor

Tim Pengembang UAS — *Aplikasi JAWARA (Manajemen Perumahan)*  
Kelas: **TI-3D / Pemrograman Mobile**

| Nama | Peran |
|------|------|
| Ghetsa Ramadhani Riska A. | **Project Manager (PM)**, Sisi Warga (semua halaman), CRUD Kegiatan (Admin), integrasi alur fitur utama |
| Oltha Rosyeda Al’haq | Keuangan (Pemasukan & Laporan) |
| Muhammad Syahrul Gunawan | Autentikasi, Manajemen Pengguna, Channel Transfer, Log Aktivitas, Pesan Warga |
| Luthfi Triaswangga | Kegiatan & Broadcast, Pengeluaran, Mutasi Keluarga |

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan **akademik (UAS)** dan **tidak untuk distribusi komersial**.  
Segala aset, warna, dan tampilan merupakan hasil karya kelompok.

---

✨ *"JAWARA — Jalinan Warga, Rumah, dan Rasa Aman dalam Satu Aplikasi."*
