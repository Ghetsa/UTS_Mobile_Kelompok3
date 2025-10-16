class Mutasi {
  final String jenis;
  final String keluarga;
  final String alasan;
  final DateTime tanggal;

  Mutasi({
    required this.jenis,
    required this.keluarga,
    required this.alasan,
    required this.tanggal,
  });
}

class MutasiStorage {
  static final List<Mutasi> daftar = [];
}
