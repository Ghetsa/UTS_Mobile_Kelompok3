import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/keluarga_model.dart';

class KeluargaService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("keluarga");

  /// ------------------------------------------------------------
  /// 🔵 Ambil Semua Data Keluarga
  /// ------------------------------------------------------------
  Future<List<KeluargaModel>> getDataKeluarga() async {
    final snapshot = await _ref.orderBy("kepala_keluarga").get();

    return snapshot.docs
        .map((doc) => KeluargaModel.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ))
        .toList();
  }

  /// ------------------------------------------------------------
  /// 🟢 Tambah Data Keluarga
  /// ------------------------------------------------------------
  Future<bool> addKeluarga(Map<String, dynamic> data) async {
    try {
      await _ref.add({
        ...data,
        "status_keluarga": data["status_keluarga"] ?? "aktif",
        "created_at": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("ERROR TAMBAH KELUARGA: $e");
      return false;
    }
  }

  /// ------------------------------------------------------------
  /// 🟡 Edit / Update Data Keluarga
  /// ------------------------------------------------------------
  Future<bool> updateKeluarga(String id, Map<String, dynamic> data) async {
    try {
      await _ref.doc(id).update({
        ...data,
        "updated_at": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("ERROR UPDATE KELUARGA: $e");
      return false;
    }
  }

  /// ------------------------------------------------------------
  /// 🔴 Hapus Data Keluarga
  /// ------------------------------------------------------------
  Future<bool> deleteKeluarga(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print("ERROR DELETE KELUARGA: $e");
      return false;
    }
  }

  /// ------------------------------------------------------------
  /// 🟣 Detail Satu Keluarga Berdasarkan DOC ID
  /// ------------------------------------------------------------
  Future<KeluargaModel?> getDetail(String id) async {
    try {
      final doc = await _ref.doc(id).get();

      if (!doc.exists) return null;

      return KeluargaModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print("ERROR GET DETAIL KELUARGA: $e");
      return null;
    }
  }

  Future<KeluargaModel?> getByDocId(String docId) async {
    try {
      final doc = await _ref.doc(docId).get();
      if (!doc.exists) return null;

      return KeluargaModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print("ERROR GET KELUARGA BY DOC ID: $e");
      return null;
    }
  }

  /// ------------------------------------------------------------
  /// 🟤 Ambil keluarga berdasarkan id_rumah (relasi satu arah)
  /// ------------------------------------------------------------
  Future<KeluargaModel?> getKeluargaByRumahId(String rumahDocId) async {
    try {
      final q = await _ref
          .where('id_rumah', isEqualTo: rumahDocId)
          .limit(1)
          .get();

      if (q.docs.isEmpty) return null;

      final doc = q.docs.first;
      return KeluargaModel.fromFirestore(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print("ERROR GET KELUARGA BY RUMAH ID: $e");
      return null;
    }
  }
}
