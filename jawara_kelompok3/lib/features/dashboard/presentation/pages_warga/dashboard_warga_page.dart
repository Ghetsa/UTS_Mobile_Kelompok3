import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Header kamu
import '../../../../core/layout/header.dart';

// Kalau warga punya sidebar sendiri, ganti ini.
// import '../../../../core/layout/sidebar_warga.dart';

// Kegiatan / Kependudukan / Keuangan navigation (opsional)
import '../../../kegiatan/presentation/pages/daftar_kegiatan_page.dart';
import '../../../dashboard/presentation/pages/kependudukan_dashboard_page.dart';
import '../../../dashboard/presentation/pages/keuangan_dashboard_page.dart';

// Keuangan service + model (yang kamu pakai)
import '../../../dashboard/data/models/keuangan_dashboard_model.dart';
import '../../../dashboard/data/services/keuangan_dashboard_service.dart';

class DashboardWargaPage extends StatelessWidget {
  const DashboardWargaPage({super.key});

  // ====== PALETTE HIJAU + COKLAT (KALem) ======
  static const _bg = Color(0xFFF4F6F2);
  static const _card = Colors.white;

  static const _greenDark = Color(0xFF2F5D50);
  static const _greenSoft = Color(0xFFA7C7B9);

  static const _brownDark = Color(0xFF6B4E3D);
  static const _brownSoft = Color(0xFFD8C3B1);

  static const _textMuted = Color(0xFF7A7A7A);

  String _norm(String? s) => (s ?? '').toString().trim().toLowerCase();

  // ====== Kegiatan: klasifikasi lewat / berlangsung / akan datang ======
  Map<String, int> _calcKegiatan(List<QueryDocumentSnapshot> docs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int lewat = 0;
    int berlangsung = 0;
    int akanDatang = 0;

    for (final d in docs) {
      final data = d.data() as Map<String, dynamic>;

      DateTime? tglMulai;
      DateTime? tglSelesai;

      if (data['tanggal_mulai'] is Timestamp) {
        tglMulai = (data['tanggal_mulai'] as Timestamp).toDate();
      }
      if (data['tanggal_selesai'] is Timestamp) {
        tglSelesai = (data['tanggal_selesai'] as Timestamp).toDate();
      }

      if (tglMulai == null) continue;

      final mulaiDate = DateTime(tglMulai.year, tglMulai.month, tglMulai.day);
      final selesaiDate = tglSelesai != null
          ? DateTime(tglSelesai.year, tglSelesai.month, tglSelesai.day)
          : mulaiDate;

      if (selesaiDate.isBefore(today)) {
        lewat++;
      } else if (mulaiDate.isAfter(today)) {
        akanDatang++;
      } else {
        berlangsung++;
      }
    }

    return {
      'lewat': lewat,
      'berlangsung': berlangsung,
      'akan': akanDatang,
      'total': lewat + berlangsung + akanDatang,
    };
  }

  // ====== Kependudukan ringkas: warga aktif/nonaktif + keluarga status ======
  Map<String, int> _calcWarga(List<QueryDocumentSnapshot> wargaDocs) {
    int aktif = 0;
    int nonaktif = 0;

    for (final d in wargaDocs) {
      final data = d.data() as Map<String, dynamic>;
      final st = _norm(data['status_warga'] as String?);
      if (st == 'aktif') aktif++;
      if (st == 'nonaktif') nonaktif++;
    }

    return {
      'aktif': aktif,
      'nonaktif': nonaktif,
      'total': wargaDocs.length,
    };
  }

  Map<String, int> _calcKeluarga(List<QueryDocumentSnapshot> keluargaDocs) {
    int aktif = 0;
    int pindah = 0;
    int sementara = 0;

    for (final d in keluargaDocs) {
      final data = d.data() as Map<String, dynamic>;
      final st = _norm(data['status_keluarga'] as String?);
      if (st == 'aktif') aktif++;
      else if (st == 'pindah') pindah++;
      else if (st == 'sementara') sementara++;
    }

    return {
      'aktif': aktif,
      'pindah': pindah,
      'sementara': sementara,
      'total': keluargaDocs.length,
    };
  }

  // ====== Keuangan ringkas ======
  String _formatShort(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)} jt';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)} rb';
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final kegiatanStream =
        FirebaseFirestore.instance.collection('kegiatan').snapshots();
    final wargaStream = FirebaseFirestore.instance.collection('warga').snapshots();
    final keluargaStream =
        FirebaseFirestore.instance.collection('keluarga').snapshots();

    final keuanganService = KeuanganService();

    return Scaffold(
      backgroundColor: _bg,

      // Kalau kamu punya sidebar warga, pasang di sini:
      // drawer: const AppSidebarWarga(),

      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(
              title: "Dashboard Warga",
              showSearchBar: false,
              showFilterButton: false,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _HeroWelcomeCard(
                    bg1: _greenSoft,
                    bg2: _brownSoft,
                    titleColor: _greenDark,
                    subtitleColor: _textMuted,
                    accent: _brownDark,
                    onQuickKegiatan: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DaftarKegiatanPage()),
                    ),
                    onQuickKependudukan: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardKependudukanPage()),
                    ),
                    onQuickKeuangan: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DashboardKeuanganPage()),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ================== RINGKASAN KEGIATAN ==================
                  StreamBuilder<QuerySnapshot>(
                    stream: kegiatanStream,
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return _SkeletonCard(title: "Ringkasan Kegiatan");
                      }
                      final counts = _calcKegiatan(snap.data!.docs);
                      return _SectionCard(
                        title: "Ringkasan Kegiatan",
                        subtitle: "Total: ${counts['total']} kegiatan",
                        icon: Icons.event_available,
                        iconBg: _greenSoft,
                        iconColor: _greenDark,
                        child: _MiniTimelineDiagram(
                          lewat: counts['lewat'] ?? 0,
                          berlangsung: counts['berlangsung'] ?? 0,
                          akanDatang: counts['akan'] ?? 0,
                          main: _greenDark,
                          soft: _greenSoft,
                          muted: _textMuted,
                        ),
                        bg: _card,
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // ================== RINGKASAN KEPENDUDUKAN ==================
                  Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: keluargaStream,
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return _SkeletonBox();
                            }
                            final c = _calcKeluarga(snap.data!.docs);
                            return _MiniStatBox(
                              title: "Keluarga",
                              big: "${c['total']}",
                              sub: "Aktif ${c['aktif']} • Pindah ${c['pindah']} • Sementara ${c['sementara']}",
                              topColor: _brownDark,
                              bottomColor: _brownSoft,
                              icon: Icons.home,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: wargaStream,
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return _SkeletonBox();
                            }
                            final w = _calcWarga(snap.data!.docs);
                            return _MiniStatBox(
                              title: "Warga",
                              big: "${w['total']}",
                              sub: "Aktif ${w['aktif']} • Nonaktif ${w['nonaktif']}",
                              topColor: _greenDark,
                              bottomColor: _greenSoft,
                              icon: Icons.people,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ================== RINGKASAN KEUANGAN ==================
                  FutureBuilder<List<KeuanganModel>>(
                    future: keuanganService.getAllKeuangan(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return _SkeletonCard(title: "Ringkasan Keuangan");
                      }

                      final list = snap.data ?? [];
                      double pemasukan = 0;
                      double pengeluaran = 0;

                      for (final t in list) {
                        final tipe = (t.tipe).toLowerCase().trim();
                        if (tipe == 'pemasukan') pemasukan += t.nominal;
                        if (tipe == 'pengeluaran') pengeluaran += t.nominal;
                      }

                      final saldo = pemasukan - pengeluaran;

                      return _SectionCard(
                        title: "Ringkasan Keuangan",
                        subtitle: "Ringkas sampai hari ini",
                        icon: Icons.account_balance_wallet_rounded,
                        iconBg: _brownSoft,
                        iconColor: _brownDark,
                        bg: _card,
                        child: _FinanceGauge(
                          pemasukan: pemasukan,
                          pengeluaran: pengeluaran,
                          saldo: saldo,
                          green: _greenDark,
                          brown: _brownDark,
                          muted: _textMuted,
                          format: _formatShort,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================= UI WIDGETS =========================

class _HeroWelcomeCard extends StatelessWidget {
  final Color bg1, bg2, titleColor, subtitleColor, accent;
  final VoidCallback onQuickKegiatan;
  final VoidCallback onQuickKependudukan;
  final VoidCallback onQuickKeuangan;

  const _HeroWelcomeCard({
    required this.bg1,
    required this.bg2,
    required this.titleColor,
    required this.subtitleColor,
    required this.accent,
    required this.onQuickKegiatan,
    required this.onQuickKependudukan,
    required this.onQuickKeuangan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [bg1.withOpacity(.65), bg2.withOpacity(.55)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ringkasan Hari Ini",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Kegiatan • Kependudukan • Keuangan (versi warga)",
            style: TextStyle(color: subtitleColor),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _QuickChip(
                label: "Kegiatan",
                icon: Icons.event,
                color: accent,
                onTap: onQuickKegiatan,
              ),
              _QuickChip(
                label: "Kependudukan",
                icon: Icons.people_alt,
                color: accent,
                onTap: onQuickKependudukan,
              ),
              _QuickChip(
                label: "Keuangan",
                icon: Icons.payments,
                color: accent,
                onTap: onQuickKeuangan,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white.withOpacity(.75),
          border: Border.all(color: color.withOpacity(.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Widget child;
  final Color bg;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.child,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg.withOpacity(.55),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _MiniTimelineDiagram extends StatelessWidget {
  final int lewat;
  final int berlangsung;
  final int akanDatang;
  final Color main;
  final Color soft;
  final Color muted;

  const _MiniTimelineDiagram({
    required this.lewat,
    required this.berlangsung,
    required this.akanDatang,
    required this.main,
    required this.soft,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    final total = lewat + berlangsung + akanDatang;
    double pct(int v) => total == 0 ? 0 : v / total;

    Widget bar(double f, Color c) => Expanded(
          flex: (f * 1000).round().clamp(1, 1000),
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );

    return Column(
      children: [
        // “diagram” bar 3 segmen
        Row(
          children: [
            bar(pct(lewat), soft.withOpacity(.55)),
            const SizedBox(width: 6),
            bar(pct(berlangsung), main.withOpacity(.85)),
            const SizedBox(width: 6),
            bar(pct(akanDatang), soft.withOpacity(.85)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _MiniKV(label: "Lewat", value: "$lewat", muted: muted)),
            Expanded(child: _MiniKV(label: "Berlangsung", value: "$berlangsung", muted: muted)),
            Expanded(child: _MiniKV(label: "Akan Datang", value: "$akanDatang", muted: muted)),
          ],
        ),
      ],
    );
  }
}

class _MiniKV extends StatelessWidget {
  final String label;
  final String value;
  final Color muted;

  const _MiniKV({
    required this.label,
    required this.value,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: muted)),
      ],
    );
  }
}

class _MiniStatBox extends StatelessWidget {
  final String title;
  final String big;
  final String sub;
  final Color topColor;
  final Color bottomColor;
  final IconData icon;

  const _MiniStatBox({
    required this.title,
    required this.big,
    required this.sub,
    required this.topColor,
    required this.bottomColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [topColor.withOpacity(.14), bottomColor.withOpacity(.18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: topColor.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: topColor),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: topColor)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            big,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: topColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sub,
            style: TextStyle(
              color: Colors.black.withOpacity(.55),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceGauge extends StatelessWidget {
  final double pemasukan;
  final double pengeluaran;
  final double saldo;

  final Color green;
  final Color brown;
  final Color muted;

  final String Function(double) format;

  const _FinanceGauge({
    required this.pemasukan,
    required this.pengeluaran,
    required this.saldo,
    required this.green,
    required this.brown,
    required this.muted,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    final maxBase = (pemasukan + pengeluaran);
    final ratio = maxBase <= 0 ? 0.0 : (saldo.abs() / maxBase).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MoneyTile(
                label: "Pemasukan",
                value: format(pemasukan),
                color: green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MoneyTile(
                label: "Pengeluaran",
                value: format(pengeluaran),
                color: brown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // “gauge” saldo (visual sederhana & kalem)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.03),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Saldo", style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text(
                    format(saldo),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: saldo >= 0 ? green : brown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 12,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    saldo >= 0 ? green.withOpacity(.75) : brown.withOpacity(.75),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                saldo >= 0 ? "Kondisi aman (surplus)" : "Perlu perhatian (defisit)",
                style: TextStyle(color: muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoneyTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MoneyTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.12)),
        color: color.withOpacity(.06),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.black.withOpacity(.55))),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final String title;
  const _SkeletonCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Container(height: 12, width: double.infinity, color: Colors.black12),
          const SizedBox(height: 8),
          Container(height: 12, width: 220, color: Colors.black12),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
    );
  }
}
