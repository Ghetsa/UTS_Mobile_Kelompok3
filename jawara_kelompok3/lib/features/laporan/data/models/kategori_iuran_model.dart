import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriIuranModel {
  final String id;
  final String nama;
  final String jenis;
  final String nominal; 
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KategoriIuranModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.nominal,
    this.createdAt,
    this.updatedAt,
  });

  factory KategoriIuranModel.fromFirestore(String id, Map<String, dynamic> data) {
    return KategoriIuranModel(
      id: id,
      nama: data['nama'] ?? '',
      jenis: data['jenis'] ?? '',
      nominal: data['nominal']?.toString() ?? '',
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : null,
      updatedAt: data['updated_at'] != null ? (data['updated_at'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jenis': jenis,
      'nominal': nominal,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}