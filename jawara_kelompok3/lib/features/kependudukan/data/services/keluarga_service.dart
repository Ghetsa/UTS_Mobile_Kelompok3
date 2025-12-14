import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/keluarga_model.dart';

class KeluargaService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("keluarga");

  Future<List<KeluargaModel>> getDataKeluarga() async {
    final snapshot = await _ref.orderBy("kepala_keluarga").get();
    return snapshot.docs
        .map((doc) => KeluargaModel.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ))
        .toList();
  }

  Future<bool> addKeluarga(Map<String, dynamic> data) async {
    try {
      await _ref.add({
        ...data,
        "status_keluarga": data["status_keluarga"] ?? "aktif",
        "created_at": FieldValue.serverTimestamp(),
        "updated_at": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("ERROR TAMBAH KELUARGA: $e");
      return false;
    }
  }

  Future<String?> addKeluargaReturnId(Map<String, dynamic> data) async {
    try {
      final doc = await _ref.add({
        ...data,
        "status_keluarga": data["status_keluarga"] ?? "aktif",
        "created_at": FieldValue.serverTimestamp(),
        "updated_at": FieldValue.serverTimestamp(),
      });
      return doc.id;
    } catch (e) {
      print("ERROR addKeluargaReturnId: $e");
      return null;
    }
  }

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

  Future<bool> deleteKeluarga(String id) async {
    try {
      await _ref.doc(id).delete();
      return true;
    } catch (e) {
      print("ERROR DELETE KELUARGA: $e");
      return false;
    }
  }

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

  Future<KeluargaModel?> getKeluargaByRumahId(String rumahDocId) async {
    try {
      final q =
          await _ref.where('id_rumah', isEqualTo: rumahDocId).limit(1).get();
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

  Future<List<KeluargaModel>> getActiveFamilies() async {
    try {
      final q = await _ref.where("status_keluarga", isEqualTo: "aktif").get();
      return q.docs
          .map((doc) => KeluargaModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      print("ERROR getActiveFamilies: $e");
      return [];
    }
  }

  // ============================================================
  // ✅ HITUNG keluarga yang "menempati" rumah (aktif / sementara)
  // ============================================================
  Future<int> countOccupyingFamiliesByRumah(String rumahDocId) async {
    try {
      // status yang dianggap masih menempati rumah
      final statuses = ["aktif", "sementara"];

      // Firestore "whereIn" maksimal 10, kita cuma 2 jadi aman
      final q = await _ref
          .where("id_rumah", isEqualTo: rumahDocId)
          .where("status_keluarga", whereIn: statuses)
          .get();

      return q.size;
    } catch (e) {
      print("ERROR countOccupyingFamiliesByRumah: $e");
      return 0;
    }
  }
}
