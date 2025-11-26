import 'package:cloud_firestore/cloud_firestore.dart';

class MutasiModel {
  final String uid;         // <-- doc ID dari Firestore
  final String alasan;
  final String dibuatOleh;
  final String idWarga;
  final String jenis;
  final DateTime? tanggal;

  MutasiModel({
    required this.uid,
    required this.alasan,
    required this.dibuatOleh,
    required this.idWarga,
    required this.jenis,
    this.tanggal,
  });

  /// Konversi dari Firestore
  factory MutasiModel.fromFirestore(String id, Map<String, dynamic> data) {
    return MutasiModel(
      uid: id,
      alasan: data["alasan"] ?? "",
      dibuatOleh: data["dibuat_oleh"] ?? "",
      idWarga: data["id_warga"] ?? "",
      jenis: data["jenis"] ?? "",
      tanggal: data["tanggal"] != null
          ? (data["tanggal"] as Timestamp).toDate()
          : null,
    );
  }

  /// Konversi ke map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      "alasan": alasan,
      "dibuat_oleh": dibuatOleh,
      "id_warga": idWarga,
      "jenis": jenis,
      "tanggal": tanggal != null ? Timestamp.fromDate(tanggal!) : FieldValue.serverTimestamp(),
    };
  }
}
