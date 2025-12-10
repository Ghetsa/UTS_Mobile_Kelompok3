import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengeluaran_lain_model.dart';

class PengeluaranLainService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('pengeluaran');

  // ============================================================
  // 🔵 GET SEMUA PENGELUARAN LAIN
  // ============================================================
  Future<List<PengeluaranLainModel>> getAll() async {
    try {
      // Try dengan orderBy tanggal, jika gagal kembalikan tanpa sort
      QuerySnapshot snap;
      try {
        snap = await _ref.orderBy('tanggal', descending: true).get();
      } catch (e) {
        print('⚠️ WARNING orderBy tanggal failed: $e, fetching without order');
        snap = await _ref.get();
      }

      return snap.docs
          .map((d) => PengeluaranLainModel.fromFirestore(
              d.id, d.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ ERROR getAll PengeluaranLain: $e');
      return [];
    }
  }

  // ============================================================
  // 🟣 GET SATU PENGELUARAN LAIN BERDASARKAN DOC ID
  // ============================================================
  Future<PengeluaranLainModel?> getByDocId(String docId) async {
    try {
      final doc = await _ref.doc(docId).get();
      if (!doc.exists) return null;
      return PengeluaranLainModel.fromFirestore(
          doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('❌ ERROR getByDocId PengeluaranLain: $e');
      return null;
    }
  }

  // ============================================================
  // 🟢 TAMBAH PENGELUARAN LAIN
  // ============================================================
  Future<bool> add(PengeluaranLainModel pengeluaran) async {
    try {
      if (pengeluaran.docId.isEmpty) {
        // docId otomatis dari Firestore
        await _ref.add(pengeluaran.toMap());
      } else {
        // pakai docId yang sudah ditentukan
        await _ref.doc(pengeluaran.docId).set(pengeluaran.toMap());
      }
      return true;
    } catch (e) {
      print('❌ ERROR add PengeluaranLain: $e');
      return false;
    }
  }

  // ============================================================
  // 🟡 UPDATE PENGELUARAN LAIN
  // ============================================================
  Future<bool> update(String docId, Map<String, dynamic> data) async {
    try {
      await _ref.doc(docId).update({
        ...data,
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('❌ ERROR update PengeluaranLain: $e');
      return false;
    }
  }

  // ============================================================
  // 🔴 DELETE PENGELUARAN LAIN
  // ============================================================
  Future<bool> delete(String docId) async {
    try {
      await _ref.doc(docId).delete();
      return true;
    } catch (e) {
      print('❌ ERROR delete PengeluaranLain: $e');
      return false;
    }
  }
}
