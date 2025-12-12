import 'package:cloud_firestore/cloud_firestore.dart';

class KeluargaModel {
  final String uid; // docId di Firestore
  final String kepalaKeluarga;

  // ✅ TAMBAHAN: simpan docId warga yang jadi kepala keluarga
  final String idKepalaWarga;

  final String idRumah; // simpan docId rumah
  final String jumlahAnggota;
  final String noKk;
  final String statusKeluarga; // "aktif" / "pindah" / "sementara"
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KeluargaModel({
    required this.uid,
    required this.kepalaKeluarga,
    required this.idKepalaWarga, // ✅ TAMBAHAN
    required this.idRumah,
    required this.jumlahAnggota,
    required this.noKk,
    required this.statusKeluarga,
    this.createdAt,
    this.updatedAt,
  });

  factory KeluargaModel.fromFirestore(String id, Map<String, dynamic> data) {
    return KeluargaModel(
      uid: id,
      kepalaKeluarga: data["kepala_keluarga"] ?? "",

      // ✅ TAMBAHAN
      idKepalaWarga: data["id_kepala_warga"] ?? "",

      idRumah: data["id_rumah"] ?? "",
      jumlahAnggota: data["jumlah_anggota"]?.toString() ?? "",
      noKk: data["no_kk"] ?? "",
      statusKeluarga: (data["status_keluarga"] ?? "aktif").toString(),
      createdAt: data["created_at"] != null
          ? (data["created_at"] as Timestamp).toDate()
          : null,
      updatedAt: data["updated_at"] != null
          ? (data["updated_at"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "kepala_keluarga": kepalaKeluarga,

      // ✅ TAMBAHAN
      "id_kepala_warga": idKepalaWarga,

      "id_rumah": idRumah,
      "jumlah_anggota": jumlahAnggota,
      "no_kk": noKk,
      "status_keluarga": statusKeluarga,
      if (createdAt != null) "created_at": Timestamp.fromDate(createdAt!),
      if (updatedAt != null) "updated_at": Timestamp.fromDate(updatedAt!),
    };
  }

  // (opsional tapi enak) helper copyWith
  KeluargaModel copyWith({
    String? uid,
    String? kepalaKeluarga,
    String? idKepalaWarga,
    String? idRumah,
    String? jumlahAnggota,
    String? noKk,
    String? statusKeluarga,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KeluargaModel(
      uid: uid ?? this.uid,
      kepalaKeluarga: kepalaKeluarga ?? this.kepalaKeluarga,
      idKepalaWarga: idKepalaWarga ?? this.idKepalaWarga,
      idRumah: idRumah ?? this.idRumah,
      jumlahAnggota: jumlahAnggota ?? this.jumlahAnggota,
      noKk: noKk ?? this.noKk,
      statusKeluarga: statusKeluarga ?? this.statusKeluarga,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
