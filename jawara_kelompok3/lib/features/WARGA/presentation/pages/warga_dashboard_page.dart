import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/layout/header_warga.dart';
import '../../../../core/layout/sidebar_warga.dart';

// ✅ PAKAI MODEL + SERVICE YANG SAMA DENGAN ADMIN
// Sesuaikan path kalau strukturmu beda
import '../../../../features/dashboard/data/models/keuangan_dashboard_model.dart';
import '../../../../features/dashboard/data/services/keuangan_dashboard_service.dart';

class WargaDashboardPage extends StatelessWidget {
  const WargaDashboardPage({super.key});

  static const _bg = Color(0xFFF5F3EE);
  static const _green = Color(0xFF2F6B4F);
  static const _brown = Color(0xFF7A5C3E);

  String _norm(String? s) => (s ?? '').toString().trim().toLowerCase();

  String _moneyShort(num v) {
    final value = v.toDouble();
    if (value.abs() >= 1000000)
      return "${(value / 1000000).toStringAsFixed(1)} jt";
    if (value.abs() >= 1000) return "${(value / 1000).toStringAsFixed(1)} rb";
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final kegiatanStream =
        FirebaseFirestore.instance.collection('kegiatan').snapshots();
    final keluargaStream =
        FirebaseFirestore.instance.collection('keluarga').snapshots();
    final wargaStream =
        FirebaseFirestore.instance.collection('warga').snapshots();

    // ✅ sama dengan admin
    final KeuanganService keuanganService = KeuanganService();

    return Scaffold(
      backgroundColor: _bg,
      drawer: const SidebarWarga(),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeaderWarga(
              title: "Dashboard Warga",
              showSearchBar: false,
              showFilterButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const _Hero(),

                    const SizedBox(height: 16),

                    // ====== KEGIATAN ======
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: kegiatanStream,
                      builder: (context, snap) {
                        if (!snap.hasData) return _loadingCard("Kegiatan");
                        final docs = snap.data!.docs;

                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);

                        int lewat = 0, berlangsung = 0, akanDatang = 0;

                        for (final d in docs) {
                          final data = d.data();
                          DateTime? mulai;
                          DateTime? selesai;

                          if (data['tanggal_mulai'] is Timestamp) {
                            mulai =
                                (data['tanggal_mulai'] as Timestamp).toDate();
                          }
                          if (data['tanggal_selesai'] is Timestamp) {
                            selesai =
                                (data['tanggal_selesai'] as Timestamp).toDate();
                          }
                          if (mulai == null) continue;

                          final mulaiDate =
                              DateTime(mulai.year, mulai.month, mulai.day);
                          final selesaiDate = (selesai != null)
                              ? DateTime(
                                  selesai.year, selesai.month, selesai.day)
                              : mulaiDate;

                          if (selesaiDate.isBefore(today)) {
                            lewat++;
                          } else if (mulaiDate.isAfter(today)) {
                            akanDatang++;
                          } else {
                            berlangsung++;
                          }
                        }

                        return _SummaryCard(
                          title: "Kegiatan",
                          subtitle: "Ringkasan jadwal kegiatan warga",
                          accent: _green,
                          child: _Split3(
                            a: ("Lewat", lewat),
                            b: ("Berlangsung", berlangsung),
                            c: ("Akan Datang", akanDatang),
                            color: _green,
                          ),
                          onTap: () =>
                              Navigator.pushNamed(context, '/warga/kegiatan'),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ====== KEPENDUDUKAN (RINGKAS) ======
                    StreamBuilder<QuerySnapshot>(
                      stream: keluargaStream,
                      builder: (context, kSnap) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: wargaStream,
                          builder: (context, wSnap) {
                            if (!kSnap.hasData || !wSnap.hasData) {
                              return _loadingCard("Kependudukan");
                            }

                            int kAktif = 0, kPindah = 0, kSementara = 0;
                            for (final d in kSnap.data!.docs) {
                              final data = d.data() as Map<String, dynamic>;
                              final st =
                                  _norm(data['status_keluarga'] as String?);
                              if (st == 'aktif')
                                kAktif++;
                              else if (st == 'pindah')
                                kPindah++;
                              else if (st == 'sementara') kSementara++;
                            }

                            int wAktif = 0, wNonaktif = 0;
                            for (final d in wSnap.data!.docs) {
                              final data = d.data() as Map<String, dynamic>;
                              final st = _norm(data['status_warga'] as String?);
                              if (st == 'aktif')
                                wAktif++;
                              else if (st == 'nonaktif') wNonaktif++;
                            }

                            return _SummaryCard(
                              title: "Kependudukan",
                              subtitle: "Ringkasan keluarga & warga",
                              accent: _brown,
                              child: Column(
                                children: [
                                  _Split3(
                                    a: ("Keluarga Aktif", kAktif),
                                    b: ("Pindah", kPindah),
                                    c: ("Sementara", kSementara),
                                    color: _brown,
                                  ),
                                  const SizedBox(height: 12),
                                  _Split2(
                                    a: ("Warga Aktif", wAktif),
                                    b: ("Nonaktif", wNonaktif),
                                    color: _brown,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ✅✅✅ KEUANGAN (SINKRON ADMIN) ✅✅✅
                    FutureBuilder<List<KeuanganModel>>(
                      future: keuanganService.getAllKeuangan(),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return _loadingCard("Keuangan");
                        }
                        if (snap.hasError) {
                          return _SummaryCard(
                            title: "Keuangan",
                            subtitle: "Gagal memuat data",
                            accent: _green,
                            child: Text(
                              "Error: ${snap.error}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final list = snap.data ?? [];

                        double totalPemasukan = 0;
                        double totalPengeluaran = 0;

                        int countPemasukan = 0;
                        int countPengeluaran = 0;

                        for (final t in list) {
                          final nominal = t.nominal; // dari model admin
                          if (nominal == 0) continue;

                          final tipeLower = t.tipe.toLowerCase();
                          final isPemasukan = tipeLower == 'pemasukan';
                          final isPengeluaran = tipeLower == 'pengeluaran';

                          if (isPemasukan) {
                            totalPemasukan += nominal;
                            countPemasukan++;
                          } else if (isPengeluaran) {
                            totalPengeluaran += nominal;
                            countPengeluaran++;
                          }
                        }

                        final totalTransaksi = list.length;
                        final saldo = totalPemasukan - totalPengeluaran;

                        return _SummaryCard(
                          title: "Keuangan",
                          subtitle: "Ringkasan kas",
                          accent: _green,
                          onTap: () {
                            // kalau kamu punya halaman detail keuangan warga
                            Navigator.pushNamed(context, '/warga/keuangan');
                          },
                          child: Column(
                            children: [
                              _Split3(
                                a: ("Transaksi", totalTransaksi),
                                b: ("Masuk", countPemasukan),
                                c: ("Keluar", countPengeluaran),
                                color: _brown,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _MoneyTile(
                                      title: "Total Pemasukan",
                                      value: _moneyShort(totalPemasukan),
                                      fg: _green,
                                      bg: const Color(0xFFE3EFE8),
                                      icon: Icons.south_west,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _MoneyTile(
                                      title: "Total Pengeluaran",
                                      value: _moneyShort(totalPengeluaran),
                                      fg: Colors.red.shade700,
                                      bg: const Color(0xFFFBEAEA),
                                      icon: Icons.north_east,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _MoneyTile(
                                title: "Saldo",
                                value: _moneyShort(saldo),
                                fg: _brown,
                                bg: const Color(0xFFF1E6DC),
                                icon: Icons.account_balance_wallet_outlined,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _loadingCard(String title) {
    return _SummaryCard(
      title: title,
      subtitle: "Memuat data...",
      accent: _green,
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 10),
            Text("Loading..."),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  static const _brown = Color(0xFF7A5C3E);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _brown.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _brown.withOpacity(0.18)),
      ),
      child: const Row(
        children: [
          Icon(Icons.eco_outlined, size: 34, color: Color(0xFF2F6B4F)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Ringkasan informasi warga: kegiatan, kependudukan, dan keuangan.",
              style: TextStyle(fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;
  final Widget child;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(.05),
                blurRadius: 18,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 10,
                    height: 10,
                    decoration:
                        BoxDecoration(color: accent, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _Split3 extends StatelessWidget {
  final (String, int) a;
  final (String, int) b;
  final (String, int) c;
  final Color color;

  const _Split3(
      {required this.a, required this.b, required this.c, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniStat(label: a.$1, value: a.$2, color: color),
        _v(),
        _MiniStat(label: b.$1, value: b.$2, color: color),
        _v(),
        _MiniStat(label: c.$1, value: c.$2, color: color),
      ],
    );
  }

  Widget _v() => Container(
        width: 1,
        height: 42,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.grey.shade300,
      );
}

class _Split2 extends StatelessWidget {
  final (String, int) a;
  final (String, int) b;
  final Color color;

  const _Split2({required this.a, required this.b, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MiniStat(label: a.$1, value: a.$2, color: color)),
        Container(
            width: 1,
            height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.grey.shade300),
        Expanded(child: _MiniStat(label: b.$1, value: b.$2, color: color)),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text("$value",
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _MoneyTile extends StatelessWidget {
  final String title;
  final String value;
  final Color fg;
  final Color bg;
  final IconData icon;

  const _MoneyTile({
    required this.title,
    required this.value,
    required this.fg,
    required this.bg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: fg.withOpacity(.12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: fg, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        color: fg, fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
