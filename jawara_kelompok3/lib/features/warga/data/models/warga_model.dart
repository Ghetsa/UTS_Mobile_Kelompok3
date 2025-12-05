import 'package:cloud_firestore/cloud_firestore.dart';

class WargaModel {
  final String docId;
  final String uid;

  final String nik;
  final String noKk;
  final String nama;
  final String pendidikan;
  final String pekerjaan;
  final String agama;
  final String jenisKelamin;   // "p" / "l"
  final String statusWarga;    // "aktif" / "nonaktif" dll
  final String idRumah;        // docId rumah
  final String idKeluarga;     // ✅ docId keluarga (baru)
  final String noHp;

  final DateTime? tanggalLahir;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WargaModel({
    required this.docId,
    required this.uid,
    required this.nik,
    required this.noKk,
    required this.nama,
    required this.pendidikan,
    required this.pekerjaan,
    required this.agama,
    required this.jenisKelamin,
    required this.statusWarga,
    required this.idRumah,
    required this.idKeluarga,   // ✅
    required this.noHp,
    this.tanggalLahir,
    this.createdAt,
    this.updatedAt,
  });

  factory WargaModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return WargaModel(
      docId: docId,
      uid: data['uid'] ?? '',
      nik: data['nik'] ?? '',
      noKk: data['no_kk'] ?? '',
      nama: data['nama'] ?? '',
      pendidikan: data['pendidikan'] ?? '',
      pekerjaan: data['pekerjaan'] ?? '',
      agama: data['agama'] ?? '',
      jenisKelamin: data['jenis_kelamin'] ?? '',
      statusWarga: data['status_warga'] ?? '',
      idRumah: data['id_rumah'] ?? '',
      idKeluarga: data['id_keluarga'] ?? '',   // ✅ bisa kosong
      noHp: data['no_hp'] ?? '',
      tanggalLahir: data['tanggal_lahir'] != null
          ? (data['tanggal_lahir'] as Timestamp).toDate()
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
      'uid': uid,
      'nik': nik,
      'no_kk': noKk,
      'nama': nama,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
      'agama': agama,
      'jenis_kelamin': jenisKelamin,
      'status_warga': statusWarga,
      'id_rumah': idRumah,
      'id_keluarga': idKeluarga,   // ✅ simpan relasi ke keluarga
      'no_hp': noHp,
      'tanggal_lahir': tanggalLahir != null
          ? Timestamp.fromDate(tanggalLahir!)
          : FieldValue.serverTimestamp(),
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
