import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/layout/header_warga.dart';
import '../../../../core/layout/sidebar_warga.dart';

class WargaKegiatanPage extends StatelessWidget {
  const WargaKegiatanPage({super.key});

  // Tema hijau-coklat kalem (local)
  static const Color _green = Color(0xFF2F6F4E);
  static const Color _brown = Color(0xFF8B6B3E);
  static const Color _bg = Color(0xFFF4F7F3);

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return "$dd-$mm-${d.year}";
  }

  DateTime? _tsToDate(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  String _statusLabel(DateTime? mulai, DateTime? selesai) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (mulai == null) return "Tidak ada tanggal";

    final m = DateTime(mulai.year, mulai.month, mulai.day);
    final s = (selesai == null)
        ? m
        : DateTime(selesai.year, selesai.month, selesai.day);

    if (s.isBefore(today)) return "Selesai";
    if (m.isAfter(today)) return "Akan Datang";
    return "Berlangsung";
  }

  Color _statusColor(String label) {
    switch (label.toLowerCase()) {
      case 'selesai':
        return _brown;
      case 'akan datang':
        return _green;
      case 'berlangsung':
        return const Color(0xFF1E5A3C);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('kegiatan')
        .orderBy('tanggal_mulai', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: _bg,
      drawer: const SidebarWarga(),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeaderWarga(
              title: "Kegiatan Warga",
              searchHint: "Cari kegiatan...",
              showSearchBar: false,
              showFilterButton: false,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(
                      child: Text("Error: ${snap.error}",
                          style: const TextStyle(color: Colors.red)),
                    );
                  }

                  final docs = snap.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text("Belum ada kegiatan yang tersedia."),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final data = docs[i].data();
                      final title = (data['judul'] ??
                              data['nama'] ??
                              'Kegiatan')
                          .toString();
                      final lokasi = (data['lokasi'] ?? '-').toString();
                      final kategori = (data['kategori'] ?? 'Umum').toString();

                      final mulai = _tsToDate(data['tanggal_mulai']);
                      final selesai = _tsToDate(data['tanggal_selesai']);

                      final status = _statusLabel(mulai, selesai);

                      return _KegiatanCard(
                        green: _green,
                        brown: _brown,
                        statusColor: _statusColor(status),
                        title: title,
                        kategori: kategori,
                        lokasi: lokasi,
                        tanggal: (mulai == null)
                            ? "-"
                            : (selesai == null || _fmtDate(mulai) == _fmtDate(selesai))
                                ? _fmtDate(mulai)
                                : "${_fmtDate(mulai)} s/d ${_fmtDate(selesai)}",
                        status: status,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KegiatanCard extends StatelessWidget {
  final Color green;
  final Color brown;
  final Color statusColor;

  final String title;
  final String kategori;
  final String lokasi;
  final String tanggal;
  final String status;

  const _KegiatanCard({
    required this.green,
    required this.brown,
    required this.statusColor,
    required this.title,
    required this.kategori,
    required this.lokasi,
    required this.tanggal,
    required this.status,
  });

  bannerColor() => green.withOpacity(0.08);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: green.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: green,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: statusColor.withOpacity(0.25)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              _Pill(icon: Icons.category, text: kategori, color: brown),
              const SizedBox(width: 8),
              Expanded(
                child: _Pill(icon: Icons.place, text: lokasi, color: green),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.calendar_month, size: 18, color: brown),
              const SizedBox(width: 8),
              Text(
                tanggal,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _Pill({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
