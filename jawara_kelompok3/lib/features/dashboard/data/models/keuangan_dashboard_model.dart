import 'package:cloud_firestore/cloud_firestore.dart';

class KeuanganModel {
  final String docId;
  final String sumber; // ✅ "pemasukan" / "pengeluaran" / "tagihan"
  final String
      jenis; // ✅ contoh: "Donasi", "Tagihan Dibayar", "Acara", "Perawatan"
  final String nama; // ✅ contoh: "Eca", "Sewa Gedung"
  final double nominal;
  final DateTime tanggal;

  KeuanganModel({
    required this.docId,
    required this.sumber,
    required this.jenis,
    required this.nama,
    required this.nominal,
    required this.tanggal,
  });

  static String _s(dynamic v, [String fallback = ""]) {
    if (v == null) return fallback;
    final t = v.toString().trim();
    return t.isEmpty ? fallback : t;
  }

  static double _parseNominal(dynamic raw) {
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      final cleaned = raw.replaceAll('.', '').replaceAll(',', '').trim();
      return double.tryParse(cleaned) ?? 0;
    }
    return 0;
  }

  /// ✅ Parse tanggal aman:
  /// - Timestamp
  /// - ISO: "2025-12-10 12:19:00.753302"
  /// - Format indo umum: "12/9/2025" atau "1/12/2025" => kita anggap d/M/yyyy (Indonesia)
  static DateTime _parseTanggal(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;

    if (raw is String) {
      final s = raw.trim();

      // coba ISO dulu
      final iso = DateTime.tryParse(s);
      if (iso != null) return iso;

      // coba d/M/yyyy atau dd/MM/yyyy
      if (s.contains('/')) {
        final parts = s.split('/');
        if (parts.length == 3) {
          final d = int.tryParse(parts[0].trim());
          final m = int.tryParse(parts[1].trim());
          final y = int.tryParse(parts[2].trim());
          if (d != null && m != null && y != null) {
            // d/M/yyyy (Indonesia)
            return DateTime(y, m, d);
          }
        }
      }
    }

    return DateTime.now();
  }

  factory KeuanganModel.fromDoc({
    required DocumentSnapshot doc,
    required String sumber,
  }) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return KeuanganModel(
      docId: doc.id,
      sumber: sumber,
      jenis: _s(data['jenis'], 'Lainnya'),
      nama: _s(data['nama'], '-'),
      nominal: _parseNominal(data['nominal'] ?? data['jumlah']),
      tanggal: _parseTanggal(data['tanggal']),
    );
  }
}
