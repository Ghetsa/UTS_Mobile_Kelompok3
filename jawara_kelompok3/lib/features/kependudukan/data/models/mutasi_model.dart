import 'package:cloud_firestore/cloud_firestore.dart';

class MutasiModel {
  /// docId di Firestore
  final String uid;

  /// id warga (relasi ke koleksi warga) → disimpan di field `id`
  final String idWarga;

  /// jenis_mutasi (mis: "pindah masuk", "pindah keluar", "sementara")
  final String jenisMutasi;

  /// keterangan mutasi
  final String keterangan;

  /// tanggal mutasi
  final DateTime? tanggal;

  /// waktu dibuat
  final DateTime? createdAt;

  /// waktu terakhir diupdate
  final DateTime? updatedAt;

  MutasiModel({
    required this.uid,
    required this.idWarga,
    required this.jenisMutasi,
    required this.keterangan,
    this.tanggal,
    this.createdAt,
    this.updatedAt,
  });

  /// Firestore → Model
  factory MutasiModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return MutasiModel(
      uid: docId,
      idWarga: data['id_warga'] ?? '',
      jenisMutasi: data['jenis_mutasi'] ?? '',
      keterangan: data['keterangan'] ?? '',
      tanggal: data['tanggal'] is Timestamp
          ? (data['tanggal'] as Timestamp).toDate()
          : null,
      createdAt: data['created_at'] is Timestamp
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: data['updated_at'] is Timestamp
          ? (data['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  /// Model → Map untuk add dokumen mutasi baru
  Map<String, dynamic> toMap() {
    return {
      'id_warga': idWarga,
      'jenis_mutasi': jenisMutasi,
      'keterangan': keterangan,
      'tanggal': tanggal != null
          ? Timestamp.fromDate(tanggal!)
          : FieldValue.serverTimestamp(),
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }
}
