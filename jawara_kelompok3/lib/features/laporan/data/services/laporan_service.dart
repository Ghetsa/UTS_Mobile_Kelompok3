import '../models/laporan_keuangan_model.dart';

class LaporanService {
  final List<LaporanKeuanganModel> _dummyData = [
    LaporanKeuanganModel(
      tanggal: DateTime(2025, 10, 13),
      keterangan: "Pembelian ATK",
      jenis: "Pengeluaran",
      nominal: 500000,
    ),
    LaporanKeuanganModel(
      tanggal: DateTime(2025, 8, 12),
      keterangan: "Iuran Warga",
      jenis: "Pemasukan",
      nominal: 1000000,
    ),
    LaporanKeuanganModel(
      tanggal: DateTime(2025, 8, 20),
      keterangan: "Bayar Listrik",
      jenis: "Pengeluaran",
      nominal: 300000,
    ),
  ];

  Future<List<LaporanKeuanganModel>> getLaporan({
    required DateTime startDate,
    required DateTime endDate,
    required String jenis, // "Semua" | "Pemasukan" | "Pengeluaran"
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return _dummyData.where((lap) {
      final inRange =
          !lap.tanggal.isBefore(startDate) && !lap.tanggal.isAfter(endDate);

      final jenisMatch = jenis == "Semua"
          ? true
          : lap.jenis.toLowerCase() == jenis.toLowerCase();

      return inRange && jenisMatch;
    }).toList();
  }
}
