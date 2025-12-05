import 'package:cloud_firestore/cloud_firestore.dart';

class KegiatanModel {
  final String uid; // docId Firestore
  final String nama;
  final String kategori; // Komunitas & Sosial, Keamanan, dll
  final String lokasi;
  final String penanggungJawab;
  final String status; // rencana / berjalan / selesai / batal
  final String keterangan;

  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KegiatanModel({
    required this.uid,
    required this.nama,
    required this.kategori,
    required this.lokasi,
    required this.penanggungJawab,
    required this.status,
    required this.keterangan,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.createdAt,
    this.updatedAt,
  });

  factory KegiatanModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return KegiatanModel(
      uid: id,
      nama: data['nama'] ?? '',
      kategori: data['kategori'] ?? '',
      lokasi: data['lokasi'] ?? '',
      penanggungJawab: data['penanggung_jawab'] ?? '',
      status: data['status'] ?? 'rencana',
      keterangan: data['keterangan'] ?? '',
      tanggalMulai: data['tanggal_mulai'] != null
          ? (data['tanggal_mulai'] as Timestamp).toDate()
          : null,
      tanggalSelesai: data['tanggal_selesai'] != null
          ? (data['tanggal_selesai'] as Timestamp).toDate()
          : null,
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
      'nama': nama,
      'kategori': kategori,
      'lokasi': lokasi,
      'penanggung_jawab': penanggungJawab,
      'status': status,
      'keterangan': keterangan,
      'tanggal_mulai': tanggalMulai != null
          ? Timestamp.fromDate(tanggalMulai!)
          : FieldValue.serverTimestamp(),
      'tanggal_selesai': tanggalSelesai != null
          ? Timestamp.fromDate(tanggalSelesai!)
          : null,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
