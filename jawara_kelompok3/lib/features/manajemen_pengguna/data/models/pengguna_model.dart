import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  /// ID dokumen Firestore
  final String docId;

  final String nama;
  final String email;
  final String statusWarga;
  final String role;
  final String nik;
  final String noHp;
  final String jenisKelamin;
  final String? fotoIdentitas;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.docId,
    required this.nama,
    required this.email,
    required this.statusWarga,
    required this.role,
    required this.nik,
    required this.noHp,
    required this.jenisKelamin,
    this.fotoIdentitas,
    this.createdAt,
    this.updatedAt,
  });

  // Firestore → Model
  factory User.fromFirestore(String docId, Map<String, dynamic> data) {
    return User(
      docId: docId,
      nama: data['nama'] ?? '',
      email: data['email'] ?? '',
      statusWarga: data['status_warga'] ?? '',
      role: data['role'] ?? '',
      nik: data['nik'] ?? '',
      noHp: data['no_hp'] ?? '',
      jenisKelamin: data['jenis_kelamin'] ?? '',
      fotoIdentitas: data['foto_identitas'] ?? data['photoUrl'],
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  /// Model → Map (untuk tambah / update Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'status_warga': statusWarga,
      'role': role,
      'nik': nik,
      'no_hp': noHp,
      'jenis_kelamin': jenisKelamin,
      'foto_identitas': fotoIdentitas,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
