import 'package:cloud_firestore/cloud_firestore.dart';

class PesanWargaModel {
  /// ID dokumen di Firestore (mis: "pesan_warga_001")
  final String docId;

  /// Field "id" di dokumen (kalau kamu pakai ID custom sendiri)
  final String idPesan;

  /// Nama warga yang membuat aspirasi
  final String nama;

  /// Isi pesan/aspirasi
  final String isiPesan;

  /// Kategori pesan (mis: "Aspirasi", "Keluhan", dll)
  final String kategori;

  /// Status pesan (mis: "Pending", "Diterima", "Ditolak")
  final String status;

  /// Timestamp dibuat
  final DateTime? createdAt;

  /// Timestamp terakhir di-update
  final DateTime? updatedAt;

  PesanWargaModel({
    required this.docId,
    required this.idPesan,
    required this.nama,
    required this.isiPesan,
    required this.kategori,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory dari Firestore
  factory PesanWargaModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return PesanWargaModel(
      docId: id,
      idPesan: data['id'] ?? '',
      nama: data['nama'] ?? '', // tambahkan ini
      isiPesan: data['isi_pesan'] ?? '',
      kategori: data['kategori'] ?? '',
      status: data['status'] ?? '',
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  /// Konversi ke Map untuk dikirim ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': idPesan,
      'nama': nama, // tambahkan ini
      'isi_pesan': isiPesan,
      'kategori': kategori,
      'status': status,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
