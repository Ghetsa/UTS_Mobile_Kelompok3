import 'package:cloud_firestore/cloud_firestore.dart';

class TagihIuranModel {
  final String id;
  final String keluarga;
  final String status;
  final String iuran;
  final String kode;
  final String nominal;
  final String periode;
  final String tagihanStatus;
  final DateTime? createdAt;

  TagihIuranModel({
    required this.id,
    required this.keluarga,
    required this.status,
    required this.iuran,
    required this.kode,
    required this.nominal,
    required this.periode,
    required this.tagihanStatus,
    this.createdAt,
  });

  factory TagihIuranModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TagihIuranModel(
      id: id,
      keluarga: data['keluarga'] ?? '',
      status: data['status'] ?? '',
      iuran: data['iuran'] ?? '',
      kode: data['kode'] ?? '',
      nominal: data['nominal'] ?? '',
      periode: data['periode'] ?? '',
      tagihanStatus: data['tagihanStatus'] ?? '',
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : null,
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
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
