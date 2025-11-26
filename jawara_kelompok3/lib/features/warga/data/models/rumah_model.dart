import 'package:cloud_firestore/cloud_firestore.dart';

class RumahModel {
  final String id; // gunakan sebagai doc id
  final String alamat;
  final String status; // mis: Ditempati / Tersedia
  final String kepemilikan; // Pemilik / Penyewa / Kosong
  final String penghuni; // nama keluarga / '-' jika kosong
  final String? idRumah; // optional, jika kamu punya
  final DateTime? createdAt;

  RumahModel({
    required this.id,
    required this.alamat,
    required this.status,
    required this.kepemilikan,
    required this.penghuni,
    this.idRumah,
    this.createdAt,
  });

  factory RumahModel.fromFirestore(String id, Map<String, dynamic> data) {
    return RumahModel(
      id: id,
      alamat: data['alamat'] ?? '',
      status: data['status'] ?? '',
      kepemilikan: data['kepemilikan'] ?? '',
      penghuni: data['penghuni'] ?? '',
      idRumah: data['id_rumah'] ?? null,
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  factory RumahModel.fromMap(Map<String, dynamic> data) {
    return RumahModel(
      id: data['id'] ?? '',
      alamat: data['alamat'] ?? '',
      status: data['status'] ?? '',
      kepemilikan: data['kepemilikan'] ?? '',
      penghuni: data['penghuni'] ?? '',
      idRumah: data['id_rumah'] ?? null,
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "alamat": alamat,
      "status": status,
      "kepemilikan": kepemilikan,
      "penghuni": penghuni,
      if (idRumah != null) "id_rumah": idRumah,
      "created_at": createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
