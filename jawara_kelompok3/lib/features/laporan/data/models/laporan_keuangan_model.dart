class LaporanKeuanganModel {
  final DateTime tanggal;
  final String keterangan;
  /// "Pemasukan" atau "Pengeluaran"
  final String jenis;
  final int nominal;

  const LaporanKeuanganModel({
    required this.tanggal,
    required this.keterangan,
    required this.jenis,
    required this.nominal,
  });

  factory LaporanKeuanganModel.fromMap(Map<String, dynamic> map) {
    return LaporanKeuanganModel(
      tanggal: map['tanggal'] is DateTime
          ? map['tanggal'] as DateTime
          : DateTime.parse(map['tanggal'] as String),
      keterangan: map['keterangan'] ?? '',
      jenis: map['jenis'] ?? '',
      nominal: map['nominal'] is int
          ? map['nominal'] as int
          : int.tryParse(map['nominal'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tanggal': tanggal.toIso8601String(),
      'keterangan': keterangan,
      'jenis': jenis,
      'nominal': nominal,
    };
  }
}
