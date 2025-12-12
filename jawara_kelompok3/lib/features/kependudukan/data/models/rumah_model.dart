import 'package:cloud_firestore/cloud_firestore.dart';

class RumahModel {
  /// docId = ID dokumen Firestore
  final String docId;

  /// field "id" (ID internal rumah yang kamu generate)
  final String id;

  final String alamat;
  final String nomor;
  final String statusRumah; // "Dihuni", "Kosong", "Renovasi"
  final String kepemilikan; // "Pemilik", "Penyewa", "Kosong"
  final String rt;
  final String rw;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  RumahModel({
    required this.docId,
    required this.id,
    required this.alamat,
    required this.nomor,
    required this.statusRumah,
    required this.kepemilikan,
    required this.rt,
    required this.rw,
    this.createdAt,
    this.updatedAt,
  });

  /// ------------------------------------------------------------
  /// Firestore → Model
  /// ------------------------------------------------------------
  factory RumahModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return RumahModel(
      docId: docId,
      id: data['id'] ?? '',
      alamat: data['alamat'] ?? '',
      nomor: data['nomor'] ?? '',
      statusRumah: data['status_rumah'] ?? '',
      kepemilikan: data['kepemilikan'] ?? '',
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

  /// ------------------------------------------------------------
  /// Model → Map (untuk Firestore)
  /// ------------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alamat': alamat,
      'nomor': nomor,
      'status_rumah': statusRumah,
      'kepemilikan': kepemilikan,
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
