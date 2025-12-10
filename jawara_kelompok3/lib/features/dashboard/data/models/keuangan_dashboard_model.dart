import 'package:cloud_firestore/cloud_firestore.dart';

/// Model transaksi keuangan gabungan dari:
/// - pemasukan
/// - pengeluaran
/// - tagihan (yang sudah dibayar)
class KeuanganModel {
  final String docId;
  final String sumber;   // "pemasukan" / "pengeluaran" / "tagihan"
  final String tipe;     // "pemasukan" / "pengeluaran"
  final String kategori;
  final double nominal;
  final DateTime tanggal;

  KeuanganModel({
    required this.docId,
    required this.sumber,
    required this.tipe,
    required this.kategori,
    required this.nominal,
    required this.tanggal,
  });

  // ---------- Helper parsing umum ----------

  static DateTime _parseTanggal(dynamic raw) {
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is String) {
      // coba parse ISO dulu
      final dt = DateTime.tryParse(raw);
      if (dt != null) return dt;
      // fallback: pakai now kalau gagal
    }
    return DateTime.now();
  }

  static double _parseNominal(dynamic raw) {
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      return double.tryParse(raw.replaceAll('.', '').replaceAll(',', '')) ?? 0;
    }
    return 0;
  }

  // ---------- Dari koleksi PEMASUKAN ----------
  factory KeuanganModel.fromPemasukanDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return KeuanganModel(
      docId: doc.id,
      sumber: 'pemasukan',
      tipe: 'pemasukan',
      kategori: (data['kategori'] ?? '') as String,
      nominal: _parseNominal(data['jumlah'] ?? data['nominal']),
      tanggal: _parseTanggal(data['tanggal']),
    );
  }

  // ---------- Dari koleksi PENGELUARAN ----------
  factory KeuanganModel.fromPengeluaranDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return KeuanganModel(
      docId: doc.id,
      sumber: 'pengeluaran',
      tipe: 'pengeluaran',
      kategori: (data['kategori'] ?? '') as String,
      nominal: _parseNominal(data['jumlah'] ?? data['nominal']),
      tanggal: _parseTanggal(data['tanggal']),
    );
  }

  // ---------- Dari koleksi TAGIHAN ----------
  /// Hanya mengembalikan `KeuanganModel` kalau tagihan SUDAH DIBAYAR.
  /// Kalau belum dibayar → return null (di-skip).
  static KeuanganModel? fromTagihanDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Status tagihan
    final statusRaw =
        (data['tagihanStatus'] ?? data['status'] ?? '') as String;
    final status = statusRaw.toLowerCase().trim();

    final sudahDibayar =
        status == 'lunas' || status == 'dibayar' || status.contains('lunas');

    if (!sudahDibayar) {
      // belum dibayar → tidak dihitung sebagai pemasukan
      return null;
    }

    return KeuanganModel(
      docId: doc.id,
      sumber: 'tagihan',
      tipe: 'pemasukan', // uang masuk ketika sudah dibayar
      kategori: (data['kategori'] ?? 'Tagihan') as String,
      nominal: _parseNominal(data['jumlah'] ?? data['nominal']),
      tanggal: _parseTanggal(data['tanggal']),
    );
  }
}
