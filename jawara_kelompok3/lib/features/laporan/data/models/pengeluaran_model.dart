class PengeluaranModel {
  final String no;
  final String nama;
  final String jenis;
  final String tanggal;
  final String nominal;

  const PengeluaranModel({
    required this.no,
    required this.nama,
    required this.jenis,
    required this.tanggal,
    required this.nominal,
  });

  /// Bikin model dari Map (misal dari dummy data atau Firestore)
  factory PengeluaranModel.fromMap(Map<String, dynamic> map) {
    return PengeluaranModel(
      no: map['no']?.toString() ?? '',
      nama: map['nama'] ?? '',
      jenis: map['jenis'] ?? '',
      tanggal: map['tanggal'] ?? '',
      nominal: map['nominal'] ?? '',
    );
  }

  /// Ubah model ke Map<String, String> (biar masih bisa dipakai widget lama)
  Map<String, String> toMap() {
    return {
      'no': no,
      'nama': nama,
      'jenis': jenis,
      'tanggal': tanggal,
      'nominal': nominal,
    };
  }

  /// Optional: supaya gampang update 1 field
  PengeluaranModel copyWith({
    String? no,
    String? nama,
    String? jenis,
    String? tanggal,
    String? nominal,
  }) {
    return PengeluaranModel(
      no: no ?? this.no,
      nama: nama ?? this.nama,
      jenis: jenis ?? this.jenis,
      tanggal: tanggal ?? this.tanggal,
      nominal: nominal ?? this.nominal,
    );
  }
}
