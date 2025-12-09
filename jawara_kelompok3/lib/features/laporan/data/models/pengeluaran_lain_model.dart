class PengeluaranLainModel {
  final String id;
  final String nama;
  final String jenis;
  final String tanggal;
  final int nominal;
  final String? buktiUrl;

  PengeluaranLainModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggal,
    required this.nominal,
    this.buktiUrl,
  });

  factory PengeluaranLainModel.fromJson(String id, Map<String, dynamic> json) {
    return PengeluaranLainModel(
      id: id,
      nama: json['nama'],
      jenis: json['jenis'],
      tanggal: json['tanggal'],
      nominal: json['nominal'],
      buktiUrl: json['bukti_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "jenis": jenis,
      "tanggal": tanggal,
      "nominal": nominal,
      "bukti_url": buktiUrl,
    };
  }
}
