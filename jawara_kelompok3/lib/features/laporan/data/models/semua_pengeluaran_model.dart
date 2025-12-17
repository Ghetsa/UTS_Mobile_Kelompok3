import 'package:cloud_firestore/cloud_firestore.dart';

class PengeluaranModel {
  final String id;
  final String nama;
  final String jenis;
  final String tanggal;
  final String nominal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PengeluaranModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggal,
    required this.nominal,
    this.createdAt,
    this.updatedAt,
  });

  // Helper untuk handle tanggal yang bisa String / Timestamp
  static String _parseTanggal(dynamic value) {
    if (value == null) return '';
    if (value is Timestamp) {
      final d = value.toDate();
      return '${d.day}/${d.month}/${d.year}';
    }
    return value.toString();
  }

  factory PengeluaranModel.fromFirestore(String id, Map<String, dynamic> data) {
    return PengeluaranModel(
      id: id,
      nama: data['nama'] ?? '',
      jenis: data['jenis'] ?? '',
      tanggal: _parseTanggal(data['tanggal']),
      nominal: data['nominal']?.toString() ?? '',
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  static PengeluaranModel fromMap(Map<String, dynamic> map) {
    return PengeluaranModel(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      jenis: map['jenis'] ?? '',
      tanggal: _parseTanggal(map['tanggal']),
      nominal: map['nominal']?.toString() ?? '',
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: map['updated_at'] is Timestamp
          ? (map['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jenis': jenis,
      'tanggal': tanggal,
      'nominal': nominal,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
