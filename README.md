# 🏠 JAWARA — Sistem Manajemen Perumahan

**JAWARA** (*Jaringan Warga dan Rumah*) adalah aplikasi manajemen perumahan berbasis **Flutter** yang membantu pengelolaan **data kependudukan, rumah, keuangan, kegiatan, tagihan, dan komunikasi** dalam satu platform terpadu.

Proyek ini dibuat untuk kebutuhan **UAS Pemrograman Mobile**, dan saat ini **sudah selesai** dengan implementasi **fitur end-to-end** untuk **Admin** dan **Warga**.

---

## ✨ Fitur Utama

### 👤 Multi Role
- **Admin**: mengelola seluruh data & operasional perumahan.
- **Warga**: akses fitur khusus warga (kegiatan, aspirasi, profil, tagihan, pembayaran).

### ✅ CRUD Lengkap + Alur & Logic
- CRUD **Data Warga**, **Rumah**, **Keluarga**, **Mutasi** (beserta aturan status aktif/nonaktif).
- CRUD **Kegiatan** (admin) + tampilan kegiatan untuk warga.
- CRUD modul keuangan (pemasukan/pengeluaran/kategori/channel).
- Tagihan: pembuatan tagihan, pembayaran warga, verifikasi admin, dan integrasi pencatatan pemasukan.

### 🧾 Cetak & Export PDF
- Cetak PDF untuk beberapa data utama (misal: warga, tagihan) sesuai data yang sedang tampil / terfilter.
- Tersedia fallback handling ketika platform tidak mendukung printing (mis. web tertentu).

### 🔐 Autentikasi & Session
- Login/Logout dengan role berbeda.
- Pengelolaan session (misalnya `SharedPreferences`) agar alur logout aman.

---

## 🎯 Tujuan Aplikasi

Aplikasi **JAWARA** dibuat untuk mempermudah pengurus dan warga dalam:
- Pengelolaan data kependudukan perumahan yang rapi dan konsisten.
- Monitoring keuangan (pemasukan, pengeluaran, laporan).
- Pengelolaan kegiatan warga (agenda & informasi).
- Komunikasi internal melalui informasi & aspirasi.
- Pengelolaan tagihan iuran (buat tagihan, bayar, verifikasi admin).
- Rekap data dan pencetakan laporan dalam format PDF.

---

## 🧩 Modul / Menu yang Tersedia

| No | Modul | Deskripsi Singkat |
|----|------|-------------------|
| 1 | **Dashboard** | Ringkasan statistik & informasi penting (chart/insight). |
| 2 | **Data Kependudukan & Rumah** | Sub menu: **Warga, Rumah, Keluarga, Mutasi** + logic status aktif/nonaktif. |
| 3 | **Keuangan — Pemasukan** | Kategori Iuran, Tagihan, Pemasukan Lainnya. |
| 4 | **Keuangan — Pengeluaran** | Daftar Pengeluaran + Tambah Pengeluaran. |
| 5 | **Laporan Keuangan** | Rekap periodik pemasukan & pengeluaran. |
| 6 | **Kegiatan & Informasi** | CRUD kegiatan (admin) + tampilan kegiatan warga. |
| 7 | **Informasi & Aspirasi** | Komunikasi warga ↔ pengurus. |
| 8 | **Manajemen Pengguna** | Kelola akun admin/pengurus/warga. |
| 9 | **Channel Transfer** | Metode pembayaran/transfer. |
| 10 | **Log Aktivitas** | Riwayat aktivitas dalam sistem. |
| 11 | **Aplikasi Warga (User Side)** | Dashboard, Kegiatan, Aspirasi, Profil, Tagihan, Bayar Tagihan. |

---

## 🔄 Flow Penting (Highlight Logic)

### 🧍‍♀️ Mutasi Warga / Keluarga
- Ketika mutasi “keluar”, sistem **otomatis mengubah status warga menjadi nonaktif** (sesuai aturan yang diterapkan).
- Penambahan anggota keluarga / keluarga baru mempengaruhi relasi data (warga ↔ keluarga ↔ rumah).

### 💳 Tagihan (End-to-End)
1. Admin membuat/kelola tagihan iuran.
2. Warga melihat tagihan.
3. Jika status **Belum Dibayar**, warga bisa klik **Bayar Tagihan**.
4. Setelah bayar → status jadi **Menunggu Verifikasi**.
5. Admin verifikasi → status jadi **Sudah Dibayar**.
6. Ketika status menjadi **Sudah Dibayar**, sistem dapat mencatat ke **Pemasukan Lainnya** (sesuai logic controller).

---

## 🧱 Teknologi yang Digunakan

- **Flutter** — framework utama.
- **Dart** — bahasa pemrograman.
- **Firebase Auth** — autentikasi.
- **SharedPreferences** — pengelolaan session / flag logout.
- **pdf + printing** — generate & print laporan PDF.

---

## ▶️ Cara Menjalankan Project

1. Clone repo:
```bash
git clone <repo-url>
cd jawara
```

2. Install dependencies:
```bash
flutter pub get
```

3. Jalankan aplikasi:
```bash
flutter run
```

> Catatan: Untuk fitur PDF/printing, beberapa fitur bisa memiliki perbedaan dukungan di Web vs Android/iOS. Pastikan testing dilakukan di device/emulator yang sesuai.

---

## 👩‍💻 Pembagian Tugas Tim

> **Keterangan:**  
> **Ghetsa Ramadhani Riska A.** adalah **PM (Project Manager)** dan juga mengerjakan modul krusial, termasuk flow & integrasi lintas fitur.

| No | Nama | Absen | NIM | Tugas / Modul yang Dikerjakan |
|----|------|------:|-----:|-------------------------------|
| 1 | **Ghetsa Ramadhani Riska A. (PM)** | 12 | 2341720004 | Dashboard (termasuk chart & integrasi data), Data Kependudukan & Rumah (Warga, Rumah, Keluarga, Mutasi + logic status), CRUD Kegiatan, Seluruh halaman sisi Warga (Dashboard, Kegiatan, Aspirasi, Profil, Tagihan & Bayar Tagihan), Perapihan flow & integrasi Tagihan Warga, PDF Export untuk modul terkait |
| 2 | **Oltha Rosyeda Al'haq** | 25 | 2341720145 | Pemasukan (Tagihan, Iuran, Lainnya), Laporan Keuangan |
| 3 | **Muhammad Syahrul Gunawan** | 22 | 2341720002 | Manajemen Pengguna, Channel Transfer, Log Aktivitas, Pesan Warga, Login, Pendaftaran |
| 4 | **Luthfi Triaswangga** | 19 | 2341720208 | Kegiatan & Broadcast, Pengeluaran, Mutasi Keluarga (UI) |

---

## 🧪 Testing

Pengujian dilakukan menggunakan metode **UAT (User Acceptance Testing)** untuk role:
- **Admin**
- **Warga**
- serta flow end-to-end (contoh: **Bayar Tagihan → Verifikasi Admin → Status sinkron**)

---

## 🎨 Desain & Tampilan

Aplikasi mengusung tema **biru profesional** dengan nuansa lembut agar nyaman dilihat.

Fitur desain utama:
- Navigasi menggunakan **Drawer Sidebar** (Admin & Warga).
- Komponen **Card**, **ListView**, **Dialog**, dan **Button** yang konsisten.
- Tampilan **responsif** untuk device mobile, dengan pertimbangan kompatibilitas di web.

---

## 👏 Kontributor

Tim Pengembang UAS — *Aplikasi JAWARA (Manajemen Perumahan)*  
Kelas: **TI-3D / Pemrograman Mobile**

| Nama | Peran |
|------|------|
| Ghetsa Ramadhani Riska A. | PM + Dashboard, Kependudukan & Rumah, Kegiatan, Seluruh fitur Warga, integrasi flow & PDF |
| Oltha Rosyeda Al’haq | Keuangan: Pemasukan & Laporan |
| Muhammad Syahrul Gunawan | Autentikasi, Manajemen Pengguna, Channel Transfer, Log Aktivitas, Pesan |
| Luthfi Triaswangga | Kegiatan/Broadcast, Pengeluaran, Mutasi |

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan **akademik (UAS)** dan **tidak untuk distribusi komersial**.  
Semua aset, warna, dan tampilan merupakan hasil karya tim.

---

✨ *"JAWARA — Jalinan Warga, Rumah, dan Rasa Aman dalam Satu Aplikasi."*
