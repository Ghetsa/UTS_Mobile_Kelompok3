import 'package:cloud_firestore/cloud_firestore.dart';

class PengeluaranLainModel {
  /// docId = ID dokumen Firestore
  final String docId;
  
  /// field "id" (ID internal pengeluaran yang kamu generate)
  final String id;
  
  final String nama;
  final String jenis;
  final String tanggal;
  final String nominal;
  final String? buktiUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PengeluaranLainModel({
    required this.docId,
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggal,
    required this.nominal,
    this.buktiUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory PengeluaranLainModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return PengeluaranLainModel(
      docId: docId,
      id: data['id'] ?? '',
      nama: data['nama'] ?? '',
      jenis: data['jenis'] ?? '',
      tanggal: data['tanggal'] ?? '',
      nominal: data['nominal']?.toString() ?? '',
      buktiUrl: data['bukti_url'],
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jenis': jenis,
      'tanggal': tanggal,
      'nominal': nominal,
      'bukti_url': buktiUrl,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory PengeluaranLainModel.fromMap(Map<String, dynamic> row) {
    return PengeluaranLainModel(
      docId: row['docId'] ?? '',
      id: row['id'] ?? '',
      nama: row['nama'] ?? '',
      jenis: row['jenis'] ?? '',
      tanggal: row['tanggal'] ?? '',
      nominal: row['nominal'] ?? '',
      buktiUrl: row['bukti_url'],
      createdAt: row['created_at'],
      updatedAt: row['updated_at'],
    );
  }
}
