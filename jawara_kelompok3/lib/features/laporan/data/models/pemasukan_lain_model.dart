import 'package:cloud_firestore/cloud_firestore.dart';

class PemasukanLainModel {
  final String id;
  final String nama;
  final String jenis;
  final String tanggal; // format tanggal string sesuai UI
  final String nominal;
  final String? buktiUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PemasukanLainModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggal,
    required this.nominal,
    this.buktiUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory PemasukanLainModel.fromFirestore(String id, Map<String, dynamic> data) {
    return PemasukanLainModel(
      id: id,
      nama: data['nama'] ?? '',
      jenis: data['jenis'] ?? '',
      tanggal: data['tanggal'] ?? '',
      nominal: data['nominal']?.toString() ?? '',
      buktiUrl: data['bukti_url'],
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : null,
      updatedAt: data['updated_at'] != null ? (data['updated_at'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jenis': jenis,
      'tanggal': tanggal,
      'nominal': nominal,
      'bukti_url': buktiUrl,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  static fromMap(Map<String, dynamic> row) {}
}