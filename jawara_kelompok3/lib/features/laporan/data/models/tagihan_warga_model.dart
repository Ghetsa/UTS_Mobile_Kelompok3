import 'package:cloud_firestore/cloud_firestore.dart';

class TagihanWargaModel {
  final String id;
  final String keluarga;
  final String status;
  final String iuran;
  final String kode;
  final String nominal;
  final String periode;
  final String tagihanStatus;
  final String? buktiBayar;
  final String? nominalDibayar;
  final String? catatanPembayaran;
  final DateTime? tanggalBayar;
  final DateTime? createdAt;

  TagihanWargaModel({
    required this.id,
    required this.keluarga,
    required this.status,
    required this.iuran,
    required this.kode,
    required this.nominal,
    required this.periode,
    required this.tagihanStatus,
    this.buktiBayar,
    this.nominalDibayar,
    this.catatanPembayaran,
    this.tanggalBayar,
    this.createdAt,
  });

  factory TagihanWargaModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TagihanWargaModel(
      id: id,
      keluarga: data['keluarga'] ?? '',
      status: data['status'] ?? '',
      iuran: data['iuran'] ?? '',
      kode: data['kode'] ?? '',
      nominal: data['nominal'] ?? '',
      periode: data['periode'] ?? '',
      tagihanStatus: data['tagihanStatus'] ?? '',
      buktiBayar: data['buktiBayar'],
      nominalDibayar: data['nominalDibayar'],
      catatanPembayaran: data['catatanPembayaran'],
      tanggalBayar: data['tanggalBayar'] != null 
          ? (data['tanggalBayar'] as Timestamp).toDate() 
          : null,
      createdAt: data['created_at'] != null 
          ? (data['created_at'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'keluarga': keluarga,
      'status': status,
      'iuran': iuran,
      'kode': kode,
      'nominal': nominal,
      'periode': periode,
      'tagihanStatus': tagihanStatus,
      'buktiBayar': buktiBayar,
      'nominalDibayar': nominalDibayar,
      'catatanPembayaran': catatanPembayaran,
      'tanggalBayar': tanggalBayar != null ? Timestamp.fromDate(tanggalBayar!) : null,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  TagihanWargaModel copyWith({
    String? tagihanStatus,
    String? buktiBayar,
    String? nominalDibayar,
    String? catatanPembayaran,
    DateTime? tanggalBayar,
  }) {
    return TagihanWargaModel(
      id: this.id,
      keluarga: this.keluarga,
      status: this.status,
      iuran: this.iuran,
      kode: this.kode,
      nominal: this.nominal,
      periode: this.periode,
      tagihanStatus: tagihanStatus ?? this.tagihanStatus,
      buktiBayar: buktiBayar ?? this.buktiBayar,
      nominalDibayar: nominalDibayar ?? this.nominalDibayar,
      catatanPembayaran: catatanPembayaran ?? this.catatanPembayaran,
      tanggalBayar: tanggalBayar ?? this.tanggalBayar,
      createdAt: this.createdAt,
    );
  }
}