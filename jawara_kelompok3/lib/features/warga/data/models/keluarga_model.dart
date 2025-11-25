import 'package:cloud_firestore/cloud_firestore.dart';

class KeluargaModel {
  final String uid;
  final String kepalaKeluarga;
  final String alamat;
  final String idRumah;
  final String jumlahAnggota;
  final String noKk;
  final DateTime? createdAt;

  KeluargaModel({
    required this.uid,
    required this.kepalaKeluarga,
    required this.alamat,
    required this.idRumah,
    required this.jumlahAnggota,
    required this.noKk,
    this.createdAt,
  });

  factory KeluargaModel.fromFirestore(String id, Map<String, dynamic> data) {
    return KeluargaModel(
      uid: id,
      kepalaKeluarga: data["kepala_keluarga"] ?? "",
      alamat: data["alamat"] ?? "",
      idRumah: data["id_rumah"] ?? "",
      jumlahAnggota: data["jumlah_anggota"] ?? "",
      noKk: data["no_kk"] ?? "",
      createdAt: data["created_at"] != null
          ? (data["created_at"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "kepala_keluarga": kepalaKeluarga,
      "alamat": alamat,
      "id_rumah": idRumah,
      "jumlah_anggota": jumlahAnggota,
      "no_kk": noKk,
      "created_at": createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
