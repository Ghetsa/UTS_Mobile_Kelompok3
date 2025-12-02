import 'package:cloud_firestore/cloud_firestore.dart';

class MutasiModel {
  final String uid;               // docId
  final String keterangan;        // dari firestore
  final String idWarga;           // firestore pakai "id"
  final String jenisMutasi;       // firestore pakai "jenis_mutasi"
  final DateTime? tanggal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MutasiModel({
    required this.uid,
    required this.keterangan,
    required this.idWarga,
    required this.jenisMutasi,
    this.tanggal,
    this.createdAt,
    this.updatedAt,
  });

  /// Dari Firestore → Model
  factory MutasiModel.fromFirestore(String id, Map<String, dynamic> data) {
    return MutasiModel(
      uid: id,
      keterangan: data["keterangan"] ?? "",
      idWarga: data["id"] ?? "",
      jenisMutasi: data["jenis_mutasi"] ?? "",
      tanggal: data["tanggal"] != null
          ? (data["tanggal"] as Timestamp).toDate()
          : null,
      createdAt: data["created_at"] != null
          ? (data["created_at"] as Timestamp).toDate()
          : null,
      updatedAt: data["updated_at"] != null
          ? (data["updated_at"] as Timestamp).toDate()
          : null,
    );
  }

  /// Model → Firestore
  Map<String, dynamic> toMap() {
    return {
      "keterangan": keterangan,
      "id": idWarga,
      "jenis_mutasi": jenisMutasi,
      "tanggal": tanggal != null
          ? Timestamp.fromDate(tanggal!)
          : FieldValue.serverTimestamp(),
      "created_at": createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      "updated_at": FieldValue.serverTimestamp(),
    };
  }
}
