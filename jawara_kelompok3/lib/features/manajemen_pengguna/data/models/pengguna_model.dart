import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  /// ID dokumen Firestore
  final String docId;

  final String nama;
  final String email;
  final String statusRegistrasi;
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
    required this.statusRegistrasi,
    required this.role,
    required this.nik,
    required this.noHp,
    required this.jenisKelamin,
    this.fotoIdentitas,
    this.createdAt,
    this.updatedAt,
  });

  /// Firestore → Model
  factory User.fromFirestore(String docId, Map<String, dynamic> data) {
    return User(
      docId: docId,
      nama: data['nama'] ?? '',
      email: data['email'] ?? '',
      statusRegistrasi: data['statusRegistrasi'] ?? '',
      role: data['role'] ?? '',
      nik: data['nik'] ?? '',
      noHp: data['noHp'] ?? '',
      jenisKelamin: data['jenisKelamin'] ?? '',
      fotoIdentitas: data['fotoIdentitas'],
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
      'statusRegistrasi': statusRegistrasi,
      'role': role,
      'nik': nik,
      'noHp': noHp,
      'jenisKelamin': jenisKelamin,
      'fotoIdentitas': fotoIdentitas,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
