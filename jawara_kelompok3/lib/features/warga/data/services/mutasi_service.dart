import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mutasi_model.dart';

class MutasiService {
  final CollectionReference<Map<String, dynamic>> col =
      FirebaseFirestore.instance.collection('mutasi_warga');

  // ============================================================
  // 🔵 GET SEMUA MUTASI
  // ============================================================
  Future<List<MutasiModel>> getAllMutasi() async {
    try {
      final snapshot = await col.orderBy('tanggal', descending: true).get();

      return snapshot.docs
          .map(
            (e) => MutasiModel.fromFirestore(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e, st) {
      print('❌ ERROR GET ALL MUTASI: $e');
      print(st);
      return [];
    }
  }

  // ============================================================
  // 🟣 GET SATU MUTASI BY DOC ID
  // ============================================================
  Future<MutasiModel?> getByDocId(String docId) async {
    try {
      final doc = await col.doc(docId).get();
      if (!doc.exists) return null;
      return MutasiModel.fromFirestore(doc.id, doc.data()!);
    } catch (e) {
      print('❌ ERROR GET MUTASI BY DOC ID: $e');
      return null;
    }
  }

  // ============================================================
  // 🟢 TAMBAH MUTASI
  // ============================================================
  Future<bool> addMutasi(MutasiModel data) async {
    try {
      await col.add(data.toMap());
      return true;
    } catch (e) {
      print('❌ ERROR ADD MUTASI: $e');
      return false;
    }
  }

  // ============================================================
  // 🟡 UPDATE MUTASI
  // ============================================================
  Future<bool> updateMutasi(String docId, Map<String, dynamic> newData) async {
    try {
      await col.doc(docId).update({
        ...newData,
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('❌ ERROR UPDATE MUTASI: $e');
      return false;
    }
  }

  // ============================================================
  // 🔴 DELETE MUTASI
  // ============================================================
  Future<bool> deleteMutasi(String docId) async {
    try {
      await col.doc(docId).delete();
      return true;
    } catch (e) {
      print('❌ ERROR DELETE MUTASI: $e');
      return false;
    }
  }
}
