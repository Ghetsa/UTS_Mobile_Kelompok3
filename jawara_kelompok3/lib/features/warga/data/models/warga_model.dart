import 'package:cloud_firestore/cloud_firestore.dart';


class WargaModel {
  final String uid;
  final String nama;
  final String nik;
  final String noKk;
  final String noHp;
  final String agama;
  final String jenisKelamin;
  final String pendidikan;
  final String pekerjaan;
  final String statusWarga;
  final String idRumah;
  final DateTime tanggalLahir;
  final DateTime createdAt;

  WargaModel({
    required this.uid,
    required this.nama,
    required this.nik,
    required this.noKk,
    required this.noHp,
    required this.agama,
    required this.jenisKelamin,
    required this.pendidikan,
    required this.pekerjaan,
    required this.statusWarga,
    required this.idRumah,
    required this.tanggalLahir,
    required this.createdAt,
  });

  factory WargaModel.fromFirestore(String id, Map<String, dynamic> data) {
    return WargaModel(
      uid: data['uid'] ?? '',
      nama: data['nama'] ?? '',
      nik: data['nik'] ?? '',
      noKk: data['no_kk'] ?? '',
      noHp: data['no_hp'] ?? '',
      agama: data['agama'] ?? '',
      jenisKelamin: data['jenis_kelamin'] ?? '',
      pendidikan: data['pendidikan'] ?? '',
      pekerjaan: data['pekerjaan'] ?? '',
      statusWarga: data['status_warga'] ?? '',
      idRumah: data['id_rumah'] ?? '',
      tanggalLahir: (data['tanggal_lahir'] as Timestamp).toDate(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "nama": nama,
      "nik": nik,
      "no_kk": noKk,
      "no_hp": noHp,
      "agama": agama,
      "jenis_kelamin": jenisKelamin,
      "pendidikan": pendidikan,
      "pekerjaan": pekerjaan,
      "status_warga": statusWarga,
      "id_rumah": idRumah,
      "tanggal_lahir": tanggalLahir,
      "created_at": createdAt,
    };
  }

  factory WargaModel.fromMap(Map<String, dynamic> data) {
  return WargaModel(
    uid: data['uid'] ?? '',
    nama: data['nama'] ?? '',
    nik: data['nik'] ?? '',
    noKk: data['no_kk'] ?? '',
    noHp: data['no_hp'] ?? '',
    agama: data['agama'] ?? '',
    jenisKelamin: data['jenis_kelamin'] ?? '',
    pendidikan: data['pendidikan'] ?? '',
    pekerjaan: data['pekerjaan'] ?? '',
    statusWarga: data['status_warga'] ?? '',
    idRumah: data['id_rumah'] ?? '',
    tanggalLahir: (data['tanggal_lahir'] as Timestamp).toDate(),
    createdAt: (data['created_at'] as Timestamp).toDate(),
  );
}

}
