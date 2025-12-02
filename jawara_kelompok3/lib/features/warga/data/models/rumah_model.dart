import 'package:cloud_firestore/cloud_firestore.dart';

class RumahModel {
  /// docId = ID dokumen Firestore (bukan field "id" di dalam dokumen)
  final String docId;

  /// field "id" di Firestore (misal nomor rumah / kode rumah)
  final String id;

  final String alamat;
  final String nomor;
  final String statusRumah;       // dari "status_rumah"
  final String kepemilikan;       // dari "kepemilikan"
  final String penghuniKeluargaId; // dari "penghuni" = id keluarga
  final String rt;                // dari "rt"
  final String rw;                // dari "rw"

  final DateTime? createdAt;
  final DateTime? updatedAt;

  RumahModel({
    required this.docId,
    required this.id,
    required this.alamat,
    required this.nomor,
    required this.statusRumah,
    required this.kepemilikan,
    required this.penghuniKeluargaId,
    required this.rt,
    required this.rw,
    this.createdAt,
    this.updatedAt,
  });

  /// Dari Firestore → Model
  factory RumahModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return RumahModel(
      docId: docId,
      id: data['id'] ?? '',
      alamat: data['alamat'] ?? '',
      nomor: data['nomor'] ?? '',
      statusRumah: data['status_rumah'] ?? '',
      kepemilikan: data['kepemilikan'] ?? '',
      penghuniKeluargaId: data['penghuni'] ?? '',
      rt: data['rt'] ?? '',
      rw: data['rw'] ?? '',
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  /// Model → Map untuk simpan/update ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alamat': alamat,
      'nomor': nomor,
      'status_rumah': statusRumah,
      'kepemilikan': kepemilikan,
      'penghuni': penghuniKeluargaId,
      'rt': rt,
      'rw': rw,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
